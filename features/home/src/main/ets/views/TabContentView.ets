import { TabContentViewModel } from '../viewModel/TabContentViewModel'
import { BreakpointModel, getBreakpointModelByAppStorage } from 'base/src/main/ets/constans/BreakpointModel'
import { DefaultAppTheme } from 'ui/src/main/ets/theme/WithDynamicThemeView'
import { LengthMetrics } from '@kit.ArkUI'
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window'
import { WindowArea } from 'base'
import { TabInfo, TabModel } from 'ui'

@Preview
@ComponentV2
export struct TabContentView {
  tabContentViewModel: TabContentViewModel = new TabContentViewModel()
  @Local curBreakpoint: BreakpointModel = getBreakpointModelByAppStorage()
  theme: CustomTheme = new DefaultAppTheme()
  windowArea: WindowArea = getWindowAreaByAppStorage()
  tabController: TabsController = new TabsController()
  curTabModel: TabModel<TabInfo> = this.tabContentViewModel.tabModels[0]
  swiperController: SwiperController = new SwiperController()

  aboutToAppear(): void {
    this.curTabModel.isSelected = true
  }

  onWillApplyTheme(theme: Theme): void {
    this.theme = theme
  }

  build() {
    Column() {
      this.TitleTabBuilder()
      this.contentPageBuilder()
    }
  }

  @Builder
  contentPageBuilder() {
    Swiper(this.swiperController) {
      LazyForEach(this.tabContentViewModel.tabDataSource, (item: TabModel<TabInfo>) => {
        Text(item.tabInfo.name)
          .width('100%')
          .height('100%')
          .fontColor(this.theme.colors?.fontPrimary)
          .backgroundColor(Color.Blue)
          .textAlign(TextAlign.Center)
      })
    }
    .width('100%')
    .height('100%')
    .loop(false)
    .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
      this.updateTab(this.tabContentViewModel.tabModels[targetIndex])
    })
  }

  private updateTab(targetTabModel: TabModel<TabInfo>) {
    let tempTabModel = this.curTabModel
    this.curTabModel = targetTabModel

    tempTabModel.isSelected = false
    this.curTabModel.isSelected = true
  }

  @Builder
  tabBuilder(tabModel: TabModel<TabInfo>, index: number) {
    Stack() {
      Text(tabModel.tabInfo.name)
        .fontColor(tabModel.isSelected ? this.theme.colors?.fontOnPrimary : this.theme.colors?.fontPrimary)
        .scale({ x: tabModel.isSelected ? 1.2 : 1, y: tabModel.isSelected ? 1.2 : 1 })
        .fontSize(14)
        .onClick(() => {
          this.updateTab(tabModel)
          this.swiperController.changeIndex(index)
        })
    }.height('100%')
    .aspectRatio(1)
  }

  @Builder
  TitleTabBuilder() {
    Stack() {
      RelativeContainer() {
        Image($r('[ui].media.logo_eyepetizer'))
          .width('20%')
          .objectFit(ImageFit.Contain)
          .margin({ start: LengthMetrics.vp(18) })
          .alignRules({
            top: { anchor: 'title_tab', align: VerticalAlign.Top },
            bottom: { anchor: 'title_tab', align: VerticalAlign.Bottom },
            start: { anchor: '__container__', align: HorizontalAlign.Start }
          })

        Row({ space: 8 }) {
          ForEach(this.tabContentViewModel.tabModels, (item: TabModel<TabInfo>, index: number) => {
            this.tabBuilder(item, index)
          })
        }
        .width('40%')
        .justifyContent(FlexAlign.End)
        .height('100%')
        .id('title_tab')
        .margin({ end: LengthMetrics.vp(20) })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          end: { anchor: '__container__', align: HorizontalAlign.End }
        })
      }
      .width('100%')
      .height('4.5%')
    }.padding({ top: px2vp(this.windowArea.statusBarHeight) })
    .backgroundColor(this.theme.colors?.backgroundPrimary)
  }
}