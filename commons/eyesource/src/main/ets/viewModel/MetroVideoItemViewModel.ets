import { MetroVideoItemViewModel } from 'ui/src/main/ets/view/MetroLargeVideoItemView'
import { ItemType } from 'ui/src/main/ets/utils/Item'
import { Metro_data } from 'eyesource/src/main/ets/bean/PageDataBean'

export class MetroVideoItemType extends MetroVideoItemViewModel implements ItemType {
  constructor(metro: Metro_data) {
    super()
    metro.text
  }

  getItemType(): string {
    return ''
  }


}
