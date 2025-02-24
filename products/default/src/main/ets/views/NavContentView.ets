import { LengthMetrics, NavPushPathHelper } from '@kit.ArkUI';
import { Home, WindowArea } from 'base';
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window';
import { RouterTabInfo } from 'ui';
import { NavContentViewModel } from '../viewModel/NavContentViewModel';

@ComponentV2
export struct NavContentView {
  windowArea: WindowArea = getWindowAreaByAppStorage();
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)
  navContentViewModel: NavContentViewModel = new NavContentViewModel()
  @Local curPageIndex: number = 0

  @Builder
  tabBuilder(tabInfo: RouterTabInfo, index: number) {
    Flex({
      direction: FlexDirection.Column,
      wrap: FlexWrap.NoWrap,
      alignItems: ItemAlign.Center,
      space: { main: LengthMetrics.vp(3) }
    }) {
      Image(this.curPageIndex == index ? tabInfo.iconSelected : tabInfo.icon)
      Text(tabInfo.name).fontColor(this.curPageIndex == index ? Color.Orange : Color.Black)
    }.onClick(() => {
      if (this.curPageIndex == index) {
        return
      }

      this.curPageIndex = index
      this.mNavPushPathHelper.pushPath(tabInfo.moduleName, { name: tabInfo.page },false)
    })
  }

  @Builder
  ContentBuilder() {

    Column() {
      Navigation(this.mNavPathStack)
        .hideNavBar(true)
        .layoutWeight(8)
        .onAppear(() => {
          this.mNavPushPathHelper.pushPath(Home.moduleName, { name: Home.HomePage })
        })

      // toolbar
      Row({}) {
        ForEach(this.navContentViewModel.tabInfos, (item: RouterTabInfo, index: number) => {
          this.tabBuilder(item, index)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor(Color.Blue)
      .layoutWeight(1)
      .padding({ 'bottom': px2vp(this.windowArea.navigationHeight) })
    }.backgroundColor(Color.Red)
  }

  build() {
    this.ContentBuilder()
  }
}