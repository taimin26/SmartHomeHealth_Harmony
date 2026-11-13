import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { UIContext } from '@ohos.arkui.UIContext';

/**
 * 自定义弹窗操作类
 */
export class PromptActionClass {
  private ctx: UIContext;
  private contentNode: ComponentContent<Object>;
  private options: promptAction.BaseDialogOptions;

  constructor(ctx: UIContext, contentNode: ComponentContent<Object>, options?: promptAction.BaseDialogOptions) {
    this.ctx = ctx;
    this.contentNode = contentNode;
    if (options === undefined) {
      this.options = { alignment: DialogAlignment.Center, offset: { dx: 0, dy: 0 } };
    } else {
      this.options = options;
    }
  }

  public openDialog() {
    if (this.contentNode !== null) {
      this.ctx.getPromptAction()
        .openCustomDialog(this.contentNode, this.options)
        .then(() => {
          console.info('OpenCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  public closeDialog() {
    if (this.contentNode !== null) {
      this.ctx.getPromptAction()
        .closeCustomDialog(this.contentNode)
        .then(() => {
          console.info('CloseCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  public updateDialog(options: promptAction.BaseDialogOptions) {
    if (this.contentNode !== null) {
      this.ctx.getPromptAction()
        .updateCustomDialog(this.contentNode, options)
        .then(() => {
          console.info('UpdateCustomDialog complete.')
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`UpdateCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }
}