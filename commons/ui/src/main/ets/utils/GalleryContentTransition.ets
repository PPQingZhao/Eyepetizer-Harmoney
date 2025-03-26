import { AttributeUpdater } from '@kit.ArkUI'
import { ArrayList } from '@kit.ArkTS'

export class GalleryContentAnimatedTransition<Attribute extends CommonMethod<Attribute>>
implements SwiperContentAnimatedTransition, DataChangeListener {
  timeout: number
  private galleryAttributeUpdates: ArrayList<GalleryAttributeUpdate<Attribute>> = new ArrayList()
  private galleryDataSource: IDataSource
  private readonly positionScaleOffset: number = 1
  private readonly positionScale: number = 0.8

  constructor(galleryDataSource: IDataSource, positionScale: number = 0.8, positionScaleOffset: number = 1,
    timeout: number = 3000) {
    this.galleryDataSource = galleryDataSource
    this.timeout = timeout
    this.positionScale = positionScale
    this.positionScaleOffset = positionScaleOffset

    this.onDataReloaded()
  }

  onDataReloaded(): void {
    let initPos = 0
    let count = this.galleryDataSource.totalCount()
    this.galleryAttributeUpdates.clear()
    for (let index = 0; index < count; index++) {
      initPos = index > count / 2 ? index - count : index
      this.galleryAttributeUpdates.add(
        new GalleryAttributeUpdate(index, initPos, this.positionScale, this.positionScaleOffset))
    }
  }

  onDataAdded(index: number): void {
    this.onDataAdd(index)
  }

  onDataAdd(index: number): void {
    let count = this.galleryDataSource.totalCount()
    let initPos = index > count / 2 ? index - count : index
    this.galleryAttributeUpdates.insert(new GalleryAttributeUpdate(index, initPos, this.positionScale,
      this.positionScaleOffset), index)
  }

  onDataMoved(from: number, to: number): void {
    this.onDataMove(from, to)
  }

  onDataMove(from: number, to: number): void {
    let fromData = this.galleryAttributeUpdates[from]
    let toData = this.galleryAttributeUpdates[to]
    this.galleryAttributeUpdates[from] = toData
    this.galleryAttributeUpdates[to] = fromData
  }

  onDataDeleted(index: number): void {
    this.onDataDelete(index)
  }

  onDataDelete(index: number): void {
    this.galleryAttributeUpdates.removeByIndex(index)
    for (let i = index; i < this.galleryAttributeUpdates.length; i++) {
      this.galleryAttributeUpdates[i].gallery(i)
    }
  }

  onDataChanged(index: number): void {
  }

  onDataChange(index: number): void {
  }

  onDatasetChange(dataOperations: DataOperation[]): void {
    dataOperations.forEach((operate) => {
      switch (operate.type) {
        case DataOperationType.ADD:
          this.onDataAdd(operate.index)
          break
        case DataOperationType.DELETE:
          this.onDataDeleted(operate.index)
          break
        case DataOperationType.MOVE:
          let moveOperate = operate as DataMoveOperation
          this.onDataMove(moveOperate.index.from, moveOperate.index.to)
          break
      }
    })
  }

  getGalleryItemAttribute(index: number): AttributeModifier<Attribute> {
    return this.galleryAttributeUpdates[index]
  }


  transition: Callback<SwiperContentTransitionProxy, void> = (proxy: SwiperContentTransitionProxy) => {
    this.galleryAttributeUpdates[proxy.index].gallery(proxy.position)
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
}