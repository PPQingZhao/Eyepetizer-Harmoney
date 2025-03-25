import { AttributeUpdater } from '@kit.ArkUI'

export class GalleryContentAnimatedTransition<Attribute extends CommonMethod<Attribute>> implements SwiperContentAnimatedTransition {
  timeout: number
  private galleryAttributeUpdate: GalleryAttributeUpdate<Attribute>[] = []

  constructor(count: number = 1, positionScale: number = 0.8, positionScaleOffset: number = 1, timeout: number = 3000) {
    this.timeout = timeout

    let initPos = 0
    for (let index = 0; index < count; index++) {
      initPos = index > count / 2 ? index - count : index
      this.galleryAttributeUpdate[index] =
        new GalleryAttributeUpdate(index, initPos, positionScale, positionScaleOffset)

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
  private readonly positionScaleOffset: number = 1
  private readonly positionScale: number = 0.8
  private readonly maxScale: number = 1.0
  private index: number = -1
  private initPosition: number = 0

  constructor(index: number, initPosition: number, positionScale: number = 0.8, positionScaleOffset: number = 1) {
    super()
    this.index = index
    this.positionScale = positionScale
    this.positionScaleOffset = positionScaleOffset
    this.initPosition = initPosition
  }

  initializeModifier(instance: Attribute): void {
    this.innerGallery(instance, this.initPosition)
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
    let linearSlope = Math.sin(position) * (this.positionScale - this.maxScale) / this.positionScaleOffset
    // console.info(`linearSlope: ${linearSlope} pos: ${position}`)
    let scaleValue = linearSlope * position + this.maxScale
    let maxScaleValue = this.maxScale
    let minScaleValue = this.positionScale
    if (this.maxScale < this.positionScale) {
      maxScaleValue = this.positionScale
      minScaleValue = this.maxScale
    }
    scaleValue = scaleValue >= maxScaleValue ? maxScaleValue : (scaleValue < minScaleValue ? minScaleValue : scaleValue)
    return scaleValue
  }
}