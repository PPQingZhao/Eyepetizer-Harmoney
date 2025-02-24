import { RouterTabInfo, TabInfo } from "./TabInfo";

export class TabModel2 {
  isSelected: boolean = false
  tabInfo: RouterTabInfo = {
    name: "222222",
    icon: $r('app.media.app_icon'),
    iconSelected: $r('app.media.app_icon'),
    moduleName: 'aaaa',
    page: 'ddd'
  }
}

// @ObservedV2
// export class TabModel {
//    isSelected: boolean = false
//   tabInfo: RouterTabInfo = {
//     name: "",
//     icon: $r('app.media.app_icon'),
//     iconSelected: $r('app.media.app_icon'),
//     moduleName: '',
//     page: ''
//   }
// }

// export function createTabModel(tabName: Resource,
//   icon: Resource,
//   iconSelected: Resource,
//   isSelected: boolean = false): TabModel<TabInfo> {
//   return {
//     tabInfo: {
//       name: tabName,
//       icon: icon,
//       iconSelected: iconSelected,
//     },
//     isSelected: isSelected
//   }
// }

// export function createRouterTabModel(tabName: Resource,
//   icon: Resource,
//   iconSelected: Resource,
//   moduleName: string,
//   page: string,
//   isSelected: boolean = false): TabModel {
//   let tabInfo: RouterTabInfo = {
//     name: tabName,
//     icon: icon,
//     iconSelected: iconSelected,
//     moduleName: moduleName,
//     page: page
//   }
//   return new TabModel()
// }