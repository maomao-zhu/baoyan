import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { StudentData, TeacherData, AdminData } from '../utils/types';
import { AppState } from '../utils/AppState';
interface TeacherLoginResponse {
  success: boolean;
  message: string;
  data: TeacherData | null;
}

interface GeneratedTypeLiteralInterface_1 {
  success: boolean;
  message: string;
  data: AdminData | null;
}

@Entry
@Component
struct LoginPage {
  @State userId: string = '';
  @State password: string = '';
  @State identity: string = '学生';
  @State isLoading: boolean = false;
  @State message: string = '';
  @State showMessage: boolean = false;
  private baseUrl: string = 'http://10.125.138.244:8080';


  build() {
    Column({ space: 20 }) {
      // 欢迎标题区域（原代码保留）
      Column({ space: 8 }) {
        Text('欢迎回来！')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 60 })
          .fontColor('#1a1a1a')
        Text('请选择你登录的"身份"')
          .fontSize(16)
          .fontColor('#666666')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 表单区域（原代码保留）
      Column({ space: 16 }) {
        TextInput({ placeholder: '学号/工号', text: this.userId })
          .width('80%')
          .height(48)
          .padding({ left: 12, right: 12 })
          .backgroundColor(Color.White)
          .border({ width: 1, color: '#e0e0e0', radius: 8 })
          .onChange((value: string) => {
            this.userId = value;
          })
        TextInput({ placeholder: '密码', text: this.password })
          .width('80%')
          .height(48)
          .padding({ left: 12, right: 12 })
          .backgroundColor(Color.White)
          .border({ width: 1, color: '#e0e0e0', radius: 8 })
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value;
          })
      }
      .width('100%')
      .margin({ top: 40 })

      // 消息提示区域（原代码保留）
      if (this.showMessage) {
        Text(this.message)
          .fontSize(14)
          .fontColor(this.message.includes('成功') ? '#28a745' : '#dc3545')
          .backgroundColor(Color.White)
          .padding(10)
          .border({ width: 1, color: this.message.includes('成功') ? '#28a745' : '#dc3545', radius: 4 })
          .margin({ top: 10 })
          .width('80%')
          .textAlign(TextAlign.Center)
      }

      // 身份选择区域（原代码保留）
      Row({ space: 30 }) {
        this.buildIdentityButton('管理员')
        this.buildIdentityButton('教师')
        this.buildIdentityButton('学生')
      }
      .margin({ top: 20 })

      // 登录按钮（原代码保留）
      Button(this.isLoading ? '登录中...' : '登入')
        .width('80%')
        .height(48)
        .backgroundColor(this.isLoading ? '#cccccc' : '#007AFF')
        .fontColor(Color.White)
        .margin({ top: 40 })
        .enabled(!this.isLoading)
        .onClick(() => {
          this.handleLogin();
        })

      // 调试信息（原代码保留）
      Column({ space: 4 }) {
        Text(`当前账号: ${this.userId}`)
          .fontSize(12)
          .fontColor('#666666')
        Text(`后端地址: ${this.baseUrl}`)
          .fontSize(10)
          .fontColor('#ff6b35')
      }
      .width('80%')
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 身份按钮构建（原代码保留）
  @Builder
  buildIdentityButton(label: string) {
    Button(label)
      .width(80)
      .height(36)
      .fontSize(14)
      .backgroundColor(this.identity === label ? '#007AFF' : '#FFFFFF')
      .fontColor(this.identity === label ? Color.White : Color.Black)
      .onClick(() => {
        this.identity = label;
        this.showCustomMessage(`已选择: ${label}`);
      })
  }

  // 登录逻辑（核心修改部分）
  async handleLogin() {
    console.log('=== 开始登录 ===');
    console.log('账号:', this.userId);
    console.log('密码长度:', this.password.length);
    console.log('当前身份:', this.identity);

    // 基础校验（原代码保留）
    if (!this.userId.trim()) {
      this.showCustomMessage('请输入账号');
      return;
    }
    if (!this.password.trim()) {
      this.showCustomMessage('请输入密码');
      return;
    }



    this.isLoading = true;
    this.showMessage = false;

    try {
      let userData: StudentData | TeacherData | AdminData | null = null;

      if (this.identity === '学生') {
        userData = await this.studentLoginRequest(this.userId, this.password);
      } else if (this.identity === '教师') {
        userData = await this.teacherLoginRequest(this.userId, this.password);
      } else if (this.identity === '管理员') {
        userData = await this.adminLoginRequest(this.userId, this.password); // 调用新增的管理员登录方法
      }

      if (userData) {
        console.log('登录成功');
        this.showCustomMessage('登录成功！正在跳转...', true);
        // 保存用户数据到全局状态（修改点3：适配多身份）
        const appState = AppState.getInstance();
        appState.setUserInfo(userData, this.identity);

        // 延迟跳转，根据身份跳转到对应页面（修改点4）
        setTimeout(() => {
          if (this.identity === '学生') {
            router.pushUrl({
              url: 'pages/Index',
              params: { userId: this.userId, userIdentity: this.identity }
            });
          } else if (this.identity === '教师') {
            router.pushUrl({
              url: 'pages/Shenhe',
              params: { teacherId: this.userId, userIdentity: this.identity }
            });
          }
          else if (this.identity === '管理员') {
            router.pushUrl({
              url: 'pages/ManagementPage', // 替换为你的管理员页面路径
              params: { adminId: this.userId, userIdentity: this.identity }
            });
          }
        }, 1500);
      } else {
        console.log('登录失败');
        this.showCustomMessage('登录失败，请检查账号和密码');
      }
    } catch (error) {
      console.error('登录过程错误:', this.errorToString(error));
      this.showCustomMessage('网络请求失败，请检查连接');
    } finally {
      this.isLoading = false;
    }
  }

  // 学生登录请求（原代码保留，仅修改方法名）
  async studentLoginRequest(userId: string, password: string): Promise<StudentData | null> {
    try {
      let httpRequest = http.createHttp();
      console.log('学生登录请求URL:', `${this.baseUrl}/student/${userId}`);
      let response = await httpRequest.request(
        `${this.baseUrl}/student/${userId}`,
        {
          method: http.RequestMethod.GET,
          connectTimeout: 15000,
          readTimeout: 15000
        }
      );
      console.log('学生登录响应状态码:', response.responseCode);

      if (response.responseCode === 200) {
        const responseText = response.result.toString();
        console.log('学生登录响应数据:', responseText);
        const studentData: StudentData = JSON.parse(responseText) as StudentData;
        // 验证密码
        if (studentData.password === password) {
          return studentData;
        } else {
          return null;
        }
      } else {
        console.log('学生账号不存在或其他错误');
        return null;
      }
    } catch (error) {
      console.error('学生登录请求异常:', this.errorToString(error));
      throw new Error(this.errorToString(error));
    }
  }

  // 新增：老师登录请求（匹配TeacherController接口）
  async teacherLoginRequest(teacherId: string, password: string): Promise<TeacherData | null> {
    try {
      let httpRequest = http.createHttp();
      // 调用老师登录接口（与你的TeacherController的/login接口匹配）
      const requestUrl = `${this.baseUrl}/teacher/login`;
      console.log('老师登录请求URL:', requestUrl);

      let response = await httpRequest.request(
        requestUrl,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ userId: teacherId, password: password }),
          connectTimeout: 15000,
          readTimeout: 15000
        }
      );
      console.log('老师登录响应状态码:', response.responseCode);

      if (response.responseCode === 200) {
        const responseText = response.result.toString();
        console.log('老师登录响应数据:', responseText);
        const result = JSON.parse(responseText) as TeacherLoginResponse;

        // 匹配后端返回格式（success为true且data存在）
        if (result.success && result.data) {
          const teacherData: TeacherData = result.data;
          // 后端已在接口内验证密码，此处直接返回
          return teacherData;
        } else {
          console.log('老师登录失败:', result.message);
          this.showCustomMessage(result.message || '老师登录失败');
          return null;
        }
      } else {
        console.log('老师账号不存在或其他错误');
        return null;
      }
    } catch (error) {
      console.error('老师登录请求异常:', this.errorToString(error));
      throw new Error(this.errorToString(error));
    }
  }

  // 新增：管理员登录请求（适配 AdminController 的 POST 登录接口，如 /admin/login）
  async adminLoginRequest(adminId: string, password: string): Promise<AdminData | null> {
    try {
      let httpRequest = http.createHttp();
      const requestUrl = `${this.baseUrl}/admin/login`;
      console.log('管理员登录请求URL:', requestUrl);
      console.log('请求参数:', JSON.stringify({ username: adminId, password: password })); // 新增：打印请求参数

      let response = await httpRequest.request(
        requestUrl,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify({ username: adminId, password: password }),
          connectTimeout: 15000,
          readTimeout: 15000
        }
      );

      console.log('管理员登录响应状态码:', response.responseCode);
      console.log('管理员登录响应原始数据:', response.result); // 新增：打印原始响应数据（关键！）

      if (response.responseCode === 200) {
        const responseText = response.result.toString();
        const result = JSON.parse(responseText) as GeneratedTypeLiteralInterface_1;

        // 新增：打印解析后的响应数据
        console.log('解析后的响应数据:', result);

        if (result.success && result.data) {
          return result.data;
        } else {
          // 新增：打印后端返回的错误信息
          console.log('管理员登录失败原因:', result.message || '无错误信息');
          this.showCustomMessage(result.message || '管理员登录失败');
          return null;
        }
      } else {
        console.log('管理员登录响应状态码非200:', response.responseCode);
        return null;
      }
    } catch (error) {
      console.error('管理员登录请求异常:', this.errorToString(error));
      throw new Error(this.errorToString(error));
    }
  }
  // 错误对象转字符串（原代码保留）
  private errorToString(error: object): string {
    if (error instanceof Error) {
      return error.message;
    } else {
      try {
        return JSON.stringify(error);
      } catch {
        return '未知错误对象';
      }
    }
  }

  // 自定义消息显示（原代码保留）
  showCustomMessage(msg: string, isSuccess: boolean = false) {
    this.message = msg;
    this.showMessage = true;
    setTimeout(() => {
      this.showMessage = false;
    }, 3000);
    console.log('显示消息:', msg);
  }
}