import { GalleryContentAnimatedTransition } from 'ui/src/main/ets/utils/GalleryContentTransition'
class DataSource implements IDataSource{
  totalCount(): number {
    throw new Error('Method not implemented.')
  }

  getData(index: number): number {
    throw new Error('Method not implemented.')
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    throw new Error('Method not implemented.')
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    throw new Error('Method not implemented.')
  }
}
@ComponentV2
export struct GallerySwiper {
  @Once @Param @Require galleryDataSource: IDataSource = new DataSource()
  @BuilderParam swiperItemBuilder: (index: number) => void
  @Once @Param positionScaleOffset: number = 1
  @Once @Param positionScale: number = 0.8
  private controller: SwiperController = new SwiperController()
  private galleryTransition =
    new GalleryContentAnimatedTransition<StackAttribute>(this.galleryDataSource,this.positionScale, this.positionScaleOffset)
  @Local private curIndex: number = 0
  private firstInit: boolean = true

  aboutToAppear(): void {
    if (this.firstInit) {
      this.firstInit = false
      this.galleryDataSource.registerDataChangeListener(this.galleryTransition)
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
    .indicator(false)
    .cachedCount(this.positionScaleOffset)
    .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
      console.info(`onGestureSwipe:  ${index}      ${extraInfo.currentOffset}   ${extraInfo.targetOffset}`)
    })
    .onContentDidScroll((selectedIndex: number, index: number, position: number, mainAxisLength: number) => {
      console.info(`onContentDidScroll:  ${selectedIndex}      ${index} `)
    })
    .onChange((index: number) => {
      this.curIndex = index
      console.info(`onChange:  ${index}`)
    })
    .customContentTransition(this.galleryTransition)
  }
}
