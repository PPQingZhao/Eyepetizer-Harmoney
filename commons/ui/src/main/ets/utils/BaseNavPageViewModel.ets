import { NavDestinationLifecycle } from 'ui/src/main/ets/components/LifecycleNavDestination';

export abstract class BaseNavPageViewModel implements NavDestinationLifecycle {
  private isFirstAppear = false

  abstract onFirstAppear(): void

  onWillAppear(): void {
  }

  onAppear(): void {
    if (!this.isFirstAppear) {
      this.onFirstAppear()
      this.isFirstAppear = true
    }
  }

  onWillShow(): void {
  }

  onShow(): void {
  }

  onWillHide(): void {
  }

  onHidden(): void {
  }

  onWillDisappear(): void {
  }

  onDisappear(): void {
  }
}