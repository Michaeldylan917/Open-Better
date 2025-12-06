import { MoodLog } from '../models/MoodLog';
import { MOOD_COLORS, MOOD_ICONS, MOOD_LABELS } from '../models/MoodType';
import { CommonConstants } from '../common/constants/CommonConstants';
import { DateUtils } from '../common/utils/DateUtils';

@Component
export struct MoodCard {
  @Prop log: MoodLog;

  build() {
    Row() {
      // Icon Circle
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(MOOD_ICONS[this.log.mood])
          .fontSize(20)
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor(MOOD_COLORS[this.log.mood])
      .opacity(0.8) // Simplified visual style
      .margin({ right: 16 })

      // Content
      Column() {
        Row() {
          Text(MOOD_LABELS[this.log.mood])
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
          
          Blank()
          
          Text(DateUtils.format(this.log.timestamp, 'MM月dd日'))
            .fontSize(12)
            .fontColor(CommonConstants.COLOR_SECONDARY)
        }
        .width('100%')
        .margin({ bottom: 4 })

        if (this.log.note) {
          Text(this.log.note)
            .fontSize(14)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(20)
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(CommonConstants.COLOR_CARD)
    .borderRadius(16)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }
}
