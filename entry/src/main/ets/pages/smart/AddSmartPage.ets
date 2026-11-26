import { Action, Condition, Smart, SmartDB } from '../../common/data/SmartDB';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { CustomDialog } from '../../common/view/dialog/CustomDialog';
import { MyUtil } from '../../common/utils/MyUtil';

@Builder
export function AddSmartPageBuilder(): void {
  AddSmartPage();
}

@Entry
@Component
struct AddSmartPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  private dialog: CustomDialog = new CustomDialog(this.getUIContext());
  private isEdit: boolean = false
  private smartId: string = ''
  private isRefresh: boolean = false
  @State smart: Smart = new Smart('', '', '', false, [], [])
  @State changeNum: number = 0

  aboutToDisappear(): void {
    if (this.isRefresh) {
      getContext(this).eventHub.emit("refreshSmart")
    }
  }

  loadData() {
    SmartDB.getSmart(this.smartId).then((data) => {
      this.smart = data
    })
  }

  build() {
    NavDestination() {
      Column() {
        Image($r('app.media.foreground')).width(50).height(50)

        TextInput({
          text: this.smart == undefined ? '' : this.smart.name,
          placeholder: '请输入智能名称'
        })
          .type(InputType.Normal)
          .backgroundColor(Color.White)
          .onChange((value: string) => {
            if (this.smart) {
              this.smart.name = value
            }
          })
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .margin({ top: 30 })
          .borderRadius(8)
          .height(50)
          .width('100%')

        Column().height(30).width('100%')

        if (this.smart.conditions.length > 0 || this.smart.actions.length > 0) {
          Row() {
            Text('触发条件').fontSize(16).fontColor($r('app.color.main_blue'))

            SymbolGlyph($r('sys.symbol.plus_circle_fill')).fontColor([$r('app.color.main_blue')])
              .onClick(() => {
                this.goCondition()
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 5, right: 5 })
          .width('100%')

          List({ space: 5 }) {
            ForEach(this.smart.conditions, (item: Condition, index: number) => {
              ListItem() {
                Row() {
                  Text(this.getConditionName(item))
                }
                .borderRadius(16)
                .backgroundColor(Color.White)
                .margin({ top: 10 })
                .padding(10)
                .height(60)
                .width('100%')
              }
            })
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
          .width('100%')
        }

        if (this.smart.conditions.length == 0) {
          Column().height(10).width('100%')

          Text('+添加条件')
            .fontColor($r('app.color.main_blue'))
            .backgroundColor(Color.White)
            .borderRadius(16)
            .textAlign(TextAlign.Center)
            .height(100)
            .width('100%')
            .onClick(() => {
              this.goCondition()
            })
        }

        Column().height(30).width('100%')

        if (this.smart.conditions.length > 0 || this.smart.actions.length > 0) {
          Row() {
            Text('执行动作').fontSize(16).fontColor($r('app.color.main_blue'))

            SymbolGlyph($r('sys.symbol.plus_circle_fill')).fontColor([$r('app.color.main_blue')])
              .onClick(() => {
                this.goAction()
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 5, right: 5 })
          .width('100%')

          List({ space: 5 }) {
            ForEach(this.smart.actions, (item: Action, index: number) => {
              ListItem() {
                Row() {
                  Text(this.getActionName(item))
                }
                .borderRadius(16)
                .backgroundColor(Color.White)
                .margin({ top: 10 })
                .padding(10)
                .height(60)
                .width('100%')
              }
            })
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
          .width('100%')
        }

        if (this.smart.actions.length == 0) {
          Column().height(10).width('100%')

          Text('+添加动作')
            .fontColor($r('app.color.main_blue'))
            .backgroundColor(Color.White)
            .borderRadius(16)
            .textAlign(TextAlign.Center)
            .height(100)
            .width('100%')
            .onClick(() => {
              this.goAction()
            })
        }

        if (this.isEdit) {
          Blank()

          Button('删除智能')
            .fontColor(Color.Red)
            .borderRadius(24)
            .backgroundColor(Color.White)
            .margin({ top: 30 })
            .height('50')
            .width('100%')
            .onClick(() => {
              this.dialog.getParams().title = '是否删除智能？'
              this.dialog.getParams().setOnCallback((data) => {
                if (data == 1) {
                  SmartDB.delete(this.smart.smartId).then(() => {
                    this.isRefresh = true
                    this.navPathStack.pop()
                  })
                }
              })
              this.dialog.openDialog()
            })
        }

      }
      .padding({
        left: 30,
        right: 30,
        top: 20,
        bottom: 50
      })
      .height('100%')
      .width('100%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.isEdit = (ctx.pathInfo.param as string) == '' ? false : true
      this.smartId = ctx.pathInfo.param as string
      this.loadData()
    })
    .title(this.isEdit ? '编辑智能' : '添加智能')
    .menus([
      {
        value: 'confirm',
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.checkmark')),
        action: () => {
          if (this.smart.name === '' || this.smart.conditions.length == 0 || this.smart.actions.length == 0) {
            return
          }
          if (this.isEdit) {
            SmartDB.update(this.smart).then(() => {
              this.isRefresh = true
              this.navPathStack.pop()
            })
          } else {
            if (this.smart.smartId === '') {
              this.smart.smartId = MyUtil.getRandomNumber16()
            }
            SmartDB.insert(this.smart).then(() => {
              this.isRefresh = true
              this.navPathStack.pop()
            })
          }
        }
      }
    ])
    .padding({ top: $r('app.float.page_title_top') })
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }

  private getConditionName(condition: Condition): string {
    switch (condition.type) {
      case 1:
        return condition.smartDevice?.deviceName ?? ""
      case 2:
        return condition.smartTimer?.time ?? ""
      default:
        return condition.smartSystem?.operate ?? ""
    }
  }

  private getActionName(action: Action): string {
    switch (action.type) {
      case 1:
        return action.smartDevice?.deviceName ?? ""
      default:
        return action.smartSystem?.operate ?? ""
    }
  }

  goCondition() {
    this.navPathStack.pushPathByName('AddConditionActionPage', '0', (popInfo) => {
      let condition: Condition = popInfo.result as Condition
      this.smart.conditions = [...this.smart.conditions, condition]
    })
  }

  goAction() {
    this.navPathStack.pushPathByName('AddConditionActionPage', '1', (popInfo) => {
      let action: Action = popInfo.result as Action
      this.smart.actions = [...this.smart.actions, action]
    })
  }
}