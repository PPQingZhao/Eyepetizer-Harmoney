import { Find, Home, Square, User } from "base/src/main/ets/router/Modules";
import { RouterTabInfo } from "ui";


export class NavContentViewModel {
  tabInfos: RouterTabInfo[] = [
    {
      name: $r('app.string.home'),
      icon: $r('app.media.app_icon'),
      iconSelected: $r('app.media.app_icon'),
      moduleName: Home.moduleName,
      page: Home.HomePage
    },
    {
      name: $r('app.string.find'),
      icon: $r('app.media.app_icon'),
      iconSelected: $r('app.media.app_icon'),
      moduleName: Find.moduleName,
      page: Find.FindPage
    },
    {
      name: $r('app.string.square'),
      icon: $r('app.media.app_icon'),
      iconSelected: $r('app.media.app_icon'),
      moduleName: Square.moduleName,
      page: Square.SquarePage
    },
    {
      name: $r('app.string.mine'),
      icon: $r('app.media.app_icon'),
      iconSelected: $r('app.media.app_icon'),
      moduleName: User.moduleName,
      page: User.MinePage
    },
  ]
}