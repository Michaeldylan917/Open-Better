import { CommonConstants } from '../common/constants/CommonConstants';
import { CalendarView } from '../components/CalendarView';
import { MoodCard } from '../components/MoodCard';
import { MoodService, TagStat } from '../services/MoodService';
import { MoodLog } from '../models/MoodLog';
import { MoodType, MOOD_COLORS, MOOD_ICONS, MOOD_LABELS } from '../models/MoodType';
import { DateUtils } from '../common/utils/DateUtils';
import { EditorParams } from './MoodEditorPage';
import { DailyTimelineDialog } from '../components/DailyTimelineDialog';

@Component
export struct HomePage {
  @Consume('pageStack') pageStack: NavPathStack;
  
  @State currentYear: number = new Date().getFullYear();
  @State currentMonth: number = new Date().getMonth();
  @State recentLogs: MoodLog[] = [];
  @State monthLogs: MoodLog[] = [];
  @State topTags: TagStat[] = [];
  
  // Dialog State
  @State selectedDateLogs: MoodLog[] = [];
  @State selectedTimestamp: number = new Date().getTime();
  
  timelineDialogController: CustomDialogController = new CustomDialogController({
    builder: DailyTimelineDialog({
      timestamp: this.selectedTimestamp,
      logs: this.selectedDateLogs,
      onAddClick: () => {
        const params: EditorParams = { timestamp: this.selectedTimestamp };
        this.pageStack.pushPath({ name: CommonConstants.URL_EDITOR, param: params as Object } as NavPathInfo);
      },
      onEditClick: (log: MoodLog) => {
        const params: EditorParams = { logId: log.id };
        this.pageStack.pushPath({ name: CommonConstants.URL_EDITOR, param: params as Object } as NavPathInfo);
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true,
    autoCancel: true
  });
  
  private moodService: MoodService = MoodService.getInstance();
  private dataChangeListener: () => void = () => this.refreshData();

  aboutToAppear() {
    this.refreshData();
    this.moodService.addChangeListener(this.dataChangeListener);
  }

  aboutToDisappear() {
    this.moodService.removeChangeListener(this.dataChangeListener);
  }

  onPageShow() {
    this.refreshData();
  }

  private refreshData(): void {
    this.recentLogs = this.moodService.getLogs().slice(0, 5); // Top 5
    this.monthLogs = this.moodService.getLogsByMonth(this.currentYear, this.currentMonth);
    this.topTags = this.moodService.getTopTags();
  }
  
  private handleDateClick(day: number): void {
    const targetDate = new Date(this.currentYear, this.currentMonth, day);
    
    // Check if future date
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const targetTime = targetDate.getTime();
    
    if (targetTime > today.getTime()) {
      this.getUIContext().showAlertDialog({
        message: '不能记录未来的心情哦 ~',
        autoCancel: true,
        alignment: DialogAlignment.Bottom,
        offset: { dx: 0, dy: -20 }
      });
      return;
    }

    // Fetch logs for the day
    this.selectedTimestamp = targetTime;
    this.selectedDateLogs = this.moodService.getLogsForDay(this.currentYear, this.currentMonth, day);
    
    // Open Timeline Dialog
    this.timelineDialogController.open();
  }
  
  private onAddClick(): void {
    this.pageStack.pushPath({ name: CommonConstants.URL_EDITOR } as NavPathInfo);
  }

  @Builder
  EmptyStateBuilder() {
    Column() {
      Text('🍃')
        .fontSize(80)
        .margin({ bottom: 16 })
      
      Text('开始记录你的第一份心情吧')
        .fontSize(16)
        .fontColor(CommonConstants.COLOR_SECONDARY)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height(200)
    .justifyContent(FlexAlign.Center)
    .margin({ top: 32 })
  }

  build() {
    Column() {
      // Header
      Row() {
        Row() {
          Text(`${this.currentYear}年 ${this.currentMonth + 1}月`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
            .margin({ right: 8 })
          
          // Date Picker Trigger
          Text('∨')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_SECONDARY)
        }
        .onClick(() => {
          this.getUIContext().showDatePickerDialog({
            start: new Date("2020-1-1"),
            end: new Date("2100-12-31"),
            selected: new Date(this.currentYear, this.currentMonth),
            showTime: false,
            useMilitaryTime: false,
            onDateAccept: (value: Date) => {
              this.currentYear = value.getFullYear();
              this.currentMonth = value.getMonth();
              this.refreshData();
            }
          })
        })
        
        Blank()
        
        Button({ type: ButtonType.Circle, stateEffect: true }) {
           Text('🔍')
             .fontSize(20)
             .fontColor(CommonConstants.COLOR_PRIMARY)
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.pageStack.pushPath({ name: CommonConstants.URL_SEARCH } as NavPathInfo);
        })
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 12, bottom: 12 })

      Scroll() {
        Column() {
          // Calendar
          CalendarView({
            currentYear: this.currentYear,
            currentMonth: this.currentMonth,
            logs: this.monthLogs,
            onDateClick: (day: number) => this.handleDateClick(day)
          })
          .margin({ bottom: 24 })
          
          // Prompt Card
          Row() {
            Column() {
              Text('今天过得怎么样?')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
                .margin({ bottom: 4 })
              Text('记录下当下的心情吧')
                .fontSize(12)
                .fontColor(CommonConstants.COLOR_SECONDARY)
            }
            .alignItems(HorizontalAlign.Start)
            
            Blank()
            
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Text('+')
                .fontSize(24)
                .fontColor(Color.White)
            }
            .width(48)
            .height(48)
            .backgroundColor(MOOD_COLORS[MoodType.HAPPY])
            .onClick(() => {
              this.onAddClick();
            })
          }
          .width('100%')
          .padding(24)
          .backgroundColor('rgba(255, 183, 178, 0.2)') // Happy color with opacity
          .borderRadius(24)
          .margin({ bottom: 24 })
          
          // Recent Memories
          Text('最近的回忆')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
            .width('100%')
            .margin({ bottom: 16, left: 4 })
            
          if (this.recentLogs.length > 0) {
            List({ space: 12 }) {
              ForEach(this.recentLogs, (log: MoodLog) => {
                ListItem() {
                  MoodCard({ log: log })
                    .onClick(() => {
                       const params: EditorParams = { logId: log.id };
                       this.pageStack.pushPath({ name: CommonConstants.URL_EDITOR, param: params as Object } as NavPathInfo);
                    })
                }
              })
            }
            .width('100%')
            .scrollBar(BarState.Off)
          } else {
            this.EmptyStateBuilder()
          }
          
          // Bottom Padding
          Blank().height(100)
        }
        .padding({ left: 24, right: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonConstants.COLOR_BG)
  }
}
