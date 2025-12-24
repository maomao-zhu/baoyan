import { router, Button } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { AppState } from '../utils/AppState';

// ========================== 1. 强类型接口定义（无any/unknown） ==========================
/** 基础账号信息（所有账号的公共属性） */
export interface BaseAccount {
  username: string;
  name: string;
  status: number;
  statusText?: string;
  statusColor?: string;
  itemKey?: string;
}

/** 管理员信息（继承基础账号 + 后端完整字段） */
export interface Admin extends BaseAccount {
  id: number;
  password: string | null;
  role: string;
  permissions: string | null;
  phone: string;
  email: string;
  lastLoginTime: string | null;
  createdTime: string;
}

/** 学生信息（继承基础账号） */
export interface Student extends BaseAccount {
  id: string;
  password?: string; // 新增：适配后端密码字段
  profession: string;
  className: string;
  totalScore?: number;
}

/** 教师信息（继承基础账号 + 后端完整字段） */
export interface Teacher extends BaseAccount {
  id: string;
  password: string;
  profession: string;
  phone: string | null;
  picture: string | null;
  title: string;
  department: string;
  email: string;
  canAudit: number;
  createdTime: string;
  updatedTime: string;
}

/** 统一账号类型 */
export type AccountItem = Admin | Student | Teacher;

/** 后端分页响应格式（适配实际返回） */
export interface PageResponse<T> {
  success: boolean;
  data: T[];
  total: number;
  pageNum: number;
  pageSize: number;
  message?: string;
}

/** 表单数据 */
export interface FormData {
  username: string;
  password: string;
  name: string;
  status: number;
  profession: string;
  className: string;
  department: string;
  title: string;
}

/** 分页信息 */
export interface Pagination {
  pageNum: number;
  pageSize: number;
  total: number;
}

/** 页面状态 */
export interface PageState {
  activeTab: number;
  accountList: AccountItem[];
  isLoading: boolean;
  showMessage: boolean;
  message: string;
  showAddDialog: boolean;
  showEditDialog: boolean;
  currentEditItemId: string;
  dialogTitle: string;
}

/** HTTP响应格式 */
export interface ApiResponse {
  responseCode: number;
  result: string;
}

// ========================== 2. 组件定义 ==========================
interface GeneratedTypeLiteralInterface_1 {
  success: boolean;
  message?: string;
}

@Entry
@Component
struct ManagementPage {
  @State pageState: PageState = {
    activeTab: 0,
    accountList: [],
    isLoading: true,
    showMessage: false,
    message: '',
    showAddDialog: false,
    showEditDialog: false,
    currentEditItemId: '',
    dialogTitle: ''
  };

  @State pagination: Pagination = {
    pageNum: 1,
    pageSize: 50,
    total: 0
  };

  @State formData: FormData = {
    username: '',
    password: '',
    name: '',
    status: 1,
    profession: '',
    className: '',
    department: '',
    title: ''
  };

  private baseUrl: string = 'http://10.125.138.244:8080';
  private identityLabels: string[] = ['管理员', '教师', '学生'];
  private statusText: string[] = ['禁用', '启用'];
  private statusColor: string[] = ['#dc3545', '#28a745'];

  async aboutToAppear() {
    const appState = AppState.getInstance();
    const userIdentity = appState.userIdentity;
    const isLoggedIn = appState.isLoggedIn;

    if (!isLoggedIn || userIdentity !== '管理员') {
      this.updateMessage('无管理员权限，请重新登录');
      setTimeout(() => {
        router.pushUrl({ url: 'pages/LoginPage' });
      }, 1500);
      return;
    }

    await this.loadAccountList();
  }

  // ========================== 纯UI构建（仅包含UI组件语法） ==========================
  build() {
    Column() {
      this.TitleUI();
      this.TabBarUI();
      this.FunctionBarUI();
      this.AccountListUI();
      this.MessageTipUI();
      this.DialogUI(); // 滑动弹窗
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }

  @Builder
  TitleUI() {
    Text('账号管理系统')
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .margin({ top: 20 })
      .width('90%')
      .textAlign(TextAlign.Start);
  }

  @Builder
  TabBarUI() {
    Row() {
      Button(this.identityLabels[0])
        .width('33.33%')
        .height(40)
        .fontSize(16)
        .backgroundColor(this.pageState.activeTab === 0 ? '#28a745' : '#f5f5f5')
        .fontColor(this.pageState.activeTab === 0 ? '#ffffff' : '#333333')
        .border({ width: 0 })
        .onClick(() => {
          this.onTabClick(0);
        });

      Button(this.identityLabels[1])
        .width('33.33%')
        .height(40)
        .fontSize(16)
        .backgroundColor(this.pageState.activeTab === 1 ? '#28a745' : '#f5f5f5')
        .fontColor(this.pageState.activeTab === 1 ? '#ffffff' : '#333333')
        .border({ width: 0 })
        .onClick(() => {
          this.onTabClick(1);
        });

      Button(this.identityLabels[2])
        .width('33.33%')
        .height(40)
        .fontSize(16)
        .backgroundColor(this.pageState.activeTab === 2 ? '#28a745' : '#f5f5f5')
        .fontColor(this.pageState.activeTab === 2 ? '#ffffff' : '#333333')
        .border({ width: 0 })
        .onClick(() => {
          this.onTabClick(2);
        });
    }
    .width('90%')
    .margin({ top: 10 });
  }

  @Builder
  FunctionBarUI() {
    Row({ space: 10 }) {
      Button('新增账号')
        .width(100)
        .height(36)
        .backgroundColor('#007bff')
        .fontColor('#ffffff')
        .onClick(() => {
          this.onAddClick();
        });

      Button('刷新列表')
        .width(100)
        .height(36)
        .backgroundColor('#6c757d')
        .fontColor('#ffffff')
        .onClick(() => {
          this.onRefreshClick();
        });
    }
    .width('90%')
    .margin({ top: 10 })
    .justifyContent(FlexAlign.Start);
  }

  @Builder
  AccountListUI() {
    if (this.pageState.isLoading) {
      Progress({ value: 50, total: 100 })
        .width(200)
        .margin({ top: 50 });
    } else if (this.pageState.accountList.length === 0) {
      Text(`暂无${this.identityLabels[this.pageState.activeTab]}账号数据`)
        .fontSize(16)
        .fontColor('#666666')
        .margin({ top: 50 });
    } else {
      List({ space: 10 }) {
        ForEach(this.pageState.accountList, (item: AccountItem) => {
          ListItem() {
            this.AccountItemUI(item);
          }
        }, (item: AccountItem) => item.itemKey || item.id.toString() || '');
      }
      .width('90%')
      .margin({ top: 10 });

      this.PaginationUI();
    }
  }

  @Builder
  AccountItemUI(item: AccountItem) {
    Column() {
      Row() {
        Column({ space: 6 }) {
          Text(`账号：${item.username}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium);
          Text(`姓名：${item.name}`)
            .fontSize(14);

          if (this.pageState.activeTab === 0) {
            Text(`管理员ID：${(item as Admin).id}`).fontSize(14);
            Text(`角色：${(item as Admin).role || '无'}`).fontSize(14);
          } else if (this.pageState.activeTab === 1) {
            Text(`教师ID：${(item as Teacher).id}`).fontSize(14);
            Text(`所属部门：${(item as Teacher).department || '无'}`).fontSize(14);
          } else if (this.pageState.activeTab === 2) {
            Text(`学生ID：${(item as Student).id}`).fontSize(14);
            Text(`专业：${(item as Student).profession || '无'}`).fontSize(14);
          }

          Text(`状态：${item.statusText}`)
            .fontSize(14)
            .fontColor(item.statusColor || '#000000');
        }
        .width('70%')
        .padding(10);

        Column({ space: 8 }) {
          Button('编辑')
            .width(80)
            .height(36)
            .backgroundColor('#ffc107')
            .fontColor('#ffffff')
            .onClick(() => {
              this.onEditClick(item);
            });

          Button(item.statusText === '启用' ? '禁用' : '启用')
            .width(80)
            .height(36)
            .backgroundColor(item.statusText === '启用' ? '#dc3545' : '#28a745')
            .fontColor('#ffffff')
            .onClick(() => {
              this.onStatusClick(item);
            });

          Button('删除')
            .width(80)
            .height(36)
            .backgroundColor('#dc3545')
            .fontColor('#ffffff')
            .onClick(() => {
              this.onDeleteClick(item);
            });
        }
        .width('30%');
      }
    }
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .shadow({ radius: 2, color: '#00000010' } as ShadowOptions);
  }

  @Builder
  PaginationUI() {
    Row({ space: 10 }) {
      Button('上一页')
        .width(80)
        .height(30)
        .backgroundColor(this.pagination.pageNum <= 1 ? '#e0e0e0' : '#007bff')
        .fontColor('#ffffff')
        .onClick(() => {
          if (this.pagination.pageNum > 1) {
            this.onPrevPageClick();
          }
        });

      Text(`第${this.pagination.pageNum}页 / 共${Math.ceil(this.pagination.total / this.pagination.pageSize)}页`)
        .fontSize(14)
        .fontColor('#666666');

      Button('下一页')
        .width(80)
        .height(30)
        .backgroundColor(this.pagination.pageNum >= Math.ceil(this.pagination.total / this.pagination.pageSize) ? '#e0e0e0' : '#007bff')
        .fontColor('#ffffff')
        .onClick(() => {
          if (this.pagination.pageNum < Math.ceil(this.pagination.total / this.pagination.pageSize)) {
            this.onNextPageClick();
          }
        });
    }
    .width('90%')
    .margin({ top: 10, bottom: 20 })
    .justifyContent(FlexAlign.Center);
  }

  @Builder
  MessageTipUI() {
    if (this.pageState.showMessage) {
      Text(this.pageState.message)
        .fontSize(14)
        .fontColor(this.pageState.message.includes('成功') ? '#28a745' : '#dc3545')
        .backgroundColor('#ffffff')
        .padding(10)
        .borderRadius(4)
        .margin({ top: 10 })
        .width('80%')
        .textAlign(TextAlign.Center);
    }
  }

  // 新增：可滑动的弹窗UI
  @Builder
  DialogUI() {
    if (this.pageState.showAddDialog || this.pageState.showEditDialog) {
      // 遮罩层
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.5)');

        // 可滑动的弹窗内容
        Scroll() {
          Column({ space: 15 }) {
            Text(this.pageState.dialogTitle)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .textAlign(TextAlign.Center);

            this.FormItem_AccountUI();

            if (this.pageState.showAddDialog) {
              this.FormItem_PasswordUI();
            }

            this.FormItem_NameUI();
            this.FormItem_StatusUI();

            if (this.pageState.activeTab === 1 || this.pageState.activeTab === 2) {
              this.FormItem_ProfessionUI();
            }

            if (this.pageState.activeTab === 1) {
              this.FormItem_DepartmentUI();
              this.FormItem_TitleUI();
            }

            if (this.pageState.activeTab === 2) {
              this.FormItem_ClassUI();
            }

            Row({ space: 10 }) {
              Button('取消')
                .width(100)
                .height(36)
                .backgroundColor('#e0e0e0')
                .fontColor('#333333')
                .onClick(() => {
                  this.pageState.showAddDialog = false;
                  this.pageState.showEditDialog = false;
                });

              Button(this.pageState.showAddDialog ? '确认新增' : '确认修改')
                .width(100)
                .height(36)
                .backgroundColor('#28a745')
                .fontColor('#ffffff')
                .onClick(() => {
                  if (this.pageState.showAddDialog) {
                    this.onConfirmAddClick();
                  } else {
                    this.onConfirmEditClick();
                  }
                });
            }
          }
          .padding(20)
          .width('80%')
          .backgroundColor('#ffffff')
          .borderRadius(8);
        }
        .width('100%')
        .height('80%')
        .scrollable(ScrollDirection.Vertical);
      }
      .width('100%')
      .height('100%')
      .position({ top: 0, left: 0 });
    }
  }

  @Builder
  FormItem_AccountUI() {
    Column({ space: 5 }) {
      Text('账号')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入账号', text: this.formData.username })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .onChange((value: string) => {
          if (this.pageState.showAddDialog) {
            this.formData.username = value;
          }
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_PasswordUI() {
    Column({ space: 5 }) {
      Text('密码')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入密码', text: this.formData.password })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .type(InputType.Password)
        .onChange((value: string) => {
          this.formData.password = value;
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_NameUI() {
    Column({ space: 5 }) {
      Text('姓名')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入姓名', text: this.formData.name })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .onChange((value: string) => {
          this.formData.name = value;
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_StatusUI() {
    Column({ space: 5 }) {
      Text('状态')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      Row({ space: 10 }) {
        Button('启用')
          .width(80)
          .height(30)
          .backgroundColor(this.formData.status === 1 ? '#28a745' : '#f5f5f5')
          .fontColor(this.formData.status === 1 ? '#ffffff' : '#333333')
          .onClick(() => {
            this.formData.status = 1;
          });

        Button('禁用')
          .width(80)
          .height(30)
          .backgroundColor(this.formData.status === 0 ? '#dc3545' : '#f5f5f5')
          .fontColor(this.formData.status === 0 ? '#ffffff' : '#333333')
          .onClick(() => {
            this.formData.status = 0;
          });
      }
      .width('100%');
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_ProfessionUI() {
    Column({ space: 5 }) {
      Text('专业')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入专业', text: this.formData.profession })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .onChange((value: string) => {
          this.formData.profession = value;
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_DepartmentUI() {
    Column({ space: 5 }) {
      Text('所属部门')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入所属部门', text: this.formData.department })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .onChange((value: string) => {
          this.formData.department = value;
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_TitleUI() {
    Column({ space: 5 }) {
      Text('职称')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入职称', text: this.formData.title })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .onChange((value: string) => {
          this.formData.title = value;
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  @Builder
  FormItem_ClassUI() {
    Column({ space: 5 }) {
      Text('班级')
        .fontSize(14)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start);

      TextInput({ placeholder: '请输入班级', text: this.formData.className })
        .width('100%')
        .height(36)
        .border({ width: 1, color: '#e0e0e0', radius: 4 })
        .padding(8)
        .onChange((value: string) => {
          this.formData.className = value;
        });
    }
    .width('100%')
    .margin({ top: 5 });
  }

  // ========================== 业务逻辑（无UI代码，严格类型校验） ==========================
  private async onTabClick(tabIndex: number) {
    this.pageState.activeTab = tabIndex;
    this.pagination.pageNum = 1;
    await this.loadAccountList();
  }

  private onAddClick() {
    this.resetFormData();
    this.pageState.showAddDialog = true;
    this.pageState.showEditDialog = false;
    this.pageState.currentEditItemId = '';
    this.pageState.dialogTitle = `新增${this.identityLabels[this.pageState.activeTab]}账号`;
  }

  private async onRefreshClick() {
    await this.loadAccountList();
  }

  private onEditClick(item: AccountItem) {
    this.setFormData(item);
    this.pageState.currentEditItemId = item.itemKey || item.id.toString() || '';
    this.pageState.showEditDialog = true;
    this.pageState.showAddDialog = false;
    this.pageState.dialogTitle = `编辑${this.identityLabels[this.pageState.activeTab]}账号`;
  }

  private async onStatusClick(item: AccountItem) {
    await this.toggleAccountStatus(item);
  }

  private async onDeleteClick(item: AccountItem) {
    await this.deleteAccount(item);
  }

  private async onPrevPageClick() {
    this.pagination.pageNum--;
    await this.loadAccountList();
  }

  private async onNextPageClick() {
    this.pagination.pageNum++;
    await this.loadAccountList();
  }

  private async onConfirmAddClick() {
    await this.addAccount();
  }

  private async onConfirmEditClick() {
    await this.updateAccount();
  }

  /** 加载账号列表（严格类型 + 无对象展开） */
  private async loadAccountList() {
    this.pageState.isLoading = true;
    try {
      const request = http.createHttp();
      const url = this.getRequestUrl();
      console.log('请求URL:', url);

      const response = await request.request(url, { method: http.RequestMethod.GET }) as ApiResponse;
      if (response.responseCode !== 200 || typeof response.result !== 'string') {
        throw new Error(`请求失败，响应码：${response.responseCode}`);
      }

      let pageResult: PageResponse<Admin> | PageResponse<Teacher> | PageResponse<Student>;
      if (this.pageState.activeTab === 0) {
        pageResult = JSON.parse(response.result) as PageResponse<Admin>;
      } else if (this.pageState.activeTab === 1) {
        pageResult = JSON.parse(response.result) as PageResponse<Teacher>;
      } else {
        pageResult = JSON.parse(response.result) as PageResponse<Student>;
      }

      if (!pageResult.success || !pageResult.data) {
        this.updateMessage(pageResult.message || `加载${this.identityLabels[this.pageState.activeTab]}列表失败`);
        this.pageState.accountList = [];
        this.pagination.total = 0;
        return;
      }

      const processedList: AccountItem[] = [];
      for (const item of pageResult.data) {
        const status = item.status ?? 1;
        const statusText = this.statusText[status];
        const statusColor = this.statusColor[status];
        let itemKey = '';

        if (this.pageState.activeTab === 0) {
          const adminItem = item as Admin;
          itemKey = adminItem.id.toString();
          const processedAdmin: Admin = {
            id: adminItem.id,
            username: adminItem.username,
            name: adminItem.name,
            status: status,
            password: adminItem.password,
            role: adminItem.role,
            permissions: adminItem.permissions,
            phone: adminItem.phone,
            email: adminItem.email,
            lastLoginTime: adminItem.lastLoginTime,
            createdTime: adminItem.createdTime,
            statusText: statusText,
            statusColor: statusColor,
            itemKey: itemKey
          };
          processedList.push(processedAdmin);
        } else if (this.pageState.activeTab === 1) {
          const teacherItem = item as Teacher;
          itemKey = teacherItem.id || teacherItem.username;
          const processedTeacher: Teacher = {
            id: teacherItem.id,
            username: teacherItem.username,
            name: teacherItem.name,
            status: status,
            password: teacherItem.password,
            profession: teacherItem.profession,
            phone: teacherItem.phone,
            picture: teacherItem.picture,
            title: teacherItem.title,
            department: teacherItem.department,
            email: teacherItem.email,
            canAudit: teacherItem.canAudit,
            createdTime: teacherItem.createdTime,
            updatedTime: teacherItem.updatedTime,
            statusText: statusText,
            statusColor: statusColor,
            itemKey: itemKey
          };
          processedList.push(processedTeacher);
        } else {
          const studentItem = item as Student;
          itemKey = studentItem.id || studentItem.username;
          const processedStudent: Student = {
            id: studentItem.id,
            username: studentItem.username,
            name: studentItem.name,
            status: status,
            password: studentItem.password,
            profession: studentItem.profession,
            className: studentItem.className,
            totalScore: studentItem.totalScore,
            statusText: statusText,
            statusColor: statusColor,
            itemKey: itemKey
          };
          processedList.push(processedStudent);
        }
      }

      this.pageState.accountList = processedList;
      this.pagination.total = pageResult.total || 0;
      console.log('加载成功，数据量:', processedList.length, '总数:', pageResult.total);

    } catch (error) {
      const errMsg = (error as Error).message || '加载失败';
      this.updateMessage(errMsg);
      this.pageState.accountList = [];
      this.pagination.total = 0;
      console.error('加载失败:', errMsg);
    } finally {
      this.pageState.isLoading = false;
    }
  }

  /** 新增账号（适配教师/学生，严格匹配后端接口） */
  private async addAccount() {
    // 基础校验
    console.log(`[新增账号] 开始执行${this.identityLabels[this.pageState.activeTab]}新增操作`);

    if (!this.formData.username.trim()) {
      console.error('[新增账号] 校验失败：账号为空');
      this.updateMessage('账号不能为空');
      return;
    }
    if (!this.formData.password.trim()) {
      console.error('[新增账号] 校验失败：密码为空');
      this.updateMessage('密码不能为空');
      return;
    }
    if (!this.formData.name.trim()) {
      console.error('[新增账号] 校验失败：姓名为空');
      this.updateMessage('姓名不能为空');
      return;
    }

    try {
      const request = http.createHttp();
      let response: ApiResponse;
      let url = '';
      // 移除 any，分分支声明显式类型
      let postData: Admin | Teacher | Student;

      if (this.pageState.activeTab === 0) {
        // 管理员新增
        url = `${this.baseUrl}/admin`;
        postData = {
          id: 0,
          username: this.formData.username,
          password: this.formData.password,
          name: this.formData.name,
          status: this.formData.status,
          role: 'admin',
          permissions: null,
          phone: '',
          email: '',
          lastLoginTime: null,
          createdTime: new Date().toISOString(),
          statusText: '',
          statusColor: '',
          itemKey: ''
        };
        console.log(`[新增账号] 管理员新增 - 请求URL: ${url}，请求参数:`, JSON.stringify(postData));

      } else if (this.pageState.activeTab === 1) {
        // 教师新增（严格匹配后端字段）
        url = `${this.baseUrl}/teacher`;
        postData = {
          id: this.formData.username, // 与后端保持一致：ID=账号
          username: this.formData.username,
          password: this.formData.password,
          name: this.formData.name,
          status: this.formData.status,
          profession: this.formData.profession,
          phone: null,
          picture: null,
          title: this.formData.title,
          department: this.formData.department,
          email: '',
          canAudit: 1,
          createdTime: new Date().toISOString(),
          updatedTime: new Date().toISOString(),
          statusText: '',
          statusColor: '',
          itemKey: ''
        };
        console.log(`[新增账号] 教师新增 - 请求URL: ${url}，请求参数:`, JSON.stringify(postData));

      } else {
        // 学生新增（补充密码字段）
        url = `${this.baseUrl}/student`;
        postData = {
          id: this.formData.username,
          username: this.formData.username,
          password: this.formData.password,
          name: this.formData.name,
          status: this.formData.status,
          profession: this.formData.profession,
          className: this.formData.className,
          totalScore: 0,
          statusText: '',
          statusColor: '',
          itemKey: ''
        };
        console.log(`[新增账号] 学生新增 - 请求URL: ${url}，请求参数:`, JSON.stringify(postData));

      }

      // 发送新增请求
      console.log(`[新增账号] 开始发送POST请求到: ${url}`);
      response = await request.request(url, {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(postData)
      }) as ApiResponse;
      console.log(`[新增账号] 请求响应 - 状态码: ${response.responseCode}，响应体: ${response.result}`);

      // 处理响应
      if (response.responseCode === 200) {
        const result = JSON.parse(response.result || '{"success":true}') as GeneratedTypeLiteralInterface_1;
        console.log(`[新增账号] 响应解析结果:`, result);
        if (result.success) {
          console.log(`[新增账号] ${this.identityLabels[this.pageState.activeTab]}新增成功`);

          this.updateMessage(`新增${this.identityLabels[this.pageState.activeTab]}成功`);
          this.pageState.showAddDialog = false;
          await this.loadAccountList();
        } else {
          console.error(`[新增账号] ${this.identityLabels[this.pageState.activeTab]}新增失败：${result.message}`);
          this.updateMessage(`新增${this.identityLabels[this.pageState.activeTab]}失败：${result.message}`);
        }
      } else {
        console.error(`[新增账号] ${this.identityLabels[this.pageState.activeTab]}新增失败 - 响应码非200: ${response.responseCode}`);
        this.updateMessage(`新增${this.identityLabels[this.pageState.activeTab]}失败`);
      }
    } catch (error) {
      const errMsg = (error as Error).message || '新增失败';
      this.updateMessage(errMsg);
      console.error(`[新增账号] 异常捕获 - ${this.identityLabels[this.pageState.activeTab]}新增失败：`, error); // 输出完整错误对象

      console.error('新增失败:', errMsg);
    }
  }

  /** 修改账号（适配教师/学生，保留原密码） */
  private async updateAccount() {
    console.log(`[修改账号] 开始执行${this.identityLabels[this.pageState.activeTab]}修改操作，当前编辑ID: ${this.pageState.currentEditItemId}`);

    if (!this.formData.name.trim()) {
      this.updateMessage('姓名不能为空');
      return;
    }

    const itemId = this.pageState.currentEditItemId;
    if (!itemId) {
      console.error('[修改账号] 校验失败：未获取到账号ID');
      this.updateMessage('修改失败：未获取到账号ID');
      return;
    }

    try {
      const request = http.createHttp();
      let url = '';
      // 移除 any，分分支声明显式类型
      let putData: Admin | Teacher | Student;
      let response: ApiResponse;

      if (this.pageState.activeTab === 0) {
        // 管理员修改
        url = `${this.baseUrl}/admin`;
        putData = {
          id: Number(itemId),
          username: this.formData.username,
          name: this.formData.name,
          status: this.formData.status,
          password: '', // 后端保留原密码
          role: 'admin',
          permissions: null,
          phone: '',
          email: '',
          lastLoginTime: null,
          createdTime: new Date().toISOString(),
          statusText: '',
          statusColor: '',
          itemKey: ''
        };
        console.log(`[修改账号] 管理员修改 - 请求URL: ${url}，请求参数:`, JSON.stringify(putData));

      } else if (this.pageState.activeTab === 1) {
        // 教师修改
        url = `${this.baseUrl}/teacher`;
        putData = {
          id: itemId,
          username: this.formData.username,
          name: this.formData.name,
          status: this.formData.status,
          password: '', // 后端保留原密码
          profession: this.formData.profession,
          phone: null,
          picture: null,
          title: this.formData.title,
          department: this.formData.department,
          email: '',
          canAudit: 1,
          createdTime: new Date().toISOString(),
          updatedTime: new Date().toISOString(),
          statusText: '',
          statusColor: '',
          itemKey: ''
        };
        console.log(`[修改账号] 教师修改 - 请求URL: ${url}，请求参数:`, JSON.stringify(putData));

      } else {
        // 学生修改
        url = `${this.baseUrl}/student`;
        putData = {
          id: itemId,
          username: this.formData.username,
          name: this.formData.name,
          status: this.formData.status,
          password: '', // 后端保留原密码
          profession: this.formData.profession,
          className: this.formData.className,
          totalScore: 0,
          statusText: '',
          statusColor: '',
          itemKey: ''
        };
        console.log(`[修改账号] 学生修改 - 请求URL: ${url}，请求参数:`, JSON.stringify(putData));

      }

      // 发送修改请求
      console.log(`[修改账号] 开始发送PUT请求到: ${url}`);

      response = await request.request(url, {
        method: http.RequestMethod.PUT,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(putData)
      }) as ApiResponse;
      console.log(`[修改账号] 请求响应 - 状态码: ${response.responseCode}，响应体: ${response.result}`);

      // 处理响应
      if (response.responseCode === 200) {
        const result = JSON.parse(response.result || '{"success":true}') as GeneratedTypeLiteralInterface_1;
        console.log(`[修改账号] 响应解析结果:`, result);
        if (result.success) {
          console.log(`[修改账号] ${this.identityLabels[this.pageState.activeTab]}修改成功`);
          this.updateMessage(`修改${this.identityLabels[this.pageState.activeTab]}成功`);
          this.pageState.showEditDialog = false;
          await this.loadAccountList();
        } else {
          console.error(`[修改账号] ${this.identityLabels[this.pageState.activeTab]}修改失败：${result.message}`);
          this.updateMessage(`修改${this.identityLabels[this.pageState.activeTab]}失败：${result.message}`);
        }
      } else {
        console.error(`[修改账号] ${this.identityLabels[this.pageState.activeTab]}修改失败 - 响应码非200: ${response.responseCode}`);

        this.updateMessage(`修改${this.identityLabels[this.pageState.activeTab]}失败`);
      }
    } catch (error) {
      const errMsg = (error as Error).message || '修改失败';
      this.updateMessage(errMsg);
      console.error(`[修改账号] 异常捕获 - ${this.identityLabels[this.pageState.activeTab]}修改失败：`, error); // 输出完整错误对象

      console.error('修改失败:', errMsg);
    }
  }

  /** 删除账号（已验证可用，保留） */
  private async deleteAccount(item: AccountItem) {
    try {
      const request = http.createHttp();
      const itemId = item.itemKey || item.id.toString() || '';
      let url = '';

      if (this.pageState.activeTab === 0) {
        url = `${this.baseUrl}/admin/${itemId}`;
      } else if (this.pageState.activeTab === 1) {
        url = `${this.baseUrl}/teacher/${itemId}`;
      } else if (this.pageState.activeTab === 2) {
        url = `${this.baseUrl}/student/${itemId}`;
      }

      const response = await request.request(url, { method: http.RequestMethod.DELETE }) as ApiResponse;

      if (response.responseCode === 200) {
        this.updateMessage(`删除${this.identityLabels[this.pageState.activeTab]}成功`);
        await this.loadAccountList();
      } else {
        this.updateMessage(`删除${this.identityLabels[this.pageState.activeTab]}失败`);
      }
    } catch (error) {
      const errMsg = (error as Error).message || '删除失败';
      this.updateMessage(errMsg);
      console.error('删除失败:', errMsg);
    }
  }

  /** 切换账号状态（前端更新，后端需同步接口） */
  /** 切换账号状态（前端更新，后端需同步接口） */
  private async toggleAccountStatus(item: AccountItem) {
    try {
      const newStatus = item.status === 1 ? 0 : 1;
      const newStatusText = this.statusText[newStatus];
      const newStatusColor = this.statusColor[newStatus];

      const updatedList: AccountItem[] = [];
      for (const acc of this.pageState.accountList) {
        if (acc.itemKey === item.itemKey) {
          if (this.pageState.activeTab === 0) {
            const adminAcc = acc as Admin;
            // 移除扩展运算符，手动赋值所有字段
            const updatedAdmin: Admin = {
              id: adminAcc.id,
              username: adminAcc.username,
              name: adminAcc.name,
              status: newStatus,
              password: adminAcc.password,
              role: adminAcc.role,
              permissions: adminAcc.permissions,
              phone: adminAcc.phone,
              email: adminAcc.email,
              lastLoginTime: adminAcc.lastLoginTime,
              createdTime: adminAcc.createdTime,
              statusText: newStatusText,
              statusColor: newStatusColor,
              itemKey: adminAcc.itemKey
            };
            updatedList.push(updatedAdmin);
          } else if (this.pageState.activeTab === 1) {
            const teacherAcc = acc as Teacher;
            // 移除扩展运算符，手动赋值所有字段
            const updatedTeacher: Teacher = {
              id: teacherAcc.id,
              username: teacherAcc.username,
              name: teacherAcc.name,
              status: newStatus,
              password: teacherAcc.password,
              profession: teacherAcc.profession,
              phone: teacherAcc.phone,
              picture: teacherAcc.picture,
              title: teacherAcc.title,
              department: teacherAcc.department,
              email: teacherAcc.email,
              canAudit: teacherAcc.canAudit,
              createdTime: teacherAcc.createdTime,
              updatedTime: teacherAcc.updatedTime,
              statusText: newStatusText,
              statusColor: newStatusColor,
              itemKey: teacherAcc.itemKey
            };
            updatedList.push(updatedTeacher);
          } else {
            const studentAcc = acc as Student;
            // 移除扩展运算符，手动赋值所有字段
            const updatedStudent: Student = {
              id: studentAcc.id,
              username: studentAcc.username,
              name: studentAcc.name,
              status: newStatus,
              password: studentAcc.password,
              profession: studentAcc.profession,
              className: studentAcc.className,
              totalScore: studentAcc.totalScore,
              statusText: newStatusText,
              statusColor: newStatusColor,
              itemKey: studentAcc.itemKey
            };
            updatedList.push(updatedStudent);
          }
        } else {
          updatedList.push(acc);
        }
      }
      this.pageState.accountList = updatedList;

      // 同步后端状态（可选，根据后端接口调整）
      const request = http.createHttp();
      const itemId = item.itemKey || item.id.toString() || '';
      let url = '';
      if (this.pageState.activeTab === 0) {
        url = `${this.baseUrl}/admin/status/${itemId}?status=${newStatus}`;
      } else if (this.pageState.activeTab === 1) {
        url = `${this.baseUrl}/teacher/status/${itemId}?status=${newStatus}`;
      } else {
        url = `${this.baseUrl}/student/status/${itemId}?status=${newStatus}`;
      }
      await request.request(url, { method: http.RequestMethod.PUT });

      this.updateMessage(`${newStatus === 1 ? '启用' : '禁用'}成功`);
    } catch (error) {
      const errMsg = (error as Error).message || '状态修改失败';
      this.updateMessage(errMsg);
      console.error('状态修改失败:', errMsg);
    }
  }

  private updateMessage(msg: string) {
    this.pageState.message = msg;
    this.pageState.showMessage = true;
    setTimeout(() => {
      this.pageState.showMessage = false;
    }, 3000);
  }

  private getRequestUrl(): string {
    const pageParams = `pageNum=${this.pagination.pageNum}&pageSize=${this.pagination.pageSize}`;
    if (this.pageState.activeTab === 0) {
      return `${this.baseUrl}/admin/page?${pageParams}`;
    } else if (this.pageState.activeTab === 1) {
      return `${this.baseUrl}/teacher/page?${pageParams}`;
    } else {
      return `${this.baseUrl}/student/page?${pageParams}`;
    }
  }

  private resetFormData() {
    this.formData = {
      username: '',
      password: '',
      name: '',
      status: 1,
      profession: '',
      className: '',
      department: '',
      title: ''
    };
  }

  private setFormData(item: AccountItem) {
    let status = 1;
    let profession = '';
    let className = '';
    let department = '';
    let title = '';

    if (this.pageState.activeTab === 0) {
      status = (item as Admin).status;
    } else if (this.pageState.activeTab === 1) {
      const teacherItem = item as Teacher;
      status = teacherItem.status ?? 1;
      profession = teacherItem.profession || '';
      department = teacherItem.department || '';
      title = teacherItem.title || '';
    } else if (this.pageState.activeTab === 2) {
      const studentItem = item as Student;
      status = studentItem.status ?? 1;
      profession = studentItem.profession || '';
      className = studentItem.className || '';
    }

    this.formData = {
      username: item.username,
      password: '',
      name: item.name,
      status: status,
      profession: profession,
      className: className,
      department: department,
      title: title
    };
  }
}