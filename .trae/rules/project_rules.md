---
alwaysApply: true
---
# 项目目录说明

## 项目目录（单层HarmonyOS架构）
```
├── AppScope/                # 应用全局配置与资源目录
│   ├── app.json5            # 应用全局配置文件
│   └── resources/           # 全局资源（如图片、字符串等）
│       └── base/            # 默认主题资源
│           ├── element/     # 字符串等元素资源
│           └── media/       # 图片、图层等多媒体资源
├── build-profile.json5      # 项目构建配置文件
├── code-linter.json5        # 代码规范/检查配置
├── entry/                   # 主应用入口模块
│   ├── build-profile.json5  # entry 模块构建配置
│   ├── hvigorfile.ts        # entry 模块构建脚本
│   ├── obfuscation-rules.txt# 混淆规则
│   ├── oh-package.json5     # entry 模块包配置
│   └── src/                 # 主模块源码
│       ├── main/            # 主入口源码
│       │   ├── ets/         # 业务逻辑代码（ets 脚本）
│       │   │   ├── entryability/        # 主 Ability 入口
│       │   │   │   └── EntryAbility.ets # 主 Ability 实现
│       │   │   ├── entrybackupability/  # 备份相关 Ability
│       │   │   │   └── EntryBackupAbility.ets
│       │   │   └── pages/               # 页面代码
│       │   │       └── Index.ets        # 首页实现
│       │   ├── module.json5             # 模块配置
│       │   └── resources/               # 资源文件
│       │       ├── base/                # 默认主题资源
│       │       │   ├── element/         # 颜色、字符串等
│       │       │   ├── media/           # 图片等
│       │       │   └── profile/         # 页面、备份等配置
│       │       ├── dark/                # 暗色主题资源
│       │       │   └── element/         # 暗色主题颜色
│       │       └── rawfile/             # 原始文件资源
│       ├── mock/                        # mock 配置
│       │   └── mock-config.json5        # mock 配置文件
│       ├── ohosTest/                    # 集成测试代码
│       │   ├── ets/                     # 测试脚本
│       │   │   └── test/                # 测试用例
│       │   │       ├── Ability.test.ets # Ability 测试
│       │   │       └── List.test.ets    # 列表测试
│       │   └── module.json5             # 测试模块配置
│       └── test/                        # 单元测试代码
│           ├── List.test.ets            # 列表单元测试
│           └── LocalUnit.test.ets       # 本地单元测试
├── hvigor/                  # 构建工具相关配置
│   └── hvigor-config.json5  # hvigor 配置
├── hvigorfile.ts            # 根构建脚本
├── local.properties         # 本地配置文件
├── oh-package-lock.json5    # 包依赖锁定文件
├── oh-package.json5         # 根包配置
├── oh_modules/              # 依赖模块目录
│   ├── .ohpm/               # OHPM 包管理器缓存
│   └── @ohos/               # 官方模块
└── run.sh                   # 一键构建部署脚本(macOs)
└── run.ps1                  # 一键构建部署脚本(windows)
```

## 目录说明（单层HarmonyOS架构）
1. **AppScope 目录**：存放应用全局配置和资源，包含应用级别的配置文件和全局资源。
2. **entry 目录**：主应用入口模块，负责应用的启动、路由配置和主要页面入口。
3. **resources 目录**：分为 base（默认主题）、dark（暗色主题）、rawfile（原始文件）等，便于多主题和多资源管理。
4. **hvigor 相关文件**：鸿蒙项目的构建工具配置，run.sh/run.ps1 脚本可一键完成依赖安装、构建、部署和启动。
5. **测试目录**：mock、ohosTest、test 目录分别用于模拟数据、集成测试和单元测试。
6. **oh_modules 目录**：存放项目依赖的第三方模块和官方模块。
7. **配置文件**：包括构建配置、代码规范配置、本地配置等。

**单层HarmonyOS架构特点**：
- **单模块结构**：以 entry 模块为核心，包含所有业务逻辑和页面
- **资源管理**：支持多主题资源管理，便于适配不同场景
- **测试完备**：包含单元测试和集成测试，保证代码质量
- **构建工具**：使用 hvigor 构建工具，支持模块化构建和部署

**代码组织说明**：
- **页面管理**：所有页面组件放在 `entry/src/main/ets/pages/` 目录下
- **组件管理**：可在 `entry/src/main/ets/` 下创建 `components/`、`views/`、`utils/` 等目录组织代码
- **资源引用**：使用 `$r('app.type.name')` 语法引用本模块资源
  ```typescript
  // 引用颜色资源
  Text('标题').fontColor($r('app.color.text_primary'))
  
  // 引用字符串资源
  Text($r('app.string.welcome_message'))
  
  // 引用图片资源
  Image($r('app.media.icon_home'))
  ```
- **常量管理**：建议在 `entry/src/main/ets/constants/` 目录下管理常量
  ```typescript
  // constants/PagePath.ets
  export class PagePath {
    static readonly HOME = 'pages/Index'
    static readonly DETAIL = 'pages/Detail'
  }
  ```
- **工具类管理**：在 `entry/src/main/ets/utils/` 目录下放置工具类和公共方法

## 资源管理规则

**规则说明：** 在单模块项目中，所有资源统一放在 `entry/src/main/resources/` 目录下管理。

**资源类型与引用方式：**

### 1. 颜色资源引用
- **资源位置**：`entry/src/main/resources/base/element/color.json`
- **引用语法**：`$r('app.color.资源名称')`
- **使用示例**：
  ```typescript
  Column()
    .backgroundColor($r('app.color.white'))
    .borderColor($r('app.color.brand_primary'))
  
  Text('标题')
    .fontColor($r('app.color.text_primary'))
  ```

### 2. 字符串资源引用
- **资源位置**：`entry/src/main/resources/base/element/string.json`
- **引用语法**：`$r('app.string.资源名称')`
- **使用示例**：
  ```typescript
  Text($r('app.string.welcome_message'))
    .fontSize(16)
  ```

### 3. 图片资源引用
- **资源位置**：`entry/src/main/resources/base/media/`
- **引用语法**：`$r('app.media.资源名称')`
- **使用示例**：
  ```typescript
  // 图片引用
  Image($r('app.media.icon_home'))
    .width(40)
    .height(40)
  
  // SVG 图标可以动态改变颜色
  Image($r('app.media.ic_arrow_right'))
    .fillColor($r('app.color.brand_primary'))
  ```

### 4. 浮点数资源引用
- **资源位置**：`entry/src/main/resources/base/element/float.json`
- **引用语法**：`$r('app.float.资源名称')`
- **使用示例**：
  ```typescript
  Text('内容')
    .fontSize($r('app.float.font_size_large'))
    .borderRadius($r('app.float.border_radius_medium'))
  ```

**注意事项：**
- 资源名称必须与 JSON 文件中定义的 `name` 字段完全匹配
- 支持暗色主题资源，放在 `dark/element/` 目录下
- SVG 图标可以使用 `fillColor` 属性动态改变颜色
- 建议统一管理颜色、字体大小等设计规范，保持应用视觉一致性

# 路由方案

## HMRouter 路由框架正确用法
- 安装依赖
  ```bash
  ohpm install @hadss/hmrouter @hadss/hmrouter-transitions
  ```
- **依赖配置**：在 oh-package.json5 中添加依赖，注意安装时的版本好
  ```json
  "@hadss/hmrouter": "^1.2.0-beta.1",
  "@hadss/hmrouter-transitions": "^1.2.0-beta.1"
  ```
- **构建插件配置**：在 hvigorfile.ts 中引入插件
  ```typescript
  import { hapPlugin } from "@hadss/hmrouter-plugin"; // entry模块
  import { hspPlugin } from "@hadss/hmrouter-plugin"; // hsp模块
  ```
- **初始化**：在 EntryAbility.ets 的 onCreate 方法中初始化
  ```typescript
  import { HMRouterMgr } from '@hadss/hmrouter';
  
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    HMRouterMgr.init({
      context: this.context,
    });
  }
  ```
- **页面注册**：使用 @HMRouter 装饰器注册页面
  ```typescript
  import { HMRouter } from '@hadss/hmrouter'
  
  @HMRouter({ pageUrl: PAGE_PATH.MEMBER_FORM_VIEW })
  @ComponentV2
  export struct MemberFormView {
    // 页面内容
  }
  ```
- **导航管理**：使用 HMRouterMgr 进行页面跳转
  ```typescript
  // 页面跳转
  HMRouterMgr.push({
    pageUrl: PAGE_PATH.MEMBER_FORM_VIEW,
    param: {
      relationship: relationship,
      parentId: this.selectedMemberId
    }
  })
  
  // 返回上一页
  HMRouterMgr.pop()
  ```
- **导航容器**：使用 HMNavigation 作为根导航容器
  ```typescript
  import { HMDefaultGlobalAnimator, HMNavigation } from '@hadss/hmrouter'
  
  HMNavigation({
    navigationId: 'MainNavigation',
    homePageUrl: 'MainPage',
    options: {
      standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
      dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
      modifier: this.modifier
    }
  }) {
    // 页面内容
  }
  ```
- **页面路径管理**：统一管理页面路径常量
  ```typescript
  export class PAGE_PATH {
    static readonly MEMBER_FORM_VIEW: string = "MemberFormView"
  }
  ```
- **注意事项**：
  - 页面组件必须使用 @HMRouter 装饰器注册
  - pageUrl 应使用统一的常量管理
  - 在 EntryAbility 中必须先初始化 HMRouterMgr
  - 使用 HMNavigation 替代原生 Navigation 组件
  - 支持页面间参数传递和动画配置

# 状态管理

## 状态管理类型规范（V2版本）

**规则说明：** @Local、@Param、@ObservedV2、@Trace 装饰的变量必须有明确的类型声明，且必须在@ComponentV2装饰的组件中使用。

**重要约束：**
- @Local、@Param、@Event等V2状态管理装饰器只能在@ComponentV2装饰的struct中使用
- @State、@Prop、@Link等V1状态管理装饰器只能在@Component装饰的struct中使用
- 不能在同一个组件中混用V1和V2状态管理装饰器
- **@ObservedV2装饰过的类在使用时无需添加@Local装饰器**，直接声明即可实现响应式更新

**正确示例：**
```typescript
// ✅ 正确 - V2状态管理组件
@ComponentV2
struct MyPageV2 {
  @Local localSearchResults: SearchResult[] = []
  @Param paramTitle: string = ''
  
  build() {
    Column() {
      // 组件内容
    }
  }
}

// ✅ 正确 - V1状态管理组件
@Component
struct MyPageV1 {
  @State searchResults: SearchResult[] = []
  @Prop title: string = ''
  
  build() {
    Column() {
      // 组件内容
    }
  }
}

// ✅ 正确 - V2数据模型
@ObservedV2
class UserModel {
  name: string = ''
  @Trace age: number = 0
}

// ✅ 正确 - 使用@ObservedV2装饰过的类（无需@Local装饰器）
@ComponentV2
struct UserProfile {
  memberData: UserModel = new UserModel() // 直接声明，自动响应式
  
  build() {
    Column() {
      Text(this.memberData.name)
      Text(this.memberData.age.toString())
    }
  }
}

// ✅ 正确 - 计算属性
@Computed
get fullName(): string {
  return `${this.firstName} ${this.lastName}`
}
```

**错误示例：**
```typescript
// ❌ 错误：在@Component中使用@Local
@Component
struct WrongPage {
  @Local localData: string = '' // 编译错误
}

// ❌ 错误：在@ComponentV2中使用@State
@ComponentV2
struct AnotherWrongPage {
  @State stateData: string = '' // 编译错误
}

// ❌ 错误：@ObservedV2装饰过的类使用@Local装饰器
@ComponentV2
struct WrongUserProfile {
  @Local memberData: UserModel = new UserModel() // 不需要@Local
}
```

# 每次代码生成后需编译检查

**重要性：** 这是最高优先级规则，每次代码生成后必须执行编译检查。

**编译检查命令：**
```bash
hvigorw assembleApp
```

**规则说明：**
- 代码生成完成后，必须立即运行 `hvigorw assembleApp` 进行全项目编译检查
- 该命令会编译所有模块（entry、basic、member等），确保代码无语法错误
- 只有编译成功（BUILD SUCCESSFUL）才能认为代码生成任务完成
- 如果编译失败，必须修复所有错误后重新编译验证

**适用场景：**
- 新增页面、组件或功能模块后
- 修改现有代码逻辑后
- 更新依赖或配置文件后
- 任何可能影响项目编译的代码变更

**注意事项：**
- 优先使用 `hvigorw assembleApp` 而不是 `hvigorw assembleHap` 或 `hvigorw build`
- 编译过程中出现的 ArkTS 错误必须根据项目规则进行修复
- 编译成功是代码交付的基本要求

# 每次代码生成后需构建部署应用

**重要性：** 这是最高优先级规则，每次代码生成后必须构建部署应用以便测试效果。

**构建部署流程：**
```bash
# 1. 编译检查 （App 包含了 hap、hsp、har）
hvigorw assembleApp  

# 2. 构建部署应用（使用项目脚本）
./run.sh # macOs
./run.ps1 # windows
```

**规则说明：**
- 代码生成完成并编译成功后，必须立即运行 `run.sh/run.ps1` 脚本进行构建部署
- 该脚本会自动完成依赖安装、构建、部署和启动应用的完整流程
- 只有应用成功启动并可以测试效果后，才能认为代码生成任务完全完成
- 如果部署失败，必须修复问题后重新部署验证

**适用场景：**
- 新增页面、组件或功能模块后
- 修改现有UI界面或交互逻辑后
- 更新路由配置或页面跳转后
- 任何需要验证用户界面效果的代码变更

**测试验证要求：**
- 验证新功能是否正常工作
- 检查UI界面是否符合预期
- 测试页面跳转和交互是否正常
- 确认没有运行时错误或异常

**注意事项：**
- 必须在编译成功后才能进行构建部署
- 使用项目根目录的 `run.sh/run.ps1` 脚本进行一键部署
- 部署成功后需要实际测试应用功能
- 构建部署成功是代码交付的最终要求

# ArkTS 常见错误与修正记录

## $$this 双向绑定语法规则
- **重要说明**：$$this 是 ArkTS 中正确的双向绑定语法，编辑器可能会报错但这是误报
- **使用场景**：在需要双向数据绑定的组件中使用，如 bindSheet、bindPopup 等
- **语法格式**：$$this.propertyName 或 $$variableName
- **编辑器报错处理**：忽略所有 $$this 相关的编辑器报错，这些都是编辑器的误判
- **正确示例**：
  ```typescript
  @ComponentV2
  struct MyComponent {
    @Local showSheet: boolean = false
    
    build() {
      Column() {
        Button('显示弹窗')
          .onClick(() => {
            this.showSheet = true
          })
      }
      .bindSheet($$this.showSheet, this.sheetBuilder, {
        height: 300
      })
    }
    
    @Builder
    sheetBuilder() {
      Text('弹窗内容')
    }
  }
  ```
- **注意事项**：
  - $$this 语法是 HarmonyOS 6 的标准双向绑定语法
  - 编译时不会报错，只是编辑器的静态检查误报
  - 可以正常使用，不影响应用运行
  - 在 code-linter.json5 中已配置忽略相关 TypeScript 报错


## 常见错误与修正记录

1. StoreConfig类型
- 错误：StoreConfig 不能加 stageMode 字段，正确写法只需 { name: string }，如需加密可加 securityLevel。
- 正确示例：const STORE_CONFIG: relationalStore.StoreConfig = { name: 'bills.db', securityLevel: relationalStore.SecurityLevel.S3 };

2. getRdbStore参数
- 错误：getRdbStore 只传 StoreConfig 会报类型错误，需传 getContext() 作为第一个参数。
- 正确示例：relationalStore.getRdbStore(getContext(), STORE_CONFIG, ...)

3. TextInput用法
- 错误：TextInput().placeholderText() 不存在，正确用法为 TextInput({ placeholder: 'xxx', text: this.xxx })

4. Blank只能在Row/Column/Flex内
- 遮罩建议用 Column().backgroundColor() 实现。

5. ArkTS对象字面量类型
- 错误：对象字面量必须显式声明类型，不能用any。

6. RdbStore.insert无需await
- insert为异步回调，不要await，否则类型报错。

7. 组件链式写法
- ArkTS推荐每个属性单独一行，便于维护和排查。

8. sys.symbol 系统图标资源正确用法
- **重要**：sys.symbol 资源必须使用 SymbolGlyph 组件，不能使用 Image 组件
- **SymbolGlyph组件**：专门用于显示系统符号图标，使用 `SymbolGlyph($r('sys.symbol.icon_name'))`
  - 正确示例：`SymbolGlyph($r('sys.symbol.chevron_right')).width(16).height(16).fontColor(['#CCCCCC', '#FFFFFF'])`
  - 错误示例：`Image($r('sys.symbol.chevron_right'))` ❌ 不要这样使用
- **注意事项**：
  - SymbolGlyph 使用 fontColor 属性设置颜色，接受数组格式：`fontColor(['#color'])`
  - Image 组件无法正确渲染 sys.symbol 资源，必须使用 SymbolGlyph
  - 系统图标名称遵循 Apple SF Symbols 命名规范
  - 常用图标：chevron_right（右箭头）、camera_fill（相机）、house（房子）、house_fill（实心房子）等

9. bindSheet 半模态弹窗正确用法
- **状态变量声明**：使用 @Local 装饰器声明控制显示状态的布尔变量
  ```typescript
  @Local showDatePicker: boolean = false
  @Local showAddMemberSheet: boolean = false
  ```
- **@Builder 方法定义**：创建弹窗内容的构建方法
  ```typescript
  @Builder
  DatePickerDialog() {
    Column() {
      Text('选择出生日期')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 20 })
      
      DatePicker({
        start: new Date('1900-1-1'),
        end: new Date(),
        selected: this.selectedDate
      })
        .onChange((value: DatePickerResult) => {
          this.selectedDate = new Date(value.year!, value.month!, value.day!)
        })
      
      // 按钮操作区域
      Row() {
        Button('取消')
          .onClick(() => {
            this.showDatePicker = false
          })
        Button('确定')
          .onClick(() => {
            // 处理确定逻辑
            this.showDatePicker = false
          })
      }
    }
    .padding(20)
  }
  ```
- **bindSheet 绑定**：在组件上使用 bindSheet 方法绑定半模态
  ```typescript
  Column() {
    // 页面内容
  }
  .bindSheet($$this.showDatePicker, this.DatePickerDialog(), {
    height: 400,
    dragBar: true,
    backgroundColor: $r('[basic].color.white'),
    onAppear: () => {
      console.info('日期选择器出现')
    },
    onDisappear: () => {
      console.info('日期选择器消失')
    }
  })
  ```
- **常用配置选项**：
  - `height`: 设置弹窗高度
  - `dragBar`: 是否显示拖拽条
  - `backgroundColor`: 背景颜色
  - `title`: 弹窗标题配置 `{ title: '标题文本' }`
  - `showClose`: 是否显示关闭按钮
  - `detents`: 弹窗高度档位，优先使用 `[SheetSize.FIT_CONTENT]` 自适应内容高度
  - `onAppear`: 弹窗出现回调
  - `onDisappear`: 弹窗消失回调
- **触发显示**：通过修改状态变量来控制弹窗显示
  ```typescript
  Button('选择日期')
    .onClick(() => {
      this.showDatePicker = true
    })
  ```
- **注意事项**：
  - 状态变量必须使用双向绑定 `$$this.variableName`
  - @Builder 方法返回的组件作为弹窗内容
  - 可以在同一个组件上绑定多个 bindSheet
  - 弹窗内容应包含关闭弹窗的操作逻辑
  - 建议在回调中添加日志便于调试

10. ArkTS对象更新规则
- **直接属性修改**：推荐使用直接属性赋值方式更新对象
  ```typescript
  // ✅ 正确：直接属性修改
  this.memberData.name = newName
  this.memberData.gender = 'male'
  this.memberData.isAlive = true
  ```
- **禁用方式**：以下方式在ArkTS中不被支持
  ```typescript
  // ❌ 错误：对象展开语法（arkts-no-spread）
  this.memberData = { ...this.memberData, name: newName }
  
  // ❌ 错误：Object.assign（arkts-no-untyped-obj-literals）
  this.memberData = Object.assign({}, this.memberData, { name: newName })
  ```
- **原因说明**：ArkTS对对象字面量和展开语法有严格限制，直接属性修改是最安全和推荐的方式
- **适用场景**：所有需要更新对象属性的场景，特别是状态管理中的数据更新

## 常见类型安全规则

### 对象字面量类型声明 (arkts-no-untyped-obj-literals)

**规则说明：** 所有对象字面量必须对应明确声明的类或接口类型。

**错误示例：**
```typescript
// ❌ 错误：未明确指定返回类型的对象字面量
return items.map(item => ({
  id: item.id,
  name: item.name,
  type: 'example'
}))

// ❌ 错误：缺少显式返回类型
function processItems(items: Item[]) {
  return items.map(item => ({
    id: item.id,
    name: item.name.toUpperCase()
  }));
}

// ❌ 错误：推断类型可能不准确
function transformData(data: any[]) {
  return data.map(item => {
    return {
      processed: true,
      value: item
    };
  });
}
```

**正确示例：**
```typescript
// ✅ 正确：明确指定返回类型
return items.map((item): ResultInterface => {
  return {
    id: item.id,
    name: item.name,
    type: 'example'
  }
})

// 或者使用临时变量
return items.map(item => {
  const result: ResultInterface = {
    id: item.id,
    name: item.name,
    type: 'example'
  }
  return result
})

// ✅ 正确：显式声明返回类型
function processItems(items: Item[]): ResultInterface[] {
  return items.map((item: Item): ResultInterface => {
    return {
      id: item.id,
      name: item.name.toUpperCase()
    };
  });
}

// ✅ 正确：明确类型声明
function transformData(data: any[]): TransformedData[] {
  return data.map((item: any): TransformedData => {
    return {
      processed: true,
      value: item
    };
  });
}
```

**适用场景：**
- map、filter、reduce 等数组方法的回调函数
- 函数返回值
- 变量赋值
- 参数传递

**修复方法：**
1. 为箭头函数添加明确的返回类型注解
2. 使用临时变量并声明类型
3. 确保接口或类型定义存在且可访问

### 对象字面量类型声明禁止 (arkts-no-obj-literals-as-types)

**规则说明：** ArkTS禁止在函数参数、变量声明等位置直接使用对象字面量作为类型声明，必须先定义接口或类型别名。

**错误示例：**
```typescript
// ❌ 错误：函数参数使用对象字面量类型
@Builder
buildStatItem(item: { number: string, label: string }) {
  // 编译错误：Object literals cannot be used as type declarations
}

// ❌ 错误：变量声明使用对象字面量类型
let config: { host: string, port: number } = {
  host: 'localhost',
  port: 3000
}

// ❌ 错误：函数返回类型使用对象字面量
function getData(): { id: number, name: string } {
  return { id: 1, name: 'test' }
}
```

**正确示例：**
```typescript
// ✅ 正确：先定义接口
interface StatItem {
  number: string;
  label: string;
}

@Builder
buildStatItem(item: StatItem) {
  // 正确使用
}

// ✅ 正确：定义配置接口
interface ServerConfig {
  host: string;
  port: number;
}

let config: ServerConfig = {
  host: 'localhost',
  port: 3000
}

// ✅ 正确：定义返回类型接口
interface DataResult {
  id: number;
  name: string;
}

function getData(): DataResult {
  return { id: 1, name: 'test' }
}
```

**修复方法：**
1. 在文件顶部或适当位置定义接口
2. 将对象字面量类型提取为独立的接口声明
3. 使用定义好的接口替换对象字面量类型
4. 确保接口命名清晰且符合业务语义

**最佳实践：**
- 接口命名使用大驼峰命名法
- 将相关接口组织在一起
- 考虑接口的复用性，避免重复定义相似结构

### 组件属性类型检查

**规则说明：** 组件的所有属性和方法参数必须有明确的类型定义。

**示例：**
```typescript
// ✅ 正确
private performSearch(keyword: string): Promise<SearchResult[]> {
  // 实现
}

private onItemClick(item: SearchResult): void {
  // 实现
}
```

# 以后遇到类似问题，优先查阅本md文件记录，避免重复犯错。