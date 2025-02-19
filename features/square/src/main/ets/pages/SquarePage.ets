
@Builder
export function SquarePageBuilder(name: String, param: Object) {
  SquarePage()
}

@Component
export struct SquarePage {
  @State message: string = 'Square';

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
