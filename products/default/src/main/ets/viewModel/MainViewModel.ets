import { Find, Home, Square, User } from 'base'
import { RouterTabInfo, TabModel } from 'ui'
import { createRouterTabModel } from 'ui/src/main/ets/tab/TabModel'

@ObservedV2
export class MainViewModel {
  @Trace
  tabInfos: TabModel<RouterTabInfo>[] = [
    createRouterTabModel(
      $r('app.string.home'),
      $r("app.media.ic_home"),
      $r('app.media.ic_home'),
      Home.moduleName,
      Home.HomePage),
    createRouterTabModel(
      $r('app.string.find'),
      $r('app.media.ic_find'),
      $r('app.media.ic_find'),
      Find.moduleName,
      Find.FindPage),
    createRouterTabModel(
      $r('app.string.square'),
      $r('app.media.ic_square'),
      $r('app.media.ic_square'),
      Square.moduleName,
      Square.SquarePage),
    createRouterTabModel(
      $r('app.string.mine'),
      $r('app.media.ic_mine'),
      $r('app.media.ic_mine'),
      User.moduleName,
      User.MinePage)
  ]
}


