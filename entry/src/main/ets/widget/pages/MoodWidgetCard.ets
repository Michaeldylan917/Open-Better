let storage = new LocalStorage();

@Entry(storage)
@Component
struct MoodWidgetCard {
  @LocalStorageProp('moodIcon') moodIcon: string = '☀️';
  @LocalStorageProp('moodLabel') moodLabel: string = '记录心情';
  @LocalStorageProp('date') date: string = '01/01';
  @LocalStorageProp('note') note: string = '点击记录第一条心情';

  build() {
    Column() {
      Row() {
        Text(this.moodIcon)
          .fontSize(20)
        Text(this.date)
          .fontSize(12)
          .fontColor('#666666')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 12 })

      Text(this.note)
        .fontSize(14)
        .fontColor('#333333')
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        
      Blank()
      
      Text(this.moodLabel)
        .fontSize(10)
        .fontColor('#999999')
        .alignSelf(ItemAlign.End)
    }
    .padding(12)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .onClick(() => {
        postCardAction(this, {
            "action": "router",
            "abilityName": "EntryAbility",
            "params": {
                "message": "addDetail"
            }
        });
    })
  }
}