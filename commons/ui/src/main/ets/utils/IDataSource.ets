import { List } from '@kit.ArkTS';

export class SimpleDataSource<Data> implements IDataSource {
  dataList: List<Data> = new List()

  constructor(dList: Data[]) {
    dList.forEach(value => {
      this.dataList.add(value)
    });
  }

  getData(index: number): Data {
    return this.dataList[index]
  }

  totalCount(): number {
    return this.dataList.length
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}