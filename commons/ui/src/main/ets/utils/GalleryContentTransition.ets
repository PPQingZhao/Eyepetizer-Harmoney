import { AttributeUpdater } from '@kit.ArkUI'
import { ArrayList } from '@kit.ArkTS'
import { OnGalleryItemSizeChangeCallback } from '../components/Gallery'

export class GalleryContentAnimatedTransition<Attribute extends CommonMethod<Attribute>>
implements SwiperContentAnimatedTransition, DataChangeListener, OnGalleryItemSizeChangeCallback {
  timeout: number
  private galleryAttributeUpdates: ArrayList<GalleryAttributeUpdate<Attribute>> = new ArrayList()
  private galleryDataSource: IDataSource
  private readonly disPlayCount: number
  private readonly itemSpace: number
  private readonly nextGalleryMargin: number
  private readonly preGalleryMargin: number
  private readonly nextGalleryInfo: GalleryInfo
  private readonly preGalleryInfo: GalleryInfo

  constructor(galleryDataSource: IDataSource,
    disPlayCount: number = 1,
    itemSpace: number = 0,
    nextGalleryMargin: number,
    preGalleryMargin: number,
    nextGalleryInfo: GalleryInfo = {
      positionScale: 1.0,
      positionScaleOffset: 1,
    },
    preGalleryInfo: GalleryInfo = {
      positionScale: 1.0,
      positionScaleOffset: 1,
    },
    timeout: number = 3000) {
    this.galleryDataSource = galleryDataSource
    this.galleryDataSource.registerDataChangeListener(this)
    this.timeout = timeout
    this.disPlayCount = disPlayCount
    this.itemSpace = itemSpace
    this.nextGalleryMargin = nextGalleryMargin
    this.preGalleryMargin = preGalleryMargin
    this.nextGalleryInfo = nextGalleryInfo
    this.preGalleryInfo = preGalleryInfo

    this.onDataReloaded()
  }

  onDataReloaded(): void {
    this.galleryAttributeUpdates.clear()
    for (let index = 0; index < this.galleryDataSource.totalCount(); index++) {
      this.galleryAttributeUpdates.add(
        new GalleryAttributeUpdate(this.nextGalleryInfo, this.preGalleryInfo, this.itemSpace))
    }
  }

  onDataAdded(index: number): void {
    this.onDataAdd(index)
  }

  private calPositionByDisPlayCountWithIndex(index: number): number {
    return this.calPositionByDisPlayCount(this.calProxyPositionByCount(index))
  }

  private calProxyPositionByCount(index: number): number {
    let count = this.galleryDataSource.totalCount()
    return index > count / 2 ? index - count : index
  }

  private calPositionByDisPlayCount(position: number) {
    let pos = position
    if (position > this.disPlayCount - 1) {
      pos = position - (this.disPlayCount - 1)
    } else if (position > 0) {
      pos = 0
    }
    return pos
  }

  onDataAdd(index: number): void {
    this.galleryAttributeUpdates.insert(new GalleryAttributeUpdate(this.nextGalleryInfo, this.preGalleryInfo,
      this.itemSpace), index)
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
      this.galleryAttributeUpdates[i].gallery(this.calProxyPositionByCount(i),
        this.calPositionByDisPlayCountWithIndex(i))
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

  onSizeChange(index: number, oldValue: SizeOptions, newValue: SizeOptions): void {
    this.galleryAttributeUpdates[index].gallery(this.calProxyPositionByCount(index),
      this.calPositionByDisPlayCountWithIndex(index), newValue.width as number)
  }

  transition: Callback<SwiperContentTransitionProxy, void> = (proxy: SwiperContentTransitionProxy) => {
    const position = this.calPositionByDisPlayCount(proxy.position)
    // console.info(`=======================> index: ${proxy.index}  position: ${proxy.position} --  ${position} selectionIndex: ${proxy.selectedIndex}`)
    this.galleryAttributeUpdates[proxy.index].gallery(proxy.position, position, proxy.mainAxisLength)
  }
}

class GalleryAttributeUpdate<Attribute extends CommonMethod<Attribute>> extends AttributeUpdater<Attribute> {
  private readonly maxScale: number = 1.0
  private mainAxisLength: number = 0
  private isInit = false
  private readonly itemSpace: number
  private readonly nextGalleryInfo: GalleryInfo
  private readonly preGalleryInfo: GalleryInfo

  constructor(nextGalleryInfo: GalleryInfo, preGalleryInfo: GalleryInfo, itemSpace: number) {
    super()
    this.nextGalleryInfo = nextGalleryInfo
    this.preGalleryInfo = preGalleryInfo
    this.itemSpace = itemSpace
  }

  initializeModifier(instance: Attribute): void {
    this.isInit = true
    // this.innerGallery(this.initPosition, this.initPosition, 0)
  }

  gallery(proxyPosition: number, position: number, mainAxisLength: number = this.mainAxisLength) {
    this.mainAxisLength = mainAxisLength
    this.innerGallery(proxyPosition, position, mainAxisLength)
  }

  private innerGallery(proxyPosition: number, position: number, mainAxisLength: number) {
    if (!this.isInit || this.attribute == null) {
      return
    }
    this.attribute.zIndex(0 <= position && position <= 0.5 ? 1 : 0)
    // 缩放
    let xScaleValue = this.calcScaleValue(position)
    let yScaleValue = this.calcScaleValue(position)
    this.attribute.scale({ x: xScaleValue, y: yScaleValue })
    // 平移
    let translateValue = this.calcTranslateValue(proxyPosition, position, mainAxisLength, xScaleValue)
    this.attribute.translate({ x: translateValue })
  }

  private getGalleryInfo(position: number) {
    return position < 0 ? this.preGalleryInfo : this.nextGalleryInfo
  }

  /**
   * 计算position位置的缩放量
   * @param position
   * @returns
   */
  private calcScaleValue(position: number): number {
    const galleryInfo = this.getGalleryInfo(position)
    let linearSlope =
      Math.sign(position) * (galleryInfo.positionScale - this.maxScale) / galleryInfo.positionScaleOffset
    // console.info(`linearSlope: ${linearSlope} pos: ${position}`)
    let scaleValue = linearSlope * position + this.maxScale
    let maxScaleValue = this.maxScale
    let minScaleValue = galleryInfo.positionScale
    if (this.maxScale < galleryInfo.positionScale) {
      maxScaleValue = galleryInfo.positionScale
      minScaleValue = this.maxScale
    }
    scaleValue = scaleValue >= maxScaleValue ? maxScaleValue : (scaleValue < minScaleValue ? minScaleValue : scaleValue)
    return scaleValue
  }

  /**
   * 每一个item首尾相连,再计算itemSpace
   * @param position
   * @param mainAxisLength
   * @param xScaleValue
   * @returns
   */
  private calcTranslateValue(proxyPosition: number, position: number, mainAxisLength: number,
    xScaleValue: number): number {
    // 1表示next条目进场  -1表示previous条目进场
    const sign = Math.sign(position)
    // 当前缩放后的item左边与未缩放状态左边对齐
    let translateValue = -sign * mainAxisLength * (1 - xScaleValue) / 2
    // 分割线
    const itemSpace = proxyPosition * this.itemSpace
    console.info(`proxyPosition:  ${proxyPosition} position: ${position} itemSpace:${itemSpace}   GalleryContentAnimatedTransition`)

    translateValue = translateValue + itemSpace
    let indexScaleValue = 0.0
    const startIndex = Math.abs(position) - 1
    // 计算position前面所有item(从position等于0到当前position前一个)的偏移量总和
    for (let index = startIndex; index > 0; index--) {
      indexScaleValue = this.calcScaleValue(sign * index)
      translateValue = translateValue + (-sign * (mainAxisLength) * (1 - indexScaleValue))
      // console.info(`index: ${index}  indexScaleValue: ${indexScaleValue} translateValue: ${translateValue}`)
    }
    console.info(`position: ${position}  translateValue: ${translateValue}   GalleryContentAnimatedTransition`)

    return translateValue
  }
}

export interface GalleryInfo {
  positionScale: number
  positionScaleOffset: number,
}