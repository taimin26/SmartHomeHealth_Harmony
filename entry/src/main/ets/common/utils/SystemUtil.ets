import { window } from '@kit.ArkUI';
import { Logger } from './Logger';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { scanBarcode, scanCore } from '@kit.ScanKit';

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

  /**
   * 申请权限
   */
  static async requestPermissions(context: Context, permissions: Array<Permissions>): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    //判断权限的授权状态来决定是否唤起弹窗
    return atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let isAll = true;
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          isAll = true;
        } else {
          isAll = false;
        }
      }
      return isAll;
    }).catch((err: BusinessError) => {
      Logger.error('requestPermissions',
        `requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
      return false;
    });
  }

  /**
   * 扫码
   */
  static openScan(context: common.Context): Promise<string> {
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true
    };

    if (!canIUse("SystemCapability.Multimedia.Scan.ScanBarcode")) {
      return Promise.resolve('');
    }

    return scanBarcode.startScanForResult(context, options).then((result: scanBarcode.ScanResult) => {
      Logger.info('openScan', `Scan result is ${JSON.stringify(result)}`);
      let value: string = result.originalValue
      return value
    }).catch((error: BusinessError) => {
      Logger.error('openScan', `Failed ScanResult. Code:${error.code}, message: ${error.message}`);
      return ''
    });
  }
}
