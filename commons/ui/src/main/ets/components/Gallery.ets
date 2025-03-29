import { GalleryContentAnimatedTransition, GalleryInfo } from 'ui/src/main/ets/utils/GalleryContentTransition'

@ComponentV2
export struct GallerySwiper {
  @Once @Param @Require galleryDataSource: IDataSource = {
    totalCount: (): number => {
      return 0
    },
    getData: (index: number): number => {
      return index
    },
    registerDataChangeListener: (listener: DataChangeListener): void => {
    },
    unregisterDataChangeListener: (listener: DataChangeListener): void => {
    }
  }
  @BuilderParam swiperItemBuilder: (index: number) => void
  @Once @Param disPlayCount: number = 1
  @Once @Param itemSpace: number = 0
  @Once @Param indicatorController: IndicatorComponentController = new IndicatorComponentController()
  @Once @Param positiveGalleryInfo: GalleryInfo = { positionScale: 1.0, positionScaleOffset: 1 }
  @Once @Param negativeGalleryInfo: GalleryInfo = { positionScale: 1.0, positionScaleOffset: 1 }
  private controller: SwiperController = new SwiperController()
  private galleryTransition =
    new GalleryContentAnimatedTransition<StackAttribute>(this.galleryDataSource, this.disPlayCount, this.itemSpace,
      this.positiveGalleryInfo, this.negativeGalleryInfo)

  build() {

    Swiper(this.controller) {
      LazyForEach(this.galleryDataSource, (item: object, index: number) => {
        Stack() {
          this.swiperItemBuilder(index)
        }
        .alignContent(Alignment.Center)
        .attributeModifier(this.galleryTransition.getGalleryItemAttribute(index))
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          this.galleryTransition.onSizeChange(index, oldValue, newValue)
        })
      })
    }
    .displayCount(this.disPlayCount)
    .nextMargin(60)
    .prevMargin(60)
    .indicator(false)
    .cachedCount(1, true)
    .indicator(this.indicatorController)
    .customContentTransition(this.galleryTransition)
  }
}

export interface OnGalleryItemSizeChangeCallback {
  onSizeChange(index: number, oldValue: SizeOptions, newValue: SizeOptions): void
}