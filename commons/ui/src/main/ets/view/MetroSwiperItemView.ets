import { GallerySwiper } from 'ui/src/main/ets/components/Gallery'
import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource'
import { LengthMetrics } from '@kit.ArkUI'

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
    Stack() {
      Text(index.toString())
        .textAlign(TextAlign.Start)
        .backgroundColor(index % 2 == 0 ? Color.Red : Color.Blue)
        .width('100%')
        .height('auto')
        .border({ color: index % 2 == 0 ? Color.Red : Color.Blue })
        .borderWidth(2)
        .padding({ start: LengthMetrics.px(20) })
        .aspectRatio(16 / 9)
      Text(index.toString())
        .textAlign(TextAlign.End)
        .padding({ end: LengthMetrics.px(20) })
        .border({ color: index % 2 == 0 ? Color.Red : Color.Blue })
        .borderWidth(2)
        .width('100%')
        .height('auto')
        .aspectRatio(16 / 9)
    }
  }

  build() {
    Column() {
      GallerySwiper({
        galleryDataSource: this.viewModel.dataSource,
        disPlayCount: 2,
        itemSpace: 10,
        nextMargin: 80,
        preMargin: 80,
        nextGalleryInfo: {
          positionScale: 0.8,
          positionScaleOffset: 1,
          galleryMargin: 0
        },
        preGalleryInfo: {
          positionScale: 0.8,
          positionScaleOffset: 1,
          galleryMargin: 0
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