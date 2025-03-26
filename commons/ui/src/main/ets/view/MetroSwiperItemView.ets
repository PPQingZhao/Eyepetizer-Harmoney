import { GallerySwiper } from 'ui/src/main/ets/components/Gallery'
import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource'

@ObservedV2
export class MetroSwiperItemViewModel {
  dataSource: SimpleDataSource<string>

  constructor(data: string[]) {
    this.dataSource = new SimpleDataSource<string>()
    this.dataSource.pushDataList(data)
  }
}

@Preview
@ComponentV2
export struct MetroSwiperItemView {
  @Param @Require viewModel: MetroSwiperItemViewModel = new MetroSwiperItemViewModel(['', '', '', '', ''])
  @Param theme?: CustomTheme = undefined

  @Builder
  galleryItem(index: number) {
    Text(index.toString())
      .textAlign(TextAlign.Center)
      .backgroundColor(index % 2 == 0 ? Color.Red : Color.Blue)
      .width('100%')
      .height('auto')
      .aspectRatio(16 / 9)
  }

  build() {
    Column() {
      GallerySwiper({
        count: this.viewModel.dataSource.totalCount(),
        positionScale: 0.8,
        swiperItemBuilder: (index) => {
          this.galleryItem(index)
        }
      }).width('100%')
        .height('auto')

      Text($r("app.string.more_detail"))
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