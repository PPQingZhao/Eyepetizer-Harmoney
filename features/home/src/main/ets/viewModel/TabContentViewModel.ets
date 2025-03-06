import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';
import { MetroVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView';
import { ItemType } from 'ui/src/main/ets/utils/Item';

@ObservedV2
export class TabContentViewModel {
  tabModels: TabModel<TabInfo>[] = [
    createTabModel($r('app.string.recommend')),
    createTabModel($r('app.string.follow')),
    createTabModel($r('app.string.daily')),
  ]
  dataSources: MetroDataSource

  constructor() {
    let dataArr: MetroItemType[] = []
    for (let index = 0; index < 100; index++) {
      dataArr[index] =
        new MetroItemType('', '', index % 2 == 0 ? '大概多少空间埃及共和国开始就看到技术开发健康减肥' :
          '就是分红i很疯狂都快散架了可见度立刻就大家拉萨解放了',
          '全球广告精选 ' + index,
          '#广告', '05:34', index % 3 == 0 ? 'large' : 'small'
        )
    }

    this.dataSources = new MetroDataSource(dataArr)
  }

  tabDataSource: TabDataSource = new TabDataSource(this.tabModels)
}

export class TabDataSource implements IDataSource {
  private tabModels: TabModel<TabInfo>[]

  constructor(tabModels: TabModel<TabInfo>[]) {
    this.tabModels = tabModels
  }

  totalCount(): number {
    return this.tabModels.length
  }

  getData(index: number): TabModel<TabInfo> {
    return this.tabModels[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

export class MetroDataSource implements IDataSource {
  private dataList: MetroVideoItemViewModel[]

  constructor(tabModels: MetroVideoItemViewModel[]) {
    this.dataList = tabModels
  }

  totalCount(): number {
    return this.dataList.length
  }

  getData(index: number): MetroVideoItemViewModel {
    return this.dataList[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

export class MetroItemType extends MetroVideoItemViewModel implements ItemType {
  private itemType: string = ''

  constructor(cover: string = '', avatar: string = '', title: string = '', nickName: string = '', tag: string = '',
    duration: string = '', type: string) {
    super();
    this.cover = cover
    this.avatar = avatar
    this.title = title
    this.nickName = nickName
    this.tag = tag
    this.duration = duration
    this.itemType = type
  }

  getItemType(): string {
    return this.itemType
  }
}