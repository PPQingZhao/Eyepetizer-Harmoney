export class SimpleDataSource<Data> implements IDataSource {
  private dataList: Data[] = []
  private listeners: DataChangeListener[] = []

  pushData(...dList: Data[]) {
    this.pushDataList(dList)
  }

  pushDataList(dList: Data[]) {
    let start: number = this.totalCount() - 1
    dList.forEach((d) => {
      this.dataList.push(d)
    })
    let count = dList.length
    notifyDatasetChange(this.listeners, [{ type: DataOperationType.ADD, index: start, count: count }])
  }

  push(data: Data) {
    this.dataList.push(data)
    notifyDataAdd(this.listeners, this.dataList.length - 1)
  }

  delete(index: number) {
    this.dataList.splice(index, 1)
    notifyDataDelete(this.listeners, index)
  }

  deleteData(d: Data) {
    let pos = this.dataList.indexOf(d)
    if (pos >= 0) {
      this.delete(pos)
    }
  }

  update(index: number, data: Data) {
    this.dataList[index] = data
    notifyDataChange(this.listeners, index)
  }

  deleteAllData() {
    this.dataList.splice(0, this.totalCount())
    notifyDataReloaded(this.listeners)
  }

  getData(index: number): Data {
    return this.dataList[index]
  }

  totalCount(): number {
    return this.dataList.length
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) >= 0) {
      return
    }
    this.listeners.push(listener)
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos < 0) {
      return
    }
    this.listeners.splice(pos, 1)
  }
}

function notifyDataAdd(listeners: DataChangeListener[], index: number) {
  listeners.forEach((l) => {
    l.onDataAdd(index)
  })
}

function notifyDataDelete(listeners: DataChangeListener[], index: number) {
  listeners.forEach((l) => {
    l.onDataDelete(index)
  })
}

function notifyDataChange(listeners: DataChangeListener[], index: number) {
  listeners.forEach((l) => {
    l.onDataChange(index)
  })
}

function notifyDataMove(listeners: DataChangeListener[], from: number, to: number) {
  listeners.forEach((l) => {
    l.onDataMove(from, to)
  })
}

function notifyDatasetChange(listeners: DataChangeListener[], dataOperations: DataOperation[]) {
  listeners.forEach((l) => {
    l.onDatasetChange(dataOperations)
  })
}

function notifyDataReloaded(listeners: DataChangeListener[]) {
  listeners.forEach((l) => {
    l.onDataReloaded()
  })
}