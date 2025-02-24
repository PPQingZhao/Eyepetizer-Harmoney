export interface TabInfo {
  name: Resource | string
  icon: Resource
  iconSelected: Resource
}

export interface RouterTabInfo extends TabInfo {
  moduleName: string
  page: string
}