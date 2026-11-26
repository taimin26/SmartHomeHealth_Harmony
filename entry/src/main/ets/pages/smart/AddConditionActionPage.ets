import { Action, Condition, Smart, SmartDB, SmartDevice, SmartSystem, SmartTimer } from '../../common/data/SmartDB';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { CustomDialog } from '../../common/view/dialog/CustomDialog';
import { TimeDateDialog } from '../../common/view/dialog/TimeDateDialog';
import { Logger } from '../../common/utils/Logger';
import { Device } from '../../common/data/RoomDeviceDB';

@Builder
export function AddConditionActionPageBuilder(): void {
  AddConditionActionPage();
}

@Entry
@Component
struct AddConditionActionPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State smart: Smart | undefined = undefined
  @State isAction: boolean = false

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text('设备')
          .fontSize(16)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .padding({ left: 20 })
          .height(60)
          .width('100%')
          .onClick(() => {
            this.navPathStack.pushPathByName('SelectDevicePage', '1', (popInfo) => {
              let device: Device = popInfo.result as Device

              if (this.isAction) {
                let data: Action =
                  new Action(1, new SmartDevice(device.deviceId, device.deviceName, device.productId, ""), null)
                this.navPathStack.pop(data)
              } else {
                let data: Condition =
                  new Condition(1, new SmartDevice(device.deviceId, device.deviceName, device.productId, ""), null,
                    null)
                this.navPathStack.pop(data)
              }
            })
          })

        if (!this.isAction) {
          Text('定时')
            .fontSize(16)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .padding({ left: 20 })
            .height(60)
            .width('100%')
            .onClick(() => {
              let dialog: TimeDateDialog = new TimeDateDialog(this.getUIContext());
              dialog.getParams().setOnCallback((data) => {
                let condition: Condition = new Condition(2, null, new SmartTimer(data, ''), null)
                this.navPathStack.pop(condition)
              })
              dialog.openDialog()
            })
        }

        Text('系统')
          .fontSize(16)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .padding({ left: 20 })
          .height(60)
          .width('100%')
          .onClick(() => {
            if (this.isAction) {
              let data: Action = new Action(3, null, new SmartSystem(1, "打开音乐"))
              this.navPathStack.pop(data)
            } else {
              let data: Condition = new Condition(3, null, null, new SmartSystem(1, "打开音乐"))
              this.navPathStack.pop(data)
            }

          })
      }
      .padding(20)
      .height('100%')
      .width('100%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.isAction = (ctx.pathInfo.param as string) == '0' ? false : true
    })
    .title(this.isAction ? '添加动作' : '添加条件')
    .padding({ top: $r('app.float.page_title_top') })
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }
}