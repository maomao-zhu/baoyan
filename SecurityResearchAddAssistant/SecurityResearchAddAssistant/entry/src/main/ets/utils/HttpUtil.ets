// utils/HttpUtil.ets

import { http } from '@kit.NetworkKit';
import { ApiResponse, LoginResponseData, PageResponse } from './types';


// ========== 新增：后端通用响应接口（替代any类型） ==========
/**
 * 后端所有接口的通用响应格式
 * @param T - 响应中data字段的类型（如StudentData、ScoreItemData等）
 */
export interface BackendResponse<T> {
  success: boolean;    // 后端响应的成功标识
  message: string;     // 后端响应的提示信息
  data: T | null;      // 后端响应的业务数据（泛型T适配不同接口）
}
// 定义HTTP请求选项类型
class HttpRequestOptions {
  method: http.RequestMethod;
  header?: Record<string, string>;
  extraData?: string;
  connectTimeout: number = 15000;  // 增加超时时间
  readTimeout: number = 15000;

  constructor(method: http.RequestMethod) {
    this.method = method;
  }
}

// 自定义HTTP异常类
class HttpError extends Error {
  code: number;
  message: string;

  constructor(code: number, message: string) {
    super(message);
    this.code = code;
    this.message = message;
    this.name = 'HttpError';
  }
}

export class HttpUtil {

  // 创建HTTP客户端（单例模式）
  private static httpClient: http.HttpRequest | null = null;

  private static getHttpClient(): http.HttpRequest {
    if (!HttpUtil.httpClient) {
      HttpUtil.httpClient = http.createHttp();
    }
    return HttpUtil.httpClient;
  }

  // ========== 通用请求方法 ==========

  /**
   * 发送HTTP请求（通用方法）
   * @param url 请求URL
   * @param options 请求选项
   * @returns 解析后的响应数据
   */
  private static async request<T>(url: string, options: HttpRequestOptions): Promise<ApiResponse<T>> {
    try {
      console.log(`[HTTP请求] ${options.method}: ${url}`);
      if (options.extraData) {
        console.log(`[请求数据] ${options.extraData}`);
      }

      const httpRequest = HttpUtil.getHttpClient();
      const response = await httpRequest.request(url, options);

      console.log(`[响应状态] ${response.responseCode}`);

      // 获取响应文本
      const responseText: string = response.result?.toString() || '{}';

      // 解析响应
      let apiResponse: ApiResponse<T>;
      try {
        apiResponse = JSON.parse(responseText);
      } catch (parseError) {
        console.error('[JSON解析失败]', parseError);
        throw new HttpError(500, '服务器响应格式错误');
      }

      // 处理HTTP状态码
      if (response.responseCode >= 200 && response.responseCode < 300) {
        // HTTP成功，检查业务逻辑成功
        if (apiResponse.success) {
          console.log('[请求成功]', apiResponse.message || '操作成功');
          return apiResponse;
        } else {
          // 业务逻辑失败
          console.warn('[业务失败]', apiResponse.message);
          throw new HttpError(apiResponse.code || 400, apiResponse.message || '操作失败');
        }
      } else {
        // HTTP错误
        console.error(`[HTTP错误] ${response.responseCode}: ${apiResponse.message || '网络请求失败'}`);
        throw new HttpError(response.responseCode, apiResponse.message || `HTTP ${response.responseCode}`);
      }
    } catch (error) {
      console.error('[请求异常]', error);

      if (error instanceof HttpError) {
        throw error;
      } else if (error instanceof Error) {
        // 网络错误或其他错误
        throw new HttpError(0, error.message || '网络请求失败');
      } else {
        throw new HttpError(0, '未知错误');
      }
    }
  }

  // ========== 具体请求方法 ==========

  /**
   * 发送GET请求
   * @param url 请求URL
   * @returns 响应数据
   */
  static async get<T>(url: string): Promise<T> {
    const options = new HttpRequestOptions(http.RequestMethod.GET);
    const response = await HttpUtil.request<T>(url, options);
    return response.data as T;
  }

  /**
   * 发送POST请求
   * @param url 请求URL
   * @param data 请求数据
   * @returns 响应数据
   */
  // 原有post方法中的“const fullResponse: any = ...”改为泛型接口
  static async post<T>(url: string, data: object): Promise<T> {
    try {
      console.log(`POST请求: ${url}`, data);
      const httpRequest = http.createHttp();
      const options = new HttpRequestOptions(http.RequestMethod.POST);
      options.header = { 'Content-Type': 'application/json' };
      options.extraData = JSON.stringify(data);

      const response = await httpRequest.request(url, options);
      console.log(`响应状态码: ${response.responseCode}`);

      if (response.responseCode === 200) {
        const responseText: string = response.result?.toString() || '{}';
        console.log('后端原始响应字符串:', responseText);

        // ========== 关键修改：用BackendResponse<T>替代any ==========
        // 解析为“通用响应接口”类型，T是post方法的泛型参数（如LoginResponseData的data类型）
        const fullResponse: BackendResponse<T> = JSON.parse(responseText);

        // 检查后端success状态
        if (fullResponse.success === true) {
          console.log('请求成功，后端返回data:', fullResponse.data);
          // 返回后端的data字段（符合前端调用时的类型预期）
          return fullResponse.data as T;
        } else {
          // 后端返回失败，抛出后端的message
          throw new Error(fullResponse.message || '后端请求失败');
        }
      } else {
        throw new Error(`HTTP响应错误: ${response.responseCode}`);
      }
    } catch (error) {
      console.error('POST请求失败:', error);
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error('网络请求失败，请检查网络');
      }
    }
  }

  /**
   * 发送PUT请求
   * @param url 请求URL
   * @param data 请求数据
   * @returns 响应数据
   */
  static async put<T>(url: string, data: object): Promise<T> {
    const options = new HttpRequestOptions(http.RequestMethod.PUT);
    options.header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    options.extraData = JSON.stringify(data);

    const response = await HttpUtil.request<T>(url, options);
    return response.data as T;
  }

  /**
   * 发送DELETE请求
   * @param url 请求URL
   * @returns 响应数据
   */
  static async delete<T>(url: string): Promise<T> {
    const options = new HttpRequestOptions(http.RequestMethod.DELETE);
    const response = await HttpUtil.request<T>(url, options);
    return response.data as T;
  }

  // ========== 分页请求方法 ==========

  /**
   * 发送分页GET请求
   * @param url 请求URL
   * @returns 分页响应数据
   */
  static async getPage<T>(url: string): Promise<PageResponse<T>> {
    const options = new HttpRequestOptions(http.RequestMethod.GET);
    const response = await HttpUtil.request<PageResponse<T>>(url, options);
    return response.data as PageResponse<T>;
  }

  // ========== 登录专用方法 ==========

  /**
   * 发送登录请求
   * @param url 登录URL
   * @param data 登录数据
   * @returns 登录响应
   */
  static async login(url: string, data: object): Promise<LoginResponseData> {
    const options = new HttpRequestOptions(http.RequestMethod.POST);
    options.header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    options.extraData = JSON.stringify(data);

    const response = await HttpUtil.request<LoginResponseData>(url, options);
    return response.data as LoginResponseData;
  }

  // ========== 文件上传方法 ==========

  /**
   * 上传文件（如果需要）
   * @param url 上传URL
   * @param fileUri 文件URI
   * @param formData 其他表单数据
   * @returns 上传结果
   */
  static async upload<T>(url: string, fileUri: string, formData?: Record<string, string>): Promise<T> {
    // TODO: 实现文件上传功能
    // 这里需要根据鸿蒙的文件上传API实现
    throw new Error('文件上传功能暂未实现');
  }

  // ========== 工具方法 ==========

  /**
   * 检查网络连接
   * @returns 是否已连接网络
   */
  static async checkNetwork(): Promise<boolean> {
    try {
      const httpRequest = HttpUtil.getHttpClient();
      // 这里可以添加更详细的网络检查
      return true;
    } catch (error) {
      console.error('[网络检查失败]', error);
      return false;
    }
  }

  /**
   * 设置请求超时时间
   * @param connectTimeout 连接超时（毫秒）
   * @param readTimeout 读取超时（毫秒）
   */
  static setTimeout(connectTimeout: number, readTimeout: number): void {
    // 可以在这里实现全局超时设置
  }

  /**
   * 设置请求头
   * @param headers 请求头对象
   */
  static setHeaders(headers: Record<string, string>): void {
    // 可以在这里实现全局请求头设置
  }

  /**
   * 清除HTTP客户端（用于重新登录等场景）
   */
  static clearClient(): void {
    HttpUtil.httpClient = null;
  }
}

// ========== 导出HTTP错误类 ==========
export { HttpError };