export interface NavDestinationLifecycle {
  onWillAppear(): void;

  onAppear(): void;

  onWillShow(): void;

  onShow(): void;

  onWillHide(): void;

  onHidden(): void;

  onWillDisappear(): void;

  onDisappear(): void;

}

@ComponentV2
export struct LifecycleNavDestination {
  @BuilderParam contentParam: () => void
  @Param lifecycle?: NavDestinationLifecycle = undefined

  build() {
    NavDestination() {
      this.contentParam()
    }
    .hideTitleBar(true)
    .onWillAppear(this.lifecycle?.onWillAppear)
    .onAppear(this.lifecycle?.onAppear)
    .onWillShow(this.lifecycle?.onWillShow)
    .onShown(this.lifecycle?.onShow)
    .onWillHide(this.lifecycle?.onWillHide)
    .onHidden(this.lifecycle?.onHidden)
    .onWillDisappear(this.lifecycle?.onWillDisappear)
    .onDisAppear(this.lifecycle?.onDisappear)
  }
}


