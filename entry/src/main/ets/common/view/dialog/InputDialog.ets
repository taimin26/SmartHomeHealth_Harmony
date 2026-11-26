import { PromptActionClass } from './PromptActionClass';
import { ComponentContent } from '@kit.ArkUI';

/**
 * 自定义弹窗
 */
export class InputDialog {
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
  onDialogCallback: (data: string) => void = () => {
  };
  text: string = "";
  inputType: InputType = InputType.Normal;

  constructor(onDialogCallback?: (data: string) => void) {
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
  setOnCallback(onDialogCallback: (data: string) => void) {
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
  value: string = ''

  build() {
    Column() {
      Text(this.params.text)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)

      TextInput({ placeholder: '请输入' })
        .type(this.params.inputType)
        .onChange((value: string) => {
          this.value = value
        })
        .margin({ top: 20 })
        .height(50)

      Row() {
        Button('取消')
          .onClick(() => {
            this.params.on(0)
          })
          .margin({ top: 36 })
          .width('50%')

        Button('确定')
          .onClick(() => {
            this.params.on(0)
            this.params.onDialogCallback(this.value)
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