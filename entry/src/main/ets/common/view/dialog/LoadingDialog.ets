import { PromptActionClass } from './PromptActionClass';
import { ComponentContent } from '@kit.ArkUI';

/**
 * 加载弹窗
 */
export class LoadingDialog {
  private ctx: UIContext;
  private params: DialogParams;
  private contentNode: ComponentContent<Object>;
  private promptActionClass: PromptActionClass;

  constructor(ctx: UIContext) {
    this.ctx = ctx;
    this.params = new DialogParams()
    this.addParamsCallback();
    //设置UI和参数
    this.contentNode = new ComponentContent(this.ctx, wrapBuilder(buildDialog), this.params);
    this.promptActionClass = new PromptActionClass(this.ctx, this.contentNode)
  }

  //打开弹窗
  openDialog() {
    this.contentNode.update(this.params)
    this.promptActionClass.openDialog()
  }

  //关闭弹窗
  closeDialog() {
    this.promptActionClass.closeDialog()
  }

  //获取参数对象，以供修改
  getParams(): DialogParams {
    return this.params;
  }

  //修改参数后，调用此方法更新
  /*update() {
    this.contentNode.update(this.params)
  }*/

  //给参数新增内部回调
  private addParamsCallback() {
    this.params.setOn((data) => {
      if (data == 0) {
        this.closeDialog();
      }
    })
  }
}

/**
 * 交互数据
 */
class DialogParams {
  on: (data: number) => void = () => {
  };
  onDialogCallback: (data: number) => void = () => {
  };
  text: string = "";

  constructor(onDialogCallback?: (data: number) => void) {
    if (onDialogCallback) {
      this.onDialogCallback = onDialogCallback;
    } else {
      this.onDialogCallback = () => {
      };
    }
  }

  //内部回调
  setOn(on: (data: number) => void) {
    this.on = on;
  }

  //外部回调
  setOnCallback(onDialogCallback: (data: number) => void) {
    this.onDialogCallback = onDialogCallback;
  }
}

/**
 * 自定义UI
 */
@Builder
function buildDialog(params: DialogParams) {
  Column() {
    DialogView({ params: params })
  }
}

@Component
struct DialogView {
  @Prop params: DialogParams = new DialogParams();

  build() {
    Column() {
      LoadingProgress()
        .width(80)
        .height(80)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFF0F0F0')
    .borderRadius(20)
    .width(100)
    .height(100)
  }
}