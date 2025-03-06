import { TabContentViewModel } from '../viewModel/TabContentViewModel'
import { BreakpointModel, getBreakpointModelByAppStorage } from 'base/src/main/ets/constans/BreakpointModel'
import { DefaultAppTheme } from 'ui/src/main/ets/theme/WithDynamicThemeView'
import { LengthMetrics } from '@kit.ArkUI'
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window'
import { WindowArea } from 'base'
import { TabInfo, TabModel } from 'ui'
import { BreakpointType } from 'base/src/main/ets/constans/BreakpointType'
import { MetroLargeVideoItemView, MetroLargeVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView'

@Preview
@ComponentV2
export struct TabContentView {
  tabContentViewModel: TabContentViewModel = new TabContentViewModel()
  @Local curBreakpoint: BreakpointModel = getBreakpointModelByAppStorage()
  theme: CustomTheme = new DefaultAppTheme()
  windowArea: WindowArea = getWindowAreaByAppStorage()
  curTabModel: TabModel<TabInfo> = this.tabContentViewModel.tabModels[0]
  swiperController: SwiperController = new SwiperController()

  aboutToAppear(): void {
    let initPage = 0
    this.updateTab(this.tabContentViewModel.tabModels[initPage])
    this.swiperController.changeIndex(initPage)
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
        WaterFlow() {
          LazyForEach(this.tabContentViewModel.dataSources, (item: MetroLargeVideoItemViewModel, index: number) => {
            FlowItem() {
              MetroLargeVideoItemView({ viewModel: item })
            }
            .width('100%')
          })
        }
        .columnsTemplate(new BreakpointType('1fr', '1fr 1fr', '1fr 1fr 1fr').getValue2(this.curBreakpoint))
        .width('100%')
        .height('100%')
        .rowsGap(12)
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
    Text(tabModel.tabInfo.name)
      .fontColor(tabModel.isSelected ? this.theme.colors?.fontOnPrimary : this.theme.colors?.fontPrimary)
      .scale({ x: tabModel.isSelected ? 1.2 : 1, y: tabModel.isSelected ? 1.2 : 1 })
      .fontSize(new BreakpointType(14, 16, 16).getValue2(this.curBreakpoint))
      .onClick(() => {
        this.updateTab(tabModel)
        this.swiperController.changeIndex(index)
      })
  }

  @Builder
  TitleTabBuilder() {
    RelativeContainer() {
      // logo
      Image($r('[ui].media.logo_eyepetizer'))
        .width(new BreakpointType('20%', '15%', '12%').getValue2(this.curBreakpoint))
        .objectFit(ImageFit.Contain)
        .aspectRatio(435 / 87)
        .height('auto')
        .id('image')
        .margin({
          start: new BreakpointType(LengthMetrics.vp(15), LengthMetrics.vp(18),
            LengthMetrics.vp(10)).getValue2(this.curBreakpoint)
        })
        .alignRules({
          top: { anchor: 'title_bar', align: VerticalAlign.Top },
          bottom: { anchor: 'title_bar', align: VerticalAlign.Bottom },
          start: { anchor: '__container__', align: HorizontalAlign.Start },
        })

      // title bar
      Row({ space: 10 }) {
        ForEach(this.tabContentViewModel.tabModels, (item: TabModel<TabInfo>, index: number) => {
          this.tabBuilder(item, index)
        })
      }
      .id('title_bar')
      .width('auto')
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .height('auto')
      .padding({
        start: new BreakpointType(LengthMetrics.vp(20), LengthMetrics.vp(25),
          LengthMetrics.vp(30)).getValue2(this.curBreakpoint),
        top: new BreakpointType(LengthMetrics.vp(8), LengthMetrics.vp(12),
          LengthMetrics.vp(15)).getValue2(this.curBreakpoint),
        bottom: new BreakpointType(LengthMetrics.vp(8), LengthMetrics.vp(12),
          LengthMetrics.vp(15)).getValue2(this.curBreakpoint),
        end: new BreakpointType(LengthMetrics.vp(20), LengthMetrics.vp(25),
          LengthMetrics.vp(30)).getValue2(this.curBreakpoint)
      })
      .alignRules({
        end: { anchor: '__container__', align: HorizontalAlign.End }
      })
    }
    .width('100%')
    .padding({ top: px2vp(this.windowArea.statusBarHeight) })
    .height('auto')
    .backgroundColor(this.theme.colors?.backgroundPrimary)
  }
}