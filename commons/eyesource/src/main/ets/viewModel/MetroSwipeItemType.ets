import { MetroSwiperItemViewModel } from 'ui/src/main/ets/view/MetroSwiperItemView'
import { ItemType } from 'ui/src/main/ets/utils/Item'
import { Metro_data } from 'eyesource/src/main/ets/bean/PageDataBean'

export class MetroSwiperItemType extends MetroSwiperItemViewModel implements ItemType {
  constructor(metro: Metro_data) {
    super([`${metro.text} ===   0`,`${metro.text}===   1`,`${metro.text}===   2`,`${metro.text}===   3`])
  }

  getItemType(): string {
    return 'swiper'
  }
}