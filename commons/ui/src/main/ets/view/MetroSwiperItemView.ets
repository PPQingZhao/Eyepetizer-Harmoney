import { Theme } from '@ohos.arkui.theme'
import { SimpleDataSource } from 'ui/src/main/ets/utils/IDataSource'

@ObservedV2
export class MetroSwiperItemViewModel {
  dataSource: SimpleDataSource<string>

  constructor(data: string[]) {
    this.dataSource = new SimpleDataSource<string>(data)
  }
}


@Preview
@ComponentV2
export struct MetroSwiperItemView {
  @Param @Require viewModel: MetroSwiperItemViewModel = new MetroSwiperItemViewModel(['', '', '', '', ''])
  theme?: CustomTheme
  scroller: Scroller = new Scroller()

  onWillApplyTheme(theme: Theme): void {
    this.theme = theme
  }

  build() {
    Column() {
      Swiper() {
        LazyForEach(this.viewModel.dataSource, (item: string, index: number) => {
          Text(item + '  ' + index)
            .textAlign(TextAlign.Center)
            .backgroundColor(index % 2 == 0 ? Color.Red : Color.Blue)
            .aspectRatio(16 / 9)
            .height('auto')
        })
      }
      .width('100%')
      .displayCount(1)
      .height('auto')
      .autoPlay(false)
      .loop(true)
      .cachedCount(2)
      .indicator(DotIndicator.dot().right(10).selectedColor(this.theme?.colors?.fontPrimary))
      .prevMargin(20)
      .nextMargin(20)
      .itemSpace(2)

      Text('了解详情   ->')
        .padding({ top: 8, left: 12, bottom: 8 })
        .width('100%')
        .height('auto')
        .fontSize(10)
        .fontColor(Color.Black)
        .backgroundColor($r('sys.color.white'))
      Divider()
        .height(1)
        .color(Color.Black)

    }.width('100%')
    .height('auto')
  }
}