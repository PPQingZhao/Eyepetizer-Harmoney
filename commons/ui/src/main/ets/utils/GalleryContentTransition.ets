import { AttributeUpdater } from '@kit.ArkUI'

export class GalleryContentAnimatedTransition<Attribute extends CommonMethod<Attribute>> implements SwiperContentAnimatedTransition {
  timeout: number
  private galleryAttributeUpdate: AttributeUpdater<Attribute>[] = []
  private minScale: number = 0.8
  private maxScale: number = 1.0
  private xSlope: number =1
  private ySlope: number =1

  getGalleryItemAttribute(index: number): AttributeModifier<Attribute> {
    return this.galleryAttributeUpdate[index]
  }

  constructor(count: number = 1, timeout: number = 3000) {
    this.timeout = timeout

    for (let index = 0; index < count; index++) {
      this.galleryAttributeUpdate[index] = new GalleryAttributeUpdate()
    }
  }

  /**
   * 计算position位置的缩放量
   * @param position
   * @returns
   */
  private calcScaleValue(position: number): number {
    let linearSlope = (this.maxScale - this.minScale) /*/ this.anchorPositionValue*/
    let scaleValue =
      Math.sign(/*this.anchorPositionValue - */position) * linearSlope * (position /*- this.anchorPositionValue*/) +
      this.maxScale
    scaleValue = scaleValue > this.maxScale ? this.maxScale : (scaleValue < this.minScale ? this.minScale : scaleValue)
    return scaleValue
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

  transition: Callback<SwiperContentTransitionProxy, void> = (proxy: SwiperContentTransitionProxy) => {

    let index = proxy.index
    let position = proxy.position
    let attribute = this.galleryAttributeUpdate[proxy.index].attribute
    let mainAxisLength = proxy.mainAxisLength
    let selectIndex = proxy.selectedIndex

    let scaleValue = this.calcScaleValue(position)
    let translateValue = this.calcTranslateValue(position, mainAxisLength)
    attribute?.scale({ x: scaleValue })
    attribute?.translate({ x: translateValue })
    console.log('GalleryContentAnimatedTransition',
      'index: ' + index + ' selectIndex: ' + selectIndex + ' position: ' + position)
  }
}

class GalleryAttributeUpdate<Attribute extends CommonMethod<Attribute>> extends AttributeUpdater<Attribute> {
}