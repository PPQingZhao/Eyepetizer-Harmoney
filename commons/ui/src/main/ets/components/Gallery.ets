import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource'
import { GalleryContentAnimatedTransition } from 'ui/src/main/ets/utils/GalleryContentTransition'

@ComponentV2
export struct GallerySwiper {
  @Once @Param @Require count: number = 0
  @BuilderParam swiperItemBuilder: (index: number) => void
  @Once @Param positionScaleOffset: number = 1
  @Once @Param positionScale: number = 0.8
  private controller: SwiperController = new SwiperController()
  private galleryTransition =
    new GalleryContentAnimatedTransition<StackAttribute>(this.count, this.positionScale, this.positionScaleOffset)
  private galleryDataSource = new SimpleDataSource<number>()
  @Local private curIndex: number = 0

  aboutToAppear(): void {
    if (this.galleryDataSource.totalCount() != this.count) {
      this.galleryDataSource.deleteAllData()
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
        .zIndex(this.curIndex == index ? 1 : 0)
      })
    }
    .displayCount(1)
    .nextMargin(40)
    .prevMargin(40)
    .cachedCount(this.positionScaleOffset)
    .onChange((index: number) => {
      this.curIndex = index
      console.info(`onChange:  ${index}`)
    })
    .customContentTransition(this.galleryTransition)
  }
}