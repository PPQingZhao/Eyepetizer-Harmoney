import { CustomColors, NavPushPathHelper } from '@kit.ArkUI';
import { Home, WindowArea } from 'base';
import { getWindowAreaByAppStorage } from 'base/src/main/ets/utils/Window';

class BlackAppColor implements CustomColors {
  fontPrimary?: ResourceColor | undefined = Color.Blue
}

class DefaultAppTheme implements CustomTheme {
  colors: BlackAppColor = new BlackAppColor()
}

@ComponentV2
export struct NavContentView {
  @Local windowArea: WindowArea = getWindowAreaByAppStorage();
  mNavPathStack: NavPathStack = new NavPathStack()
  mNavPushPathHelper: NavPushPathHelper = new NavPushPathHelper(this.mNavPathStack)
  @Local theme: CustomTheme = new DefaultAppTheme()

  @Builder
  tabBuilder(content: string | Resource,
    src: PixelMap | ResourceStr | DrawableDescriptor) {
    Flex({
      direction: FlexDirection.Column,
      wrap: FlexWrap.NoWrap,
      alignItems: ItemAlign.Center
    }) {
      Image(src)
      Text(content)
    }.onClick(() => {

    })
  }

  @Builder
  ContentBuilder() {

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

  build() {
    this.ContentBuilder()
  }
}