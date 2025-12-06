import { CommonConstants } from '../common/constants/CommonConstants';
import { MoodService, TagStat } from '../services/MoodService';
import { MoodLog } from '../models/MoodLog';
import { MoodCard } from '../components/MoodCard';

@Component
export struct SearchPage {
  @Consume('pageStack') pageStack: NavPathStack;
  @State selectedTag: string = '';
  @State allTags: TagStat[] = [];
  @State filteredLogs: MoodLog[] = [];
  
  private moodService: MoodService = MoodService.getInstance();

  aboutToAppear() {
    this.allTags = this.moodService.getTopTags(50); // Get up to 50 tags
  }

  private onTagClick(tag: string) {
    if (this.selectedTag === tag) {
      this.selectedTag = '';
      this.filteredLogs = [];
    } else {
      this.selectedTag = tag;
      this.filteredLogs = this.moodService.getLogsByTag(tag);
    }
  }

  build() {
    NavDestination() {
      Column() {
        // Header
        Row() {
          Text('<')
            .fontSize(24)
            .padding(12)
            .onClick(() => {
              this.pageStack.pop();
            })
          
          Text('搜索与筛选')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonConstants.COLOR_PRIMARY)
            .margin({ left: 8 })
          
          Blank()
        }
        .width('100%')
        .padding({ left: 12, right: 24, top: 12, bottom: 12 })

        // Tags Filter Section
        Column() {
          Text('按标签筛选')
            .fontSize(14)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .width('100%')
            .margin({ bottom: 12 })

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.allTags, (tagStat: TagStat) => {
              Text(`# ${tagStat.tag}`)
                .fontSize(14)
                .fontColor(this.selectedTag === tagStat.tag ? Color.White : CommonConstants.COLOR_PRIMARY)
                .backgroundColor(this.selectedTag === tagStat.tag ? CommonConstants.COLOR_PRIMARY : Color.White)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .borderRadius(20)
                .margin({ right: 12, bottom: 12 })
                .border({ width: 1, color: this.selectedTag === tagStat.tag ? CommonConstants.COLOR_PRIMARY : '#E5E7EB' })
                .onClick(() => {
                  this.onTagClick(tagStat.tag);
                })
            }, (tagStat: TagStat) => tagStat.tag)
          }
          .width('100%')
        }
        .padding(24)

        // Results
        if (this.selectedTag) {
          Text(`找到 ${this.filteredLogs.length} 条 "${this.selectedTag}" 相关日记`)
            .fontSize(14)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .width('100%')
            .padding({ left: 24, right: 24, bottom: 12 })

          List({ space: 12 }) {
            ForEach(this.filteredLogs, (log: MoodLog) => {
              ListItem() {
                MoodCard({ log: log })
              }
            }, (log: MoodLog) => log.id)
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 24, right: 24, bottom: 24 })
        } else {
          // Empty State / Placeholder
          Column() {
            Text('🔍')
              .fontSize(48)
              .margin({ bottom: 16 })
              .opacity(0.5)
            Text('选择一个标签开始筛选')
              .fontSize(14)
              .fontColor(CommonConstants.COLOR_SECONDARY)
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .opacity(0.6)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(CommonConstants.COLOR_BG)
    }
    .hideTitleBar(true)
  }
}
