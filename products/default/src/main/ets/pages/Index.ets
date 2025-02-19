import { NavContentView } from '../views/NavContentView'

@Entry
@Component
struct Index {
  mNavPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.mNavPathStack) {
      NavContentView()
        .width('100%')
        .height('100%')
    }.hideToolBar(true)
  }
}
