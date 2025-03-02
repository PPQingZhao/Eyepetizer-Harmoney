import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';

@ObservedV2
export class TabContentViewModel {
  tabModels: TabModel<TabInfo>[] = [
    createTabModel($r('app.string.recommend')),
    createTabModel($r('app.string.follow')),
    createTabModel($r('app.string.daily')),
  ]
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