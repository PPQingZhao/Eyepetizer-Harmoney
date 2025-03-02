export interface RouterTabInfo extends TabInfo {
  moduleName: string
  page: string
}

export interface TabInfo {
  name: Resource | string
  icon: Resource | undefined
  iconSelected: Resource | undefined
}
