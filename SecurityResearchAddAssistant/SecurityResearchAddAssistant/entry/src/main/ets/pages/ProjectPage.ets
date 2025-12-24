import { AppState } from '../utils/AppState'
import {
  ScoreItemData,
  AuditStatus,
  StudentData,
  StudentStats
} from '../utils/types'
import { HttpUtil } from '../utils/HttpUtil'
import { ApiConstants } from '../utils/ApiConstants'
import { router } from '@kit.ArkUI'

// 定义本地使用的信息类
class Info {
  id: string = '';
  type: string = '';
  content: string = '';
  value: number = 0;
  status: number = 0; // 0-待审核, 1-通过, 2-驳回（对应AuditStatus）
  statusText: string = ''; // 状态文本（待审核/已通过/已驳回）
  rejectReason: string = ''; // 驳回原因
  auditorName: string = ''; // 审核人姓名
  auditCount: number = 0; // 审核次数
}

// API响应类
class ScoreItemsApiResponse {
  success: boolean = false;
  data: ScoreItemData[] = [];
  count: number = 0;
  message: string = '';
}

interface StudentScore {
  totalScore: number;
  studentRank: number;
}

interface StudentRankResponse {
  success: boolean;
  studentRank: number;
  message: string;
}

class StatsApiResponse {
  success: boolean = false;
  data: StudentScore = {
    totalScore: 0,
    studentRank: 0
  };
  message: string = '';
}

class AddItemApiResponse {
  success: boolean = false;
  data: ScoreItemData = new ScoreItemData();
  message: string = '';
}

// 复用types中的StudentStats类型
type StudentStatsData = StudentStats;

interface StudentInformation {
  studentId: string;
  studentName: string;
  itemName: string;
  itemCategory: string;
  itemScore: number;
  itemDescription: string;
  proofImage: string | null;
  proofFiles: string;
  status: number;
}

@Entry
@Component
export struct ProjectPage {
  @State showPracticeTypePicker: boolean = false
  @State showGPADialog: boolean = false
  @State gpaInput: string = ''

  // 实践类型选项
  practiceTypes: string[] = ['科研成果', '竞赛获奖', '科创项目', '绩点得分', '荣誉称号']
  @State practiceType: string = '请选择实践类型'
  @State bonusContent: string = ''
  @State bonusValue: string = ''
  @State proofImage: string = ''

  // 基础分和加分项数据
  @State baseScore: number = 85.0
  @State bonusItems: Info[] = []

  // 后端数据
  @State backendItems: ScoreItemData[] = []

  // 初始化总分变量
  @State totalScoreValue: number = 0
  @State ranking: number = 0

  // 用户信息
  @State studentName: string = ''
  @State studentId: string = ''
  @State studentProfession: string = ''

  // 加载状态
  @State isLoading: boolean = false
  @State showMessage: boolean = false
  @State messageText: string = ''
  @State messageType: string = 'info'

  // 新增统计相关状态
  @State studentTotalScore: number = 0; // 登录返回的总分
  @State studentRank: number = 0;       // 登录返回的排名
  @State bonusTotalScore: number = 0;   // 加分项总分（统计接口）
  @State approvedCount: number = 0;     // 已通过项目数
  @State pendingCount: number = 0;      // 待审核项目数

  // 页面加载时获取用户信息
  aboutToAppear() {
    // ========== 修复：删除原AppStorage逻辑，改为从AppState获取 ==========
    const appState = AppState.getInstance()
    const studentData = appState.getStudentData()
    if (studentData) {
      this.studentTotalScore = studentData.totalScore || 0;
      this.studentRank = studentData.studentRank || 0;
    }

    // 加载用户信息和后端数据
    this.loadUserInfo();
  }

  // 加载用户信息
  loadUserInfo() {
    const appState = AppState.getInstance()
    const studentData = appState.getStudentData()

    if (studentData) {
      this.studentName = studentData.name || ''
      this.studentId = studentData.id || ''
      this.studentProfession = studentData.profession || ''

      console.log('=== ProjectPage 用户信息 ===')
      console.log('姓名:', this.studentName)
      console.log('学号:', this.studentId)
      console.log('专业:', this.studentProfession)

      // 加载后端数据
      this.loadBackendData()
    } else {
      console.log('未找到学生数据，用户可能未登录或不是学生身份')
      this.showMessageDialog('请先登录', 'error')
      // 跳转到登录页
      setTimeout(() => {
        router.pushUrl({ url: 'pages/LoginPage' })
      }, 1500)
    }
  }

  // 新增：重置新增表单字段
  resetForm() {
    this.practiceType = '请选择实践类型';
    this.bonusContent = '';
    this.bonusValue = '';
    this.proofImage = ''; // 清空图片字段
    this.gpaInput = ''; // 可选：清空绩点输入（若需要）
  }

  async loadRankFromBackend() {
    try {
      // 改用已有的统计接口（避免新增API常量）
      const url = ApiConstants.buildStudentStatsUrl(this.studentId);
      // 明确指定泛型为StudentRankResponse
      const response: StudentRankResponse = await HttpUtil.get<StudentRankResponse>(url);
      this.ranking = response.studentRank || 0;
    } catch (error) {
      console.error('加载排名失败:', error);
    }
  }

  // 加载后端数据
  async loadBackendData() {
    if (!this.studentId) return

    this.isLoading = true

    try {
      // 并行加载项目和统计信息
      await Promise.all([
        this.loadScoreItemsFromBackend(),
        this.loadStudentStatsFromBackend(),
        this.loadRankFromBackend() // 新增
      ])
    } catch (error) {
      console.error('加载数据失败:', error)
      this.showMessageDialog('加载数据失败', 'error')
    } finally {
      this.isLoading = false
      console.log('【数据加载完成】排名:', this.ranking, '总分:', this.totalScoreValue);
    }
  }

  // 从后端加载加分项目
  async loadScoreItemsFromBackend() {
    try {
      const url = ApiConstants.buildStudentScoreItemsUrl(this.studentId)
      console.log('加载项目URL:', url)

      // 明确指定泛型为ScoreItemData[]
      const response: ScoreItemData[] = await HttpUtil.get<ScoreItemData[]>(url)
      console.log('【加分项接口】完整响应:', JSON.stringify(response))

      // 确保backendItems是ScoreItemData[]类型
      this.backendItems = response || []
      this.updateLocalItems()
      console.log('【加分项接口】加载成功，数据条数:', this.backendItems.length)
    } catch (error) {
      console.error('【加分项接口】加载失败:', error)
      this.showMessageDialog('加载项目失败', 'error')
    }
  }

  // 从后端加载统计信息
  async loadStudentStatsFromBackend() {
    try {
      const url = ApiConstants.buildStudentStatsUrl(this.studentId)
      console.log('加载统计URL:', url)

      // 适配后端返回的纯StudentStatsData对象
      const response: StudentStatsData = await HttpUtil.get<StudentStatsData>(url)
      console.log('【统计接口】完整响应:', JSON.stringify(response))

      if (response) {
        // 提取统计接口数据
        this.bonusTotalScore = response.totalScore || 0;
        this.approvedCount = response.approvedCount || 0;
        this.pendingCount = response.pendingCount || 0;

        // ========== 修复：从统计接口获取排名（新增/修改） ==========
        // ① 若统计接口返回studentRank字段，直接取
        this.ranking = response.studentRank || this.studentRank || 0;
        // ② 若统计接口返回的是排名相关的其他字段（如rank），替换为对应字段
        // this.ranking = response.rank || this.studentRank || 0;

        // 兼容原有总分逻辑
        this.totalScoreValue = this.studentTotalScore || (this.baseScore + this.bonusTotalScore);

        console.log('【统计接口】加载成功:', {
          综合总分: this.totalScoreValue,
          排名: this.ranking, // 确认日志中排名是否正确
          加分项总分: this.bonusTotalScore,
          已通过数量: this.approvedCount,
          待审核数量: this.pendingCount
        })
      } else {
        this.showMessageDialog('加载统计信息失败', 'error')
      }
    } catch (error) {
      console.error('【统计接口】加载失败:', error)
      this.showMessageDialog('加载统计信息失败', 'error')
    }
  }

  // 更新本地项目列表
  updateLocalItems() {
    const approvedItems = this.backendItems; // 显示所有状态的项目

    this.bonusItems = approvedItems.map(item => {
      const localItem = new Info()
      localItem.id = item.id?.toString() || ''
      localItem.type = item.itemCategory || '未知类型'
      localItem.content = item.itemName || '无内容'
      localItem.value = item.itemScore || 0
      localItem.status = item.status || 0;
      // 根据status生成状态文本（对应AuditStatus枚举）
      switch (localItem.status) {
        case AuditStatus.PENDING:
          localItem.statusText = '待审核';
          break;
        case AuditStatus.APPROVED:
          localItem.statusText = '已通过';
          break;
        case AuditStatus.REJECTED:
          localItem.statusText = '已驳回';
          localItem.rejectReason = item.rejectReason || ''; // 存储驳回原因
          break;
        default:
          localItem.statusText = '未知状态';
      }
      localItem.auditorName = item.auditorName || '待审核'; // 未审核时显示“待审核”
      // 2. 审核次数（后端若返回auditCount则直接用，否则用resubmitCount+1）
      // resubmitCount：重新提交次数，审核次数=重新提交次数+1（首次审核为1次）
      const resubmitCount = item.resubmitCount || 0;
      localItem.auditCount = resubmitCount + 1; // 审核次数计算

      return localItem
    })

    this.calculateTotalScore()
    console.log('【本地加分项】转换后数据:', JSON.stringify(this.bonusItems))
  }

  // 计算总分并更新状态变量
  calculateTotalScore() {
    const bonusTotal = this.bonusItems.reduce((sum, item) => sum + item.value, 0)
    // 优先使用登录返回的总分，无则计算
    this.totalScoreValue = this.studentTotalScore || (this.baseScore + bonusTotal)
  }

  // 获取总分
  get totalScore(): number {
    return this.totalScoreValue
  }

  // 计算进度条百分比
  get progressValue(): number {
    return Math.min((this.totalScoreValue / 150) * 100, 100)
  }

  // 显示消息对话框
  showMessageDialog(message: string, type: string = 'info') {
    this.messageText = message
    this.messageType = type
    this.showMessage = true

    setTimeout(() => {
      this.showMessage = false
    }, 3000)
  }

  // 构建绩点输入弹窗
  @Builder
  buildGPADialog() {
    Column() {
      // 遮罩层（固定定位覆盖全屏）
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .position({ left: 0, top: 0, right: 0, bottom: 0 })
        .onClick(() => {
          this.showGPADialog = false
        })

      // 弹窗内容（固定定位居中）
      Column() {
        Text('输入推免绩点')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(16)

        TextInput({ placeholder: '请输入推免绩点', text: this.gpaInput })
          .onChange((value: string) => {
            this.gpaInput = value
          })
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .width('90%')
          .height(50)
          .margin({ bottom: 20 })
          .border({ width: 1, color: '#CCCCCC' })

        Button('确认')
          .width('90%')
          .height(45)
          .backgroundColor('#007AFF')
          .fontColor(Color.White)
          .onClick(() => {
            if (this.gpaInput) {
              const gpa = parseFloat(this.gpaInput)
              if (!isNaN(gpa) && gpa > 0) {
                this.baseScore = 24.99 * gpa + 1.28
                this.calculateTotalScore()
                this.showGPADialog = false
                this.gpaInput = ''
                this.showMessageDialog('基础分已更新', 'success')
              } else {
                this.showMessageDialog('请输入有效的绩点数值', 'error')
              }
            } else {
              this.showMessageDialog('请输入绩点', 'error')
            }
          })
      }
      .backgroundColor(Color.White)
      .borderRadius(16)
      .width('80%')
      .padding(20)
      .position({ left: '10%', top: '30%' })
    }
    .width('100%')
    .height('100%')
    .position({ left: 0, top: 0, right: 0, bottom: 0 })
    .zIndex(999)
  }

  // 构建实践类型选择器弹窗（独立Builder，修复定位和事件）
  @Builder
  buildPracticeTypePicker() {
    Column() {
      // 遮罩层（固定定位覆盖全屏）
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .position({ left: 0, top: 0, right: 0, bottom: 0 })
        .onClick(() => {
          this.showPracticeTypePicker = false
        })

      // 弹窗内容（固定定位居中）
      Column() {
        Text('选择实践类型')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(16)

        Column() {
          ForEach(this.practiceTypes, (type: string) => {
            Column() {
              Text(type)
                .fontSize(16)
                .fontColor('#333333')
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding(12)
            }
            .width('100%')
            .backgroundColor(this.practiceType === type ? '#f0f0f0' : Color.White)
            .onClick(() => {
              this.practiceType = type
              this.showPracticeTypePicker = false
            })
          })
        }
        .width('100%')

        Column() {
          Text('取消')
            .fontSize(16)
            .fontColor('#007AFF')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(12)
        }
        .width('100%')
        .margin({ top: 8 })
        .backgroundColor(Color.White)
        .onClick(() => {
          this.showPracticeTypePicker = false
        })
      }
      .backgroundColor('#f5f5f5')
      .borderRadius(16)
      .width('80%')
      .position({ left: '10%', top: '30%' })
    }
    .width('100%')
    .height('100%')
    .position({ left: 0, top: 0, right: 0, bottom: 0 })
    .zIndex(999)
  }

  // 添加新的加分项
  async addBonusItem() {
    // ========== 防止重复提交（如果正在加载，直接返回） ==========
    if (this.isLoading) {
      return;
    }

    console.log('【提交加分项】开始验证表单:', {
      practiceType: this.practiceType,
      bonusContent: this.bonusContent,
      bonusValue: this.bonusValue
    });

    //表单验证逻辑
    if (this.practiceType === '请选择实践类型') {
      this.showMessageDialog('请选择实践类型', 'error');
      return;
    }
    if (!this.bonusContent.trim()) {
      this.showMessageDialog('请输入具体内容', 'error');
      return;
    }
    if (!this.bonusValue.trim()) {
      this.showMessageDialog('请输入加分分值', 'error');
      return;
    }

    const value = parseFloat(this.bonusValue);
    if (isNaN(value)) {
      this.showMessageDialog('请输入有效的分值', 'error');
      return;
    }

    if (value <= 0 || value > 100) {
      this.showMessageDialog('分值必须大于0且不超过100', 'error');
      return;
    }

    this.isLoading = true; // 禁用按钮

    try {
      const requestData: StudentInformation = {
        studentId: this.studentId,
        studentName: this.studentName,
        itemName: this.bonusContent.trim(),
        itemCategory: this.practiceType,
        itemScore: value,
        itemDescription: this.bonusContent.trim(),
        proofImage: this.proofImage || null,
        proofFiles: '[]',
        status: AuditStatus.PENDING
      };

      console.log('【提交加分项】请求参数:', JSON.stringify(requestData));

      // 提交请求
      const response: AddItemApiResponse = await HttpUtil.post<AddItemApiResponse>(
        ApiConstants.SCORE_ITEM_ADD,
        requestData
      );

      console.log('【提交加分项】响应数据:', JSON.stringify(response));

      if (response.success) {
        // ========== 修复：调用统一的重置方法 ==========
        this.resetForm();

        // ========== 增强：强制刷新数据并验证 ==========
        await this.loadBackendData();
        // 手动触发更新（可选，确保UI刷新）
        this.bonusItems = [...this.bonusItems];

        const newItem = response.data;
        const localNewItem = new Info();
        localNewItem.id = newItem.id?.toString() || '';
        localNewItem.type = newItem.itemCategory || '未知类型';
        localNewItem.content = newItem.itemName || '无内容';
        localNewItem.value = newItem.itemScore || 0;
        localNewItem.status = newItem.status || 0;
        localNewItem.statusText = newItem.status === AuditStatus.PENDING ? '待审核' : '未知状态';
        this.bonusItems = [...this.bonusItems, localNewItem];

        this.resetForm();
        this.showMessageDialog('项目提交成功，等待审核', 'success');
        // 可选：仍调用loadBackendData确保数据一致性
        await this.loadBackendData();

      } else {
        this.showMessageDialog(response.message || '提交失败', 'error');
      }

    } catch (error) {
      console.error('【提交加分项】异常类型:', (error as Error).name);
      console.error('【提交加分项】异常消息:', (error as Error).message);
      console.error('【提交加分项】异常堆栈:', (error as Error).stack);

      const errMsg = (error as Error).message.includes('网络')
        ? '网络请求失败，请检查后端服务是否启动'
        : '提交失败: ' + (error as Error).message;
      this.showMessageDialog(errMsg, 'error');
    } finally {
      this.isLoading = false; // 恢复按钮
    }
  }

  // 删除加分项
  deleteBonusItem(id: string) {
    const index = this.bonusItems.findIndex(item => item.id === id)
    if (index !== -1) {
      this.bonusItems = [...this.bonusItems.slice(0, index), ...this.bonusItems.slice(index + 1)]
      this.calculateTotalScore()
      this.showMessageDialog('删除成功', 'success')
    } else {
      this.showMessageDialog('未找到该加分项', 'error')
    }
  }

  // 构建单个加分项组件
  @Builder
  buildBonusItem(item: Info) {
    Swiper() {
      Column() {
        Row() {
          Row({ space: 7 }) {
            Image(this.getIconByType(item.type))
              .width(15)
            Text(item.type || '未知类型')
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
          }

          // ========== 状态显示 ==========
          Text(item.statusText)
            .fontSize(10)
            .fontColor(this.getStatusColor(item.status))
            .backgroundColor(this.getStatusBgColor(item.status))
            .padding({ left: 4, right: 4, top: 2, bottom: 2 })
            .borderRadius(4)

          Text(`+${item.value.toFixed(1)}`)
            .fontSize(11)
            .fontColor('#6D6D6D')
        }
        .padding({ top: 15 })
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')

        Row() {
          Text(`·${item.content || '无内容'}`)
            .fontSize(12)
            .fontColor('#6B7280')
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        // ========== 审核人+审核次数显示 ==========
        Row() {
          // 审核人姓名
          Text(`审核人：${item.auditorName}`)
            .fontSize(10)
            .fontColor('#888888')
          // 审核次数（与审核人换行/同行，可调整布局）
          Text(`审核次数：${item.auditCount}次`)
            .fontSize(10)
            .fontColor('#888888')
            .margin({ left: 10 })
        }
        .padding({ top: 5 })
        .justifyContent(FlexAlign.Start)
        .width('100%')
        // ========== 驳回原因显示（可选） ==========
        if (item.status === AuditStatus.REJECTED && item.rejectReason) {
          Row() {
            Text(`驳回原因：${item.rejectReason}`)
              .fontSize(10)
              .fontColor('#dc3545')
          }
          .padding({ top: 5 })
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
      }
      .padding({ left: 13, right: 13 })
      .borderRadius(10)
      .border({ width: 2, color: '#ccc' })
      .height(item.status === AuditStatus.REJECTED ? 90 : 70) // 驳回时增高高度
      .width('100%')
      .backgroundColor(Color.White)

      Column() {
        Button('删除')
          .backgroundColor('#FF3B30')
          .width(80)
          .height('100%')
          .onClick(() => {
            this.deleteBonusItem(item.id)
          })
      }
      .width(80)
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .vertical(false)
    .index(0)
    .autoPlay(false)
    .indicator(false)
    .loop(false)
    .width('100%')
    .height(item.status === AuditStatus.REJECTED ? 90 : 70)
    .margin({ top: 10 })
  }

  // ========== 新增：根据状态获取颜色的方法 ==========
  getStatusColor(status: number): string {
    switch (status) {
      case AuditStatus.PENDING:
        return '#ffc107'; // 黄色
      case AuditStatus.APPROVED:
        return '#28a745'; // 绿色
      case AuditStatus.REJECTED:
        return '#dc3545'; // 红色
      default:
        return '#666';
    }
  }

  // ========== 新增：根据状态获取背景色的方法 ==========
  getStatusBgColor(status: number): string {
    switch (status) {
      case AuditStatus.PENDING:
        return '#fff3cd'; // 浅黄
      case AuditStatus.APPROVED:
        return '#d4edda'; // 浅绿
      case AuditStatus.REJECTED:
        return '#f8d7da'; // 浅红
      default:
        return '#f0f0f0';
    }
  }

  // 根据类型获取图标
  getIconByType(type: string): ResourceStr {
    if (!type) return $r('app.media.33')
    switch (type) {
      case '科研成果': return $r('app.media.33')
      case '竞赛获奖': return $r('app.media.jiangbei')
      case '科创项目': return $r('app.media.kcxm')
      case '绩点得分': return $r('app.media.x1')
      case '荣誉称号': return $r('app.media.x2')
      default: return $r('app.media.33')
    }
  }

  // 构建用户信息显示
  @Builder
  buildUserInfo() {
    if (this.studentName) {
      Column() {
        Row() {
          Text(`学生: ${this.studentName}`)
            .fontSize(14)
            .fontColor('#333333')
          Text(`专业: ${this.studentProfession || '未设置'}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 16 })
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .padding(8)
        .backgroundColor('#f8f9fa')
        .borderRadius(8)
        .margin({ bottom: 12 })
      }
      .width('100%')
    }
  }

  // 构建消息提示
  @Builder
  buildMessageDialog() {
    if (this.showMessage) {
      Column() {
        Column() {
          Text(this.messageText)
            .fontSize(14)
            .fontColor(this.messageType === 'error' ? '#dc3545' : '#28a745')
            .textAlign(TextAlign.Center)
            .padding(16)
        }
        .backgroundColor(Color.White)
        .border({
          width: 1,
          color: this.messageType === 'error' ? '#dc3545' : '#28a745',
          radius: 8
        })
        .width('80%')
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.showMessage = false
      })
    }
  }

  // 构建加载指示器
  @Builder
  buildLoadingOverlay() {
    if (this.isLoading) {
      Column() {
        LoadingProgress()
          .color('#007AFF')
          .width(50)
          .height(50)
        Text('加载中...')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 10 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(255,255,255,0.8)')
      .position({ x: 0, y: 0 })
    }
  }

  build() {
    // 页面根Column（所有bindContentCover挂载在此处）
    Column() {
      // 加载指示器
      this.buildLoadingOverlay()

      // 消息提示
      this.buildMessageDialog()

      // 用户信息显示
      this.buildUserInfo()

      Scroll() {
        Column() {
          Column() {
            // 顶部总分区域
            Column() {
              Row() {
                // 左侧：总分信息和排名
                Column() {
                  // 总分
                  Row() {
                    Text('当前总分')
                      .fontSize(12)
                      .fontColor('#6B7280')
                      .fontWeight(700)
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')

                  Row() {
                    Text(`${this.totalScoreValue.toFixed(1)}分`)
                      .fontWeight(700)
                      .fontSize(25)
                      .fontColor('#6D6D6D')
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')
                  .margin({ top: 5 })

                  // 排名（保持原位置）
                  Row() {
                    Text('排名')
                      .fontSize(12)
                      .fontColor('#6B7280')
                      .fontWeight(700)
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')
                  .margin({ top: 15 })

                  Row() {
                    Text(`第 ${this.ranking || '--'} 名`)
                      .fontWeight(700)
                      .fontSize(16)
                      .fontColor('#007AFF')
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')
                  .margin({ top: 5 })
                }
                .padding({ top: 15, left: 5 })
                .height('100%')
                .width(120)

                // 右侧：圆形进度条
                Stack() {
                  Circle({ width: 100, height: 100 })
                    .stroke('#e5e7eb')
                    .strokeWidth(15)

                  Circle({ width: 100, height: 100 })
                    .stroke('#53516f')
                    .strokeWidth(15)
                    .fillOpacity(0)
                    .strokeDashArray([this.progressValue * 2 * Math.PI * 50 / 100, 1000])
                    .strokeDashOffset(0)
                }
                .width(100)
                .height(100)
                .margin({ left: 30, right: 30 })
              }
              .width('100%')
              .height(160)

              // 基础分和加分项（放在排名下方）
              Row() {
                // 基础分
                Column() {
                  Row({ space: 8 }) {
                    Image($r('app.media.x1'))
                      .fillColor('#6B7280')
                      .width(10)
                    Text('基础分')
                      .fontSize(12)
                      .fontWeight(700)
                      .fontColor('#6D6D6D')
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')

                  Row() {
                    Text(this.baseScore.toFixed(1))
                      .fontSize(14)
                      .fontWeight(700)
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')
                  .margin({ top: 5 })

                  Row() {
                    Text('输入绩点')
                      .fontSize(10)
                      .fontColor('#007AFF')
                  }
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)
                  .backgroundColor('#f0f0f0')
                  .borderRadius(5)
                  .height(25)
                  .width(70)
                  .margin({ top: 8 })
                  .onClick(() => {
                    this.showGPADialog = true
                  })
                }
                .borderRadius(10)
                .backgroundColor(Color.White)
                .padding({ left: 15, top: 10, bottom: 10, right: 15 })
                .width(130)
                .margin({ right: 10 })

                // 加分项
                Column() {
                  Row({ space: 8 }) {
                    Image($r('app.media.x2'))
                      .fillColor('#6B7280')
                      .width(10)
                    Text('加分项')
                      .fontSize(12)
                      .fontWeight(700)
                      .fontColor('#6D6D6D')
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')

                  Row() {
                    Text(this.bonusTotalScore.toFixed(1))
                      .fontSize(14)
                      .fontWeight(700)
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')
                  .margin({ top: 5 })
                }
                .borderRadius(10)
                .backgroundColor(Color.White)
                .padding({ left: 15, top: 10, bottom: 10, right: 15 })
                .width(130)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 10 })
            }
            .padding({ left: 15, right: 15, top: 15, bottom: 20 })
            .borderRadius(10)
            .backgroundColor('#e3e3e3')
            .width('100%')
            .height(280)

            // 加分项统计
            Column() {
              Row() {
                Text('加分项统计')
                  .fontSize(14)
                  .fontWeight(700)
                Text(`共${this.bonusItems.length}项 | 已通过${this.approvedCount}项 | 待审核${this.pendingCount}项`)
                  .fontSize(11)
                  .fontColor('#9CA3AF')
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: 5, right: 5 })
              .width('100%')

              // 加分项列表
              Scroll() {
                Column() {
                  ForEach(this.bonusItems, (item: Info) => {
                    this.buildBonusItem(item)
                  }, (item: Info) => item.id) // 使用item.id作为唯一键（必须保证id唯一）
                }
                .width('100%')
              }
              .height(250)
              .width('100%')
              .scrollBar(BarState.Auto)
              .backgroundColor('#f9f9f9')
              .borderRadius(8)
              .padding(5)
            }
            .padding({ left: 13, right: 13, top: 20 })
            .margin({ top: 10 })
            .borderRadius(10)
            .height(300)
            .backgroundColor(Color.White)
            .width('100%')

            // 添加加分项组件
            Column() {
              Row() {
                Text('添加加分项')
                  .fontSize(14)
                  .fontWeight(700)
                Row({ space: 5 }) {
                  Image($r('app.media.yiwen'))
                    .width(15)
                  Text('规则说明')
                    .fontSize(11)
                    .fontColor('#9CA3AF')
                }
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: 5, right: 5 })
              .width('100%')
              .margin({ bottom: 20 })

              Row() {
                Text('加分类别')
                  .fontSize(12)
                  .fontColor('#4B5563')
                  .fontWeight(700)
              }
              .padding({ left: 5, right: 5 })
              .margin({ bottom: 5 })
              .justifyContent(FlexAlign.Start)
              .width('100%')

              // 实践类型选择框
              Column() {
                Row() {
                  Text(this.practiceType)
                    .fontSize(14)
                    .fontColor(this.practiceType === '请选择实践类型' ? '#999999' : '#333333')
                    .layoutWeight(1)
                    .textAlign(TextAlign.Start)

                  Image($r('app.media.xiala'))
                    .width(12)
                    .height(12)
                }
                .borderRadius(10)
                .border({ width: 2, color: '#ccc' })
                .padding(12)
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
                .onClick(() => {
                  this.showPracticeTypePicker = true
                })
              }
              .backgroundColor(Color.White)
              .borderRadius(8)
              .width('100%')
              .height(40)

              Row() {
                Text('具体内容')
                  .fontSize(12)
                  .fontColor('#4B5563')
                  .fontWeight(700)
              }
              .padding({ left: 5, right: 5 })
              .margin({ top: 15, bottom: 5 })
              .justifyContent(FlexAlign.Start)
              .width('100%')

              TextInput({ placeholder: '请输入具体内容', text: this.bonusContent })
                .onChange((value: string) => {
                  this.bonusContent = value
                })
                .padding(12)
                .fontSize(12)
                .placeholderFont({ size: 12 })
                .backgroundColor(Color.White)
                .borderRadius(8)
                .width('100%')
                .height(40)
                .border({ width: 2, color: '#ccc' })

              Row() {
                Text('加分分值')
                  .fontSize(12)
                  .fontColor('#4B5563')
                  .fontWeight(700)
              }
              .padding({ left: 5, right: 5 })
              .margin({ top: 15, bottom: 5 })
              .justifyContent(FlexAlign.Start)
              .width('100%')

              TextInput({ placeholder: '请输入分值', text: this.bonusValue })
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.bonusValue = value
                })
                .placeholderFont({ size: 12 })
                .padding(12)
                .backgroundColor(Color.White)
                .borderRadius(8)
                .width('100%')
                .height(40)
                .border({ width: 2, color: '#ccc' })

              Button(this.isLoading ? '提交中...' : '添加')
                .fontColor(Color.White)
                .fontSize(13)
                .margin({ top: 15 })
                .borderRadius(5)
                // 禁用状态背景色变灰，可用状态为深灰
                .backgroundColor(this.isLoading ? '#6d6d6d' : '#007AFF')
                .height(40)
                .width(300)
                // 关键：enabled属性控制按钮是否可点击
                .enabled(!this.isLoading)

                .onClick(() => {
                  this.addBonusItem();
                })
            }
            .padding({ left: 13, right: 13, top: 20 })
            .margin({ top: 10 })
            .borderRadius(10)
            .height(300)
            .backgroundColor(Color.White)
            .width('100%')

            Row()
              .height(150)
          }
        }
      }
      .padding({ left: 10, right: 10 })
      .backgroundColor('#f1f1f1')
      .height('100%')
      .width('100%')

      // ========== 修复点：弹窗移到根Column末尾 ==========
      // 实践类型选择器弹窗（顶级层级）
      if (this.showPracticeTypePicker) {
        this.buildPracticeTypePicker()
      }

      // 绩点输入弹窗（顶级层级）
      if (this.showGPADialog) {
        this.buildGPADialog()
      }
    }
    // 根Column的样式
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f1f1')
  }
}