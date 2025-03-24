import { LifecycleComponent } from 'ui/src/main/ets/components/LifecycleComponent'
import { FollowViewModel } from '../viewModel/FollowViewModel'


@ComponentV2
export struct Follow {
  private viewModel: FollowViewModel = new FollowViewModel()

  @Builder
  private ContentBuilder() {
    Text('Follow')
      .textAlign(TextAlign.Center)
      .width('100%')
      .height('100%')
      .fontColor(Color.Green)
  }

  build() {
    LifecycleComponent({
      contentView: () => {
        this.ContentBuilder()
      },
      lifecycle: this.viewModel
    })
  }
}