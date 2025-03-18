@ComponentV2
export struct GallerySwiper {
  @Param modifier?: AttributeModifier<SwiperAttribute> = undefined
  @Param @Require dataSource: IDataSource
  @BuilderParam swiperItemBuilder: (item: object) => void = this.defaultItem

  @Builder
  defaultItem(item: object) {

  }

  build() {
    Swiper() {
      LazyForEach(this.dataSource, (index: number) => {
        this.swiperItemBuilder(this.dataSource.getData(index))
      })
    }
    .attributeModifier(this.modifier)
    .customContentTransition({
      timeout: 3000,
      transition: (proxy: SwiperContentTransitionProxy) => {
        console.log('MetroSwiperItemView',
          'index: ' + proxy.index + '  position: ' + proxy.position + ' selectedIndex: ' + proxy.selectedIndex +
            '  mainAxisLength: ' + proxy.mainAxisLength)
      }
    })
  }
}