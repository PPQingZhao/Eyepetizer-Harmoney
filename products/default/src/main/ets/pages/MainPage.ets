import { Home, WindowArea } from 'base';
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window';
import { MainViewModel } from '../viewModel/MainViewModel';
import { RouterTabInfo, TabModel } from 'ui';
import { LengthMetrics, NavPushPathHelper } from '@kit.ArkUI';
import { BreakpointModel, getBreakpointModelByAppStorage } from 'base/src/main/ets/constans/BreakpointModel';
import { BreakpointConstants } from 'base/src/main/ets/constans/BreakpointConstants';

@ComponentV2
export struct MainPage {
  windowArea: WindowArea = getWindowAreaByAppStorage();
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)
  navContentViewModel: MainViewModel = new MainViewModel()
  curTabModel: TabModel<RouterTabInfo> = this.navContentViewModel.tabInfos[0]
  @Local curBreakpoint: BreakpointModel = getBreakpointModelByAppStorage()

  @Builder
  tabBuilder(tabModel: TabModel<RouterTabInfo>) {

    Stack({ alignContent: Alignment.Center }) {
      Text(tabModel.tabInfo.name)
        .scale({ x: tabModel.isSelected ? 0.8 : 1, y: tabModel.isSelected ? 0.8 : 1 })
        .animation({ curve: Curve.Linear, duration: 400 })
      Image(tabModel.tabInfo.icon)
        .padding(5)
        .translate({ y: tabModel.isSelected ? '0%' : '101%' })
        .backgroundColor($r('sys.color.background_primary'))
        .animation({ curve: tabModel.isSelected ? Curve.EaseIn : Curve.EaseOut, duration: 400 })
        .borderRadius(8)
    }
    .height(this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? undefined : '60%')
    .width(this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? '40%' : undefined)
    .aspectRatio(1)
    .clip(true)
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

  }

  @Builder
  CustomToolBuilder() {
    // toolbar
    Flex({
      direction: this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? FlexDirection.Column :
      FlexDirection.Row,
      justifyContent: this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? FlexAlign.Center :
      FlexAlign.SpaceAround,
      space: { main: LengthMetrics.vp(20) },
    }) {
      ForEach(this.navContentViewModel.tabInfos, (item: TabModel<RouterTabInfo>) => {
        Stack({ alignContent: Alignment.Center }) {
          this.tabBuilder(item)
        }.height(this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? undefined : '100%')
        .width(this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? '100%' : undefined)
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_primary'))
    // .padding({ 'bottom': px2vp(this.windowArea.navigationHeight) })
  }

  build() {

    NavDestination() {
      GridRow({
        direction: this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? GridRowDirection.RowReverse :
        GridRowDirection.Row
      }) {
        GridCol({ span: { sm: 12, md: 12, lg: 11 } }) {
          this.ContentBuilder()
        }.height(this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? '100%' : '92%')

        GridCol({ span: { sm: 12, md: 12, lg: 1 } }) {
          this.CustomToolBuilder()
        }.height(this.curBreakpoint.breakpoint == BreakpointConstants.BREAKPOINT_LG ? '100%' : '8%')
      }.width('100%')
      .height('100%')
    }.hideTitleBar(true)
  }
}

@Builder
function MainPageBuilder(name: String, param: Object) {
  MainPage()
}