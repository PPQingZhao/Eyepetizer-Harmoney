@Builder
export function HomePageBuilder(name: String, param: Object) {
  HomePage()
}

@Preview
@Component
export struct HomePage {
  @StorageProp("_StatusBarHeight")
  statusbarHeight: number = 0
  @State message: string = 'Home';
  mNavPathStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Stack() {
        Text(this.message + "  " + this.statusbarHeight)
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
