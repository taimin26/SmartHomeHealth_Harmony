import { SystemUtil } from '../../common/utils/SystemUtil';
import { InputDialog } from '../../common/view/dialog/InputDialog';
import { CustomDialog } from '../../common/view/dialog/CustomDialog';
import EntryAbility from '../../entryability/EntryAbility';
import { Device, Room, RoomDeviceDao } from '../../common/data/RoomDeviceDB';
import { SymbolGlyphModifier } from '@kit.ArkUI';
import { MyUtil } from '../../common/utils/MyUtil';
import { Product } from '../../common/bean/Product';

@Builder
export function AddDeviceConfirmPageBuilder(): void {
  AddDeviceConfirmPage();
}

@Entry
@Component
struct AddDeviceConfirmPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  private product: Product = new Product('', '')
  private room: Room | undefined = undefined
  @State roomName: string = ''
  @State deviceName: string = ''
  private hardwareId: string = MyUtil.getRandomStr16(true)

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text('设备名称：')

          TextInput({ text: this.deviceName })
            .type(InputType.Normal)
            .onChange((value: string) => {
              this.deviceName = value
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
          this.navPathStack.pushPathByName('RoomManagerPage', '0', (popInfo) => {
            this.room = popInfo.result as Room
            this.roomName = this.room.roomName
          })
        })
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height('60')
        .width('100%')

        Row() {
          Text('设备硬件ID：')

          Text(this.hardwareId)
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .padding({ left: 10, right: 10 })
        .margin({ top: 30 })
        .justifyContent(FlexAlign.SpaceBetween)
        .height('60')
        .width('100%')

        Blank()

        Button('确认添加')
          .borderRadius(24)
          .margin({ bottom: 50 })
          .height('50')
          .width('100%')
          .onClick(() => {
            if (this.room) {
              RoomDeviceDao.insertDevice(new Device(MyUtil.getRandomStr16(),
                this.room.roomId, this.deviceName, this.product.productId,
                this.hardwareId, '', '', false))
                .then(() => {
                  this.navPathStack.pop('')
                })
            }
          })
      }
      .height('100%')
      .width('90%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.product = ctx.pathInfo.param as Product
      this.deviceName = this.product.productName
    })
    .title('添加设备')
    .padding({ top: $r('app.float.page_title_top') })
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }
}