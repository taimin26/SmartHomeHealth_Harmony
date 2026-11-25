import { PromptActionClass } from './PromptActionClass';
import { ComponentContent } from '@kit.ArkUI';

/**
 * 时间日期弹窗
 */
export class TimeDateDialog {
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
  private selectedDate: Date = new Date()
  @State isShowDate: boolean = false
  private tempDate: Date = new Date()

  build() {
    Column() {
      if (!this.isShowDate) {
        Column() {
          Text('Select Time')
            .fontWeight(FontWeight.Medium)
            .width('100%')

          TimePicker({ selected: this.selectedDate })
            .useMilitaryTime(true)
            .onChange((value) => {
              this.selectedDate.setHours(value.hour, value.minute, 0, 0)
            })
            .margin({ top: 30, bottom: 30 })

          Row() {
            SymbolGlyph($r('sys.symbol.calendar'))
              .fontColor([$r('app.color.main_blue')])
              .fontSize(30)
              .onClick(() => {
                this.isShowDate = true
              })

            Blank()

            Text('Cancel')
              .fontColor($r('app.color.main_blue'))
              .margin({ right: 30 })
              .onClick(() => {
                this.params.on(0)
              })

            Text('OK')
              .fontColor($r('app.color.main_blue'))
              .onClick(() => {
                // yyyy-MM-dd HH:mm
                const timeStr = `${this.formatDate(this.selectedDate)}`
                this.params.on(0)
                this.params.onDialogCallback(timeStr)
              })
          }
          .width('100%')
        }
        .padding(20)
        .margin(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
      } else {
        Column() {
          Text('Select Date')
            .fontWeight(FontWeight.Medium)
            .width('100%')

          DatePicker({
            start:new Date(),
            end: new Date(2036, 1, 1),
            selected: this.selectedDate
          })
            .onDateChange((value: Date) => {
              this.tempDate = value
            })
            .margin({ top: 30, bottom: 30 })

          Row() {
            Blank()

            Text('Cancel')
              .fontColor($r('app.color.main_blue'))
              .margin({ right: 30 })
              .onClick(() => {
                this.isShowDate = false
              })

            Text('OK')
              .fontColor($r('app.color.main_blue'))
              .onClick(() => {
                this.selectedDate.setFullYear(
                  this.tempDate.getFullYear(),
                  this.tempDate.getMonth(),
                  this.tempDate.getDate()
                )
                this.isShowDate = false
              })
          }
          .width('100%')
        }
        .padding(20)
        .margin(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
      }
    }
  }

  // 日期格式化 yyyy-MM-dd HH:mm
  private formatDate(date: Date): string {
    const y = date.getFullYear()
    const m = this.padZero(date.getMonth() + 1)
    const d = this.padZero(date.getDate())
    const h = this.padZero(date.getHours())
    const mi = this.padZero(date.getMinutes())
    return `${y}-${m}-${d} ${h}:${mi}`
  }

  private padZero(num: number): string {
    return num < 10 ? `0${num}` : `${num}`
  }
}