export interface ComponentLifecycle {

  onFirstAppear(): void;

  aboutToAppear(): void;

  aboutToDisappear(): void;

  aboutToRecycle(): void;

  aboutToReuse(params: Record<string, ESObject>): void;

}

@ComponentV2
export struct LifecycleComponent {
  @BuilderParam contentView: () => void
  @Param lifecycle?: ComponentLifecycle = undefined

  aboutToAppear(): void {
    this.lifecycle?.aboutToAppear()
  }

  aboutToDisappear(): void {
    this.lifecycle?.aboutToDisappear()
  }

  aboutToReuse(params: Record<string, ESObject>): void {
    this.lifecycle?.aboutToReuse(params)
  }

  aboutToRecycle(): void {
    this.lifecycle?.aboutToRecycle()
  }

  build() {
    this.contentView()
  }
}


