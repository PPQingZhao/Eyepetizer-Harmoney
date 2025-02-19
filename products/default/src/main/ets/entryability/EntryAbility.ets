import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIAbility } from '@kit.AbilityKit';


export class WindowStorage {
  static readonly PROP_STATUSBAR_HEIGHT: string = "_StatusBarHeight"
  static readonly PROP_NAVIGATION_HEIGHT: string = "_NavigationHeight"
}

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

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
    AppStorage.setOrCreate(WindowStorage.PROP_STATUSBAR_HEIGHT, statusHeight)
    AppStorage.setOrCreate(WindowStorage.PROP_NAVIGATION_HEIGHT, navigationHeight)

    // 注册监听函数，动态获取避让区域数据
    windowClazz.on('avoidAreaChange', (data) => {
      if (data.type == window.AvoidAreaType.TYPE_SYSTEM) {
        AppStorage.setOrCreate(WindowStorage.PROP_STATUSBAR_HEIGHT, data.area.topRect.height)
      } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        AppStorage.setOrCreate(WindowStorage.PROP_NAVIGATION_HEIGHT, data.area.bottomRect.height)
      }
    })
  }
}
