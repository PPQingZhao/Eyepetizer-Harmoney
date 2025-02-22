import { AppStorageV2, NavPushPathHelper } from '@kit.ArkUI'
import { Find, Home, WindowArea } from 'base'

@ComponentV2
export struct NavContentView {
  @Local windowArea: WindowArea = AppStorageV2.connect<WindowArea>(WindowArea, () => new WindowArea())!;
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)

  @Builder
  tabBuilder(content: string | Resource,
    src: PixelMap | ResourceStr | DrawableDescriptor) {
    Flex({
      direction: FlexDirection.Column,
      wrap: FlexWrap.NoWrap,
      alignItems: ItemAlign.Center
    }) {
      Image(src)
      Text(content).fontSize(15)
    }
  }

  build() {
    Column() {
      Navigation(this.mNavPathStack)
        .hideNavBar(true)
        .layoutWeight(8)
        .onAppear(() => {
          this.mNavPushPathHelper.pushPath(Home.moduleName, { name: Home.HomePage })
          // this.mNavPushPathHelper.pushPath(Square.moduleName, { name: Square.SquarePage })
          // this.mNavPushPathHelper.pushPath(User.moduleName, { name: User.MinePage })
          // this.mNavPushPathHelper.pushPath(Find.moduleName, { name: Find.FindPage })
        })

      // toolbar
      Row({}) {
        this.tabBuilder("首页", $r('app.media.app_icon'))
        this.tabBuilder("发现", $r('app.media.app_icon'))
        this.tabBuilder("广场", $r('app.media.app_icon'))
        this.tabBuilder("我的", $r('app.media.app_icon'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor(Color.Blue)
      .layoutWeight(1)
      .padding({ 'bottom': px2vp(this.windowArea.navigationHeight) })
    }.backgroundColor(Color.Red)
  }
}