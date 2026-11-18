import { SystemUtil } from '../../common/utils/SystemUtil';
import { InputDialog } from '../../common/view/dialog/InputDialog';
import { CustomDialog } from '../../common/view/dialog/CustomDialog';
import EntryAbility from '../../entryability/EntryAbility';
import { Device, Room, RoomDeviceDao } from '../../common/data/RoomDeviceDB';
import { SymbolGlyphModifier } from '@kit.ArkUI';

@Builder
export function DeviceEditPageBuilder(): void {
  DeviceEditPage();
}

@Entry
@Component
struct DeviceEditPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  private dialog: CustomDialog = new CustomDialog(this.getUIContext());
  private dialog_input: InputDialog = new InputDialog(this.getUIContext());
  private isRefreshDevice: boolean = false
  private device: Device | undefined = undefined
  private room: Room | undefined = undefined
  @State roomName: string = ''
  @State deviceName: string = ''
  @State deviceId: string = ''
  @State hardwareId: string = ''

  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
    if (this.isRefreshDevice) {
      getContext(this).eventHub.emit("refreshDevice")
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text('设备名称：')

          TextInput({ text: this.deviceName })
            .type(InputType.Normal)
            .onChange((value: string) => {
              this.deviceName = value
              if (this.device) {
                this.device.deviceName = value
              }
            })
            .textAlign(TextAlign.End)
            .maxLines(1)
            .height('80%')
            .width('60%')
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height('60')
        .width('100%')

        Row() {
          Text('房间：')

          Row() {
            Text(this.roomName).margin({ right: 10 })
            SymbolGlyph($r('sys.symbol.chevron_right')).width(20).height(20)
          }
        }
        .onClick(() => {
          if (this.room) {
            this.navPathStack.pushPathByName('RoomManagerPage', this.room.roomId, (popInfo) => {
              this.room = popInfo.result as Room
              this.roomName = this.room.roomName
              if (this.device) {
                this.device.belongRoomId = this.room.roomId
              }
            })
          }
        })
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height('60')
        .width('100%')

        Row() {
          Text('设备ID：')

          Text(this.device?.deviceId)
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height('60')
        .width('100%')

        Row() {
          Text('设备硬件ID：')

          Text(this.device?.hardwareId)
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height('60')
        .width('100%')

        Blank()

        Button('删除设备')
          .fontColor(Color.Red)
          .borderRadius(24)
          .backgroundColor(Color.White)
          .margin({ bottom: 50 })
          .height('50')
          .width('100%')
          .onClick(() => {
            this.dialog.getParams().title = '是否删除设备？'
            this.dialog.getParams().setOnCallback((data) => {
              if (data == 1) {
                if (this.device) {
                  RoomDeviceDao.deleteDevice(this.device.deviceId)
                  this.isRefreshDevice = true
                  this.navPathStack.pop()
                }
              }
            })
            this.dialog.openDialog()
          })
      }
      .height('100%')
      .width('90%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.device = JSON.parse(ctx.pathInfo.param as string)
      this.deviceName = this.device?.deviceName ?? ''
      if (this.device) {
        RoomDeviceDao.getRoom(this.device.belongRoomId).then((data) => {
          this.room = data
          this.roomName = this.room.roomName
        })
      }
    })
    .title('设备编辑')
    .menus([
      {
        value: 'confirm',
        symbolIcon: new SymbolGlyphModifier($r('sys.symbol.checkmark')),
        action: () => {
          if (this.device) {
            RoomDeviceDao.updateDevice(this.device)
            this.isRefreshDevice = true
            this.navPathStack.pop()
          }
        }
      }
    ])
    .padding({ top: $r('app.float.page_title_top') })
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }
}