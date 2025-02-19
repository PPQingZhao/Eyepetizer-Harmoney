import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export class BaseEntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    /**
     *  沉浸式布局--窗口全屏不隐藏避让区方案
     */
    // 获取应用主窗口
    let windowClazz: window.Window = windowStage.getMainWindowSync()
    // 设置窗口全屏显示
    windowClazz.setWindowLayoutFullScreen(true)
    // 状态栏高度
    let statusHeight = windowClazz.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
    //导航栏高度
    let navigationHeight =
      windowClazz.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height

    // 保存
    // AppStorage.setOrCreate(WindowStorage.PROP_STATUSBAR_HEIGHT, statusHeight)
    // AppStorage.setOrCreate(WindowStorage.PROP_NAVIGATION_HEIGHT, navigationHeight)

    // 注册监听函数，动态获取避让区域数据
    windowClazz.on('avoidAreaChange', (data) => {
      if (data.type == window.AvoidAreaType.TYPE_SYSTEM) {
        // AppStorage.setOrCreate(WindowStorage.PROP_STATUSBAR_HEIGHT, data.area.topRect.height)
      } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        // AppStorage.setOrCreate(WindowStorage.PROP_NAVIGATION_HEIGHT, data.area.bottomRect.height)
      }
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}