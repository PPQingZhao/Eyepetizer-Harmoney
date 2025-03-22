import { WindowArea } from 'base';
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window';
import { MainViewModel } from '../viewModel/MainViewModel';
import { RouterTabInfo, TabModel } from 'ui';
import { LengthMetrics, NavPushPathHelper } from '@kit.ArkUI';
import { BreakpointModel, getBreakpointModelByAppStorage } from 'base/src/main/ets/constans/BreakpointModel';
import { BreakpointType } from 'base/src/main/ets/constans/BreakpointType';
import { DefaultAppTheme } from 'ui/src/main/ets/theme/WithDynamicThemeView';

@ComponentV2
export struct MainPage {
  windowArea: WindowArea = getWindowAreaByAppStorage();
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)
  navContentViewModel: MainViewModel = new MainViewModel()
  curTabModel: TabModel<RouterTabInfo> = this.navContentViewModel.tabInfos[0]
  @Local curBreakpoint: BreakpointModel = getBreakpointModelByAppStorage()
  theme: CustomTheme = new DefaultAppTheme()

  onWillApplyTheme(theme: Theme): void {
    this.theme = theme
  }

  @Builder
  tabBuilder(tabModel: TabModel<RouterTabInfo>) {

    Stack({ alignContent: Alignment.Center }) {
      Text(tabModel.tabInfo.name)
        .scale({ x: tabModel.isSelected ? 0.8 : 1, y: tabModel.isSelected ? 0.8 : 1 })
        .animation({ curve: Curve.Linear, duration: 400 })
        .maxLines(1)
        .maxFontSize(15)
        .minFontSize(11)

      Image(tabModel.tabInfo.icon)
        .padding(5)
        .translate({ y: tabModel.isSelected ? '0%' : '101%' })
        .animation({ curve: tabModel.isSelected ? Curve.EaseIn : Curve.EaseOut, duration: 400 })
        .borderRadius(8)
        .backgroundColor(this.theme.colors?.backgroundPrimary)
        .fillColor(this.theme.colors?.fontPrimary)
    }
    .height(new BreakpointType('60%', undefined, undefined).getValue(this.curBreakpoint.breakpoint))
    .width(new BreakpointType(undefined, '50%', '40%').getValue(this.curBreakpoint.breakpoint))
    .aspectRatio(1)
    .clip(true)
    .onClick(() => {
      this.navToTabPage(tabModel)
    })
  }

  private navToTabPage(tabModel: TabModel<RouterTabInfo>) {
    if (tabModel.isSelected) {
      return
    }

    let oldTabModel = this.curTabModel
    this.curTabModel = tabModel

    oldTabModel.isSelected = false
    this.curTabModel.isSelected = true

    this.mNavPushPathHelper.pushPath(tabModel.tabInfo.moduleName,
      { name: tabModel.tabInfo.page }, { launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON, animated: false })
  }

  @Builder
  ContentBuilder() {
    Navigation(this.mNavPathStack)
      .hideToolBar(true)
      .hideTitleBar(true)
      .hideNavBar(true)
      .layoutWeight(8)
      .onAppear(() => {
        this.navToTabPage(this.curTabModel)
      })
  }

  @Builder
  CustomToolBuilder() {
    // toolbar
    Flex({
      direction:
      new BreakpointType(FlexDirection.Row, FlexDirection.Column,
        FlexDirection.Column).getValue(this.curBreakpoint.breakpoint),
      justifyContent:
      new BreakpointType(FlexAlign.SpaceAround, FlexAlign.Center,
        FlexAlign.Center).getValue(this.curBreakpoint.breakpoint),
      space: { main: LengthMetrics.vp(20) },
    }) {
      ForEach(this.navContentViewModel.tabInfos, (item: TabModel<RouterTabInfo>) => {
        Stack({ alignContent: Alignment.Center }) {
          this.tabBuilder(item)
        }.height(new BreakpointType('100%', undefined, undefined).getValue(this.curBreakpoint.breakpoint))
        .width(new BreakpointType(undefined, '100%', '100%').getValue(this.curBreakpoint.breakpoint))
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.theme.colors?.backgroundPrimary)

    // .padding({ 'bottom': px2vp(this.windowArea.navigationHeight) })
  }

  build() {

    NavDestination() {
      GridRow({
        direction: new BreakpointType(GridRowDirection.Row, GridRowDirection.RowReverse,
          GridRowDirection.RowReverse).getValue(this.curBreakpoint.breakpoint),
        columns: { sm: 12, md: 10, lg: 12 }
      }) {
        GridCol({ span: { sm: 12, md: 9, lg: 11 } }) {
          this.ContentBuilder()
        }.height(new BreakpointType('92%', '100%', '100%').getValue(this.curBreakpoint.breakpoint))

        GridCol({ span: { sm: 12, md: 1, lg: 1 } }) {
          this.CustomToolBuilder()
        }.height(new BreakpointType('8%', '100%', '100%').getValue(this.curBreakpoint.breakpoint))
      }.width('100%')
      .height('100%')
    }.hideTitleBar(true)
  }
}

@Builder
function MainPageBuilder(name: String, param: Object) {
  MainPage()
}