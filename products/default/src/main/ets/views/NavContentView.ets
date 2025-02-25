import { LengthMetrics, NavPushPathHelper } from '@kit.ArkUI';
import { Home, WindowArea } from 'base';
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window';
import { RouterTabInfo } from 'ui/src/main/ets/tab/TabInfo';
import { NavContentViewModel, TabModel } from '../viewModel/NavContentViewModel';

@ComponentV2
export struct NavContentView {
  windowArea: WindowArea = getWindowAreaByAppStorage();
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)
  navContentViewModel: NavContentViewModel = new NavContentViewModel()
  curTabModel: TabModel<RouterTabInfo> = this.navContentViewModel.tabInfos[0]

  @Builder
  tabBuilder(tabModel: TabModel<RouterTabInfo>) {
    Flex({
      direction: FlexDirection.Column,
      wrap: FlexWrap.NoWrap,
      alignItems: ItemAlign.Center,
      space: { main: LengthMetrics.vp(3) }
    }) {
      Image(tabModel.isSelected ?
      tabModel.tabInfo.iconSelected :
      tabModel.tabInfo.icon)
      Text(tabModel.tabInfo.name!)
        .fontColor(tabModel.isSelected ? Color.Orange : Color.Black)
    }.onClick(() => {
      if (tabModel.isSelected) {
        return
      }

      let oldTabModel = this.curTabModel
      this.curTabModel = tabModel

      oldTabModel.isSelected = false
      this.curTabModel.isSelected = true

      this.mNavPushPathHelper.pushPath(tabModel.tabInfo.moduleName,
        { name: tabModel.tabInfo.page }, { launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON, animated: false })
    })
  }

  @Builder
  ContentBuilder() {

    Column() {
      Navigation(this.mNavPathStack)
        .hideToolBar(true)
        .hideTitleBar(true)
        .hideNavBar(true)
        .layoutWeight(8)
        .onAppear(() => {
          this.curTabModel.isSelected = true
          this.mNavPushPathHelper.pushPath(Home.moduleName, { name: Home.HomePage },
            { launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON, animated: false })
        })

      // toolbar
      Row({}) {
        ForEach(this.navContentViewModel.tabInfos, (item: TabModel<RouterTabInfo>) => {
          this.tabBuilder(item)
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