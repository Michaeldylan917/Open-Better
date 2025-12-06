```markdown
# HarmonyOS 手势与导航 - Cursor Rules

你正在为HarmonyOS应用开发相关功能。以下是你需要遵循的开发规则。

## 核心原则

- **手势优先级明确**：导航手势（如Tab切换）优先于页面内手势（如列表滚动），通过`gesturePriority`明确层级
- **导航层级扁平化**：Tab数量控制在5个以内，禁止Tabs嵌套，遵循"一屏一核心任务"原则
- **跨设备一致性**：利用媒体查询和断点系统，一次开发适配手机、平板、折叠屏
- **路由统一管理**：使用HMRouter集中配置路由表，禁止硬编码路由路径
- **性能优先**：Tab内容使用懒加载，按需加载页面资源

## 推荐做法

### 代码结构
- 使用`Tabs`+`TabContent`构建一级导航，`TabBar`置于底部（手机）或侧边（平板）
- 路由配置独立成模块，通过HMRouter管理push、replace等跳转模式
- 将手势热区配置与业务逻辑分离，便于统一调整

### 最佳实践
- 横滑切换Tab时，与内部`Scroll`/`List`组件做好事件分发，设置2/3屏幕宽度为导航热区
- 为每个Tab提供清晰的图标+文字标签，选中态与未选中态视觉区分明显
- 折叠屏展开状态切换为侧边栏导航，折叠状态使用底部TabBar
- 页面跳转使用参数序列化传递，避免直接引用对象

## 禁止做法

- 在TabBar中放置超过5个项目，或使用无文字标签的纯图标Tab
- 深层嵌套Tabs或在TabContent内再嵌套独立导航
- 在页面边缘热区拦截系统返回手势或Tab切换手势
- 路由跳转时传递复杂对象或循环引用数据
- 忽略不同设备的导航体验差异，使用固定布局

## 代码示例

### 推荐写法
```arkts
// 基础Tab导航结构，带手势优先级
@Entry
@Component
struct MainNavigation {
  @State currentIndex: number = 0
  
  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() { HomePage() }
        .tabBar(this.tabBuilder('首页', 0, $r('app.media.ic_home')))
        .backgroundColor('#F1F3F5') // 区分内容区与TabBar
    }
    .vertical(false).scrollable(true).barHeight(56)
    .onGestureSwipe((index: number) => {
      // 手势冲突时优先响应Tab切换
      this.currentIndex = index
    })
  }
}
```

### 避免写法
```arkts
// 错误：深层嵌套Tabs，手势冲突
@Component
struct NestedTabs {
  build() {
    Tabs() {
      TabContent() {
        Tabs() { // 禁止嵌套！
          TabContent() { List() {} }.tabBar('子Tab1')
        }
      }.tabBar('主Tab1')
    }
  }
}

// 错误：硬编码路由
jump() {
  router.pushUrl({ url: 'pages/detail' }) // 应使用HMRouter
}
```

## 注意事项

- **手势冲突调试**：使用`onGestureRecognizerJudgeBegin`监听手势竞争，确保导航手势响应时间<100ms
- **折叠屏适配**：监听`display`状态变化，动态调整`barPosition`和`barWidth`
- **性能监控**：Tab切换时避免重复创建组件，使用`@Reusable`优化列表页
- **路由守卫**：在HMRouter中配置拦截器，处理登录态校验和权限控制
- **热区测试**：在真机上测试边缘滑动，确保误触率<5%
```