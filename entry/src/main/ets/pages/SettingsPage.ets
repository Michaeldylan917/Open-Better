import { CommonConstants } from '../common/constants/CommonConstants';
import { MoodService } from '../services/MoodService';
import { promptAction } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct SettingsPage {
  private exportData(): void {
    try {
      const data = MoodService.getInstance().exportData();
      const context = getContext(this);
      const filesDir = context.filesDir;
      const path = filesDir + '/mood_diary_export.json';
      
      const file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
      fileIo.writeSync(file.fd, data);
      fileIo.closeSync(file);
      
      promptAction.showToast({
        message: `数据已导出至: ${path}`,
        duration: 3000
      });
    } catch (error) {
      const err = error as BusinessError;
      promptAction.showToast({
        message: `导出失败: ${err.message}`
      });
    }
  }

  private showThemeDialog(): void {
    promptAction.showActionMenu({
      title: '选择主题',
      buttons: [
        { text: '默认 (Cream)', color: '#333333' },
        { text: '樱花 (Sakura)', color: '#FFB7B2' },
        { text: '午夜 (Midnight)', color: '#666666' }
      ]
    }).then(data => {
      switch (data.index) {
        case 0: promptAction.showToast({ message: '已切换至 Cream 主题' }); break;
        case 1: promptAction.showToast({ message: '已切换至 Sakura 主题' }); break;
        case 2: promptAction.showToast({ message: '已切换至 Midnight 主题' }); break;
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

            Button('编辑')
              .fontSize(12)
              .fontColor(CommonConstants.COLOR_PRIMARY)
              .backgroundColor(Color.Transparent)
              .border({ width: 1, color: '#E5E7EB', radius: 16 })
              .height(32)
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
            this.SettingItem('应用锁', 'blue', true)
            Divider().color('#F9FAFB').margin({ left: 56 })
            this.SettingItem('提醒', 'purple', false, '21:00')
            Divider().color('#F9FAFB').margin({ left: 56 })
            this.SettingItem('主题', 'orange', false, '默认 (Cream)', false, () => this.showThemeDialog())
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
            this.SettingItem('导出数据', 'green', false, '', false, () => this.exportData())
            Divider().color('#F9FAFB').margin({ left: 56 })
            this.SettingItem('清除所有数据', 'red', false, '', true)
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
  SettingItem(title: string, colorTheme: string, isToggle: boolean, valueText: string = '', isDestructive: boolean = false, onClick?: () => void) {
    Row() {
      // Icon
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        // Placeholder for icon
        Circle({ width: 12, height: 12 })
          .fill(this.getColor(colorTheme))
      }
      .width(32)
      .height(32)
      .borderRadius(16)
      .backgroundColor(this.getColor(colorTheme) + '1A') // 10% opacity
      .margin({ right: 12 })

      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(isDestructive ? '#EF4444' : CommonConstants.COLOR_PRIMARY)
      
      Blank()

      if (isToggle) {
        Toggle({ type: ToggleType.Switch, isOn: false })
          .selectedColor(this.getColor(colorTheme))
      } else if (valueText) {
        Text(valueText)
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
          .margin({ right: 8 })
        
        Text('>') // Chevron placeholder
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
      } else {
        Text('>') // Chevron placeholder
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
      }
    }
    .width('100%')
    .padding(16)
    .height(64)
    .onClick(() => {
      if (onClick) onClick();
    })
  }

  private getColor(theme: string): string {
    switch (theme) {
      case 'blue': return '#3B82F6';
      case 'purple': return '#8B5CF6';
      case 'orange': return '#F97316';
      case 'green': return '#10B981';
      case 'red': return '#EF4444';
      default: return CommonConstants.COLOR_PRIMARY;
    }
  }
}
