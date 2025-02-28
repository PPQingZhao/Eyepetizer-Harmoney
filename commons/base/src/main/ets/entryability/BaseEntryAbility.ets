import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { getWindowAreaByAppStorage, WindowArea } from '../utils/Window';
import { BreakpointConstants } from 'base/src/main/ets/constans/BreakpointConstants';
import { BusinessError } from '@kit.BasicServicesKit';
import { updateBreakpointModel } from 'base/src/main/ets/constans/BreakpointModel';

export default class BaseEntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {


    windowStage.getMainWindow((err: BusinessError<void>, data) => {
      if (err.code) {
        hilog.info(0x0000, 'testTag', '%{public}s', 'getMainWindow failed');
        return;
      }

      this.updateBreakpoint(data.getWindowProperties().windowRect.width);
      data.on('windowSizeChange', (windowSize: window.Size) => {
        this.updateBreakpoint(windowSize.width);
      })

      /**
       *  沉浸式布局--窗口全屏不隐藏避让区方案
       */
      // 获取应用主窗口
      let windowClazz: window.Window = data
      // 设置窗口全屏显示
      windowClazz.setWindowLayoutFullScreen(true)
      // 状态栏高度
      let statusHeight = windowClazz.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
      //导航栏高度
      let navigationHeight =
        windowClazz.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height

      // 保存
      let windowArea: WindowArea = getWindowAreaByAppStorage()
      windowArea.statusBarHeight = statusHeight
      windowArea.navigationHeight = navigationHeight

      // 注册监听函数，动态获取避让区域数据
      windowClazz.on('avoidAreaChange', (data) => {
        if (data.type == window.AvoidAreaType.TYPE_SYSTEM) {
          windowArea.statusBarHeight = statusHeight
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          windowArea.navigationHeight = navigationHeight
        }
      })
    })
  }

  private updateBreakpoint(windowWidth: number): void {
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let curBp: string = '';
    if (windowWidthVp < BreakpointConstants.BREAKPOINT_RANGES[1]) {
      curBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidthVp < BreakpointConstants.BREAKPOINT_RANGES[2]) {
      curBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      curBp = BreakpointConstants.BREAKPOINT_LG;
    }
    updateBreakpointModel(curBp)
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