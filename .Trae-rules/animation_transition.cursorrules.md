# HarmonyOS 动画与转场 - Cursor Rules

你正在为HarmonyOS应用开发动画与转场功能。以下是你需要遵循的开发规则。

## 核心原则

- **性能优先**：动画帧率必须稳定在60fps，避免掉帧和卡顿
- **用户感知**：动画时长控制在200-400ms之间，过长会显得拖沓
- **场景匹配**：根据操作类型选择动画强度，日常操作使用 subtle 动画，重要转场使用 expressive 动画
- **一致性**：相同类型的页面/组件使用统一的动画曲线和时长

## 推荐做法

### 代码结构
- 使用`animateTo`显式动画处理属性变化，避免在setter中直接修改
- 页面转场优先使用`transition`组件级转场，复杂场景使用`sharedTransition`共享元素转场
- 将动画参数（时长、曲线）抽取为常量配置，便于全局统一管理

### 最佳实践
- **时长设置**：点击反馈150-200ms，页面转场300-400ms，列表项插入/删除250ms
- **曲线选择**：使用`Curve.Friction`（阻尼曲线）用于自然物理效果，`Curve.EaseInOut`用于常规转场
- **性能优化**：动画属性仅使用`transform`和`opacity`，避免触发布局重排；使用`renderGroup`提升复杂场景性能
- **一镜到底**：共享元素转场时，确保两个页面元素`id`和`sharedTransition`配置完全一致

## 禁止做法

- 禁止在`aboutToAppear`或`onPageShow`中直接执行耗时动画操作
- 禁止频繁快速触发动画，需添加节流控制
- 禁止对`width`、`height`、`margin`等布局属性做动画，改用`transform: scale`替代
- 禁止在列表滚动中触发复杂动画，应使用`onScrollFrameBegin`优化

## 代码示例

### 推荐写法
```arkts
// 显式动画控制属性变化
private animateButtonScale() {
  animateTo({ 
    duration: 200,
    curve: Curve.Friction,
    onFinish: () => {
      this.isAnimating = false;
    }
  }, () => {
    this.buttonScale = this.isPressed ? 0.95 : 1.0;
  })
}

// 共享元素转场
Image($r('app.media.icon'))
  .sharedTransition('sharedId', {
    duration: 350,
    curve: Curve.EaseInOut,
    delay: 50
  })
```

### 避免写法
```arkts
// 错误：在setter中直接修改触发布局动画
set width(value: number) {
  this._width = value; // 会触发重排
}

// 错误：频繁触发动画无节流
onTouchMove(event: TouchEvent) {
  this.positionX = event.touches[0].x; // 每次移动都触发动画
}
```

## 注意事项

- **调试**：开启开发者选项中的"显示GPU视图更新"监控动画性能
- **降级**：低性能设备自动降低动画复杂度，使用`systemCapability`检测设备能力
- **可访问性**：当用户开启"减少动画"辅助功能时，全局禁用非必要动画
- **内存**：复杂动画场景及时调用`.dispose()`释放资源，避免内存泄漏