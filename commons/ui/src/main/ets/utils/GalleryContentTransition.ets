import { AttributeUpdater } from '@kit.ArkUI'

export class GalleryContentAnimatedTransition<Attribute extends CommonMethod<Attribute>> implements SwiperContentAnimatedTransition {
  timeout: number
  private galleryAttributeUpdate: GalleryAttributeUpdate<Attribute>[] = []
  private minScaleOffset: number = 1
  private minScale: number = 0.8
  private readonly maxScale: number = 1.0
  private xSlope: number = 1
  private ySlope: number = 1

  constructor(count: number = 1, minScale: number = 0.8, minScaleOffset: number = 1, timeout: number = 3000) {
    this.minScale = minScale
    this.minScaleOffset = minScaleOffset
    this.timeout = timeout

    for (let index = 0; index < count; index++) {
      this.galleryAttributeUpdate[index] = new GalleryAttributeUpdate(index)

    }
  }

  getGalleryItemAttribute(index: number): AttributeModifier<Attribute> {
    return this.galleryAttributeUpdate[index]
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

      // translateValue += Math.sin(position - anchorPosition) *
      //   (mainAxisLength * this.calcScaleValue(tempPosition) - mainAxisLength) * 0.5
      // tempPosition += 1
    }
    return translateValue
  }


  transition: Callback<SwiperContentTransitionProxy, void> = (proxy: SwiperContentTransitionProxy) => {
    this.galleryAttributeUpdate[proxy.index].gallery(proxy.position)
  }
}


class GalleryAttributeUpdate<Attribute extends CommonMethod<Attribute>> extends AttributeUpdater<Attribute> {
  private minScaleOffset: number = 1
  private minScale: number = 0.8
  private readonly maxScale: number = 1.0
  private xSlope: number = 1
  private ySlope: number = 1
  private index: number = -1

  constructor(index: number) {
    super()
    this.index = index
  }

  initializeModifier(instance: Attribute): void {
    this.innerGallery(instance, this.index)
  }

  gallery(position: number) {
    this.innerGallery(this.attribute!!, position)
  }

  private innerGallery(attribute: Attribute, position: number) {
    let xScaleValue = this.calcScaleValue(position)
    let yScaleValue = this.calcScaleValue(position)
    attribute.scale({ x: xScaleValue, y: yScaleValue })
    console.log('GalleryContentAnimatedTransition==> ',
      `index: ${this.index}   ${position}  scale: {x:${xScaleValue},y:${yScaleValue}}`)
  }

  /**
   * 计算position位置的缩放量
   * @param position
   * @returns
   */
  private calcScaleValue(position: number): number {
    let linearSlope = -1 * Math.sign(position) * Math.abs(this.maxScale - this.minScale) / this.minScaleOffset
    // console.info(`linearSlope: ${linearSlope} pos: ${position}`)
    let scaleValue = linearSlope * position + this.maxScale
    scaleValue = scaleValue > this.maxScale ? this.maxScale : (scaleValue < this.minScale ? this.minScale : scaleValue)
    return scaleValue
  }
}