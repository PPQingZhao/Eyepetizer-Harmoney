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
  private readonly nextGalleryInfo: GalleryInfo
  private readonly preGalleryInfo: GalleryInfo

  constructor(galleryDataSource: IDataSource,
    disPlayCount: number = 1,
    itemSpace: number = 0,
    nextGalleryInfo: GalleryInfo = {
      positionScale: 1.0,
      positionScaleOffset: 1,
      galleryMargin: 0
    },
    preGalleryInfo: GalleryInfo = {
      positionScale: 1.0,
      positionScaleOffset: 1,
      galleryMargin: 0
    },
    timeout: number = 3000) {
    this.galleryDataSource = galleryDataSource
    this.galleryDataSource.registerDataChangeListener(this)
    this.timeout = timeout
    this.disPlayCount = disPlayCount
    this.itemSpace = itemSpace
    this.nextGalleryInfo = nextGalleryInfo
    this.preGalleryInfo = preGalleryInfo

    this.onDataReloaded()
  }

  onDataReloaded(): void {
    this.galleryAttributeUpdates.clear()
    for (let index = 0; index < this.galleryDataSource.totalCount(); index++) {
      this.galleryAttributeUpdates.add(
        new GalleryAttributeUpdate(this.disPlayCount, this.nextGalleryInfo, this.preGalleryInfo, this.itemSpace))
    }
  }

  onDataAdded(index: number): void {
    this.onDataAdd(index)
  }

  onDataAdd(index: number): void {
    this.galleryAttributeUpdates.insert(new GalleryAttributeUpdate(this.disPlayCount, this.nextGalleryInfo,
      this.preGalleryInfo,
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
      this.galleryAttributeUpdates[i].gallery(this.calProxyPositionByCount(i))
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
    this.galleryAttributeUpdates[index].gallery(this.calProxyPositionByCount(index), newValue.width as number)
  }

  private calProxyPositionByCount(index: number): number {
    const count = this.galleryDataSource.totalCount()
    return index > count / 2 ? index - count : index
  }

  transition: Callback<SwiperContentTransitionProxy, void> = (proxy: SwiperContentTransitionProxy) => {
    // console.info(`=======================> index: ${proxy.index}  position: ${proxy.position} --  ${position} selectionIndex: ${proxy.selectedIndex}`)
    this.galleryAttributeUpdates[proxy.index].gallery(proxy.position, proxy.mainAxisLength)
  }
}

class GalleryAttributeUpdate<Attribute extends CommonMethod<Attribute>> extends AttributeUpdater<Attribute> {
  private readonly maxScale: number = 1.0
  private mainAxisLength: number = 0
  private isInit = false
  private readonly itemSpace: number
  private readonly nextGalleryInfo: GalleryInfo
  private readonly preGalleryInfo: GalleryInfo
  private readonly disPlayCount: number = 1

  constructor(displayCount: number, nextGalleryInfo: GalleryInfo, preGalleryInfo: GalleryInfo, itemSpace: number) {
    super()
    this.disPlayCount = displayCount
    this.nextGalleryInfo = nextGalleryInfo
    this.preGalleryInfo = preGalleryInfo
    this.itemSpace = itemSpace
  }

  initializeModifier(instance: Attribute): void {
    this.isInit = true
    // this.innerGallery(this.initPosition, this.initPosition, 0)
  }

  gallery(proxyPosition: number, mainAxisLength: number = this.mainAxisLength) {
    this.mainAxisLength = mainAxisLength
    this.innerGallery(proxyPosition, mainAxisLength)
  }

  private innerGallery(proxyPosition: number, mainAxisLength: number) {
    if (!this.isInit || this.attribute == null) {
      return
    }
    const position = this.calPositionByDisPlayCount(proxyPosition)
    this.attribute.zIndex(-0.5 <= position && position <= 0.5 ? 1 : 0)
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

  private calcGalleryMargin(position: number) {
    const galleryInfo = this.getGalleryInfo(position)
    let galleryMargin = 0
    if (position < -1 || position > 1) {
      galleryMargin = -Math.sign(position) * (galleryInfo.galleryMargin + this.itemSpace)
    } else {
      galleryMargin = -(galleryInfo.galleryMargin + this.itemSpace) * position
    }
    return galleryMargin
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
    let translateValue = -sign * mainAxisLength * (1 - xScaleValue) * 0.5
    // 分割线
    const itemSpace = (proxyPosition - (this.disPlayCount - 1) * 0.5) * this.itemSpace
    translateValue = translateValue + itemSpace
    // gallery margin
    const galleryMargin = this.calcGalleryMargin(position)
    // console.info(`proxyPosition:  ${proxyPosition} position: ${position} galleryMargin:${galleryMargin}   GalleryContentAnimatedTransition`)
    translateValue = translateValue + galleryMargin
    let indexScaleValue = 0.0
    const startIndex = Math.abs(position) - 1
    // 计算position前面所有item(从position等于0到当前position前一个)的偏移量总和
    for (let index = startIndex; index > 0; index--) {
      indexScaleValue = this.calcScaleValue(sign * index)
      translateValue = translateValue + (-sign * (mainAxisLength) * (1 - indexScaleValue))
      // console.info(`index: ${index}  indexScaleValue: ${indexScaleValue} translateValue: ${translateValue}`)
    }
    // console.info(`position: ${position}  translateValue: ${translateValue}   GalleryContentAnimatedTransition`)

    return translateValue
  }

  private calPositionByDisPlayCount(proxyPosition: number) {
    let pos = proxyPosition
    if (proxyPosition > this.disPlayCount - 1) {
      pos = proxyPosition - (this.disPlayCount - 1)
    } else if (proxyPosition > 0) {
      pos = 0
    }
    return pos
  }
}

export interface GalleryInfo {
  positionScale: number
  positionScaleOffset: number,
  galleryMargin: number,
}