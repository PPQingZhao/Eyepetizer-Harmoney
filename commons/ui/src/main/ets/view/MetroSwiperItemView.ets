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
  @Param theme?: CustomTheme = undefined

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
      .indicator(DotIndicator.dot().right(10).selectedColor(this.theme?.colors?.fontOnPrimary))
      .prevMargin(18)
      .nextMargin(18)
      .itemSpace(2)

      Text($r('app.string.more_detail'))
        .padding({ top: 10, left: 15, bottom: 10 })
        .width('100%')
        .height('auto')
        .fontSize(12)
        .fontColor(this.theme?.colors?.fontPrimary)

      Divider()
        .height(1)
        .color(this.theme?.colors?.fontPrimary)

    }.width('100%')
    .height('auto')
  }
}