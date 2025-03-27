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
    this.galleryDataSource.registerDataChangeListener(this)
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
        new GalleryAttributeUpdate(initPos, this.positionScale, this.positionScaleOffset))
    }
  }

  onDataAdded(index: number): void {
    this.onDataAdd(index)
  }

  private calPosition(index: number) {
    let count = this.galleryDataSource.totalCount()
    let initPos = index > count / 2 ? index - count : index
    return initPos
  }

  onDataAdd(index: number): void {
    this.galleryAttributeUpdates.insert(new GalleryAttributeUpdate(this.calPosition(index), this.positionScale,
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
      this.galleryAttributeUpdates[i].gallery(i, 0)
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

  gallery(index: number, size: SizeOptions) {
    this.galleryAttributeUpdates[index].gallery(this.calPosition(index), size.width as number)
  }

  transition: Callback<SwiperContentTransitionProxy, void> = (proxy: SwiperContentTransitionProxy) => {
    console.info(`=======================> index: ${proxy.index}  position: ${proxy.position} selectionIndex: ${proxy.selectedIndex}`)
    this.galleryAttributeUpdates[proxy.index].gallery(proxy.position, proxy.mainAxisLength)
  }
}


class GalleryAttributeUpdate<Attribute extends CommonMethod<Attribute>> extends AttributeUpdater<Attribute> {
  private readonly positionScaleOffset: number = 1
  private readonly positionScale: number = 0.8
  private readonly maxScale: number = 1.0
  private initPosition: number = 0

  constructor(initPosition: number, positionScale: number = 0.8, positionScaleOffset: number = 1) {
    super()
    this.positionScale = positionScale
    this.positionScaleOffset = positionScaleOffset
    this.initPosition = initPosition
  }

  initializeModifier(instance: Attribute): void {
    this.innerGallery(instance, this.initPosition, 0)
  }

  gallery(position: number, mainAxisLength: number) {
    this.innerGallery(this.attribute!!, position, mainAxisLength)
  }

  private innerGallery(attribute: Attribute, position: number, mainAxisLength: number) {
    attribute.zIndex(0 <= position && position <= 0.5 ? 1 : 0)
    // 缩放
    let xScaleValue = this.calcScaleValue(position)
    let yScaleValue = this.calcScaleValue(position)
    attribute.scale({ x: xScaleValue, y: yScaleValue })
    // 平移
    let translateValue = this.calcTranslateValue(position, mainAxisLength, xScaleValue)
    attribute.translate({ x: translateValue })
  }

  /**
   * 计算position位置的缩放量
   * @param position
   * @returns
   */
  private calcScaleValue(position: number): number {
    let linearSlope = Math.sign(position) * (this.positionScale - this.maxScale) / this.positionScaleOffset
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

  /**
   * 每一个item与左右两个item相连
   * @param position
   * @param mainAxisLength
   * @param xScaleValue
   * @returns
   */
  private calcTranslateValue(position: number, mainAxisLength: number, xScaleValue: number): number {
    console.info(`===========> position: ${position} xScaleValue:${xScaleValue}}`)
    const sign = -1 * Math.sign(position)
    // 当前缩放后的item左边与未缩放状态左边对齐
    let translateValue = sign * mainAxisLength * (1 - xScaleValue) / 2
    let indexScaleValue = 0.0
    const startIndex = Math.abs(position) - 1
    // 计算position前面所有item(从position等于0到当前position前一个)的偏移量总和
    for (let index = startIndex; index > 0; index--) {
      indexScaleValue = this.calcScaleValue(index)
      translateValue = translateValue + sign * mainAxisLength * (1 - indexScaleValue)
      console.info(`index: ${index}  idnexScaleValue: ${indexScaleValue} translateValue: ${translateValue}`)
    }
    console.info(`GalleryContentAnimatedTransition  position: ${position}  translateValue: ${translateValue}`)

    return translateValue
  }
}