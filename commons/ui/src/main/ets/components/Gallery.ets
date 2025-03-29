import { GalleryContentAnimatedTransition } from 'ui/src/main/ets/utils/GalleryContentTransition'

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
  @Once @Param positionScaleOffset: number = 1
  @Once @Param positionScale: number = 0.5
  @Once @Param itemSpace: number = 0
  private controller: SwiperController = new SwiperController()
  private galleryTransition =
    new GalleryContentAnimatedTransition<StackAttribute>(this.galleryDataSource, this.disPlayCount, this.itemSpace,
      this.positionScale,
      this.positionScaleOffset)

  build() {

    Swiper(this.controller) {
      LazyForEach(this.galleryDataSource, (item: object, index: number) => {
        Stack() {
          this.swiperItemBuilder(index)
        }
        .alignContent(Alignment.Center)
        .attributeModifier(this.galleryTransition.getGalleryItemAttribute(index))
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          this.galleryTransition.onSizeChaneCallback(index, oldValue, newValue)
        })
      })
    }
    .displayCount(this.disPlayCount)
    .nextMargin(60)
    .prevMargin(60)
    .indicator(false)
    .cachedCount(1, true)
    .customContentTransition(this.galleryTransition)
  }
}

export interface OnGalleryItemSizeChangeCallback {
  onSizeChaneCallback(index: number, oldValue: SizeOptions, newValue: SizeOptions): void
}