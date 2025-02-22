import { NavContentView } from '../views/NavContentView'

@Entry
@ComponentV2
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
