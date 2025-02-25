import { util } from '@kit.ArkTS';

@Builder
export function FindPageBuilder(name: String, param: Object) {
  FindPage()
}

@ComponentV2
export struct FindPage {
  @Local message: string = 'Find';

  aboutToAppear(): void {
    console.log("TAG", 'find   ' + util.getHash(this))
  }

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
    }.hideTitleBar(true)
  }
}
