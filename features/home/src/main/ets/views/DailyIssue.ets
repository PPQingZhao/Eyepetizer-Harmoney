import { LifecycleComponent } from "ui/src/main/ets/components/LifecycleComponent"
import { DailyIssueViewModel } from "../viewModel/DailyIssueViewModel"

@ComponentV2
export struct DailyIssue {
  private viewModel: DailyIssueViewModel = new DailyIssueViewModel()

  @Builder
  private ContentBuilder() {
    Text('DailyIssue')
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