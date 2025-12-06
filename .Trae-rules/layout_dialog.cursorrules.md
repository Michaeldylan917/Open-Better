```markdown
# HarmonyOS 布局与弹窗 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- **数据驱动UI**：所有界面变化必须通过状态变量（@State、@Prop、@Link）驱动，禁止直接操作UI节点
- **性能优先**：长列表必须使用LazyForEach，组件使用@Reusable装饰器，布局层级不超过5层
- **弹窗中心化**：复杂弹窗统一通过DialogHub管理，避免分散调用导致生命周期混乱
- **手势精确处理**：缩放/拖拽/滑动场景需明确手势优先级，使用GestureMode.Sequential避免冲突

## 推荐做法

### 代码结构
- 将重复UI单元封装为@Component组件，通过@Builder优化复杂构建逻辑
- 弹窗内容超过半屏时，优先使用bindContentCover替代CustomDialog
- 瀑布流/网格布局统一基于ScrollComponents实现，图片加载必须设置占位符

### 最佳实践
- 列表项触摸热区不小于48vp×48vp，使用cachedCount预加载2-3屏数据
- 图片预览器使用PinchGesture+PanGesture组合，缩放>1时禁用滑动切换
- 文本展开折叠通过LineHeight和maxLines控制，动画使用animateTo实现平滑过渡
- 键盘弹起场景使用expandSafeArea配合避让布局，防止输入框遮挡

## 禁止做法

- ❌ 在build()函数中执行数据转换、排序等耗时操作
- ❌ ForEach渲染超过20条数据，会导致首帧卡顿和内存飙升
- ❌ 弹窗内嵌套滚动容器，造成手势冲突和性能劣化
- ❌ 组件复用场景下使用全局状态或@ObjectLink传递大数据对象

## 代码示例

### 推荐写法
```arkts
// 可复用列表项组件
@Reusable
@Component
struct ListItem {
  @Prop item: ItemModel;
  
  aboutToReuse(params: Record<string, Object>): void {
    this.item = params.item as ItemModel; // 仅更新数据，不重建组件
  }
  
  build() {
    Row() { /* 扁平化布局 */ }
    .gesture(TapGesture({ count: 1 })) // 明确手势配置
  }
}

// 懒加载长列表
LazyForEach(this.dataSource, (item: ItemModel) => {
  ListItem({ item: item })
}, (item: ItemModel) => item.id)
```

### 避免写法
```arkts
// 错误：深层嵌套+匿名组件
Column() {
  Stack() {
    Column() {
      ForEach(this.largeList, (item) => { // 性能灾难
        Row() { /* 匿名组件无法复用 */ }
      })
    }
  }
}

// 错误：弹窗内直接加载长列表
@CustomDialog
struct BadDialog {
  build() {
    Scroll() { // 手势冲突
      ForEach(this.comments, (c) => { CommentItem(c) })
    }
  }
}
```

## 注意事项

- 使用Swiper轮播时，loop模式下索引需通过onChange同步回父组件
- Grid拖拽交换必须基于数据数组splice操作，禁止直接修改UI位置
- DialogHub注册的弹窗需在aboutToDisappear中销毁，防止内存泄漏
- 瀑布流图片高度需预计算或onComplete回调后刷新，避免布局抖动
- 所有动画优先使用ArkUI原生动画，避免setInterval实现帧动画
```