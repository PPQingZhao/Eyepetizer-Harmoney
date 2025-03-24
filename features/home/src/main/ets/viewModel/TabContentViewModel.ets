import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';
import { SimpleDataSource } from 'ui/src/main/ets/utils/IDataSource';
import { BaseNavPageViewModel } from 'ui/src/main/ets/utils/BaseNavPageViewModel';

export enum TabType {
  Recommend = 'recommend',
  Follow = 'follow',
  DailyIssue = 'dailyIssue',
}

@ObservedV2
export class TabContentViewModel extends BaseNavPageViewModel {
  tabModels: TabModel<TabInfo>[] = [
    createTabModel($r('[ui].string.recommend'), TabType.Recommend),
    createTabModel($r('[ui].string.follow'), TabType.Follow),
    createTabModel($r('[ui].string.daily'), TabType.DailyIssue),
  ]

  onFirstAppear(): void {
    console.info('onFirstAppear==============================>')
  }

  tabDataSource: SimpleDataSource<TabModel<TabInfo>> = new SimpleDataSource<TabModel<TabInfo>>(this.tabModels)
  private curTabModel: TabModel<TabInfo> = this.tabModels[0]

  selectedTab(index: number) {
    const targetTabModel = this.tabModels[index]
    let tempTabModel = this.curTabModel
    this.curTabModel = targetTabModel

    tempTabModel.isSelected = false
    this.curTabModel.isSelected = true
  }
}

