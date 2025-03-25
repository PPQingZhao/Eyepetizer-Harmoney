import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';
import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource';

export enum TabType {
  Recommend = 'recommend',
  Follow = 'follow',
  DailyIssue = 'dailyIssue',
}

@ObservedV2
export class TabContentViewModel {
  tabDataSource: SimpleDataSource<TabModel<TabInfo>> = new SimpleDataSource<TabModel<TabInfo>>()
  private curIndex = 0

  constructor() {
    this.tabDataSource.pushData(createTabModel($r('[ui].string.recommend'), TabType.Recommend),
      createTabModel($r('[ui].string.follow'), TabType.Follow),
      createTabModel($r('[ui].string.daily'), TabType.DailyIssue),)
  }

  getCurIndex() {
    return this.curIndex
  }

  selectedTab(index: number) {
    const targetTabModel = this.tabDataSource.getData(index)
    let oldTabModel = this.tabDataSource.getData(this.curIndex)

    oldTabModel.isSelected = false
    targetTabModel.isSelected = true
    this.curIndex = index
  }
}

