import { TabContentView } from '../views/TabContentView';

@Builder
export function HomePageBuilder(name: String, param: Object) {
  HomePage()
}

@Preview
@ComponentV2
export struct HomePage {

  build() {
    NavDestination() {
      TabContentView()
    }.width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}
