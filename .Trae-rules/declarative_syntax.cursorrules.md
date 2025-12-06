```markdown
# HarmonyOS 声明式语法 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- **精确控制状态作用域**：仅在必要组件中声明状态，避免不必要的状态提升
- **最小化刷新范围**：使用精准装饰器控制组件刷新，防止冗余渲染
- **优先使用V2装饰器**：@ComponentV2、@ObservedV2、@Trace等新装饰器性能更优
- **合理划分组件层级**：将频繁变化与稳定状态分离，减少级联刷新

## 推荐做法

### 代码结构
- 使用@ComponentV2替代@Component，@Param传递只读数据
- 复杂对象状态使用@ObservedV2 + @Trace精准控制属性级刷新
- 全局状态通过StateStore管理，避免层层传递
- 组件间通信使用@Event回调，保持单向数据流

### 最佳实践
- 列表渲染优先使用LazyForEach实现懒加载
- 大对象使用@Track标记仅需要监听的属性
- 频繁更新的UI元素抽取为独立小组件
- 使用shouldBuild控制组件是否参与构建

## 禁止做法

- 避免在根组件声明@State导致全量刷新
- 禁止在ForEach循环中直接创建状态
- 避免@ObjectLink与@State混用导致重复观察
- 禁止将AppStorage作为组件内部状态使用

## 代码示例

### 推荐写法
```arkts
@ObservedV2
class UserState {
  @Trace name: string = ''  // 仅name变化触发刷新
  age: number = 0           // age变化不刷新
}

@ComponentV2
struct UserCard {
  @Param user: UserState    // 只读传入，不触发重建
  @Event onUpdate: (name: string) => void
  
  build() {
    Column() {
      Text(this.user.name)
      Button('更新').onClick(() => this.onUpdate('newName'))
    }
  }
}
```

### 避免写法
```arkts
// 错误：大对象全量观察导致冗余刷新
@Observed
class AppState {
  theme: Theme = new Theme()
  user: User = new User()      // user变化会触发所有引用组件刷新
  settings: Settings = new Settings()
}

// 错误：循环中创建状态导致性能问题
ForEach(this.items, (item) => {
  @State itemState: Item = item  // 禁止！
})
```

## 注意事项

- 使用性能分析工具监控组件刷新频率，识别冗余渲染
- @ObjectLink仅用于子组件观察父组件传递的@Observed对象
- 慎用@Provide/@Consume，优先通过参数传递明确依赖
- 对于复杂列表，结合@Reuse实现组件复用
- 状态变更避免在build方法中直接修改，防止循环刷新
```