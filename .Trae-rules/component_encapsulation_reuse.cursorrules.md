```markdown
# HarmonyOS 组件封装与复用 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

1. **优先复用而非创建**：始终优先考虑组件复用机制，避免不必要的动态创建
2. **高内聚低耦合**：组件应独立完整，通过清晰接口通信，避免状态耦合
3. **性能意识**：动态创建和复用操作必须进行性能评估，防止内存泄漏和卡顿
4. **状态隔离**：组件内部状态应私有化，仅暴露必要@Prop和@Link参数
5. **生命周期管理**：严格管理动态组件的创建、复用和销毁时机

## 推荐做法

### 代码结构
- 使用`@Component`装饰器封装可复用UI单元，配合`@Builder`方法构建动态内容
- 实现`IReusable`接口并设置`reuseId`标识组件复用类型
- 静态布局与动态内容分离，将动态部分提取为独立`@Builder`方法
- 复用组件中实现`aboutToReuse()`方法更新数据，确保状态重置

### 最佳实践
- 列表场景优先使用`LazyForEach` + 组件复用，减少节点创建开销
- 动态创建前评估必要性，简单条件渲染优先使用`if/else`
- 复用池组件保持轻量，避免在复用组件中持有大量数据
- 使用`@Observed/@ObjectLink`管理复杂对象状态，确保数据同步
- 通过`node.destroy()`及时释放不再使用的动态组件

## 禁止做法

- 在循环中直接动态创建组件而不使用复用机制
- 复用组件中保留上一个使用周期的状态数据
- 将业务逻辑与UI组件强耦合，导致组件无法独立使用
- 忽略`aboutToReuse()`回调，导致数据显示错乱
- 过度使用动态创建替代静态布局，增加代码复杂度

## 代码示例

### 推荐写法
```arkts
// 可复用组件实现
@Reusable
@Component
struct ListItemCard {
  @Prop itemData: ItemModel
  
  aboutToReuse(params: Record<string, Object>): void {
    this.itemData = params.itemData as ItemModel
  }
  
  build() {
    Row() {
      Text(this.itemData.title)
    }
  }
}

// 使用LazyForEach + 复用
List() {
  LazyForEach(this.dataSource, (item: ItemModel) => {
    ListItemCard({ itemData: item })
      .reuseId('list_item_type')
  })
}
```

### 避免写法
```arkts
// 错误：循环中直接动态创建
ForEach(this.itemList, (item: string) => {
  this.DynamicBuilder(item) // 无复用机制
})

// 错误：复用组件未重置状态
@Reusable
@Component
struct BadExample {
  @State private count: number = 0 // 状态残留风险
  // 缺少aboutToReuse回调
}
```

## 注意事项

- 使用DevEco Studio Profiler监控组件创建和复用性能
- 复用组件中避免使用全局状态或事件总线，防止数据污染
- 动态创建超过50个节点时，考虑分页或懒加载策略
- 调试复用问题时，检查`reuseId`一致性和状态更新逻辑
- 组件销毁必须在UI线程执行，避免异步操作导致内存泄漏
```