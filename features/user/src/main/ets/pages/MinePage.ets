import { util } from '@kit.ArkTS';

@Builder
export function MinePageBuilder(name: String, param: Object) {
  MinePage()
}

@ComponentV2
export struct MinePage {
  @Local message: string = 'mine';

  aboutToReuse(params: Record<string, ESObject>): void {
    console.log("TAG", 'mine   aboutToReuse' + util.getHash(this))
  }

  onPageShow(): void {
    console.log("TAG", 'mine  onPageShow ' + util.getHash(this))
  }

  aboutToAppear(): void {
    console.log("TAG", 'mine   ' + util.getHash(this))
  }

  build() {
    NavDestination() {

      Row() {
        Column() {
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold).onClick(() => {
            this.message = 'mine aaaaaaaaaaaaaaaaaaaaa'
          })
        }
        .width('100%')
      }
      .height('100%')
    }.hideTitleBar(true)
  }
}
