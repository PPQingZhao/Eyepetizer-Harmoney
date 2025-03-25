import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource'
import { GalleryContentAnimatedTransition } from 'ui/src/main/ets/utils/GalleryContentTransition'

@ObservedV2
class GalleryItemAttribute {
  @Trace private xScaleValue: number = 1.0
  @Trace private yScaleValue: number = 1.0
}


@ComponentV2
export struct GallerySwiper {
  @Param @Require count: number = 0
  @BuilderParam swiperItemBuilder: (index: number) => void
  minScaleOffset: number = 1
  minScale: number = 0.8
  private readonly maxScale: number = 1.0
  private controller: SwiperController = new SwiperController()
  private galleryTransition: GalleryContentAnimatedTransition<StackAttribute> =
    new GalleryContentAnimatedTransition(this.count)
  private galleryDataSource = new SimpleDataSource<number>()

  aboutToAppear(): void {
    if (this.galleryDataSource.totalCount() == 0 && this.count > 0) {
      for (let index = 0; index < this.count; index++) {
        this.galleryDataSource.pushData(index)
      }
    }
  }

  build() {
    Swiper(this.controller) {
      LazyForEach(this.galleryDataSource, (item: object, index: number) => {
        Stack() {
          this.swiperItemBuilder(index)
        }
        .border({ width: 1 })
        .alignContent(Alignment.Center)
        .borderColor(index % 2 === 0 ? Color.Yellow : Color.Green)
        .attributeModifier(this.galleryTransition.getGalleryItemAttribute(index))
      })
    }
    .displayCount(1)
    .nextMargin(40)
    .prevMargin(40)
    .cachedCount(2)
    .onChange((index: number) => {
      console.info(`onChange:  ${index}`)
    })
    .customContentTransition(this.galleryTransition)
  }

  private calcTranslateValue(position: number, mainAxisLength: number): number {
    let anchorPosition = Math.abs(Math.abs(position)/* - this.anchorPositionValue*/)
    let translateCount = Math.abs(position - anchorPosition)
    if (translateCount < 1) {
      return 0
    }
    let translateValue = 0
    let tempPosition = anchorPosition
    for (let index = 0; index <= translateCount; index++) {

      translateValue += Math.sin(position - anchorPosition) *
        (mainAxisLength * this.calcScaleValue(tempPosition) - mainAxisLength) * 0.5
      tempPosition += 1
    }
    return translateValue
  }

  /**
   * 计算position位置的缩放量
   * @param position
   * @returns
   */
  private calcScaleValue(position: number): number {
    let linearSlope = (this.maxScale - this.minScale) / this.minScaleOffset
    let scaleValue =
      Math.sign(this.minScaleOffset - position) * linearSlope * (position - this.minScaleOffset) +
      this.maxScale
    scaleValue = scaleValue > this.maxScale ? this.maxScale : (scaleValue < this.minScale ? this.minScale : scaleValue)
    return scaleValue
  }
}