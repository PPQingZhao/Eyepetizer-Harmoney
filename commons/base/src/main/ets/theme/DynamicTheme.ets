import { CustomColors } from '@kit.ArkUI'

class AppColor implements CustomColors {
}

class AppTheme implements CustomTheme {
  colors: AppColor = new AppColor()
}

class Theme {
  dynamicTheme: CustomTheme = new AppTheme()
}
