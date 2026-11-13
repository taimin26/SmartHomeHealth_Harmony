import { Family, FamilyDB } from '../../common/data/FamilyDB';
import { MyUtil } from '../../common/utils/MyUtil';
import { SystemUtil } from '../../common/utils/SystemUtil';
import { InputDialog } from '../../common/view/dialog/InputDialog';
import { CustomDialog } from '../../common/view/dialog/CustomDialog';
import EntryAbility from '../../entryability/EntryAbility';
import { Room, RoomDeviceDao } from '../../common/data/RoomDeviceDB';

@Builder
export function RoomManagerPageBuilder(): void {
  RoomManagerPage();
}

@Entry
@Component
struct RoomManagerPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State roomList: Room[] = []
  private dialog: CustomDialog = new CustomDialog(this.getUIContext());
  private dialog_input: InputDialog = new InputDialog(this.getUIContext());
  private isRefreshRoom: boolean = false
  private isSelect: boolean = false

  aboutToAppear(): void {
    SystemUtil.setWindowFullScreen(EntryAbility.windowStage, false)

    this.loadRoomList()
  }

  aboutToDisappear(): void {
    SystemUtil.setWindowFullScreen(EntryAbility.windowStage, true)

    if (this.isRefreshRoom) {
      getContext(this).eventHub.emit("refreshRoom")
    }
  }

  loadRoomList() {
    RoomDeviceDao.getAllRooms().then((data) => {
      this.roomList = data
    })
  }

  build() {
    NavDestination() {
      // if (!this.isSelect) {
        RelativeContainer() {
          List({ space: 12 }) {
            ForEach(this.roomList, (room: Room, index: number) => {
              ListItem() {
                RoomItem({
                  item: room, onDelete: () => {
                    this.dialog.getParams().title = '删除房间'
                    this.dialog.getParams().text = `确定要删除“ ${room.roomName} ”吗？`
                    this.dialog.getParams().setOnCallback((data) => {
                      if (data == 1) {
                        RoomDeviceDao.deleteRoom(room.roomId).then((value) => {
                          if (value > 0) {
                            this.loadRoomList()
                            this.isRefreshRoom = true
                            RoomDeviceDao.deleteDevicesInRoom(room.roomId)
                          }
                        })
                      }
                    })
                    this.dialog.openDialog()
                  }
                })
              }
            });
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
          .margin({
            top: 20,
            bottom: 20
          })
          .width('90%')
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: 'RoomManagerPage_btn', align: VerticalAlign.Top }
          })

          Button('创建房间')
            .id('RoomManagerPage_btn')
            .backgroundColor($r('app.color.main_blue'))
            .borderRadius(24)
            .margin({
              bottom: 30
            })
            .width('80%')
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
            })
            .onClick(() => {
              this.dialog_input.getParams().text = '房间名称'
              this.dialog_input.getParams().setOnCallback((data) => {
                if (data !== '') {
                  RoomDeviceDao.insertRoom(new Room(MyUtil.getRandomStr16(), data)).then((value) => {
                    if (value > 0) {
                      this.loadRoomList()
                      this.isRefreshRoom = true
                    }
                  })
                }
              })
              this.dialog_input.openDialog()
            })
        }
        .height('100%')
        .width('100%')
/*      } else {
        RelativeContainer() {
          List({ space: 12 }) {
            ForEach(this.roomList, (room: Room, index: number) => {
              ListItem() {
                RoomSelectItem({
                  item: room, onDelete: () => {

                  }
                })
              }
            });
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Off)
          .margin({
            top: 20,
            bottom: 20
          })
          .width('90%')
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: 'RoomManagerPage_btn_select', align: VerticalAlign.Top }
          })

          Button('选择房间')
            .id('RoomManagerPage_btn_select')
            .backgroundColor($r('app.color.main_blue'))
            .borderRadius(24)
            .margin({
              bottom: 30
            })
            .width('80%')
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
            })
            .onClick(() => {

            })
        }
        .height('100%')
        .width('100%')
      }*/
    }
    .onReady((ctx: NavDestinationContext) => {
      this.isSelect = (ctx.pathInfo.param as string) == '1' ? true : false
    })
    .title(this.isSelect ? '选择房间' : '房间管理')
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }
}

@Component
struct RoomItem {
  @Consume('pageNav') navPathStack: NavPathStack;
  @Prop item: Room
  onDelete: () => void = () => {
  }

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.trash_fill')).width(20).height(20)
        .onClick(() => {
          this.onDelete()
        })

      Text(this.item.roomName)
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 20, right: 20 })

      Blank()

      SymbolGlyph($r('sys.symbol.list_bullet')).width(20).height(20)
    }
    .borderRadius(24)
    .backgroundColor(Color.White)
    .padding(20)
    .width('100%')
  }
}

/*
@Component
struct RoomSelectItem {
  @Consume('pageNav') navPathStack: NavPathStack;
  @Prop item: Room
  onDelete: () => void = () => {
  }

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.trash_fill')).width(20).height(20)
        .onClick(() => {
          this.onDelete()
        })

      Text(this.item.roomName)
        .fontSize(16)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 20, right: 20 })

      Blank()

      SymbolGlyph($r('sys.symbol.list_bullet')).width(20).height(20)
    }
    .borderRadius(24)
    .backgroundColor(Color.White)
    .padding(20)
    .width('100%')
  }
}*/
