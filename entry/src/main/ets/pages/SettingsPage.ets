import { CommonConstants } from '../common/constants/CommonConstants';
import { MoodService } from '../services/MoodService';
import { promptAction } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PreferencesUtil } from '../common/utils/PreferencesUtil';
import { common, ConfigurationConstant } from '@kit.AbilityKit';

const KEY_THEME_MODE = 'theme_mode';
const URL_WIDGETS = 'pages/WidgetsPage'; // Placeholder if needed

class SettingOptions {
  isToggle?: boolean = false;
  isOn?: boolean = false;
  valueText?: string = '';
  isDestructive?: boolean = false;
  onClick?: () => void = () => {};
  onToggleChange?: (isOn: boolean) => void = () => {};
}

@Component
export struct SettingsPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State themeName: string = '默认 (Cream)';

  async aboutToAppear() {
    await PreferencesUtil.getInstance().init(this.getUIContext().getHostContext() as common.UIAbilityContext);
    
    const themeMode = await PreferencesUtil.getInstance().getValue(KEY_THEME_MODE, 0) as number;
    this.updateThemeName(themeMode);
  }

  private updateThemeName(mode: number) {
    switch (mode) {
      case 0: this.themeName = '默认 (Cream)'; break;
      case 1: this.themeName = '樱花 (Sakura)'; break;
      case 2: this.themeName = '午夜 (Midnight)'; break;
    }
  }

  private exportData(): void {
    try {
      const data = MoodService.getInstance().exportData();
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const filesDir = context.filesDir;
      const path = filesDir + '/mood_diary_export.json';
      
      const file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
      fileIo.writeSync(file.fd, data);
      fileIo.closeSync(file);
      
      this.getUIContext().getPromptAction().showToast({
        message: `数据已导出至: ${path}`,
        duration: 3000
      });
    } catch (error) {
      const err = error as BusinessError;
      this.getUIContext().getPromptAction().showToast({
        message: `导出失败: ${err.message}`
      });
    }
  }

  private showThemeDialog(): void {
    this.getUIContext().getPromptAction().showActionMenu({
      title: '选择主题',
      buttons: [
        { text: '默认 (Cream)', color: '#333333' },
        { text: '樱花 (Sakura)', color: '#FFB7B2' },
        { text: '午夜 (Midnight)', color: '#666666' }
      ]
    }).then(async data => {
      this.updateThemeName(data.index);
      await PreferencesUtil.getInstance().putValue(KEY_THEME_MODE, data.index);
      
      let colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
      if (data.index === 2) { // Midnight
        colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      }
      (this.getUIContext().getHostContext() as common.UIAbilityContext).getApplicationContext().setColorMode(colorMode);

      switch (data.index) {
        case 0: this.getUIContext().getPromptAction().showToast({ message: '已切换至 Cream 主题' }); break;
        case 1: this.getUIContext().getPromptAction().showToast({ message: '已切换至 Sakura 主题' }); break;
        case 2: this.getUIContext().getPromptAction().showToast({ message: '已切换至 Midnight 主题' }); break;
      }
    }).catch((err: Error) => {
      console.info('ActionMenu cancelled');
    })
  }

  build() {
    Column() {
      // Header
      Row() {
        Text('设置')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 12, bottom: 24 })

      Scroll() {
        Column() {
          // Profile Section
          Row() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('🐻')
                .fontSize(24)
            }
            .width(56)
            .height(56)
            .borderRadius(28)
            .backgroundColor(CommonConstants.COLOR_BG) // Use theme color or specific
            .margin({ right: 16 })

            Column() {
              Text('本地用户')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
              Text('数据仅存储在设备上')
                .fontSize(12)
                .fontColor(CommonConstants.COLOR_SECONDARY)
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .padding(20)
          .backgroundColor(CommonConstants.COLOR_CARD)
          .borderRadius(24)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .margin({ bottom: 24 })

          // General Settings
          Text('通用')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .width('100%')
            .margin({ bottom: 12, left: 8 })

          Column() {
            this.WidgetGalleryItem()
            Divider().color('#F9FAFB').margin({ left: 56 })
            
            this.SettingItem('主题', 'pink', '🎨', { 
              valueText: this.themeName, 
              onClick: (): void => this.showThemeDialog() 
            })
          }
          .backgroundColor(CommonConstants.COLOR_CARD)
          .borderRadius(24)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .margin({ bottom: 24 })

          // Data Settings
          Text('数据')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .width('100%')
            .margin({ bottom: 12, left: 8 })

          Column() {
            this.SettingItem('导出数据', 'green', '📤', { 
              onClick: (): void => this.exportData() 
            })
            Divider().color('#F9FAFB').margin({ left: 56 })
            this.SettingItem('清除所有数据', 'red', '🗑️', { 
              isDestructive: true 
            })
          }
          .backgroundColor(CommonConstants.COLOR_CARD)
          .borderRadius(24)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .margin({ bottom: 32 })

          Text('MoodDiary v1.0.0 (Offline Build)')
            .fontSize(10)
            .fontColor('#D1D5DB')
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .padding({ left: 24, right: 24, bottom: 100 })
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonConstants.COLOR_BG)
  }

  @Builder
  WidgetGalleryItem() {
    Row() {
      // Left side: Icon + Title + Badge
      Row() {
        // Icon
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('🧩').fontSize(16) // Layer icon placeholder
        }
        .width(32)
        .height(32)
        .borderRadius(16)
        .backgroundColor('#FFF7ED') // Orange-50 equivalent
        .margin({ right: 12 })

        Text('小组件画廊')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
          .margin({ right: 8 })
        
        Text('New')
          .fontSize(10)
          .fontColor('#6B7280') // Gray-500
          .backgroundColor('#F3F4F6') // Gray-100
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(10)
      }

      Blank()

      // Right side: Mini Widget Preview
      Row({ space: 4 }) {
        // Mini Widget 1 (Sun)
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('☀️').fontSize(10)
        }
        .width(24)
        .height(24)
        .borderRadius(6)
        .backgroundColor('rgba(255, 183, 178, 0.2)') // Happy/20
        .border({ width: 1, color: 'rgba(255, 183, 178, 0.3)' })

        // Mini Widget 2 (Cloud)
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('☁️').fontSize(10)
        }
        .width(24)
        .height(24)
        .borderRadius(6)
        .backgroundColor('rgba(181, 234, 215, 0.2)') // Sad/20
        .border({ width: 1, color: 'rgba(181, 234, 215, 0.3)' })
      }
      .opacity(0.8)
    }
    .width('100%')
    .padding(16)
    .height(64)
    .onClick(() => {
      // Navigate to Widgets Page
      this.pageStack.pushPath({ name: CommonConstants.URL_WIDGETS });
    })
  }

  @Builder
  SettingItem(title: string, colorTheme: string, icon: string, options: SettingOptions) {
    Row() {
      // Icon
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(icon).fontSize(16)
      }
      .width(32)
      .height(32)
      .borderRadius(16)
      .backgroundColor(this.getColor(colorTheme) + '1A') // 10% opacity
      .margin({ right: 12 })

      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(options.isDestructive ? '#EF4444' : CommonConstants.COLOR_PRIMARY)
      
      Blank()

      if (options.valueText) {
        Text(options.valueText)
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
          .margin({ right: 8 })
      }

      if (options.isToggle) {
        Toggle({ type: ToggleType.Switch, isOn: options.isOn })
          .selectedColor(this.getColor(colorTheme))
          .onChange((isOn: boolean): void => {
            if (options.onToggleChange) {
              options.onToggleChange(isOn);
            }
          })
      } else {
        Text('>') // Chevron placeholder
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
      }
    }
    .width('100%')
    .padding(16)
    .height(64)
    .onClick((): void => {
      if (options.onClick) options.onClick();
    })
  }

  private getColor(theme: string): string {
    switch (theme) {
      case 'blue': return '#3B82F6';
      case 'purple': return '#8B5CF6';
      case 'orange': return '#F97316';
      case 'green': return '#10B981';
      case 'red': return '#EF4444';
      default: return CommonConstants.COLOR_PRIMARY_HEX;
    }
  }
}
