import { TabInfo, TabModel } from 'ui';
import { createTabModel } from 'ui/src/main/ets/tab/TabModel';
import { MetroVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView';
import { MetroSwiperItemViewModel } from 'ui/src/main/ets/view/MetroSwiperItemView';
import { ItemType } from 'ui/src/main/ets/utils/Item';
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
  dataSources: SimpleDataSource<ItemType>

  constructor() {
    super();
    let dataArr: ItemType[] = []
    for (let index = 0; index < 100; index++) {

      dataArr[index] = index == 1 ? new MetroSwiperItemType(['0', '1', '2', '3', '4', '5']) :
        new MetroItemType('', '', index % 2 == 0 ? '大概多少空间埃及共和国开始就看到技术开发健康减肥' :
          '就是分红i很疯狂都快散架了可见度立刻就大家拉萨解放了',
          '全球广告精选 ' + index,
          '#广告', '05:34', index % 3 == 0 ? 'large' : 'small'
        )
    }

    this.dataSources = new SimpleDataSource<ItemType>(dataArr)
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

  onWillAppear(): void {
    console.info('onWillAppear==============================>')
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

export class MetroSwiperItemType extends MetroSwiperItemViewModel implements ItemType {
  getItemType(): string {
    return 'swiper'
  }
}