@Builder
export function FindPageBuilder(name: String, param: Object) {
  FindPage()
}

@Component
export struct FindPage {
  @State message: string = 'Find';

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
