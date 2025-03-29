import { MetroSwiperItemViewModel } from 'ui/src/main/ets/view/MetroSwiperItemView'
import { ItemType } from 'ui/src/main/ets/utils/Item'
import { Metro_data } from 'eyesource/src/main/ets/bean/PageDataBean'

export class MetroSwiperItemType extends MetroSwiperItemViewModel implements ItemType {
  constructor(metro: Metro_data) {
    const data: string[] = []
    for (let index = 0; index < 9; index++) {
      data[index] = index.toString()
    }
    super(data)
  }

  getItemType(): string {
    return 'swiper'
  }
}