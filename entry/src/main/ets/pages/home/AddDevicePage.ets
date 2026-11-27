import { getProductList, Product } from '../../common/bean/Product';
import { Device, RoomDeviceDao } from '../../common/data/RoomDeviceDB';
import { MyUtil } from '../../common/utils/MyUtil';
import { DeviceScanView } from '../../common/view/DeviceScanView';

@Builder
export function AddDevicePageBuilder(): void {
  AddDevicePage();
}

@Entry
@Component
struct AddDevicePage {
  @Consume('pageNav') navPathStack: NavPathStack;
  private isRefreshDevice: boolean = false
  private productList: Product[] = []

  aboutToAppear(): void {
    this.productList = getProductList()
  }

  aboutToDisappear(): void {
    if (this.isRefreshDevice) {
      getContext(this).eventHub.emit("refreshDevice")
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {

          Column() {
            Text('扫描设备中...')

            DeviceScanView({ isScanning: true, boxSize: 200, scanColor: '#FF2196F3' })
          }
          .borderRadius(16)
          .backgroundColor(Color.White)
          .padding(10)
          .width('100%')

          Column() {
            Text('扫码添加')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(16)
          .backgroundColor(Color.White)
          .padding(10)
          .margin({ top: 20 })
          .height(60)
          .width('100%')

          Column() {
            Text('手动添加').width('100%').margin({ top: 10, left: 10 })

            Column() {
              Grid() {
                ForEach(this.productList, (value: Product, index: number) => {
                  GridItem() {
                    this.ProductBuilder(value)
                  }
                });
              }
              .columnsTemplate('1fr 1fr')
              .columnsGap(15)
              .rowsGap(15)
              .padding(15)
            }
            .width('100%')
          }
          .borderRadius(16)
          .backgroundColor(Color.White)
          .padding(10)
          .margin({ top: 20 })
          .width('100%')

        }
        .padding(10)
        .height('100%')
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
    }
    .title('添加设备')
    .padding({ top: $r('app.float.page_title_top') })
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }

  @Builder
  ProductBuilder(value: Product) {
    Row() {
      Image($r('app.media.foreground')).margin({ right: 10 }).width(30).height(30)

      Text(value.productName).fontSize(15).fontColor(Color.Black)
    }
    .onClick(() => {
      this.navPathStack.pushPathByName('AddDeviceConfirmPage', value, (data) => {
        this.isRefreshDevice = true
        this.navPathStack.pop()
      })
    })
    .padding(10)
    .backgroundColor('#E0FFF0E6')
    .borderRadius(16)
    .height(60)
    .width('100%')
  }
}