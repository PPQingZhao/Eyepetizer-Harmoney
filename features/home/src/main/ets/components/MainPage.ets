@Preview
@Component
export struct MainPage {
  @State message: string = 'Home';

  build() {
    Stack() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }.width('100%')
    .height('100%')
    .backgroundColor('#cc23')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
