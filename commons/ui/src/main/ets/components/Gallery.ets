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
  @Once @Param positionScaleOffset: number = 1
  @Once @Param positionScale: number = 0.5
  private controller: SwiperController = new SwiperController()
  private curSelectionIndex = 0
  private galleryTransition =
    new GalleryContentAnimatedTransition<StackAttribute>(this.galleryDataSource, this.positionScale,
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
          console.info(`=============================  onSizeChange`)
          this.galleryTransition.gallery(index, newValue)
        })
      })
    }
    .displayCount(1)
    .nextMargin(60)
    .prevMargin(60)
    .indicator(false)
    .cachedCount(1)
    .customContentTransition(this.galleryTransition)
    .onChange((index) => {
      this.curSelectionIndex = index
    })
  }
}
