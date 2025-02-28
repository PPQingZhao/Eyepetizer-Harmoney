import { NavPushPathHelper } from '@kit.ArkUI'

@Entry
@ComponentV2
struct Index {
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)

  build() {
    Navigation(this.mNavPathStack)
      .hideToolBar(true)
      .hideTitleBar(true)
      .onAppear(() => {
        this.mNavHelper.pushPath(
          'default',
          { name: 'MainPage' },
          { launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON, animated: false })
      })
  }
}
