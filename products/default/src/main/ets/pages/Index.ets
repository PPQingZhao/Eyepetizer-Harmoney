import { FindPage } from 'find'
import { MainPage } from 'home'
import { SquarePage } from 'square'
import { MinePage } from 'mine'

@Entry
@Component
struct Index {
  @StorageProp("navigationHeight")
  navigationHeight: number = 0

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
    }.padding(5)
  }

  build() {
    Tabs() {
      TabContent() {
        MainPage()
      }.tabBar(this.tabBuilder('首页', $r('app.media.app_icon')))

      TabContent() {
        SquarePage()
      }.tabBar(this.tabBuilder('广场', $r('app.media.app_icon')))

      TabContent() {
        FindPage()
      }.tabBar(this.tabBuilder('发现', $r('app.media.app_icon')))

      TabContent() {
        MinePage()
      }.tabBar(this.tabBuilder('我的', $r('app.media.app_icon')))
    }
    .barMode(BarMode.Fixed)
    .width('100%')
    .height('100%')
    .padding({ 'bottom': px2vp(this.navigationHeight) })
    .barHeight('8%')
    .backgroundColor('#ccaa')
    .barBackgroundColor(Color.Transparent)
    .barPosition(BarPosition.End)
  }
}
