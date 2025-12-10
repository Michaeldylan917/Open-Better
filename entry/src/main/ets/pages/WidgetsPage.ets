import { CommonConstants } from '../common/constants/CommonConstants';
import { promptAction } from '@kit.ArkUI';
import { MoodService } from '../services/MoodService';
import { MoodLog } from '../models/MoodLog';
import { DateUtils } from '../common/utils/DateUtils';
import { MOOD_ICONS, MOOD_LABELS } from '../models/MoodType';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct WidgetsPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State latestLog: MoodLog | undefined = undefined;
  
  private moodService: MoodService = MoodService.getInstance();

  aboutToAppear() {
    const logs = this.moodService.getLogs();
    if (logs.length > 0) {
      this.latestLog = logs[0];
    }
  }

  private async addToDesktop() {
    // Note: formProvider.requestPublishForm might not be available in all SDK versions or device types.
    // Fallback to guiding the user.
    this.getUIContext().getPromptAction().showToast({
      message: '请返回桌面，长按空白处添加"拾光日签"小组件',
      duration: 3000
    });
  }

  build() {
    NavDestination() {
      Column() {
        // Header
        Row() {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r('app.media.ic_settings_normal')) // Use back arrow if available, or rotation
              .width(24)
              .height(24)
              .fillColor(CommonConstants.COLOR_PRIMARY)
              .rotate({ angle: 180 }) // Rotate settings icon or use proper back icon
          }
          .width(40)
          .height(40)
          .backgroundColor(Color.White)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .onClick(() => {
            this.pageStack.pop();
          })

          Column() {
            Text('小组件画廊')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(CommonConstants.COLOR_PRIMARY)
            Text('长按预览或添加到桌面')
              .fontSize(12)
              .fontColor(CommonConstants.COLOR_SECONDARY)
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)

          // Spacer for balance
          Blank().width(40)
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 12, bottom: 24 })

        Scroll() {
          Column({ space: 24 }) {
            // 2x2 Widget (Small)
            this.SmallWidgetCard()

            // 2x4 Widget (Medium) - Style 1
            this.MediumWidgetCardStyle1()

            // 2x4 Widget (Medium) - Style 2 (Dark)
            this.MediumWidgetCardStyle2()

            // Add Button
            Button() {
              Row() {
                Text('+')
                  .fontSize(16)
                  .fontColor(Color.White)
                  .margin({ right: 8 })
                Text('添加到主屏幕')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.White)
              }
              .padding({ left: 32, right: 32, top: 12, bottom: 12 })
            }
            .backgroundColor(CommonConstants.COLOR_PRIMARY)
            .type(ButtonType.Capsule)
            .shadow({ radius: 8, color: 'rgba(0,0,0,0.2)', offsetY: 4 })
            .onClick(() => {
              this.addToDesktop();
            })
            .margin({ top: 16, bottom: 48 })
          }
          .width('100%')
          .padding({ left: 24, right: 24 })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(CommonConstants.COLOR_BG)
    }
    .hideTitleBar(true)
  }

  @Builder
  SmallWidgetCard() {
    Column() {
      // Background Gradient
      // ArkTS doesn't support complex CSS gradients easily on containers yet, simulating with color or image
      // Using a light yellow/orange mix
      
      Column() {
        Row() {
          Text(this.latestLog ? MOOD_ICONS[this.latestLog.mood] : '☀️')
            .fontSize(16)
          Text(this.latestLog ? DateUtils.format(this.latestLog.timestamp, 'MM/dd') : '12/08')
            .fontSize(10)
            .fontColor(CommonConstants.COLOR_SECONDARY)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text(this.latestLog && this.latestLog.note ? `"${this.latestLog.note}"` : '"我相信今天\n会有好事发生。"')
          .fontSize(14)
          .fontColor(CommonConstants.COLOR_PRIMARY)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 24 })
          .lineHeight(20)
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Blank()
        
        Row() {
          Blank()
          Text('★')
            .fontSize(10)
            .fontColor(CommonConstants.COLOR_SECONDARY)
        }
        .width('100%')
      }
      .width(160)
      .height(160)
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(24)
      .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 4 })
      .linearGradient({
        direction: GradientDirection.RightBottom,
        colors: [['rgba(255, 209, 102, 0.2)', 0.0], ['rgba(226, 240, 203, 0.2)', 1.0]]
      })
    }
    .alignSelf(ItemAlign.Center)
  }

  @Builder
  MediumWidgetCardStyle1() {
    Row() {
      // Left: Info
      Column() {
        Column() {
          Text(this.latestLog ? DateUtils.format(this.latestLog.timestamp, 'dd') : '08')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
          Text(this.latestLog ? DateUtils.format(this.latestLog.timestamp, 'MM月') : 'DECEMBER')
            .fontSize(10)
            .fontColor(CommonConstants.COLOR_SECONDARY)
        }
        
        Column() {
          Text(this.latestLog ? MOOD_ICONS[this.latestLog.mood] : '⛅')
            .fontSize(20)
            // .fontColor('#B5EAD7') // Sad color - icons are text, color might not apply if it's emoji
          Text(this.latestLog ? MOOD_LABELS[this.latestLog.mood] : '22°C')
            .fontSize(10)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .margin({ top: 4 })
        }
      }
      .width('33%')
      .height('100%')
      .backgroundColor('#FAFAFA')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
      .border({ width: { right: 1 }, color: '#F3F4F6' })

      // Right: Quote
      Stack() {
        Text(this.latestLog && this.latestLog.note ? `"${this.latestLog.note}"` : '"我拥抱\n每一个当下的自己。"')
          .fontSize(16)
          .fontColor(CommonConstants.COLOR_PRIMARY)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .lineHeight(24)
          .maxLines(4)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding(8)
      }
      .width('67%')
      .height('100%')
      .backgroundColor(Color.White)
      .alignContent(Alignment.Center)
    }
    .width('100%')
    .height(160)
    .borderRadius(24)
    .clip(true)
    .backgroundColor(Color.White)
    .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 4 })
  }

  @Builder
  MediumWidgetCardStyle2() {
    Stack() {
      Column() {
        Row() {
          Blank()
          Row() {
            Text('🌙')
              .fontSize(12)
              .fontColor('rgba(255,255,255,0.6)')
              .margin({ right: 4 })
            Text('晚安')
              .fontSize(12)
              .fontColor('rgba(255,255,255,0.6)')
          }
        }
        .width('100%')
        .margin({ bottom: 8 })

        Text('亲爱的,')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })
          .fontFamily('HarmonyOS Sans SC') // Serif placeholder

        Text('"愿你今晚做一个甜美的梦，放下所有的疲惫与担忧。"')
          .fontSize(14)
          .fontColor('rgba(255,255,255,0.9)')
          .lineHeight(22)
      }
      .padding(24)
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(160)
    .borderRadius(24)
    .backgroundColor('#333333')
    .shadow({ radius: 10, color: 'rgba(0,0,0,0.1)', offsetY: 4 })
  }
}
