import { NavPushPathHelper } from '@kit.ArkUI';
import { Home, WindowArea } from 'base';
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window';
import { NavContentViewModel } from '../viewModel/MainViewModel';
import { RouterTabInfo, TabModel } from 'ui';

@ComponentV2
export struct MainPage {
  windowArea: WindowArea = getWindowAreaByAppStorage();
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)
  navContentViewModel: NavContentViewModel = new NavContentViewModel()
  curTabModel: TabModel<RouterTabInfo> = this.navContentViewModel.tabInfos[0]

  @Builder
  tabBuilder(tabModel: TabModel<RouterTabInfo>) {

    Stack({ alignContent: Alignment.Center }) {
      Text(tabModel.tabInfo.name)
        .scale({ x: tabModel.isSelected ? 0.8 : 1, y: tabModel.isSelected ? 0.8 : 1 })
        .animation({ curve: Curve.Linear, duration: 400 })
      Image(tabModel.tabInfo.icon)
        .padding(5)
        .translate({ y: tabModel.isSelected ? '0%' : '100%' })
        .backgroundColor($r('sys.color.background_primary'))
        .animation({ curve: tabModel.isSelected ? Curve.EaseIn : Curve.EaseOut, duration: 400 })
        .borderRadius(8)

    }
    .height('60%')
    .aspectRatio(1)
    .clip(true)
    .backgroundColor($r('sys.color.background_primary'))
    .onClick(() => {
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
      .backgroundColor(Color.White)
      .layoutWeight(1)
      .padding({ 'bottom': px2vp(this.windowArea.navigationHeight) })
    }.backgroundColor(Color.White)
  }

  build() {
    NavDestination() {
      this.ContentBuilder()
    }.hideTitleBar(true)
  }
}

@Builder
function MainPageBuilder(name: String, param: Object) {
  MainPage()
}