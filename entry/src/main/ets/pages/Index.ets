import { HomePage } from './HomePage';
import { StatsPage } from './StatsPage';
import { ToolsPage } from './ToolsPage';
import { SettingsPage } from './SettingsPage';
import { MoodEditorPage } from './MoodEditorPage';
import { SearchPage } from './SearchPage';
import { WidgetsPage } from './WidgetsPage';
import { CommonConstants } from '../common/constants/CommonConstants';

@Entry
@Component
export struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();
  @State currentIndex: number = 0;

  @Builder
  PageMap(name: string) {
    if (name === CommonConstants.URL_EDITOR) {
      MoodEditorPage()
    } else if (name === CommonConstants.URL_SEARCH) {
      SearchPage()
    } else if (name === CommonConstants.URL_WIDGETS) {
      WidgetsPage()
    }
  }

  @Builder
  TabBuilder(title: string, index: number, iconNormal: Resource, iconSelected: Resource) {
    Column() {
      Image(this.currentIndex === index ? iconSelected : iconNormal)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
      Text(title)
        .fontSize(10)
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? CommonConstants.COLOR_PRIMARY : CommonConstants.COLOR_SECONDARY)
        .margin({ top: 4 })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }

  @Builder
  PlaceholderTabBuilder() {
    Column()
      .width('100%')
      .height('100%')
  }

  build() {
    Navigation(this.pageStack) {
      Stack({ alignContent: Alignment.Bottom }) {
        Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
          TabContent() {
            HomePage()
          }
          .tabBar(this.TabBuilder('首页', 0, $r('app.media.ic_home_normal'), $r('app.media.ic_home_selected')))

          TabContent() {
            StatsPage()
          }
          .tabBar(this.TabBuilder('统计', 1, $r('app.media.ic_stats_normal'), $r('app.media.ic_stats_selected')))

          // Placeholder Tab for "+" button
          TabContent() {
            Column() // Empty content
          }
          .tabBar(this.PlaceholderTabBuilder())
          .enabled(false) // Disable interaction

          TabContent() {
            ToolsPage()
          }
          .tabBar(this.TabBuilder('急救', 3, $r('app.media.ic_home_normal'), $r('app.media.ic_home_selected')))

          TabContent() {
            SettingsPage()
          }
          .tabBar(this.TabBuilder('设置', 4, $r('app.media.ic_settings_normal'), $r('app.media.ic_settings_selected')))
        }
        .scrollable(false)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
        .barHeight(56)
        .backgroundColor(Color.White)

        // Floating "+" Button
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Text('+')
            .fontSize(32)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Lighter)
            .margin({ bottom: 4 }) // Visual adjustment
        }
        .width(56)
        .height(56)
        .backgroundColor(CommonConstants.COLOR_PRIMARY)
        .shadow({ radius: 8, color: 'rgba(0,0,0,0.2)', offsetY: 4 })
        .margin({ bottom: 12 }) // Lift up from bottom
        .onClick(() => {
          this.pageStack.pushPath({ name: CommonConstants.URL_EDITOR } as NavPathInfo);
        })
      }
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .width('100%')
    .height('100%')
    .backgroundColor(CommonConstants.COLOR_BG)
  }
}
