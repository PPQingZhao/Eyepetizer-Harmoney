import { TabContentViewModel } from '../viewModel/TabContentViewModel';
import { TabContentView } from '../views/TabContentView';
import { LifecycleNavDestination } from 'ui/src/main/ets/utils/LifecycleNavDestination';

@Builder
export function HomePageBuilder(name: String, param: Object) {
  HomePage()
}


@Preview
@ComponentV2
export struct HomePage {
  private tabViewModel = new TabContentViewModel()

  @Builder
  ContentBuilder() {
    TabContentView({ tabContentViewModel: this.tabViewModel })
  }

  build() {
    LifecycleNavDestination({
      contentParam: () => {
        this.ContentBuilder()
      },
      lifecycle: this.tabViewModel
    }).width('100%')
      .height('100%')
  }
}
