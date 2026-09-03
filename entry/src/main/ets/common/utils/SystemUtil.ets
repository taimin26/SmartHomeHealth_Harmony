import { window } from '@kit.ArkUI';
import { Logger } from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

export class SystemUtil {
  /**
   * 结束app
   *
   * 在page页使用
   * (getContext(this) as common.UIAbilityContext)?.terminateSelf();
   *
   * 在EntryAbility使用
   * this.context.terminateSelf();
   */
  static finish(context: Context) {
    (context as common.UIAbilityContext)?.terminateSelf();
  }

  /**
   * 获取状态栏高度
   * getContext(this)
   */
  static getStatusBarHeight(ctx: Context): Promise<number> {
    return window.getLastWindow(ctx).then((windowClass) => {
      const avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let statusBarHeight: number = avoidArea.topRect.height; // 单位px
      return px2vp(statusBarHeight); // 转换为vp
    }).catch((err: BusinessError) => {
      Logger.error(`获取状态栏高度失败: ${err.code}, message: ${err.message}`);
      return 0;
    });
  }

  /**
   * 设置沉浸式、全屏
   */
  static setWindowFullScreen(windowStage: window.WindowStage, isFullScreen: boolean) {
    try {
      let windowClass: window.Window = windowStage.getMainWindowSync();
      windowClass.setWindowLayoutFullScreen(isFullScreen).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        Logger.error(`设置沉浸式、全屏失败: ${err.code}, message: ${err.message}`);
      });
    } catch (error) {
      Logger.error(`设置沉浸式、全屏失败: ${error.code}, message: ${error.message}`);
    }
  }
}
