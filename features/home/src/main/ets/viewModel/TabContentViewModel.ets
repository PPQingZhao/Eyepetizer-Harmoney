import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';
import { SimpleDataSource } from 'ui/src/main/ets/utils/IDataSource';

export enum TabType {
  Recommend = 'recommend',
  Follow = 'follow',
  DailyIssue = 'dailyIssue',
}

@ObservedV2
export class TabContentViewModel {
  tabModels: TabModel<TabInfo>[] = [
    createTabModel($r('[ui].string.recommend'), TabType.Recommend),
    createTabModel($r('[ui].string.follow'), TabType.Follow),
    createTabModel($r('[ui].string.daily'), TabType.DailyIssue),
  ]

  tabDataSource: SimpleDataSource<TabModel<TabInfo>> = new SimpleDataSource<TabModel<TabInfo>>(this.tabModels)
  private curIndex = 0

  getCurIndex() {
    return this.curIndex
  }

  selectedTab(index: number) {
    const targetTabModel = this.tabModels[index]
    let oldTabModel = this.tabModels[this.curIndex]

    oldTabModel.isSelected = false
    targetTabModel.isSelected = true
    this.curIndex = index
  }
}

