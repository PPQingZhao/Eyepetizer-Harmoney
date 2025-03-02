import { TabContentViewModel } from '../viewModel/TabContentViewModel'
import { BreakpointModel, getBreakpointModelByAppStorage } from 'base/src/main/ets/constans/BreakpointModel'
import { DefaultAppTheme } from 'ui/src/main/ets/theme/WithDynamicThemeView'
import { LengthMetrics } from '@kit.ArkUI'
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window'
import { WindowArea } from 'base'
import { TabInfo, TabModel } from 'ui'
import { BreakpointType } from 'base/src/main/ets/constans/BreakpointType'

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
    this.updateTab(this.tabContentViewModel.tabModels[0])
    this.swiperController.changeIndex(0)
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
        .fontSize(new BreakpointType(14, 16, 16).getValue2(this.curBreakpoint))
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
          .width(new BreakpointType('20%', '15%', '12%').getValue2(this.curBreakpoint))
          .objectFit(ImageFit.Contain)
          .aspectRatio(435 / 87)
          .margin({
            start: new BreakpointType(LengthMetrics.vp(15), LengthMetrics.vp(18),
              LengthMetrics.vp(10)).getValue2(this.curBreakpoint)
          })
          .alignRules({
            start: { anchor: '__container__', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })

        Row({ space: 8 }) {
          ForEach(this.tabContentViewModel.tabModels, (item: TabModel<TabInfo>, index: number) => {
            this.tabBuilder(item, index)
          })
        }
        .width('40%')
        .justifyContent(FlexAlign.End)
        .height('100%')
        .margin({
          end: new BreakpointType(LengthMetrics.vp(20), LengthMetrics.vp(25),
            LengthMetrics.vp(30)).getValue2(this.curBreakpoint)
        })
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          end: { anchor: '__container__', align: HorizontalAlign.End }
        })
      }
      .width('100%')
      .height(new BreakpointType('4.5%', '5%', '5%').getValue2(this.curBreakpoint))
    }.padding({ top: px2vp(this.windowArea.statusBarHeight) })
    .backgroundColor(this.theme.colors?.backgroundPrimary)
  }
}