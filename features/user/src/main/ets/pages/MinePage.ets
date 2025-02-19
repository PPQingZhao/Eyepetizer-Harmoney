@Builder
export function MinePageBuilder(name: String, param: Object) {
  MinePage()
}

@Component
export struct MinePage {
  @State message: string = 'mine';

  build() {
    NavDestination() {

      Row() {
        Column() {
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}
