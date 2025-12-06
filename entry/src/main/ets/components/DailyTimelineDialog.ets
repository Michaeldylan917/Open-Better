import { MoodLog } from '../models/MoodLog';
import { MOOD_COLORS, MOOD_ICONS, MOOD_LABELS } from '../models/MoodType';
import { DateUtils } from '../common/utils/DateUtils';
import { CommonConstants } from '../common/constants/CommonConstants';

@CustomDialog
export struct DailyTimelineDialog {
  controller: CustomDialogController;
  @Prop timestamp: number = new Date().getTime();
  @Link logs: MoodLog[];
  onAddClick?: () => void;
  onEditClick?: (log: MoodLog) => void;

  build() {
    Column() {
      // Header
      Row() {
        Text(DateUtils.format(this.timestamp, 'MM月dd日'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        
        Blank()
        
        Button('关闭')
          .fontSize(14)
          .fontColor(CommonConstants.COLOR_SECONDARY)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.controller.close();
          })
      }
      .width('100%')
      .padding({ bottom: 16 })

      // Timeline List
      if (this.logs.length > 0) {
        List({ space: 16 }) {
          ForEach(this.logs, (log: MoodLog) => {
            ListItem() {
              this.TimelineItem(log)
            }
          })
        }
        .width('100%')
        .height(300) // Max height
      } else {
        Column() {
          Text('今天还没有记录哦')
            .fontSize(14)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .margin({ top: 32, bottom: 32 })
        }
        .width('100%')
      }

      // Add Button
      Button('+ 添加记录')
        .width('100%')
        .margin({ top: 16 })
        .backgroundColor(CommonConstants.COLOR_PRIMARY)
        .onClick(() => {
          this.controller.close();
          if (this.onAddClick) this.onAddClick();
        })
    }
    .padding(24)
    .backgroundColor(Color.White)
    .borderRadius(24)
    .width('90%')
  }

  @Builder
  TimelineItem(log: MoodLog) {
    Row() {
      // Time
      Column() {
        Text(DateUtils.format(log.timestamp, 'HH:mm'))
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
      }
      .width(40)
      .margin({ right: 12 })

      // Content
      Row() {
        Text(MOOD_ICONS[log.mood])
          .fontSize(24)
          .margin({ right: 12 })
        
        Column() {
          Text(MOOD_LABELS[log.mood])
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(MOOD_COLORS[log.mood])
            .margin({ bottom: 4 })
          
          if (log.note) {
            Text(log.note)
              .fontSize(14)
              .fontColor(CommonConstants.COLOR_PRIMARY)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }

          if (log.tags && log.tags.length > 0) {
            Row() {
              ForEach(log.tags, (tag: string) => {
                Text('#' + tag)
                  .fontSize(10)
                  .fontColor(CommonConstants.COLOR_SECONDARY)
                  .margin({ right: 6, top: 4 })
              })
            }
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .padding(12)
      .backgroundColor(CommonConstants.COLOR_BG)
      .borderRadius(12)
      .onClick(() => {
        this.controller.close();
        if (this.onEditClick) this.onEditClick(log);
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
  }
}
