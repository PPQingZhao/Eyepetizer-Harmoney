import { ComponentLifecycle } from 'ui/src/main/ets/components/LifecycleComponent';

export abstract class BaseComponentViewModel implements ComponentLifecycle {
  private isFirstAppear = false

  abstract onFirstAppear(): void

  aboutToAppear(): void {
    if (!this.isFirstAppear) {
      this.onFirstAppear()
      this.isFirstAppear = true
    }
  }

  aboutToDisappear(): void {
  }

  aboutToRecycle(): void {
  }

  aboutToReuse(params: Record<string, ESObject>): void {
  }
}