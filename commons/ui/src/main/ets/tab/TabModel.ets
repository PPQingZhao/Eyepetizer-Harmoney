import { RouterTabInfo, TabInfo } from './TabInfo'

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
  icon: Resource | undefined = undefined,
  iconSelected: Resource | undefined = undefined,
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


export function createTabModel(tabName: Resource,
  icon: Resource | undefined = undefined,
  iconSelected: Resource | undefined = undefined,
  isSelected: boolean = false): TabModel<TabInfo> {
  let tabInfo: TabInfo = {
    name: tabName,
    icon: icon,
    iconSelected: iconSelected,
  }
  return new TabModel<TabInfo>(tabInfo, isSelected)
}

