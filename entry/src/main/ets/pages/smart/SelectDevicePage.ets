import { Device, getDeviceList, Room, RoomDeviceDao, RoomDevices } from '../../common/data/RoomDeviceDB';

@Builder
export function SelectDevicePageBuilder(): void {
  SelectDevicePage();
}

@Entry
@Component
struct SelectDevicePage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State roomDevicesList: RoomDevices[] = []
  @State roomList: Room[] = []
  @State currentIndex: number = 0;
  private isSelect: boolean = false

  aboutToAppear(): void {
    RoomDeviceDao.getAllRoomsWithDevices().then((data) => {
      this.roomDevicesList = data
      if (this.roomDevicesList.length == 0) {
        RoomDeviceDao.insertTest()
        this.roomDevicesList = getDeviceList()
      }
      for (let i = 0; i < this.roomDevicesList.length; i++) {
        this.roomList[i] = this.roomDevicesList[i].room
      }
    })
  }

  build() {
    NavDestination() {
      Column() {
        Tabs({ index: this.currentIndex }) {
          ForEach(this.roomList, (value: Room, index: number) => {
            TabContent() {
              this.DevicePageBuilder(this.roomDevicesList[index].devices)
            }
            .tabBar(this.TabItemBuilder(value.roomName, index))
          });
        }
        .barMode(BarMode.Scrollable)
        .fadingEdge(false)
        .onChange((index: number) => {
          this.currentIndex = index
        })
        .margin({ top: 20 })
      }
      .height('100%')
      .width('100%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.isSelect = (ctx.pathInfo.param as string) == '' ? false : true
    })
    .title('选择设备')
    .padding({ top: $r('app.float.page_title_top') })
    .height('100%')
    .width('100%')
  }

  @Builder
  TabItemBuilder(title: string, index: number) {
    Row() {
      Text(title)
        .fontSize(this.currentIndex === index ? 20 : 18)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? '#000000' : '#80000000')
        .maxLines(1)
    }
    .justifyContent(FlexAlign.Center)
    .width(80)
  }

  @Builder
  DevicePageBuilder(deviceList: Device[]) {
    Column() {
      Grid() {
        ForEach(deviceList, (value: Device, index: number) => {
          GridItem() {
            this.DeviceBuilder(value)
          }
        });
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(20)
      .rowsGap(20)
      .padding(20)
    }
    .width('100%')
  }

  @Builder
  DeviceBuilder(value: Device) {
    Column() {
      Text(value.deviceName).fontSize(16).fontWeight(FontWeight.Medium).fontColor(Color.Black)

      Text(value.status === '1' ? '在线' : '离线')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#80000000')
        .margin({ top: 4 })

      Image($r('app.media.foreground')).margin({ top: 20 }).width(30).height(30)
    }
    .onClick(() => {
      this.navPathStack.pop(value)
    })
    .padding(20)
    .backgroundColor('#E0FFF0E6')
    .borderRadius(15)
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}