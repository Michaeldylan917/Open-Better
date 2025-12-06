# HarmonyOS ArkTS 开发规范与最佳实践

本文档面向所有HarmonyOS ArkTS应用开发者，提供完整的编码规范、项目结构、模块使用和最佳实践指导。适用于任何新建或现有的ArkTS项目。

## 目录

- [1. 项目结构规范](#1-项目结构规范)
- [2. 模块导入规范](#2-模块导入规范)
- [3. 类型定义规范](#3-类型定义规范)
- [4. 组件开发规范](#4-组件开发规范)
- [5. UI布局与样式规范](#5-ui布局与样式规范)
- [6. 代码格式化规范](#6-代码格式化规范)
- [7. 异步编程规范](#7-异步编程规范)
- [8. 资源管理规范](#8-资源管理规范)
- [9. 错误处理规范](#9-错误处理规范)
- [10. 性能优化指南](#10-性能优化指南)
- [11. 安全开发规范](#11-安全开发规范)
- [12. 测试规范](#12-测试规范)

---

## 1. 项目结构规范

### 1.1 标准目录结构
```
entry/src/main/ets/
├── common/              # 公共工具类、常量、枚举
│   ├── constants/       # 常量定义
│   ├── utils/          # 工具函数
│   ├── types/          # 通用类型定义
│   └── managers/       # 业务管理器
├── components/         # 可复用UI组件
│   ├── base/          # 基础组件
│   └── business/      # 业务组件
├── pages/             # 页面级组件
│   ├── main/          # 主要页面
│   └── settings/      # 设置相关页面
├── services/          # 业务逻辑服务
│   ├── api/           # API接口服务
│   ├── data/          # 数据服务
│   └── storage/       # 存储服务
├── models/            # 数据模型定义
└── entryability/      # 应用入口能力
```

### 1.2 文件命名规范
- **文件名**: 使用PascalCase，如：`UserProfile.ets`、`HttpService.ets`
- **页面文件**: 使用PascalCase + "Page"后缀，如：`HomePage.ets`、`SettingsPage.ets`
- **组件文件**: 使用PascalCase，如：`CustomButton.ets`、`LoadingSpinner.ets`
- **服务文件**: 使用PascalCase + "Service"后缀，如：`ApiService.ets`
- **工具文件**: 使用PascalCase + "Utils"后缀，如：`DateUtils.ets`

### 1.3 模块职责划分
- `common/`: 项目通用代码，不依赖具体业务
- `components/`: 可复用UI组件，支持props传递
- `pages/`: 页面级组件，包含完整的页面逻辑
- `services/`: 业务逻辑层，处理数据和业务规则
- `models/`: 数据模型，定义应用使用的数据结构

---

## 2. 模块导入规范

### 2.1 Kit模块 vs API模块详解

#### 2.1.1 @kit模块（推荐使用）
- **定义**: HarmonyOS为提升开发效率而推出的高级别API封装方式
- **特点**: 面向特定领域或功能的开发工具包，API设计更加独立和高级
- **版本**: 从API 12开始推荐使用，替代传统@ohos模块
- **优势**: 更易使用，功能更完整，开发效率更高

#### 2.1.2 @ohos模块（兼容保留）
- **定义**: HarmonyOS核心系统级API，提供底层系统功能
- **特点**: 更接近操作系统底层，提供基础运行环境和服务
- **兼容性**: 仍然保持兼容，但官方推荐迁移到@kit
- **关系**: 被@kit模块内部依赖和调用

### 2.2 完整Kit模块参考

#### 2.2.1 核心框架Kit
```typescript
// 应用框架服务
import { AbilityConstant, UIAbility, Want, common } from '@kit.AbilityKit';
// UI开发框架
import { window, promptAction } from '@kit.ArkUI';
```

#### 2.2.2 文件和媒体Kit
```typescript
// 文件管理服务
import { File, fileIo } from '@kit.CoreFileKit';
// 媒体库访问服务
import { photoAccessHelper } from '@kit.MediaLibraryKit';
// 图像处理服务
import { image } from '@kit.ImageKit';
// 媒体处理服务
import { media } from '@kit.MediaKit';
```

#### 2.2.3 网络和通信Kit
```typescript
// 网络通信服务
import { http } from '@kit.NetworkKit';
```

#### 2.2.4 系统服务Kit
```typescript
// 基础服务
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
// 性能分析工具
import { hilog } from '@kit.PerformanceAnalysisKit';
```

#### 2.2.5 智能功能Kit
```typescript
// 扫码服务
import { detectBarcode, scanBarcode } from '@kit.ScanKit';
// 语音服务
import { speechKit } from '@kit.SpeechKit';
// 视觉服务
import { interactiveLiveness } from '@kit.VisionKit';
import { textRecognition } from '@kit.CoreVisionKit';
```

### 2.3 常用ohos API模块参考

#### 2.3.1 路由和导航
```typescript
// 页面路由
import router from '@ohos.router';
```

#### 2.3.2 多媒体模块
```typescript
// 相机功能
import camera from '@ohos.multimedia.camera';
// 图像处理
import image from '@ohos.multimedia.image';
// 音视频媒体
import media from '@ohos.multimedia.media';
```

#### 2.3.3 文件系统
```typescript
// 文件I/O操作
import fileio from '@ohos.fileio';
// 照片访问助手
import photoAccessHelper from '@ohos.file.photoAccessHelper';
```

#### 2.3.4 系统服务
```typescript
// 日志服务
import hilog from '@ohos.hilog';
// 窗口管理
import window from '@ohos.window';
// 权限访问控制
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
// 应用包管理
import bundleManager from '@ohos.bundle.bundleManager';
```

### 2.4 导入顺序规范
1. **HarmonyOS Kit模块**（@kit.xxx）- 优先使用
2. **HarmonyOS API模块**（@ohos.xxx）- 兼容使用
3. **项目内部模块**（相对路径）

### 2.5 导入示例模板
```typescript
// 1. Kit模块 (优先推荐)
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { http } from '@kit.NetworkKit';

// 2. API模块 (兼容使用)
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';

// 3. 项目内部模块
import { ApiService } from '../services/ApiService';
import { UserModel } from '../models/UserModel';
import { CustomButton } from '../components/CustomButton';
```

### 2.6 版本兼容策略
- **API 12+**: 优先使用@kit模块，@ohos模块作为补充
- **API 9-11**: 主要使用@ohos模块，部分功能可用@kit
- **迁移建议**: 逐步将@ohos导入替换为对应的@kit导入

---

## 3. 类型定义规范

### 3.1 接口定义
```typescript
// 基础数据接口
export interface UserInfo {
  id: string;
  name: string;
  email?: string;
  avatar?: string;
}

// API响应接口
export interface ApiResponse<T = any> {
  code: number;
  message: string;
  data?: T;
  timestamp: number;
}

// 组件属性接口
export interface ButtonProps {
  text: string;
  type?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
  onClick?: () => void;
}
```

### 3.2 类型安全原则
- **禁用any**: 使用具体类型，避免使用`any`类型
- **未知类型**: 使用`object`或`Record<string, Function>`代替`any`
- **可选属性**: 合理使用`?`标记可选属性
- **联合类型**: 使用联合类型限制值的范围

### 3.3 类型转换
```typescript
// 正确的类型转换
const context = getContext(this) as common.UIAbilityContext;
const windowObj = mainWindow as Record<string, Function>;

// 错误处理类型转换
const businessError = error as BusinessError;
```

---

## 4. 组件开发规范

### 4.1 组件结构模板
```typescript
@Entry  // 页面组件使用
@Component
export struct ComponentName {
  // 1. 状态变量（按重要性排序）
  @State private isLoading: boolean = false;
  @State selectedItem: string = '';
  
  // 2. 属性参数
  title: string = '默认标题';
  onConfirm?: (data: any) => void;
  
  // 3. 私有属性
  private dataService: DataService = DataService.getInstance();
  
  // 4. 生命周期方法
  aboutToAppear(): void {
    this.initializeData();
  }
  
  aboutToDisappear(): void {
    this.cleanup();
  }
  
  // 5. 私有方法
  private async initializeData(): Promise<void> {
    // 初始化逻辑
  }
  
  private cleanup(): void {
    // 清理逻辑
  }
  
  // 6. 事件处理方法
  private handleClick(): void {
    this.onConfirm?.(this.selectedItem);
  }
  
  // 7. Builder方法
  @Builder
  private buildHeader() {
    Row() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
    }
  }
  
  // 8. build方法
  build() {
    Column() {
      this.buildHeader()
      // 其他UI内容
    }
    .width('100%')
    .height('100%')
  }
}
```

### 4.2 状态管理规范
- 使用`@State`装饰器声明响应式状态
- 布尔值状态使用`is`、`has`、`show`、`can`等前缀
- 私有状态变量使用`private`关键字
- 避免在状态中存储复杂对象，优先使用基本类型

### 4.3 组件通信规范
```typescript
// 父传子：属性传递
@Component
export struct ChildComponent {
  data: string = '';
  callback?: (value: string) => void;
}

// 子传父：回调函数
@Component
export struct ParentComponent {
  @State childData: string = '';
  
  private handleChildCallback = (value: string): void => {
    this.childData = value;
  }
  
  build() {
    ChildComponent({
      data: this.childData,
      callback: this.handleChildCallback
    })
  }
}
```

---

## 5. UI布局与样式规范

### 5.1 布局组件选择
- **Column**: 垂直线性布局
- **Row**: 水平线性布局  
- **Stack**: 层叠布局，组件重叠
- **Flex**: 弹性布局，复杂排列
- **Grid**: 网格布局，规则排列
- **List**: 列表布局，大量数据

### 5.2 样式属性顺序
```typescript
Component()
  // 1. 尺寸属性
  .width('100%')
  .height(200)
  
  // 2. 定位属性  
  .margin({ top: 10, bottom: 10 })
  .padding(16)
  .position({ x: 0, y: 0 })
  
  // 3. 背景属性
  .backgroundColor('#FFFFFF')
  .backgroundImage('/path/to/image')
  
  // 4. 边框属性
  .border({ width: 1, color: '#E0E0E0', radius: 8 })
  
  // 5. 阴影属性
  .shadow({ radius: 4, color: 'rgba(0,0,0,0.1)', offsetY: 2 })
  
  // 6. 文本属性
  .fontSize(16)
  .fontColor('#333333')
  .fontWeight(FontWeight.Medium)
  
  // 7. 变换属性
  .opacity(0.9)
  .scale({ x: 1.1, y: 1.1 })
  .rotate({ angle: 45 })
  
  // 8. 交互属性
  .enabled(true)
  .focusable(true)
  .onClick(() => {})
```

### 5.3 颜色值规范
```typescript
// 推荐：使用十六进制颜色
.backgroundColor('#FF6B35')
.fontColor('#333333')

// 推荐：使用RGBA透明度
.backgroundColor('rgba(255, 107, 53, 0.8)')
.shadow({ color: 'rgba(0, 0, 0, 0.15)' })

// 推荐：使用系统颜色
.fontColor(Color.White)
.backgroundColor(Color.Transparent)

// 避免：使用颜色名称
.backgroundColor('red')  // 不推荐
```

### 5.4 响应式布局
```typescript
// 使用百分比布局
.width('100%')
.height('50%')

// 使用layoutWeight实现弹性布局
Column() {
  Text('固定高度').height(50)
  Text('弹性高度').layoutWeight(1)
  Text('固定高度').height(50)
}

// 使用媒体查询适配不同屏幕
@Styles
function responsiveWidth() {
  .width('90%')
  // 可以根据屏幕尺寸调整
}
```

---

## 6. 代码格式化规范

### 6.1 缩进和空格
- 使用2个空格缩进，不使用Tab
- 运算符前后添加空格
- 逗号、分号后添加空格

### 6.2 换行规则
```typescript
// 方法链式调用每个方法独占一行
Button('确定')
  .fontSize(16)
  .fontColor(Color.White)
  .backgroundColor('#007AFF')
  .borderRadius(8)
  .padding({ left: 20, right: 20, top: 10, bottom: 10 })
  .onClick(() => {
    this.handleConfirm();
  })

// 长参数列表适当换行
function createUser(
  name: string,
  email: string,
  phone: string,
  address: string
): UserInfo {
  // 实现
}

// 对象字面量适当换行
const userInfo = {
  id: '123',
  name: '张三',
  email: 'zhangsan@example.com',
  createTime: Date.now()
};
```

### 6.3 大括号规范
```typescript
// 控制语句大括号与语句同行
if (condition) {
  // 代码
}

// 函数大括号另起一行（可选）
function methodName(): void {
  // 代码
}

// 或与函数名同行
function methodName(): void {
  // 代码
}
```

---

## 7. 异步编程规范

### 7.1 Promise处理模式
```typescript
// 标准async/await模式
async function fetchUserData(userId: string): Promise<UserInfo | null> {
  try {
    const response = await apiService.getUser(userId);
    if (response.code === 200) {
      return response.data;
    } else {
      console.error('获取用户信息失败:', response.message);
      return null;
    }
  } catch (error) {
    const businessError = error as BusinessError;
    console.error('请求异常:', businessError.message);
    return null;
  }
}

// 组件中使用异步方法
@Component
export struct UserProfile {
  @State userInfo: UserInfo | null = null;
  @State isLoading: boolean = false;
  
  async aboutToAppear(): Promise<void> {
    await this.loadUserData();
  }
  
  private async loadUserData(): Promise<void> {
    this.isLoading = true;
    try {
      this.userInfo = await fetchUserData('123');
    } finally {
      this.isLoading = false;
    }
  }
}
```

### 7.2 错误处理策略
```typescript
// 统一错误处理函数
function handleError(error: unknown, context: string): void {
  const businessError = error as BusinessError;
  console.error(`${context}发生错误:`, {
    code: businessError.code,
    message: businessError.message,
    stack: businessError.stack
  });
  
  // 可以添加用户提示逻辑
  promptAction.showToast({
    message: '操作失败，请稍后重试',
    duration: 2000
  });
}

// 在业务代码中使用
async function saveUserInfo(userInfo: UserInfo): Promise<boolean> {
  try {
    await apiService.updateUser(userInfo);
    return true;
  } catch (error) {
    handleError(error, '保存用户信息');
    return false;
  }
}
```

### 7.3 并发处理
```typescript
// 并发请求处理
async function loadPageData(): Promise<void> {
  const [userInfo, notifications, settings] = await Promise.all([
    fetchUserInfo(),
    fetchNotifications(),
    fetchSettings()
  ]);
  
  // 处理结果
  this.userInfo = userInfo;
  this.notifications = notifications;
  this.settings = settings;
}

// 串行请求处理
async function processUserFlow(): Promise<void> {
  const userInfo = await fetchUserInfo();
  if (userInfo) {
    const preferences = await fetchUserPreferences(userInfo.id);
    await applyPreferences(preferences);
  }
}
```

---

## 8. 资源管理规范

### 8.1 单例模式实现
```typescript
export class DataManager {
  private static instance: DataManager;
  private cache: Map<string, any> = new Map();
  
  private constructor() {}
  
  public static getInstance(): DataManager {
    if (!DataManager.instance) {
      DataManager.instance = new DataManager();
    }
    return DataManager.instance;
  }
  
  public setCache(key: string, value: any): void {
    this.cache.set(key, value);
  }
  
  public getCache(key: string): any {
    return this.cache.get(key);
  }
  
  public clearCache(): void {
    this.cache.clear();
  }
}
```

### 8.2 资源生命周期管理
```typescript
@Component
export struct ResourceComponent {
  private resourceManager?: ResourceManager;
  
  aboutToAppear(): void {
    this.initializeResources();
  }
  
  aboutToDisappear(): void {
    this.releaseResources();
  }
  
  private initializeResources(): void {
    this.resourceManager = new ResourceManager();
    this.resourceManager.initialize();
  }
  
  private async releaseResources(): Promise<void> {
    if (this.resourceManager) {
      await this.resourceManager.release();
      this.resourceManager = undefined;
    }
  }
}
```

### 8.3 内存管理
```typescript
// 大对象及时释放
class DataProcessor {
  private largeData?: ArrayBuffer;
  
  process(data: ArrayBuffer): void {
    this.largeData = data;
    // 处理数据
    this.processInternal();
    // 处理完成后立即释放
    this.largeData = undefined;
  }
  
  private processInternal(): void {
    // 具体处理逻辑
  }
}

// 避免内存泄漏
class EventManager {
  private listeners: Set<Function> = new Set();
  
  addListener(listener: Function): void {
    this.listeners.add(listener);
  }
  
  removeListener(listener: Function): void {
    this.listeners.delete(listener);
  }
  
  destroy(): void {
    this.listeners.clear();
  }
}
```

---

## 9. 错误处理规范

### 9.1 错误类型定义
```typescript
export enum ErrorCode {
  NETWORK_ERROR = 1001,
  PERMISSION_DENIED = 1002,
  DATA_NOT_FOUND = 1003,
  INVALID_PARAMETER = 1004,
  SYSTEM_ERROR = 1005
}

export interface AppError {
  code: ErrorCode;
  message: string;
  details?: any;
  timestamp: number;
}

export class AppException extends Error {
  public readonly code: ErrorCode;
  public readonly details?: any;
  public readonly timestamp: number;
  
  constructor(code: ErrorCode, message: string, details?: any) {
    super(message);
    this.code = code;
    this.details = details;
    this.timestamp = Date.now();
    this.name = 'AppException';
  }
}
```

### 9.2 全局错误处理
```typescript
export class GlobalErrorHandler {
  public static handle(error: Error | AppException): void {
    if (error instanceof AppException) {
      this.handleAppException(error);
    } else if (error instanceof Error) {
      this.handleGenericError(error);
    }
  }
  
  private static handleAppException(error: AppException): void {
    console.error('应用错误:', {
      code: error.code,
      message: error.message,
      details: error.details,
      timestamp: error.timestamp
    });
    
    // 根据错误类型显示相应提示
    switch (error.code) {
      case ErrorCode.NETWORK_ERROR:
        this.showNetworkErrorToast();
        break;
      case ErrorCode.PERMISSION_DENIED:
        this.showPermissionErrorDialog();
        break;
      default:
        this.showGenericErrorToast(error.message);
    }
  }
  
  private static handleGenericError(error: Error): void {
    console.error('系统错误:', error.message, error.stack);
    this.showGenericErrorToast('系统错误，请稍后重试');
  }
}
```

### 9.3 组件错误边界
```typescript
@Component
export struct ErrorBoundary {
  @State hasError: boolean = false;
  @State errorMessage: string = '';
  
  @BuilderParam content: () => void;
  
  private handleError = (error: Error): void => {
    this.hasError = true;
    this.errorMessage = error.message;
    GlobalErrorHandler.handle(error);
  }
  
  build() {
    if (this.hasError) {
      Column() {
        Text('页面加载失败')
          .fontSize(16)
          .fontColor('#FF6B6B')
        
        Text(this.errorMessage)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 8 })
        
        Button('重试')
          .margin({ top: 16 })
          .onClick(() => {
            this.hasError = false;
            this.errorMessage = '';
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      try {
        this.content()
      } catch (error) {
        this.handleError(error as Error);
      }
    }
  }
}
```

---

## 10. 性能优化指南

### 10.1 渲染优化
```typescript
// 使用@Builder减少重复构建
@Component
export struct OptimizedList {
  @State items: ListItem[] = [];
  
  // 将复杂的列表项抽取为Builder
  @Builder
  private buildListItem(item: ListItem, index: number) {
    Row() {
      Image(item.avatar)
        .width(40)
        .height(40)
        .borderRadius(20)
      
      Column() {
        Text(item.name).fontSize(16)
        Text(item.description).fontSize(12).fontColor('#999999')
      }
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
  }
  
  build() {
    List() {
      ForEach(this.items, (item: ListItem, index: number) => {
        ListItem() {
          this.buildListItem(item, index)
        }
      }, (item: ListItem) => item.id) // 提供稳定的key
    }
  }
}
```

### 10.2 状态优化
```typescript
// 避免不必要的状态更新
@Component
export struct OptimizedComponent {
  @State private dataVersion: number = 0;
  private cachedData: ComplexData | null = null;
  
  // 使用计算属性避免重复计算
  private get processedData(): ProcessedData | null {
    if (!this.cachedData) {
      return null;
    }
    
    // 只有数据版本变化时才重新计算
    if (this.lastProcessedVersion !== this.dataVersion) {
      this.processedResult = this.processData(this.cachedData);
      this.lastProcessedVersion = this.dataVersion;
    }
    
    return this.processedResult;
  }
  
  private lastProcessedVersion: number = -1;
  private processedResult: ProcessedData | null = null;
  
  private updateData(newData: ComplexData): void {
    if (this.isDataChanged(this.cachedData, newData)) {
      this.cachedData = newData;
      this.dataVersion++; // 触发重新计算
    }
  }
}
```

### 10.3 内存优化
```typescript
// 图片资源优化
@Component
export struct ImageGallery {
  @State images: string[] = [];
  private imageCache: Map<string, PixelMap> = new Map();
  
  private async loadImage(url: string): Promise<PixelMap | null> {
    // 检查缓存
    if (this.imageCache.has(url)) {
      return this.imageCache.get(url) || null;
    }
    
    try {
      const pixelMap = await image.createImageSource(url).createPixelMap();
      
      // 控制缓存大小
      if (this.imageCache.size >= 50) {
        const firstKey = this.imageCache.keys().next().value;
        this.imageCache.delete(firstKey);
      }
      
      this.imageCache.set(url, pixelMap);
      return pixelMap;
    } catch (error) {
      console.error('图片加载失败:', error);
      return null;
    }
  }
  
  aboutToDisappear(): void {
    // 释放图片缓存
    this.imageCache.clear();
  }
}
```

---

## 11. 安全开发规范

### 11.1 数据验证
```typescript
export class DataValidator {
  public static validateEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
  
  public static validatePhone(phone: string): boolean {
    const phoneRegex = /^1[3-9]\d{9}$/;
    return phoneRegex.test(phone);
  }
  
  public static sanitizeInput(input: string): string {
    return input
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
      .replace(/[<>&"']/g, (match) => {
        const escapeMap: Record<string, string> = {
          '<': '&lt;',
          '>': '&gt;',
          '&': '&amp;',
          '"': '&quot;',
          "'": '&#x27;'
        };
        return escapeMap[match];
      });
  }
  
  public static validateUserInput(data: any): ValidationResult {
    const errors: string[] = [];
    
    if (!data.email || !this.validateEmail(data.email)) {
      errors.push('邮箱格式不正确');
    }
    
    if (!data.phone || !this.validatePhone(data.phone)) {
      errors.push('手机号格式不正确');
    }
    
    return {
      isValid: errors.length === 0,
      errors
    };
  }
}
```

### 11.2 权限管理
```typescript
export class PermissionManager {
  public static async checkPermission(permission: Permissions): Promise<boolean> {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const bundleInfo = await bundleManager.getBundleInfoForSelf(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
      );
      const tokenId = bundleInfo.appInfo.accessTokenId;
      
      const result = await atManager.checkAccessToken(tokenId, permission);
      return result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    } catch (error) {
      console.error('权限检查失败:', error);
      return false;
    }
  }
  
  public static async requestPermission(
    context: common.UIAbilityContext,
    permissions: Permissions[]
  ): Promise<boolean> {
    try {
      const atManager = abilityAccessCtrl.createAtManager();
      const result = await atManager.requestPermissionsFromUser(context, permissions);
      
      return result.authResults.every(
        result => result === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
      );
    } catch (error) {
      console.error('权限请求失败:', error);
      return false;
    }
  }
}
```

### 11.3 数据加密
```typescript
export class SecurityUtils {
  // 敏感信息不要硬编码
  private static readonly STORAGE_KEY_PREFIX = 'app_secure_';
  
  public static encodeBase64(data: string): string {
    try {
      return util.Base64Helper.encodeSync(data);
    } catch (error) {
      console.error('Base64编码失败:', error);
      return '';
    }
  }
  
  public static decodeBase64(encodedData: string): string {
    try {
      return util.Base64Helper.decodeSync(encodedData);
    } catch (error) {
      console.error('Base64解码失败:', error);
      return '';
    }
  }
  
  // 安全存储敏感数据
  public static async storeSecureData(key: string, value: string): Promise<boolean> {
    try {
      const secureKey = this.STORAGE_KEY_PREFIX + key;
      const encodedValue = this.encodeBase64(value);
      
      const preferences = await dataPreferences.getPreferences(getContext(), 'secure_storage');
      await preferences.put(secureKey, encodedValue);
      await preferences.flush();
      
      return true;
    } catch (error) {
      console.error('安全存储失败:', error);
      return false;
    }
  }
  
  public static async getSecureData(key: string): Promise<string | null> {
    try {
      const secureKey = this.STORAGE_KEY_PREFIX + key;
      const preferences = await dataPreferences.getPreferences(getContext(), 'secure_storage');
      const encodedValue = await preferences.get(secureKey, '') as string;
      
      if (encodedValue) {
        return this.decodeBase64(encodedValue);
      }
      return null;
    } catch (error) {
      console.error('安全读取失败:', error);
      return null;
    }
  }
}
```

---

## 12. 测试规范

### 12.1 单元测试结构
```typescript
// 测试用例组织结构
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { BusinessLogic } from '../src/main/ets/services/BusinessLogic';

export default function businessLogicTest() {
  describe('BusinessLogic', () => {
    let businessLogic: BusinessLogic;
    
    beforeAll(() => {
      // 全局设置
    });
    
    beforeEach(() => {
      // 每个测试前的设置
      businessLogic = new BusinessLogic();
    });
    
    afterEach(() => {
      // 每个测试后的清理
      businessLogic = null;
    });
    
    afterAll(() => {
      // 全局清理
    });
    
    it('should calculate correctly', () => {
      // 准备
      const input = { a: 1, b: 2 };
      const expected = 3;
      
      // 执行
      const result = businessLogic.calculate(input.a, input.b);
      
      // 验证
      expect(result).assertEqual(expected);
    });
    
    it('should handle error cases', () => {
      // 测试异常情况
      expect(() => {
        businessLogic.calculate(null, null);
      }).assertThrow();
    });
  });
}
```

### 12.2 组件测试
```typescript
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';

export default function componentTest() {
  describe('CustomButton Component', () => {
    it('should render correctly', async () => {
      const driver = Driver.create();
      
      // 查找组件
      const button = await driver.findComponent(ON.text('确定'));
      expect(await button.isEnabled()).assertTrue();
      
      // 模拟点击
      await button.click();
      
      // 验证结果
      const result = await driver.findComponent(ON.text('已点击'));
      expect(await result.isExist()).assertTrue();
    });
  });
}
```

### 12.3 API测试
```typescript
export default function apiTest() {
  describe('API Service', () => {
    it('should fetch user data successfully', async () => {
      const apiService = new ApiService();
      const mockUserId = '123';
      
      const result = await apiService.getUserInfo(mockUserId);
      
      expect(result).not.assertNull();
      expect(result.id).assertEqual(mockUserId);
      expect(result.name).not.assertNull();
    });
    
    it('should handle network errors', async () => {
      const apiService = new ApiService();
      
      // 模拟网络错误
      try {
        await apiService.getUserInfo('invalid_id');
        expect().assertFail('应该抛出异常');
      } catch (error) {
        expect(error.code).assertEqual(ErrorCode.NETWORK_ERROR);
      }
    });
  });
}
```

---

## 13. Kit vs ohos模块迁移指南

### 13.1 选择原则
- **新项目**: 优先使用@kit模块，减少@ohos依赖
- **现有项目**: 逐步迁移，优先迁移核心功能
- **兼容性考虑**: 两种方式可共存，但建议统一风格

### 13.2 迁移路径
```typescript
// 第一步：识别可替换的ohos导入
import hilog from '@ohos.hilog';
import fileio from '@ohos.fileio';
import image from '@ohos.multimedia.image';

// 第二步：替换为对应Kit导入
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';

// 第三步：更新使用方式（如果需要）
// 某些API调用方式可能略有不同，需要查阅文档确认

// 第四步：测试验证功能正常
```

### 13.3 混合使用策略
```typescript
// 项目中Kit和ohos可以共存，逐步迁移
import { common } from '@kit.AbilityKit';          // 优先使用Kit
import { hilog } from '@kit.PerformanceAnalysisKit'; // 已迁移到Kit
import router from '@ohos.router';                   // 暂时保留ohos版本
import { BusinessError } from '@ohos.base';         // 基础类型继续使用ohos
```

---

## 附录：常用工具和资源

### A.1 开发工具配置
- **DevEco Studio**: 官方IDE，支持代码提示、调试、打包
- **代码格式化**: 配置Prettier或EditorConfig统一代码风格
- **ESLint**: 配置代码质量检查规则
- **版本控制**: 使用Git管理代码版本

### A.2 调试技巧
```typescript
// 使用hilog进行调试
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'MyApp';
const DOMAIN = 0x0001;

// 不同级别的日志
hilog.debug(DOMAIN, TAG, '调试信息: %{public}s', debugInfo);
hilog.info(DOMAIN, TAG, '一般信息: %{public}s', info);
hilog.warn(DOMAIN, TAG, '警告信息: %{public}s', warning);
hilog.error(DOMAIN, TAG, '错误信息: %{public}s', error);
```

### A.3 性能监控
```typescript
// 性能监控工具类
export class PerformanceMonitor {
  private static timers: Map<string, number> = new Map();
  
  public static startTimer(name: string): void {
    this.timers.set(name, Date.now());
  }
  
  public static endTimer(name: string): number {
    const startTime = this.timers.get(name);
    if (startTime) {
      const duration = Date.now() - startTime;
      hilog.info(0x0001, 'Performance', `${name} 耗时: ${duration}ms`);
      this.timers.delete(name);
      return duration;
    }
    return 0;
  }
}
```

---

## 结语

本规范文档提供了HarmonyOS ArkTS开发的完整指导，涵盖了从项目结构到具体编码实践的各个方面。建议开发团队根据项目具体需求灵活应用这些规范，并结合团队经验不断完善。

良好的编码规范不仅能提高代码质量，还能提升团队协作效率，为项目的长期维护奠定坚实基础。

**建议使用方式:**
1. 新项目开始时参考项目结构规范
2. 日常开发时遵循编码和样式规范  
3. 代码审查时对照质量和安全规范
4. 项目迭代时考虑性能优化建议

---

*本文档将随着HarmonyOS版本更新和最佳实践演进而持续更新*