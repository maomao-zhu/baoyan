import { router} from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { AppState } from '../utils/AppState';
import { ScoreItemData, TeacherData } from '../utils/types';

// 强类型接口定义
interface ApproveRequest {
  teacherId: string;
  teacherName: string;
  auditNote: string;
}

interface RejectRequest {
  teacherId: string;
  teacherName: string;
  rejectReason: string;
}

interface PendingItemsResponse {
  data: ScoreItemData[];
}

interface AuditedItemsResponse {
  data: ScoreItemData[];
}

// 组件属性接口（约束UI组件属性）
interface GeneratedTypeLiteralInterface_2 {
  radius: number;
  color: string;
}

interface GeneratedTypeLiteralInterface_1 {
  left?: number;
  right?: number;
  bottom?: number;
}

interface UIComponentStyle {
  space?: number;
  width?: string;
  padding?: number | GeneratedTypeLiteralInterface_1;
  backgroundColor?: string;
  borderRadius?: number;
  shadow?: GeneratedTypeLiteralInterface_2;
}


interface GeneratedTypeLiteralInterface_3 {
  success: boolean;
  data: ScoreItemData[];
  message?: string;
}

@Entry
@Component
struct ShenhePage {
  // 状态定义（仅状态，无其他代码）
  @State pendingItems: ScoreItemData[] = [];
  @State isLoading: boolean = true;
  @State message: string = '';
  @State showMessage: boolean = false;
  @State rejectReason: string = '';
  @State currentItemId: number = -1;
  @State showRejectDialog: boolean = false;
  @State activeTab: number = 0; // 改用数字表示标签（0=待审核，1=已审核）
  @State auditedItems: ScoreItemData[] = [];
  @State isAuditedLoading: boolean = false;
  @State auditFilter: number = 0; // 0=全部，1=通过，2=驳回

  private baseUrl: string = 'http://10.125.138.244:8080';
  private teacherId: string = '';
  private teacherName: string = '';


  // 页面初始化逻辑（移到aboutToAppear，不写在build中）
  async aboutToAppear() {
    const appState = AppState.getInstance();
    const teacherData = appState.getTeacherData();
    const userIdentity = appState.userIdentity;
    const isLoggedIn = appState.isLoggedIn;

    if (teacherData && userIdentity === '教师') {
      this.teacherId = teacherData.id;
      this.teacherName = teacherData.name;
      await this.loadPendingItems();
    } else {
      this.showCustomMessage('未获取到教师信息，请重新登录');
      setTimeout(() => router.pushUrl({ url: 'pages/LoginPage' }), 1500);
    }
  }


  // build方法：仅包含UI组件嵌套
  build() {
    Column({ space: 0 } as UIComponentStyle) {
      // 顶部标题
      Text('加分项审核管理')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .width('90%')
        .textAlign(TextAlign.Start);

      // 标签切换栏（用Row+Button模拟SegmentedControl，解决导入报错）
      Row({ space: 0 } as UIComponentStyle) {
        Button('待审核')
          .width('50%')
          .height(40)
          .fontSize(16)
          .backgroundColor(this.activeTab === 0 ? '#28a745' : '#f5f5f5')
          .fontColor(this.activeTab === 0 ? '#ffffff' : '#333333')
          .border({ width: 0 })
          .onClick(() => {
            this.activeTab = 0;
            this.loadPendingItems();
          });

        Button('已审核')
          .width('50%')
          .height(40)
          .fontSize(16)
          .backgroundColor(this.activeTab === 1 ? '#28a745' : '#f5f5f5')
          .fontColor(this.activeTab === 1 ? '#ffffff' : '#333333')
          .border({ width: 0 })
          .onClick(() => {
            this.activeTab = 1;
            this.loadAuditedItems();
          });
      }
      .width('90%')
      .margin({ top: 10 });


      // 待审核标签内容（纯UI组件）
      if (this.activeTab === 0) {
        if (this.isLoading) {
          Progress({ value: 50, total: 100 })
            .width(200)
            .margin({ top: 50 });
        } else if (this.pendingItems.length === 0) {
          Text('暂无待审核的加分项目')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 50 });
        } else {
          List({ space: 10 } as UIComponentStyle) {
            ForEach(this.pendingItems, (item: ScoreItemData) => {
              ListItem() {
                this.buildPendingItem(item);
              }
            }, (item: ScoreItemData) => item.id.toString());
          }
          .width('90%')
          .margin({ top: 10 });
        }
      }


      // 已审核标签内容（纯UI组件）
      if (this.activeTab === 1) {
        // 筛选栏（纯UI）
        Row({ space: 10 } as UIComponentStyle) {
          Text('筛选：')
            .fontSize(14)
            .fontColor('#666666');

          Button('全部')
            .width(80)
            .height(30)
            .fontSize(14)
            .backgroundColor(this.auditFilter === 0 ? '#28a745' : '#f5f5f5')
            .fontColor(this.auditFilter === 0 ? '#ffffff' : '#333333')
            .onClick(() => this.auditFilter = 0);

          Button('通过')
            .width(80)
            .height(30)
            .fontSize(14)
            .backgroundColor(this.auditFilter === 1 ? '#28a745' : '#f5f5f5')
            .fontColor(this.auditFilter === 1 ? '#ffffff' : '#333333')
            .onClick(() => this.auditFilter = 1);

          Button('驳回')
            .width(80)
            .height(30)
            .fontSize(14)
            .backgroundColor(this.auditFilter === 2 ? '#28a745' : '#f5f5f5')
            .fontColor(this.auditFilter === 2 ? '#ffffff' : '#333333')
            .onClick(() => this.auditFilter = 2);
        }
        .width('90%')
        .margin({ top: 10 })
        .justifyContent(FlexAlign.Start);


        if (this.isAuditedLoading) {
          Progress({ value: 50, total: 100 })
            .width(200)
            .margin({ top: 50 });
        } else if (this.getFilteredAuditedItems().length === 0) {
          Text(this.auditFilter === 0 ? '暂无已审核的加分项目记录' : this.auditFilter === 1 ? '暂无通过的加分项目记录' : '暂无驳回的加分项目记录')
            .fontSize(16)
            .fontColor('#666666')
            .margin({ top: 50 });
        } else {
          List({ space: 10 } as UIComponentStyle) {
            ForEach(this.getFilteredAuditedItems(), (item: ScoreItemData) => {
              ListItem() {
                this.buildAuditedItem(item);
              }
            }, (item: ScoreItemData) => item.id.toString());
          }
          .width('90%')
          .margin({ top: 10 });
        }
      }


      // 消息提示（纯UI）
      if (this.showMessage) {
        Text(this.message)
          .fontSize(14)
          .fontColor(this.message.includes('成功') ? '#28a745' : '#dc3545')
          .backgroundColor('#ffffff')
          .padding(10)
          .borderRadius(4)
          .margin({ top: 10 })
          .width('80%')
          .textAlign(TextAlign.Center);
      }


      // 驳回对话框（纯UI）
      if (this.showRejectDialog) {
        Column({ space: 15 } as UIComponentStyle) {
          Text('请输入驳回原因')
            .fontSize(16)
            .fontWeight(FontWeight.Bold);

          TextInput({ placeholder: '请说明驳回该加分项的原因...', text: this.rejectReason })
            .width('100%')
            .height(120)
            .border({ width: 1, color: '#e0e0e0', radius: 4 })
            .padding(10)
            .maxLines(6)
            .onChange((value: string) => this.rejectReason = value);

          Row({ space: 10 } as UIComponentStyle) {
            Button('取消')
              .width(100)
              .height(36)
              .backgroundColor('#e0e0e0')
              .onClick(() => this.showRejectDialog = false);

            Button('确认驳回')
              .width(100)
              .height(36)
              .backgroundColor('#dc3545')
              .onClick(() => {
                if (!this.rejectReason.trim()) {
                  this.showCustomMessage('请输入驳回原因');
                  return;
                }
                this.handleReject(this.currentItemId, this.rejectReason);
                this.showRejectDialog = false;
              });
          }
        }
        .padding(20)
        .width('80%')
        .backgroundColor('#ffffff')
        .borderRadius(8)
        .position({ left: '10%', top: '30%' })
        .zIndex(999);
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5');
  }


  // 待审核项目UI（@Builder内仅UI组件）
  @Builder
  buildPendingItem(item: ScoreItemData) {
    Column({ space: 10 } as UIComponentStyle) {
      Row({ space: 0 } as UIComponentStyle) {
        Column({ space: 6 } as UIComponentStyle) {
          Text(`学生：${item.studentName}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium);
          Text(`项目名称：${item.itemName}`)
            .fontSize(14);
          Text(`项目类别：${item.itemCategory}`)
            .fontSize(14);
          Text(`申请分数：${item.itemScore}分`)
            .fontSize(14);
          Text(`提交时间：${this.formatTime(item.createTime)}`)
            .fontSize(12)
            .fontColor('#666666');
        }
        .width('70%')
        .padding(10);

        Column({ space: 8 } as UIComponentStyle) {
          Button('通过')
            .width(80)
            .height(36)
            .fontSize(14)
            .backgroundColor('#28a745')
            .onClick(() => this.handleApprove(item.id));

          Button('驳回')
            .width(80)
            .height(36)
            .fontSize(14)
            .backgroundColor('#dc3545')
            .onClick(() => {
              this.currentItemId = item.id;
              this.rejectReason = '';
              this.showRejectDialog = true;
            });
        }
        .width('30%');
      }

      if (item.itemDescription) {
        Text(`项目描述：${item.itemDescription}`)
          .fontSize(14)
          .width('100%')
          .padding({ left: 10, right: 10, bottom: 10 })
          .textAlign(TextAlign.Start);
      }
    }
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .shadow({ radius: 2, color: '#00000010' });
  }


  // 已审核项目UI（@Builder内仅UI组件，变量用内联表达式）
  @Builder
  buildAuditedItem(item: ScoreItemData) {
    Column({ space: 10 } as UIComponentStyle) {
      Row({ space: 0 } as UIComponentStyle) {
        Column({ space: 6 } as UIComponentStyle) {
          Text(`学生：${item.studentName}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium);
          Text(`项目名称：${item.itemName}`)
            .fontSize(14);
          Text(`项目类别：${item.itemCategory}`)
            .fontSize(14);
          Text(`申请分数：${item.itemScore}分`)
            .fontSize(14);
          Text(`提交时间：${this.formatTime(item.createTime)}`)
            .fontSize(12)
            .fontColor('#666666');
        }
        .width('70%')
        .padding(10);

        Column({ space: 8 } as UIComponentStyle) {
          Text(item.status === 1 ? '审核通过' : '审核驳回')
            .fontSize(14)
            .fontColor(item.status === 1 ? '#28a745' : '#dc3545')
            .backgroundColor(item.status === 1 ? '#d4edda' : '#f8d7da')
            .padding(4)
            .borderRadius(4)
            .width(80)
            .textAlign(TextAlign.Center);
        }
        .width('30%');
      }

      if (item.itemDescription) {
        Text(`项目描述：${item.itemDescription}`)
          .fontSize(14)
          .width('100%')
          .padding({ left: 10 })
          .textAlign(TextAlign.Start);
      }

      Column({ space: 4 } as UIComponentStyle) {
        Text(`审核人：${item.auditorName || this.teacherName}`)
          .fontSize(12)
          .fontColor('#666666');
        Text(`审核时间：${this.formatTime(item.auditTime || item.updateTime)}`)
          .fontSize(12)
          .fontColor('#666666');

        if (item.status === 1 && item.auditNote) {
          Text(`审核备注：${item.auditNote}`)
            .fontSize(12)
            .fontColor('#28a745');
        }
        if (item.status === 2 && item.rejectReason) {
          Text(`驳回原因：${item.rejectReason}`)
            .fontSize(12)
            .fontColor('#dc3545');
        }
      }
      .width('100%')
      .padding({ left: 10, right: 10, bottom: 10 });
    }
    .backgroundColor(item.status === 1 ? '#f0f8f0' : '#fdf2f2')
    .borderRadius(8)
    .shadow({ radius: 2, color: '#00000010' });
  }


  async loadPendingItems() {
    this.isLoading = true;
    try {
      const httpRequest = http.createHttp();
      const url = `${this.baseUrl}/teacher/pending-items?pageNum=1&pageSize=100`;
      const response = await httpRequest.request(url, { method: http.RequestMethod.GET });

      if (response.responseCode === 200 && typeof response.result === 'string') {
        const result: GeneratedTypeLiteralInterface_3 = JSON.parse(response.result);
        if (result.success) {
          this.pendingItems = result.data || [];
        } else {
          this.showCustomMessage(`加载待审核项目失败：${result.message || '后端返回错误'}`);
          this.pendingItems = [];
        }
      } else {
        this.showCustomMessage('加载待审核项目失败：响应码异常');
        this.pendingItems = [];
      }
    } catch (error) {
      console.error('加载待审核错误:', error);
      this.showCustomMessage('网络错误，无法加载待审核项目');
      this.pendingItems = [];
    } finally {
      this.isLoading = false;
    }
  }

  async loadAuditedItems() {
    this.isAuditedLoading = true;
    try {
      const httpRequest = http.createHttp();
      // 修正：接口路径改为/processed-items，仅传递teacherId参数（后端不支持pageNum/pageSize）
      const url = `${this.baseUrl}/teacher/processed-items?teacherId=${this.teacherId}`;
      console.log('已审核项目请求地址：', url);
      console.log('当前教师ID：', this.teacherId);

      const response = await httpRequest.request(url, { method: http.RequestMethod.GET });

      console.log('已审核项目响应码：', response.responseCode);
      console.log('已审核项目响应结果：', response.result);

      if (response.responseCode === 200 && typeof response.result === 'string') {
        const result: GeneratedTypeLiteralInterface_3 = JSON.parse(response.result);
        console.log('已审核项目解析后数据：', result);
        // 适配后端返回的success字段：成功则取data，失败则提示
        if (result.success) {
          this.auditedItems = result.data || [];
        } else {
          this.showCustomMessage(`加载已审核项目失败：${result.message || '后端返回错误'}`);
          this.auditedItems = [];
        }
      } else {
        console.error('加载失败：响应码不是200或结果不是字符串', response.responseCode, typeof response.result);
        this.showCustomMessage(`加载已审核项目失败：响应码${response.responseCode}`);
        this.auditedItems = [];
      }
    } catch (error) {
      console.error('加载已审核项目异常：', error);
      if ((error as Error).message.includes('Network')) {
        this.showCustomMessage('网络错误，无法连接到服务器');
      } else if ((error as Error).message.includes('JSON')) {
        this.showCustomMessage('数据解析错误，后端返回格式不正确');
      } else {
        this.showCustomMessage(`网络错误，无法加载已审核项目：${(error as Error).message}`);
      }
      this.auditedItems = [];
    } finally {
      this.isAuditedLoading = false;
    }
  }

  getFilteredAuditedItems(): ScoreItemData[] {
    if (this.auditFilter === 0) return this.auditedItems;
    if (this.auditFilter === 1) return this.auditedItems.filter(item => item.status === 1);
    return this.auditedItems.filter(item => item.status === 2);
  }

  async handleApprove(itemId: number) {
    try {
      const httpRequest = http.createHttp();
      const url = `${this.baseUrl}/teacher/approve/${itemId}`;
      const requestData: ApproveRequest = {
        teacherId: this.teacherId,
        teacherName: this.teacherName,
        auditNote: '审核通过'
      };
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(requestData)
      });

      if (response.responseCode === 200) {
        this.showCustomMessage('审核通过成功');
        this.loadPendingItems();
      } else {
        this.showCustomMessage('审核通过失败');
      }
    } catch (error) {
      console.error('审核错误:', error);
      this.showCustomMessage('网络错误，审核失败');
    }
  }

  async handleReject(itemId: number, reason: string) {
    try {
      const httpRequest = http.createHttp();
      const url = `${this.baseUrl}/teacher/reject/${itemId}`;
      const requestData: RejectRequest = {
        teacherId: this.teacherId,
        teacherName: this.teacherName,
        rejectReason: reason
      };
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(requestData)
      });

      if (response.responseCode === 200) {
        this.showCustomMessage('驳回成功');
        this.loadPendingItems();
      } else {
        this.showCustomMessage('驳回失败');
      }
    } catch (error) {
      console.error('驳回错误:', error);
      this.showCustomMessage('网络错误，驳回失败');
    }
  }

  formatTime(timeString: string): string {
    if (!timeString) return '';
    const date = new Date(timeString);
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
  }

  showCustomMessage(msg: string) {
    this.message = msg;
    this.showMessage = true;
    setTimeout(() => this.showMessage = false, 3000);
  }
}