import { CommonConstants } from '../common/constants/CommonConstants';
import { MoodType, MOOD_COLORS, MOOD_ICONS, MOOD_LABELS } from '../models/MoodType';
import { MoodService } from '../services/MoodService';
import { DateUtils } from '../common/utils/DateUtils';

export interface EditorParams {
  logId?: string;
  timestamp?: number;
}

@Component
export struct MoodEditorPage {
  @Consume('pageStack') pageStack: NavPathStack;
  
  // Received params
  params?: EditorParams;

  @State selectedMood: MoodType = MoodType.HAPPY;
  @State note: string = '';
  @State selectedTags: string[] = [];
  @State currentTimestamp: number = new Date().getTime();
  @State isEditMode: boolean = false;
  @State editingLogId: string = '';
  
  // Available moods
  private moods: MoodType[] = [
    MoodType.ECSTATIC,
    MoodType.HAPPY,
    MoodType.NEUTRAL,
    MoodType.SAD,
    MoodType.ANGRY
  ];

  private tags: string[] = ['#工作', '#学习', '#家庭', '#美食', '#运动'];

  private moodService: MoodService = MoodService.getInstance();

  aboutToAppear() {
    if (this.params) {
      if (this.params.logId) {
        // Edit Mode
        const log = this.moodService.getLogById(this.params.logId);
        if (log) {
          this.isEditMode = true;
          this.editingLogId = log.id;
          this.selectedMood = log.mood;
          this.note = log.note ?? '';
          this.selectedTags = [];
          if (log.tags) {
            log.tags.forEach(tag => this.selectedTags.push(tag));
          }
          this.currentTimestamp = log.timestamp;
        }
      } else if (this.params.timestamp) {
        // Add Mode for specific date
        this.currentTimestamp = this.params.timestamp;
      }
    }
  }

  build() {
    NavDestination() {
      Column() {
        // Nav Bar
        Row() {
          Button({ type: ButtonType.Circle }) {
            Text('×') // Close icon
              .fontSize(24)
              .fontColor(CommonConstants.COLOR_SECONDARY)
          }
          .width(40)
          .height(40)
          .backgroundColor(Color.White)
          .shadow({ radius: 2, color: 'rgba(0,0,0,0.05)' })
          .onClick(() => {
            this.pageStack.pop();
          })

          Text(this.isEditMode ? '编辑心情' : '记录心情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
          
          Blank().width(40) // Spacer
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 24, right: 24, top: 12, bottom: 16 })

        // Date Display
        Row() {
          Text(`${DateUtils.format(this.currentTimestamp, 'yyyy年 MM月 dd日')} · ${DateUtils.isToday(this.currentTimestamp) ? '今天' : '补录'}`)
            .fontSize(14)
            .fontColor(CommonConstants.COLOR_PRIMARY)
            .fontWeight(FontWeight.Bold)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .backgroundColor(Color.White)
            .borderRadius(20)
            .shadow({ radius: 2, color: 'rgba(0,0,0,0.05)' })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 32 })

        Scroll() {
          Column() {
            Text('现在感觉如何?')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(CommonConstants.COLOR_PRIMARY)
              .margin({ bottom: 24 })
              .width('100%')
              .textAlign(TextAlign.Center)

            // Mood Selector
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              ForEach(this.moods, (mood: MoodType) => {
                Column() {
                  Button({ type: ButtonType.Circle }) {
                    Text(MOOD_ICONS[mood])
                      .fontSize(30)
                  }
                  .width(56)
                  .height(56)
                  .backgroundColor(this.selectedMood === mood ? MOOD_COLORS[mood] : Color.Transparent)
                  .scale({ x: this.selectedMood === mood ? 1.1 : 1.0, y: this.selectedMood === mood ? 1.1 : 1.0 })
                  .animation({ duration: 300, curve: Curve.EaseOut })
                  .onClick(() => {
                    this.selectedMood = mood;
                  })
                  
                  Text(MOOD_LABELS[mood])
                    .fontSize(12)
                    .fontColor(CommonConstants.COLOR_SECONDARY)
                    .fontWeight(FontWeight.Medium)
                    .margin({ top: 8 })
                }
              })
            }
            .width('100%')
            .padding({ left: 8, right: 8 })
            .margin({ bottom: 40 })

            // Note Area
            Column() {
              Text('写点什么 (可选)')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
                .margin({ bottom: 12 })
                .width('100%')

              TextArea({ placeholder: '记录下此刻的想法...', text: this.note })
                .width('100%')
                .height(128)
                .backgroundColor('#F9FAFB') // Very light gray
                .borderRadius(12)
                .padding(16)
                .fontSize(14)
                .placeholderColor('#9CA3AF')
                .onChange((value: string) => {
                  this.note = value;
                })
                .maxLength(140)
              
              Text(`${this.note.length}/140`)
                .fontSize(12)
                .fontColor('#D1D5DB')
                .width('100%')
                .textAlign(TextAlign.End)
                .margin({ top: 8 })
            }
            .padding(20)
            .backgroundColor(Color.White)
            .borderRadius(24)
            .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)' })
            .margin({ bottom: 24 })

            // Tags
            Column() {
              Text('标签')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
                .margin({ bottom: 12 })
                .width('100%')

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.tags, (tag: string) => {
                  Text(tag)
                    .fontSize(12)
                    .fontColor(this.selectedTags.includes(tag) ? Color.White : CommonConstants.COLOR_SECONDARY)
                    .fontWeight(FontWeight.Medium)
                    .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                    .backgroundColor(this.selectedTags.includes(tag) ? MOOD_COLORS[MoodType.HAPPY] : Color.White)
                    .borderRadius(16)
                    .margin({ right: 8, bottom: 8 })
                    .onClick(() => {
                      if (this.selectedTags.includes(tag)) {
                        this.selectedTags = this.selectedTags.filter(t => t !== tag);
                      } else {
                        this.selectedTags.push(tag);
                      }
                    })
                    .shadow({ radius: 2, color: 'rgba(0,0,0,0.05)' })
                })
                
                // Add tag button placeholder
                Row() {
                  Text('+')
                    .fontSize(14)
                    .fontColor('#9CA3AF')
                }
                .width(32)
                .height(28)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('#F3F4F6')
                .borderRadius(16)
              }
            }
            .width('100%')
            .margin({ bottom: 100 })
          }
          .padding({ left: 24, right: 24 })
        }
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(CommonConstants.COLOR_BG)
      
      // Save Button
      Column() {
        Button(this.isEditMode ? '更新记录' : '保存记录')
          .width('100%')
          .height(56)
          .backgroundColor(CommonConstants.COLOR_PRIMARY)
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .borderRadius(16)
          .shadow({ radius: 8, color: 'rgba(0,0,0,0.2)', offsetY: 4 })
          .onClick(() => {
            this.saveLog();
          })
      }
      .position({ x: 0, y: '100%' })
      .markAnchor({ x: 0, y: '100%' })
      .padding({ left: 24, right: 24, bottom: 32 })
    }
    .hideTitleBar(true)
  }

  private saveLog() {
    if (this.isEditMode) {
      this.moodService.updateLog({
        id: this.editingLogId,
        timestamp: this.currentTimestamp,
        mood: this.selectedMood,
        note: this.note,
        tags: this.selectedTags
      });
    } else {
      this.moodService.addLog({
        id: new Date().getTime().toString(),
        timestamp: this.currentTimestamp,
        mood: this.selectedMood,
        note: this.note,
        tags: this.selectedTags
      });
    }
    this.pageStack.pop();
  }
}
