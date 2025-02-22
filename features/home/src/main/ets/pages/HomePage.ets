import { WindowArea } from "base/src/main/ets/utils/Window";
import { AppStorageV2 } from "@kit.ArkUI";

@Builder
export function HomePageBuilder(name: String, param: Object) {
  HomePage()
}

@Preview
@ComponentV2
export struct HomePage {
  @Local windowArea: WindowArea = AppStorageV2.connect(WindowArea, () => new WindowArea())!
  @Local message: string = 'Home';
  mNavPathStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Stack() {
        Text(this.message + "  " + this.windowArea.statusBarHeight)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
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
