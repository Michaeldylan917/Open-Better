import { MoodLog } from '../models/MoodLog';
import { MOOD_COLORS } from '../models/MoodType';
import { CommonConstants } from '../common/constants/CommonConstants';
import { DateUtils } from '../common/utils/DateUtils';
import { MoodService } from '../services/MoodService';

@Component
export struct CalendarView {
  @Prop currentYear: number;
  @Prop currentMonth: number; // 0-11
  
  // We watch this prop to trigger updates
  @Watch('updateSummaries') @Prop logs: MoodLog[];
  
  // Callback for date click
  onDateClick?: (day: number) => void;

  // Days of week
  private weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六'];
  
  // Internal state for display
  @State dailySummaries: Map<number, MoodLog> = new Map();

  aboutToAppear() {
    this.updateSummaries();
  }

  private updateSummaries() {
    // Create a new map to ensure UI update
    const newMap = new Map<number, MoodLog>();
    const service = MoodService.getInstance();
    const daysInMonth = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();

    for (let d = 1; d <= daysInMonth; d++) {
      const summary = service.getDailySummary(this.currentYear, this.currentMonth, d);
      if (summary) {
        newMap.set(d, summary);
      }
    }
    this.dailySummaries = newMap;
  }

  @Builder
  DayItem(day: number, isCurrentMonth: boolean) {
    Column() {
      if (isCurrentMonth) {
        Text(day.toString())
          .fontSize(14)
          .fontColor(DateUtils.isToday(new Date(this.currentYear, this.currentMonth, day).getTime()) ? Color.White : CommonConstants.COLOR_PRIMARY)
          .fontWeight(FontWeight.Medium)
          .width(28)
          .height(28)
          .textAlign(TextAlign.Center)
          .borderRadius(14)
          .backgroundColor(DateUtils.isToday(new Date(this.currentYear, this.currentMonth, day).getTime()) ? CommonConstants.COLOR_PRIMARY : Color.Transparent)
        
        if (this.dailySummaries.has(day)) {
          Circle({ width: 8, height: 8 })
            .fill(MOOD_COLORS[this.dailySummaries.get(day)!.mood])
            .margin({ top: 4 })
        } else {
           // Placeholder to keep alignment
           Circle({ width: 8, height: 8 })
            .fill(Color.Transparent)
            .margin({ top: 4 })
        }
      } else {
        Text(day.toString())
          .fontSize(14)
          .fontColor('#D1D1D6') // Light gray for other month days
          .width(28)
          .height(28)
          .textAlign(TextAlign.Center)
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (isCurrentMonth && this.onDateClick) {
        this.onDateClick(day);
      }
    })
  }

  build() {
    Column() {
      // Week Header
      Grid() {
        ForEach(this.weekDays, (day: string) => {
          GridItem() {
            Text(day)
              .fontSize(12)
              .fontColor(CommonConstants.COLOR_SECONDARY)
              .fontWeight(FontWeight.Bold)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr')
      .height(30)
      .width('100%')
      .margin({ bottom: 10 })

      // Days Grid
      Grid() {
        ForEach(this.getCalendarDays(), (item: CalendarDayModel) => {
           GridItem() {
             this.DayItem(item.day, item.isCurrentMonth)
           }
        }, (item: CalendarDayModel, index: number) => index.toString() + '_' + item.day + '_' + item.isCurrentMonth)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .width('100%')
      .height(300) // Fixed height or auto
    }
    .padding(20)
    .backgroundColor(CommonConstants.COLOR_CARD)
    .borderRadius(24)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  private getCalendarDays(): CalendarDayModel[] {
    const days: CalendarDayModel[] = [];
    const date = new Date(this.currentYear, this.currentMonth, 1);
    const firstDayOfWeek = date.getDay(); // 0 (Sun) - 6 (Sat)
    
    // Previous month days
    const prevMonthDate = new Date(this.currentYear, this.currentMonth, 0);
    const prevMonthDays = prevMonthDate.getDate();
    
    for (let i = firstDayOfWeek - 1; i >= 0; i--) {
      days.push({ day: prevMonthDays - i, isCurrentMonth: false });
    }
    
    // Current month days
    const currentMonthDays = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
    for (let i = 1; i <= currentMonthDays; i++) {
      days.push({ day: i, isCurrentMonth: true });
    }
    
    // Next month days to fill the grid (assuming 6 rows max = 42)
    const remaining = 42 - days.length;
    for (let i = 1; i <= remaining; i++) {
      days.push({ day: i, isCurrentMonth: false });
    }
    
    return days;
  }
}

interface CalendarDayModel {
  day: number;
  isCurrentMonth: boolean;
}
