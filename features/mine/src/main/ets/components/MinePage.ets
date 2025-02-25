import { util } from "@kit.ArkTS";

@ComponentV2
export struct MinePage {
  @Local message: string = 'mine';

  aboutToAppear(): void {
    console.log("TAG",'mine   ' +  util.getHash(this))
  }

  build() {
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
