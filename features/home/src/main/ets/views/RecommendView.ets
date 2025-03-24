import { LifecycleComponent } from 'ui/src/main/ets/components/LifecycleComponent'
import { RecommendViewModel } from '../viewModel/RecommendViewModel'

@ComponentV2
export struct Recommend {
  private viewModel: RecommendViewModel = new RecommendViewModel()

  @Builder
  private ContentBuilder() {
    Text('recommend')
      .textAlign(TextAlign.Center)
      .width('100%')
      .height('100%')
      .fontColor(Color.Blue)
  }

  build() {
    LifecycleComponent({
      contentParam: () => {
        this.ContentBuilder()
      },
      lifecycle: this.viewModel
    })
  }
}