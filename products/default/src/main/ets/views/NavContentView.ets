@Component
export struct NavContentView {
  @StorageProp("_NavigationHeight")
  navigationHeight: number = 0
  mNavPathStack: NavPathStack = new NavPathStack()

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
          // this.mNavPathStack.pushPathByName('HomePage', null)
          // this.mNavPathStack.pushPathByName('FindPage', null)
          // this.mNavPathStack.pushPathByName('SquarePage', null)
          this.mNavPathStack.pushPathByName('MinePage', null)
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
      .padding({ 'bottom': px2vp(this.navigationHeight) })
    }.backgroundColor(Color.Red)
  }
}