import { TabContentView } from '../views/TabContentView';
import { LifecycleNavDestination } from 'ui/src/main/ets/components/LifecycleNavDestination';

@Builder
export function HomePageBuilder(name: String, param: Object) {
  HomePage()
}


@Preview
@ComponentV2
export struct HomePage {

  @Builder
  ContentBuilder() {
    TabContentView()
  }

  build() {
    LifecycleNavDestination({
      contentView: () => {
        this.ContentBuilder()
      },
    }).width('100%')
      .height('100%')
  }
}
