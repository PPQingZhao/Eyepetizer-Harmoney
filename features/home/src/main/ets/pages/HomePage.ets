import { getWindowAreaByAppStorage, WindowArea } from 'base/src/main/ets/utils/Window';
import { util } from '@kit.ArkTS';

@Builder
export function HomePageBuilder(name: String, param: Object) {
  HomePage()
}

@Preview
@ComponentV2
export struct HomePage {
  @Local windowArea: WindowArea = getWindowAreaByAppStorage()
  @Local message: string = 'Home';
  mNavPathStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Stack() {
        Text(this.message + "  " + this.windowArea.statusBarHeight)
          .fontSize(50)
          .fontWeight(FontWeight.Bold).onClick(() => {
          this.windowArea.navigationHeight = 100
        })
      }.width('100%')
      .height('100%')
      .backgroundColor('#cc23')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    }.width('100%')
    .height('100%')
    .onReady((context: NavDestinationContext) => {
      this.mNavPathStack = context.pathStack
    })
  }
}
