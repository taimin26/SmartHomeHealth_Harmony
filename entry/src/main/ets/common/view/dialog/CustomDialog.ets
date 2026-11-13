import { PromptActionClass } from './PromptActionClass';
import { ComponentContent } from '@kit.ArkUI';

/**
 * 自定义弹窗
 */
export class CustomDialog {
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

  getParams(): DialogParams {
    return this.params;
  }

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
  title: string = "";
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
      Text(this.params.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)

      Text(this.params.text)
        .fontSize(16)
        .margin({ top: 10 })

      Row() {
        Button('取消')
          .onClick(() => {
            this.params.on(0)
            this.params.onDialogCallback(0)
          })
          .margin({ top: 36 })
          .width('50%')

        Button('确定')
          .onClick(() => {
            this.params.on(0)
            this.params.onDialogCallback(1)
          })
          .margin({ top: 36, left: 10 })
          .width('50%')
      }

    }
    .backgroundColor('#FFF0F0F0')
    .borderRadius(20)
    .padding(30)
    .width('80%')
  }
}