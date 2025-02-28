import { AppStorageV2, CustomColors, ThemeControl } from '@kit.ArkUI'

class DefaultAppColor implements CustomColors {
  fontPrimary?: ResourceColor | undefined = Color.Black
}

class BlackAppColor implements CustomColors {
  fontPrimary?: ResourceColor | undefined = Color.Blue
}

class DefaultAppTheme implements CustomTheme {
  colors: CustomColors = new DefaultAppColor()
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

export function getTheme(theme: AppTheme): CustomTheme {
  let valueTheme: CustomTheme = new DefaultAppTheme()
  switch (theme) {
    case AppTheme.Black:
      valueTheme = new BlackAppTheme()
      break
    default:
      break;
  }
  return valueTheme
}

export function setAppTheme(theme: AppTheme) {
  ThemeControl.setDefaultTheme(getTheme(theme))
}


@ComponentV2
export struct WithDynamicThemeView {
  // @BuilderParam customBuilderParam: () => void = this.customBuilder;

  @Builder
  customBuilder() {
    Text("AAAAAAAA")
  };

  build() {
    Column() {
      // WithTheme({ theme: getAppThemeByAppStore().dynamicTheme }) {
      // this.customBuilderParam()
      this.customBuilder()
      // }
    }
  }
}


