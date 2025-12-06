import { HomePage } from './HomePage';
import { StatsPage } from './StatsPage';
import { ToolsPage } from './ToolsPage';
import { SettingsPage } from './SettingsPage';
import { MoodEditorPage } from './MoodEditorPage';
import { SearchPage } from './SearchPage';
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
    } else if (name === 'pages/SearchPage') {
      SearchPage()
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

  build() {
    Navigation(this.pageStack) {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.TabBuilder('首页', 0, $r('app.media.ic_home_normal'), $r('app.media.ic_home_selected')))

        TabContent() {
          StatsPage()
        }
        .tabBar(this.TabBuilder('统计', 1, $r('app.media.ic_stats_normal'), $r('app.media.ic_stats_selected')))

        TabContent() {
          ToolsPage()
        }
        .tabBar(this.TabBuilder('急救', 2, $r('app.media.ic_home_normal'), $r('app.media.ic_home_selected')))

        TabContent() {
          SettingsPage()
        }
        .tabBar(this.TabBuilder('设置', 3, $r('app.media.ic_settings_normal'), $r('app.media.ic_settings_selected')))
      }
      .scrollable(false)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .barHeight(56)
      .backgroundColor(Color.White)
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
