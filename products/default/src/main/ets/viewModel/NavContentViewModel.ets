import { Find, Home, Square, User } from 'base'
import { RouterTabInfo } from 'ui/src/main/ets/tab/TabInfo'

@ObservedV2
export class NavContentViewModel {
  @Trace
  tabInfos: TabModel<RouterTabInfo>[] = [
    createRouterTabModel($r('app.string.home'), $r("app.media.ic_home"), $r('app.media.ic_home'), Home.moduleName,
      Home.HomePage),
    createRouterTabModel($r('app.string.find'), $r('app.media.ic_find'), $r('app.media.ic_find'), Find.moduleName,
      Find.FindPage),
    createRouterTabModel($r('app.string.square'), $r('app.media.ic_square'), $r('app.media.ic_square'),
      Square.moduleName,
      Square.SquarePage),
    createRouterTabModel($r('app.string.mine'), $r('app.media.ic_mine'), $r('app.media.ic_mine'), User.moduleName,
      User.MinePage)
  ]
}

@ObservedV2
export class TabModel<Info> {
  @Trace isSelected: boolean = false
  tabInfo: Info

  constructor(info: Info, isSelected: boolean) {
    this.isSelected = isSelected
    this.tabInfo = info
  }
}

export function createRouterTabModel(tabName: Resource,
  icon: Resource,
  iconSelected: Resource,
  moduleName: string,
  page: string,
  isSelected: boolean = false): TabModel<RouterTabInfo> {
  let tabInfo: RouterTabInfo = {
    name: tabName,
    icon: icon,
    iconSelected: iconSelected,
    moduleName: moduleName,
    page: page
  }
  return new TabModel<RouterTabInfo>(tabInfo, isSelected)
}

