import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';
import { MetroLargeVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView';

@ObservedV2
export class TabContentViewModel {
  tabModels: TabModel<TabInfo>[] = [
    createTabModel($r('app.string.recommend')),
    createTabModel($r('app.string.follow')),
    createTabModel($r('app.string.daily')),
  ]
  dataSources: MetroDataSource

  constructor() {
    let dataArr: MetroLargeVideoItemViewModel[] = []
    for (let index = 0; index < 100; index++) {
      dataArr[index] =
        new MetroLargeVideoItemViewModel('', '', index % 2 == 0 ? '大概多少空间埃及共和国开始就看到技术开发健康减肥' :
          '就是分红i很疯狂都快散架了可见度立刻就大家拉萨解放了',
          '全球广告精选 ' + index,
          '#广告', '05:34'
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
  private dataList: MetroLargeVideoItemViewModel[]

  constructor(tabModels: MetroLargeVideoItemViewModel[]) {
    this.dataList = tabModels
  }

  totalCount(): number {
    return this.dataList.length
  }

  getData(index: number): MetroLargeVideoItemViewModel {
    return this.dataList[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}