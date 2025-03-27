import { BaseComponentViewModel } from 'ui/src/main/ets/utils/BaseComponentViewModel';
import { SimpleDataSource } from 'ui/src/main/ets/utils/DataSource';
import { ItemType } from 'ui/src/main/ets/utils/Item';
import { MetroSwiperItemType } from 'eyesource/src/main/ets/viewModel/MetroSwipeItemType'

@ObservedV2
export class RecommendViewModel extends BaseComponentViewModel {
  dataSources: SimpleDataSource<ItemType> = new  SimpleDataSource<ItemType>()

  onFirstAppear(): void {
    const dataList: ItemType[] = []
    for (let index = 0; index < 1; index++) {
      dataList[index] = new MetroSwiperItemType({ text: `index: ${index}` })
    }
    this.dataSources.pushDataList(dataList)
  }

}
