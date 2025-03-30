import { GallerySwiper } from 'ui/src/main/ets/components/Gallery'
import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource'

@ObservedV2
export class MetroSwiperItemViewModel {
  @Trace dataSource: SimpleDataSource<string>

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
  private indicatorController: IndicatorComponentController = new IndicatorComponentController()

  @Builder
  galleryItem(index: number) {
    Text(index.toString() + '      ' + this.viewModel.dataSource.getData(index))
      .textAlign(TextAlign.Center)
      .backgroundColor(index % 2 == 0 ? Color.Red : Color.Blue)
      .width('100%')
      .height('auto')
      .aspectRatio(16 / 9)
      .onClick(() => {
        // this.viewModel.dataSource.delete(index)
        // this.viewModel.dataSource.push('sss')
      })
  }

  build() {
    Column() {
      GallerySwiper({
        galleryDataSource: this.viewModel.dataSource,
        disPlayCount: 1,
        itemSpace: 20,
        nextMargin: 60,
        preMargin: 60,
        nextGalleryInfo: {
          positionScale: 0.85,
          positionScaleOffset: 1,
          galleryMargin: 30
        },
        preGalleryInfo: {
          positionScale: 0.85,
          positionScaleOffset: 1,
          galleryMargin: 30
        },
        indicatorController: this.indicatorController,
        swiperItemBuilder: (index) => {
          this.galleryItem(index)
        }
      }).width('100%')
        .height('auto')

      Row() {
        Text($r('app.string.more_detail'))
          .padding({ top: 10, left: 15, bottom: 10 })
          .width('auto')
          .height('auto')
          .fontSize(12)
          .fontColor(this.theme?.colors?.fontPrimary)
          .layoutWeight(1)

        IndicatorComponent(this.indicatorController)
          .style(
            DotIndicator.dot()
              .selectedColor(this.theme?.colors?.fontOnPrimary)
              .color(this.theme?.colors?.fontPrimary)
          )
          .count(this.viewModel.dataSource.totalCount())
          .loop(true)
          .alignSelf(ItemAlign.End)
          .vertical(false)
          .count(this.viewModel.dataSource.totalCount())
      }.alignItems(VerticalAlign.Center)
      .width('100%')

      Divider()
        .height(1)
        .color(this.theme?.colors?.fontPrimary)

    }.width('100%')
    .height('auto')
  }
}