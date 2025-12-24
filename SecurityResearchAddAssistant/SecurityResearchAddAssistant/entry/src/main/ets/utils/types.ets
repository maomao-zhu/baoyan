// utils/types.ets

// ========== 学生数据类型（完全匹配后端Student.java） ==========
export class StudentData {
  // 主键信息
  id: string = '';                 // 学号/工号
  name: string = '';               // 姓名
  password: string = '';           // 密码（加密存储）
  profession: string = '';         // 专业
  phone: string = '';              // 联系电话
  picture: string = '';            // 头像URL

  // 分数相关
  baseScore: number = 0;           // 基础分（对应后端BigDecimal）
  totalScore: number = 0;          // 总分（基础分+加分项）
  studentRank: number = 0;         // 排名（数据库字段student_rank）

  // 附加信息
  className: string = '';          // 班级
  email: string = '';              // 邮箱
  status: number = 1;              // 账号状态：0-禁用，1-正常

  // 时间戳
  createdTime: string = '';        // 创建时间
  updatedTime: string = '';        // 更新时间
  static totalScore: number;
  static studentRank: number;

  constructor() {
    // 初始化所有字段
  }
}

// ========== 教师数据类型（完全匹配后端Teacher.java） ==========
export class TeacherData {
  // 基本信息
  id: string = '';                 // 教师工号
  name: string = '';               // 姓名
  password: string = '';           // 密码
  profession: string = '';         // 负责专业
  phone: string = '';              // 联系电话
  picture: string = '';            // 头像URL

  // 教师信息
  title: string = '';              // 职称
  department: string = '';         // 院系
  email: string = '';              // 邮箱
  status: number = 1;              // 账号状态：0-禁用，1-正常
  canAudit: number = 1;            // 是否有审核权限：0-无，1-有

  // 时间戳
  createdTime: string = '';        // 创建时间
  updatedTime: string = '';        // 更新时间

  constructor() {
    // 初始化所有字段
  }
}

// ========== 管理员数据类型（完全匹配后端Admin.java） ==========
export class AdminData {
  // 注意：id是number类型（自增主键）
  id: number = 0;                  // 管理员ID（自增主键）
  username: string = '';           // 管理员账号
  name: string = '';               // 姓名
  password: string = '';           // 密码

  // 权限相关
  role: string = 'admin';          // 角色：super_admin-超级管理员, admin-普通管理员
  permissions: string = '';        // 权限列表JSON
  status: number = 1;              // 账号状态：0-禁用，1-正常

  // 联系信息
  phone: string = '';              // 联系电话
  email: string = '';              // 邮箱

  // 登录记录
  lastLoginTime: string = '';      // 最后登录时间

  // 时间戳
  createdTime: string = '';        // 创建时间

  constructor() {
    // 初始化所有字段
  }
}

// ========== 加分项目数据类型（完全匹配后端ScoreItem.java） ==========
export class ScoreItemData {
  // 主键ID
  id: number = 0;

  // 学生信息
  studentId: string = '';
  studentName: string = '';

  // 项目基本信息
  itemName: string = '';
  itemCategory: string = '';
  itemScore: number = 0;           // 项目分数
  itemDescription: string = '';

  // 证明材料
  proofImage: string = '';
  proofFiles: string = '';         // JSON字符串格式

  // 审核状态
  status: number = 0;              // 审核状态：0-待审核, 1-审核通过, 2-审核驳回
  rejectReason: string = '';

  // 时间信息
  createTime: string = '';
  updateTime: string = '';
  auditTime: string = '';
  lastAuditTime: string = '';      // 上次审核时间

  // 审核人信息
  auditorId: string = '';
  auditorName: string = '';
  auditNote: string = '';          // 审核备注

  // 提交统计
  resubmitCount: number = 0;       // 重新提交次数

  constructor() {
    // 初始化所有字段
  }
}

// ========== 通用响应类型（匹配后端统一响应格式） ==========
export class ApiResponse<T> {
  success: boolean = false;
  message: string = '';
  data: T | null = null;
  code: number = 0;
  timestamp: number = 0;

  constructor() {
    this.data = null;
  }
}

// ========== 分页响应类型（匹配后端Page.java） ==========
export class PageResponse<T> {
  pageNum: number = 1;
  pageSize: number = 10;
  total: number = 0;
  list: T[] = [];

  constructor() {
    this.list = [];
  }
}

// ========== 登录请求类型 ==========
export class LoginRequest {
  userId?: string = '';            // 学生/教师登录用
  username?: string = '';          // 管理员登录用
  password: string = '';

  constructor() {
    // 初始化
  }
}

// ========== 登录响应类型 ==========
export class LoginResponseData {
  success: boolean = false;   // 和后端的success对齐
  message: string = '';       // 和后端的message对齐
  data: StudentData | null = null; // 和后端的data对齐（存储学生数据）

  constructor() {
    this.success = false;
    this.message = '';
    this.data = null;
  }
}

// ========== 审核请求类型 ==========
export class AuditRequest {
  teacherId: string = '';
  teacherName: string = '';
  auditNote?: string = '';         // 审核通过时的备注
  rejectReason?: string = '';      // 审核驳回时的原因

  constructor() {
    // 初始化
  }
}

// ========== 学生统计信息类型 ==========
export class StudentStats {
  totalItems: number = 0;          // 总项目数
  pendingCount: number = 0;        // 待审核数量
  approvedCount: number = 0;       // 通过数量
  rejectedCount: number = 0;       // 驳回数量
  totalScore: number = 0;          // 总分（只计算已通过）
  approvalRate: number = 0;        // 通过率
  studentRank: number = 0;

  constructor() {
    // 初始化
  }
}

// ========== 教师审核统计类型 ==========
export class TeacherAuditStats {
  pendingCount: number = 0;        // 待审核数量
  approvedCount: number = 0;       // 通过数量
  rejectedCount: number = 0;       // 驳回数量
  approvalRate: number = 0;        // 通过率

  constructor() {
    // 初始化
  }
}

// ========== 枚举常量（与后端保持一致） ==========

// 审核状态枚举（完全匹配ScoreItem.Status）
export class AuditStatus {
  static readonly PENDING: number = 0;    // 待审核
  static readonly APPROVED: number = 1;   // 审核通过
  static readonly REJECTED: number = 2;   // 审核驳回

  // 获取状态文本
  static getStatusText(status: number): string {
    switch (status) {
      case AuditStatus.PENDING: return '待审核';
      case AuditStatus.APPROVED: return '审核通过';
      case AuditStatus.REJECTED: return '审核驳回';
      default: return '未知状态';
    }
  }
}

// 账号状态枚举
export class AccountStatus {
  static readonly DISABLED: number = 0;   // 禁用
  static readonly ENABLED: number = 1;    // 启用
}

// 项目类别常量（可以根据你的实际分类调整）
export class ItemCategory {
  static readonly ACADEMIC_PAPER: string = '学术论文';
  static readonly RESEARCH_PROJECT: string = '科研项目';
  static readonly SUBJECT_COMPETITION: string = '学科竞赛';
  static readonly PATENT: string = '发明专利';
  static readonly SOCIAL_PRACTICE: string = '社会实践';
  static readonly VOLUNTEER_SERVICE: string = '志愿服务';

  // 获取所有类别（用于下拉选择）
  static getAllCategories(): string[] {
    return [
      ItemCategory.ACADEMIC_PAPER,
      ItemCategory.RESEARCH_PROJECT,
      ItemCategory.SUBJECT_COMPETITION,
      ItemCategory.PATENT,
      ItemCategory.SOCIAL_PRACTICE,
      ItemCategory.VOLUNTEER_SERVICE
    ];
  }
}

// 用户身份类型
export class UserIdentity {
  static readonly STUDENT: string = 'student';
  static readonly TEACHER: string = 'teacher';
  static readonly ADMIN: string = 'admin';

  // 获取中文名称
  static getChineseName(identity: string): string {
    switch (identity) {
      case UserIdentity.STUDENT: return '学生';
      case UserIdentity.TEACHER: return '教师';
      case UserIdentity.ADMIN: return '管理员';
      default: return '未知';
    }
  }
}