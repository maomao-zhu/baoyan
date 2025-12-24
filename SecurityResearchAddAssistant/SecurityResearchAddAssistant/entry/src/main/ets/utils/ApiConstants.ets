// utils/ApiConstants.ets

export class ApiConstants {
  // 基础URL - 请根据你的后端地址修改
  // 注意：鸿蒙模拟器访问本地后端需要使用IP地址，不能使用localhost
  static BASE_URL: string = 'http://10.125.138.244:8080';

  // 学生接口
  static get STUDENT_BASE(): string {
    return `${ApiConstants.BASE_URL}/student`;
  }

  // 学生登录（使用你现有的登录方式）
  static get STUDENT_LOGIN(): string {
    return `${ApiConstants.BASE_URL}/student/login`;
  }

  // 加分项目相关
  static get SCORE_ITEM_ADD(): string {
    return `${ApiConstants.STUDENT_BASE}/score-item`;
  }

  static get SCORE_ITEM_DETAIL(): string {
    return `${ApiConstants.STUDENT_BASE}/score-item`; // + /{id}
  }

  static get STUDENT_SCORE_ITEMS(): string {
    return `${ApiConstants.STUDENT_BASE}`; // + /{studentId}/score-items
  }

  static get STUDENT_SCORE_ITEMS_BY_STATUS(): string {
    return `${ApiConstants.STUDENT_BASE}`; // + /{studentId}/score-items/status/{status}
  }

  static get STUDENT_RESUBMIT(): string {
    return `${ApiConstants.STUDENT_BASE}`; // + /{studentId}/resubmit/{itemId}
  }

  static get STUDENT_STATS(): string {
    return `${ApiConstants.STUDENT_BASE}`; // + /{studentId}/stats
  }

  // 教师接口
  static get TEACHER_BASE(): string {
    return `${ApiConstants.BASE_URL}/teacher`;
  }

  static get TEACHER_PENDING_ITEMS(): string {
    return `${ApiConstants.TEACHER_BASE}/pending-items`;
  }

  static get TEACHER_APPROVE(): string {
    return `${ApiConstants.TEACHER_BASE}/approve`; // + /{id}
  }

  static get TEACHER_REJECT(): string {
    return `${ApiConstants.TEACHER_BASE}/reject`; // + /{id}
  }

  // 静态方法：构建完整URL
  static buildStudentScoreItemsUrl(studentId: string): string {
    return `${ApiConstants.STUDENT_BASE}/${studentId}/score-items`;
  }

  static buildStudentScoreItemsByStatusUrl(studentId: string, status: number): string {
    return `${ApiConstants.STUDENT_BASE}/${studentId}/score-items/status/${status}`;
  }

  static buildStudentResubmitUrl(studentId: string, itemId: number): string {
    return `${ApiConstants.STUDENT_BASE}/${studentId}/resubmit/${itemId}`;
  }

  static buildStudentStatsUrl(studentId: string): string {
    return `${ApiConstants.STUDENT_BASE}/${studentId}/stats`;
  }

  static buildScoreItemDetailUrl(itemId: number): string {
    return `${ApiConstants.SCORE_ITEM_ADD}/${itemId}`;
  }

  static buildTeacherApproveUrl(itemId: number): string {
    return `${ApiConstants.TEACHER_APPROVE}/${itemId}`;
  }

  static buildTeacherRejectUrl(itemId: number): string {
    return `${ApiConstants.TEACHER_REJECT}/${itemId}`;
  }
}