```markdown
# HarmonyOS 主题与样式 - Cursor Rules

你正在为HarmonyOS应用开发主题与样式功能。以下是你需要遵循的开发规则。

## 核心原则

- **系统一致性**：遵循系统主题设置，避免强制覆盖用户偏好
- **资源分离**：使用限定词目录管理主题资源，禁止硬编码样式
- **动态响应**：实时监听主题变化并刷新UI，确保无缝切换
- **体验优先**：亮度调节需考虑功耗和用户舒适度，提供明确控制

## 推荐做法

### 代码结构
- 按`resources/{base,dark}/element/color.json`结构分离主题资源
- 统一使用`$r('app.color.name')`引用资源，避免直接使用色值
- 在`EntryAbility.ets`中监听`onConfigurationUpdate`配置变更
- 亮度调节使用`window.setWindowBrightness`并记录用户选择

### 最佳实践
- 深色模式适配需覆盖所有界面元素（颜色、图标、状态栏）
- 提供应用内主题设置选项，但默认跟随系统
- 亮度设置范围0.1-1.0，避免设置极端值
- 使用`ColorMode`枚举判断当前主题模式

## 禁止做法

- ❌ 在代码中硬编码颜色值如`#FFFFFF`或`Color.White`
- ❌ 忽略`resources/dark/`目录中的反向适配
- ❌ 强制设置亮度后不恢复系统默认值
- ❌ 使用已废弃的`setAppBrightness`等过时API
- ❌ 在`@Entry`组件中直接操作`configuration`而不通过Ability

## 代码示例

### 推荐写法
```arkts
// 资源引用与动态监听
@Entry
@Component
struct Index {
  @State isDark: boolean = getContext().config.colorMode === ColorMode.COLOR_MODE_DARK
  
  onPageShow() {
    // 刷新状态栏
    window.getLastWindow(getContext()).then(w => {
      w.setWindowBarColor(this.isDark ? '#000000' : '#FFFFFF')
    })
  }
  
  build() {
    Column() {
      Text('示例').fontColor($r('app.color.text_primary'))
    }.backgroundColor($r('app.color.bg_primary'))
  }
}
```

### 避免写法
```arkts
// 硬编码与错误实践
@Entry
@Component
struct BadExample {
  build() {
    Column() {
      Text('错误示例')
        .fontColor('#000000') // 禁止：硬编码
        .backgroundColor(Color.White) // 禁止：不使用资源
    }
  }
  
  setBrightness() {
    // 禁止：无用户授权强制设置
    window.setWindowBrightness(1.0) 
  }
}
```

## 注意事项

- **版本兼容**：API 9+支持`onConfigurationUpdate`，低版本需手动刷新
- **性能**：避免在`build()`中频繁调用`getContext().config`，应在状态变更时缓存
- **状态栏**：深色模式需同步设置`setWindowBarColor`和`setWindowSystemBarProperties`
- **调试**：使用`hdc shell cmd window set-color-mode`命令模拟主题切换
- **权限**：亮度调节无需特殊权限，但需告知用户
```