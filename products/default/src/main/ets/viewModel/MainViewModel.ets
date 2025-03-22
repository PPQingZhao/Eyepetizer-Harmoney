import { Find, Home, Square, User } from 'base'
import { RouterTabInfo, TabModel } from 'ui'
import { createRouterTabModel } from 'ui/src/main/ets/tab/TabModel'

@ObservedV2
export class MainViewModel {
  @Trace
  tabInfos: TabModel<RouterTabInfo>[] = [
    createRouterTabModel(
      $r('[ui].string.home'),
      $r("app.media.ic_home"),
      $r('app.media.ic_home'),
      Home.moduleName,
      Home.HomePage),
    createRouterTabModel(
      $r('[ui].string.find'),
      $r('app.media.ic_find'),
      $r('app.media.ic_find'),
      Find.moduleName,
      Find.FindPage),
    createRouterTabModel(
      $r('[ui].string.square'),
      $r('app.media.ic_square'),
      $r('app.media.ic_square'),
      Square.moduleName,
      Square.SquarePage),
    createRouterTabModel(
      $r('[ui].string.mine'),
      $r('app.media.ic_mine'),
      $r('app.media.ic_mine'),
      User.moduleName,
      User.MinePage)
  ]
}


