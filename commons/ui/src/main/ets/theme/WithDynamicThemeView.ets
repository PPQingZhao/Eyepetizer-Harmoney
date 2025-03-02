import { AppStorageV2, CustomColors, ThemeControl, window } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'

class DefaultAppColor implements CustomColors {
  fontPrimary: ResourceColor | undefined = Color.White
  fontOnPrimary : ResourceColor | undefined = '#ff736e6e'
  backgroundPrimary: ResourceColor | undefined = Color.Black
}

class BlackAppColor implements CustomColors {
  fontPrimary?: ResourceColor | undefined = Color.Blue
  backgroundPrimary: ResourceColor | undefined = Color.Black
}

export class DefaultAppTheme implements CustomTheme {
  colors: CustomColors = new DefaultAppColor()
}

class BlackAppTheme implements CustomTheme {
  colors: CustomColors = new BlackAppColor()
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

export function setAppTheme2(theme: AppTheme, window: window.Window) {
  let t: CustomTheme = getTheme(theme)
  ThemeControl.setDefaultTheme(t)

  let sysBarProps: window.SystemBarProperties = {
    // 以下两个属性从API Version8开始支持。
    statusBarContentColor: t.colors?.fontPrimary?.toString(),
    navigationBarContentColor: t.colors?.fontPrimary?.toString()
  };

  window.setWindowSystemBarProperties(sysBarProps).then(() => {
    console.info('Succeeded in setting the system bar properties.');
  }).catch((err: BusinessError) => {
    console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
  });
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


