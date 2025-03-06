import { util } from '@kit.ArkTS';

@Preview
@ComponentV2
export struct MinePage {
  @Local message: string = 'mine';

  aboutToAppear(): void {
    console.log("TAG", 'mine   ' + util.getHash(this))
  }

  build() {
    Stack() {
      Stack() {

        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .height('100%')
      }
      .margin(20)
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.Blue)

  }
}
