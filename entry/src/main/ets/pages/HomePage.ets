import { LengthMetrics } from "@kit.ArkUI";
import { Logger } from "../common/utils/Logger";
import { SystemUtil } from "../common/utils/SystemUtil";
import { Permissions } from "@kit.AbilityKit";
import { SmartDB, Smart } from "../common/data/SmartDB";
import { StoreRUtil } from "../common/data/StoreRUtil";
import { Family, FamilyDB, getFamilyList } from "../common/data/FamilyDB";
import { Device, getDeviceList, Room, RoomDeviceDao, RoomDevices } from "../common/data/RoomDeviceDB";

/**
 * 家居
 */
@Component
export struct HomePage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State familyName: string = '--的家'
  @State currentIndex: number = 0;
  @State familyList: Family[] = []
  @State roomDevicesList: RoomDevices[] = []
  @State roomList: Room[] = []

  aboutToAppear(): void {
    FamilyDB.queryAll().then((data) => {
      this.familyList = data
      if (this.familyList.length == 0) {
        FamilyDB.insertTest()
        this.familyList = getFamilyList()
      }
      this.familyName = this.familyList[0].familyName + '的家'
    })
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
        this.TopFunBuilder()

        Tabs() {
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
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.transparent'))
    .padding({ bottom: 100 })
    .width('100%')
    .height('100%')
  }

  @Builder
  TopFunBuilder() {
    Row() {
      Text(this.familyName)
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)
        .bindMenu(this.FamilyMenuBuilder())

      Text('+').fontSize(35).fontColor(Color.Black).bindMenu(this.AddMenuBuilder())
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 60, left: 20, right: 20 })
    .width('100%')
  }

  @Builder
  FamilyMenuBuilder() {
    Menu() {
      ForEach(this.familyList, (value: Family, index: number) => {
        MenuItem({ content: value.familyName + '的家' })
          .onClick(() => {
            this.familyName = value.familyName + '的家'
          })
      });
    }

    Column() {
    }.height(1).background('#E5E5E5').margin({ left: 10, right: 10 })

    Row() {
      SymbolGlyph($r('sys.symbol.gearshape_fill'))

      Text('家庭设置').fontSize(16).margin({ left: 10 })
    }
    .margin({ left: 10, right: 10 })
    .height(50)
  }

  @Builder
  AddMenuBuilder() {
    Menu() {
      MenuItem({ content: "添加设备" })
        .onClick(() => {
        })
      MenuItem({ content: "创建智能" })
        .onClick(() => {
        })
      MenuItem({ content: "扫一扫" })
        .onClick(() => {
          const permissions: Array<Permissions> = [
            'ohos.permission.CAMERA'];
          SystemUtil.requestPermissions(getContext(this), permissions).then((is) => {
            if (!is) {
              return
            }
            SystemUtil.openScan(getContext(this)).then((value: string) => {
              Logger.debug(value)
            })
          })
        })
      MenuItem({ content: "管理房间" })
        .onClick(() => {

        })
    }
    .menuItemDivider({
      strokeWidth: LengthMetrics.vp(1),
      color: '#E5E5E5',
      startMargin: LengthMetrics.vp(10),
      endMargin: LengthMetrics.vp(10),
      mode: DividerMode.EMBEDDED_IN_MENU
    })
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
    .padding(20)
    .backgroundColor('#E0FFF0E6')
    .borderRadius(15)
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}