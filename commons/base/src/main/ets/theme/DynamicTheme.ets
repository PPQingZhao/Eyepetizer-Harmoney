import { AppStorageV2, CustomColors } from '@kit.ArkUI'

class DefaultAppColor implements CustomColors {
  fontPrimary?: ResourceColor | undefined = Color.Red
}

class BlackAppColor implements CustomColors {
  fontPrimary?: ResourceColor | undefined = Color.Blue
}

class DefaultAppTheme implements CustomTheme {
  colors: DefaultAppColor = new DefaultAppColor()
}

class BlackAppTheme implements CustomTheme {
  colors: DefaultAppColor = new BlackAppColor()
}

@ObservedV2
class ThemeModel {
  @Trace dynamicTheme: CustomTheme = new DefaultAppTheme()
}

const keyThemeModel: string = 'key_themeModel'

function getAppThemeByAppStore(): ThemeModel {
  return AppStorageV2.connect(ThemeModel, keyThemeModel, () => new ThemeModel())!
}

export enum AppTheme {
  Default = 'default',
  Black = 'black'
}


@ComponentV2
export struct WithDynamicThemeView {
  @BuilderParam customBuilderParam: () => void = this.customBuilder;

  @Builder
  customBuilder() {
    Text("AAAAAAAA")
  };

  build() {
    Column() {
      WithTheme({ theme: getAppThemeByAppStore().dynamicTheme }) {
        this.customBuilderParam()
      }
    }
  }
}


