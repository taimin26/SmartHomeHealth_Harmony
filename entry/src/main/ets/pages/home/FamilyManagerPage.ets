import { Family, FamilyDB } from '../../common/data/FamilyDB';
import { MyUtil } from '../../common/utils/MyUtil';
import { SystemUtil } from '../../common/utils/SystemUtil';
import { InputDialog } from '../../common/view/dialog/InputDialog';
import { CustomDialog } from '../../common/view/dialog/CustomDialog';
import EntryAbility from '../../entryability/EntryAbility';

@Builder
export function FamilyManagerPageBuilder(): void {
  FamilyManagerPage();
}

@Entry
@Component
struct FamilyManagerPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State familyList: Family[] = []
  private dialog: CustomDialog = new CustomDialog(this.getUIContext());
  private dialog_input: InputDialog = new InputDialog(this.getUIContext());
  private isRefreshFamily: boolean = false

  aboutToAppear(): void {
    SystemUtil.setWindowFullScreen(EntryAbility.windowStage, false)

    this.loadFamilyList()
  }

  aboutToDisappear(): void {
    SystemUtil.setWindowFullScreen(EntryAbility.windowStage, true)

    if (this.isRefreshFamily) {
      getContext(this).eventHub.emit("refreshFamily")
    }
  }

  loadFamilyList() {
    FamilyDB.queryAll().then((data) => {
      this.familyList = data
    })
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        List({ space: 12 }) {
          ForEach(this.familyList, (value: Family, index: number) => {
            ListItem() {
              FamilyItem({
                item: value, onDelete: () => {
                  this.dialog.getParams().title = '删除家庭'
                  this.dialog.getParams().text = `确定要删除“ ${value.familyName}的家 ”吗？`
                  this.dialog.getParams().setOnCallback((data) => {
                    if (data == 1) {
                      FamilyDB.delete(value.familyId).then((value) => {
                        if (value > 0) {
                          this.loadFamilyList()
                          this.isRefreshFamily = true
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
          bottom: { anchor: 'FamilyManagerPage_btn', align: VerticalAlign.Top }
        })

        Button('创建家庭')
          .id('FamilyManagerPage_btn')
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
            this.dialog_input.getParams().text = '家庭名称'
            this.dialog_input.getParams().setOnCallback((data) => {
              if (data !== '') {
                FamilyDB.insert(new Family(MyUtil.getRandomNumber16(), data)).then((value) => {
                  if (value > 0) {
                    this.loadFamilyList()
                    this.isRefreshFamily = true
                  }
                })
              }
            })
            this.dialog_input.openDialog()
          })
      }
      .height('100%')
      .width('100%')
    }
    .title('家庭管理')
    .backgroundColor($r('app.color.bg'))
    .height('100%')
    .width('100%')
  }
}

@Component
struct FamilyItem {
  @Consume('pageNav') navPathStack: NavPathStack;
  @Prop item: Family
  onDelete: () => void = () => {
  }

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.trash_fill')).width(20).height(20)
        .onClick(() => {
          this.onDelete()
        })

      Text(this.item.familyName + '的家')
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