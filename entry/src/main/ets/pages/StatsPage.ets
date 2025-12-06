import { CommonConstants } from '../common/constants/CommonConstants';
import { MoodService } from '../services/MoodService';
import { MoodType, MOOD_COLORS, MOOD_LABELS, MOOD_ICONS } from '../models/MoodType';
import { MoodLog } from '../models/MoodLog';
import { DateUtils } from '../common/utils/DateUtils';
import { MoodCard } from '../components/MoodCard';

interface WeeklyStat {
  day: string;
  score: number;
  color: string;
}

@Component
export struct StatsPage {
  @State logs: MoodLog[] = [];
  @State bestDay: MoodLog | undefined = undefined;
  @State worstDay: MoodLog | undefined = undefined;
  @State currentYear: number = new Date().getFullYear();
  @State currentMonth: number = new Date().getMonth();
  @State weeklyStats: WeeklyStat[] = [];
  @State angrySource: string | null = null;
  @State sadSource: string | null = null;
  @State streak: number = 0;
  @State showDetailSheet: boolean = false;
  @State selectedLog: MoodLog | undefined = undefined;
  
  private moodService: MoodService = MoodService.getInstance();
  private dataChangeListener = () => {
    this.refreshData();
  }

  aboutToAppear() {
    this.refreshData();
    this.moodService.addChangeListener(this.dataChangeListener);
  }

  aboutToDisappear() {
    this.moodService.removeChangeListener(this.dataChangeListener);
  }

  private refreshData() {
    this.logs = this.moodService.getLogsByMonth(this.currentYear, this.currentMonth);
    this.streak = this.moodService.calculateCurrentStreak();
    this.calculateStats();
    this.calculateWeeklyStats();
    this.analyzeTags();
  }

  private calculateStats() {
    if (this.logs.length > 0) {
      // Use the refined Best Day logic from Service
      this.bestDay = this.moodService.getBestDay(this.currentYear, this.currentMonth) || undefined;
      // Simple Worst Day logic (First Angry or Sad) - can be improved later
      this.worstDay = this.logs.find(l => l.mood === MoodType.ANGRY) || this.logs.find(l => l.mood === MoodType.SAD);
    } else {
      this.bestDay = undefined;
      this.worstDay = undefined;
    }
  }

  private analyzeTags() {
    this.angrySource = this.moodService.getTopTagForMood(MoodType.ANGRY);
    this.sadSource = this.moodService.getTopTagForMood(MoodType.SAD);
  }

  private calculateWeeklyStats() {
    // Get current week dates (Sun-Sat)
    const today = new Date();
    const dayOfWeek = today.getDay(); // 0-6
    const sunday = new Date(today);
    sunday.setDate(today.getDate() - dayOfWeek);
    
    const weekData: WeeklyStat[] = [];
    const weekDays = ['日', '一', '二', '三', '四', '五', '六'];
    
    for (let i = 0; i < 7; i++) {
      const d = new Date(sunday);
      d.setDate(sunday.getDate() + i);
      
      // Find logs for this day
      const dayLogs = this.logs.filter(l => {
        const ld = new Date(l.timestamp);
        return ld.getDate() === d.getDate() && ld.getMonth() === d.getMonth();
      });

      let score = 0;
      let color = '#F3F4F6';

      if (dayLogs.length > 0) {
        // Average score
        const totalScore = dayLogs.reduce((acc, log) => {
          switch (log.mood) {
            case MoodType.ECSTATIC: return acc + 100;
            case MoodType.HAPPY: return acc + 80;
            case MoodType.NEUTRAL: return acc + 60;
            case MoodType.SAD: return acc + 40;
            case MoodType.ANGRY: return acc + 20;
            default: return acc;
          }
        }, 0);
        score = totalScore / dayLogs.length;
        
        // Determine color based on avg mood
        if (score >= 90) color = MOOD_COLORS[MoodType.ECSTATIC];
        else if (score >= 70) color = MOOD_COLORS[MoodType.HAPPY];
        else if (score >= 50) color = MOOD_COLORS[MoodType.NEUTRAL];
        else if (score >= 30) color = MOOD_COLORS[MoodType.SAD];
        else color = MOOD_COLORS[MoodType.ANGRY];
      }

      weekData.push({
        day: weekDays[i],
        score: score,
        color: color
      });
    }
    
    this.weeklyStats = weekData;
  }

  private getMoodPercentage(mood: MoodType): number {
    if (this.logs.length === 0) return 0;
    const count = this.logs.filter(l => l.mood === mood).length;
    return Math.round((count / this.logs.length) * 100);
  }

  @Builder
  BarItem(day: string, height: number, color: string) {
    Column() {
      Column()
        .width(12)
        .height(height)
        .backgroundColor(color)
        .borderRadius({ topLeft: 6, topRight: 6 })
        .opacity(0.8)
      
      Text(day)
        .fontSize(10)
        .fontColor(CommonConstants.COLOR_SECONDARY)
        .margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Column() {
      // Header
      Row() {
        Column() {
          Text('数据回顾')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
          Text(`${this.currentYear}年 ${this.currentMonth + 1}月`)
            .fontSize(14)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        
        Blank()
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 12, bottom: 16 })

      Scroll() {
        Column() {
          // Streak Card
          Row() {
             Row() {
                Text(this.streak >= 7 ? '🔥' : '✨')
                  .fontSize(24)
                  .margin({ right: 12 })
                
                Column() {
                  Text('连续记录')
                    .fontSize(12)
                    .fontColor(CommonConstants.COLOR_SECONDARY)
                  Text(`${this.streak} 天`)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(CommonConstants.COLOR_PRIMARY)
                }
                .alignItems(HorizontalAlign.Start)
             }
             
             if (this.streak >= 7) {
               Text('本周全勤')
                 .fontSize(12)
                 .fontColor('#F59E0B')
                 .backgroundColor('#FFFBEB')
                 .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                 .borderRadius(12)
             }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(CommonConstants.COLOR_CARD)
          .borderRadius(24)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .margin({ bottom: 24 })
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

          // Weekly Trend
          Column() {
            Row() {
              Text('本周心情趋势')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
              Blank()
            }
            .width('100%')
            .margin({ bottom: 16 })

            Row() {
              ForEach(this.weeklyStats, (item: WeeklyStat) => {
                this.BarItem(item.day, Math.max(item.score, 10), item.color)
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Bottom)
            .height(120)
          }
          .padding(20)
          .backgroundColor(CommonConstants.COLOR_CARD)
          .borderRadius(24)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .margin({ bottom: 24 })

          // Monthly Distribution (Donut)
          Row() {
            // Donut Chart Placeholder (Canvas or Stack)
            Stack({ alignContent: Alignment.Center }) {
              // Simplified Donut Visual using Data
              Circle({ width: 120, height: 120 })
                .fill(Color.Transparent)
                .strokeWidth(20)
                .stroke(CommonConstants.COLOR_SECONDARY)
                .opacity(0.1)
              
              // Overlay arcs could be done with Canvas, but for now keeping it simple
              // Just showing primary mood color if exists
              if (this.logs.length > 0) {
                 Circle({ width: 120, height: 120 })
                .fill(Color.Transparent)
                .strokeWidth(20)
                .stroke(MOOD_COLORS[MoodType.HAPPY]) // Just a dominant color for now
                .strokeDashArray([this.getMoodPercentage(MoodType.HAPPY) * 3.77, 1000]) 
                .rotate({ angle: -90 })
              }

              Column() {
                Text(this.logs.length.toString())
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(CommonConstants.COLOR_PRIMARY)
                Text('Records')
                  .fontSize(10)
                  .fontColor(CommonConstants.COLOR_SECONDARY)
              }
            }
            .margin({ right: 24 })

            // Legend
            Column() {
              Text('当月占比')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
                .margin({ bottom: 12 })
              
              Column({ space: 8 }) {
                this.LegendItem(MoodType.HAPPY)
                this.LegendItem(MoodType.NEUTRAL)
                this.LegendItem(MoodType.SAD)
                this.LegendItem(MoodType.ANGRY)
              }
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .padding(20)
          .backgroundColor(CommonConstants.COLOR_CARD)
          .borderRadius(24)
          .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
          .margin({ bottom: 24 })
          .width('100%')

          // Best vs Worst
          Grid() {
            GridItem() {
               this.StatCard('BEST DAY', this.bestDay)
            }
            .onClick(() => {
              if (this.bestDay) {
                this.selectedLog = this.bestDay;
                this.showDetailSheet = true;
              }
            })

            GridItem() {
               this.StatCard('WORST DAY', this.worstDay)
            }
            .onClick(() => {
              if (this.worstDay) {
                this.selectedLog = this.worstDay;
                this.showDetailSheet = true;
              }
            })
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(16)
          .width('100%')
          .height(160)
          .margin({ bottom: 24 })

          // Insight / Sources
          if (this.angrySource || this.sadSource) {
            Column() {
              Text('情绪洞察')
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonConstants.COLOR_PRIMARY)
                .margin({ bottom: 12 })
              
              if (this.angrySource) {
                Text(`😡 本月大部分愤怒来自 #${this.angrySource}`)
                  .fontSize(14)
                  .fontColor(CommonConstants.COLOR_PRIMARY)
                  .margin({ bottom: 8 })
              }
              
              if (this.sadSource) {
                Text(`😔 本月大部分难过来自 #${this.sadSource}`)
                  .fontSize(14)
                  .fontColor(CommonConstants.COLOR_PRIMARY)
              }
            }
            .width('100%')
            .padding(20)
            .backgroundColor(CommonConstants.COLOR_CARD)
            .borderRadius(24)
            .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 24 })
          }

          Blank().height(80)
        }
        .padding({ left: 24, right: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonConstants.COLOR_BG)
    .bindSheet($$this.showDetailSheet, this.DetailSheetBuilder(), {
      height: '50%',
      dragBar: true,
      backgroundColor: CommonConstants.COLOR_BG
    })
  }

  @Builder
  DetailSheetBuilder() {
    Column() {
      if (this.selectedLog) {
        Text('记录详情')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
          .margin({ bottom: 16 })
          .width('100%')
          .textAlign(TextAlign.Center)
        
        MoodCard({ log: this.selectedLog })
      }
    }
    .width('100%')
    .padding(24)
  }

  @Builder
  LegendItem(mood: MoodType) {
    Row() {
      Row() {
        Circle({ width: 8, height: 8 }).fill(MOOD_COLORS[mood])
        Text(MOOD_LABELS[mood])
          .fontSize(12)
          .fontColor(CommonConstants.COLOR_SECONDARY)
          .margin({ left: 8 })
      }
      Blank()
      Text(this.getMoodPercentage(mood) + '%')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonConstants.COLOR_PRIMARY)
    }
    .width('100%')
  }

  @Builder
  StatCard(title: string, log: MoodLog | undefined) {
    Column() {
      Text(title)
        .fontSize(10)
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(51, 51, 51, 0.5)')
        .margin({ bottom: 8 })
      
      if (log) {
        Text(MOOD_ICONS[log.mood])
          .fontSize(40)
          .margin({ bottom: 8 })
        
        Text(DateUtils.format(log.timestamp, 'MM月dd日'))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
        
        if (log.note) {
          Text(log.note)
            .fontSize(10)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }
      } else {
        Text('-')
          .fontSize(40)
          .fontColor(CommonConstants.COLOR_SECONDARY)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(log ? MOOD_COLORS[log.mood] + '33' : '#F3F4F6') // 33 for ~20% opacity
    .borderRadius(24)
    .justifyContent(FlexAlign.Center)
  }
}
