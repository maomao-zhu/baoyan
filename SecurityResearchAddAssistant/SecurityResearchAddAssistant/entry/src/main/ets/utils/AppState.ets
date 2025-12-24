// utils/AppState.ets
import { StudentData, TeacherData, AdminData } from './types';
// 使用普通类，不使用 @State 装饰器
export class AppState {
  // 使用普通属性，不使用 @State
  private _currentUser: StudentData | TeacherData | AdminData | null = null;
  private _userIdentity: string = '';
  private _isLoggedIn: boolean = false;

  // 单例模式
  private static instance: AppState = new AppState();

  static getInstance(): AppState {
    return AppState.instance;
  }

  // 获取当前用户
  get currentUser(): StudentData | TeacherData | AdminData | null {
    return this._currentUser;
  }

  // 获取用户身份
  get userIdentity(): string {
    return this._userIdentity;
  }

  // 获取登录状态
  get isLoggedIn(): boolean {
    return this._isLoggedIn;
  }

  // 设置用户信息
  setUserInfo(userData: StudentData | TeacherData | AdminData, identity: string): void {
    this._currentUser = userData;
    this._userIdentity = identity;
    this._isLoggedIn = true;
  }

  // 清除用户信息
  clearUserInfo(): void {
    this._currentUser = null;
    this._userIdentity = '';
    this._isLoggedIn = false;
  }

  // 获取学生数据（类型安全）
  getStudentData(): StudentData | null {
    if (this._userIdentity === '学生' && this._currentUser) {
      return this._currentUser as StudentData;
    }
    return null;
  }

  // 获取教师数据
  getTeacherData(): TeacherData | null {
    if (this._userIdentity === '教师' && this._currentUser) {
      return this._currentUser as TeacherData;
    }
    return null;
  }

  // 获取管理员数据
  getAdminData(): AdminData | null {
    if (this._userIdentity === '管理员' && this._currentUser) {
      return this._currentUser as AdminData;
    }
    return null;
  }
}