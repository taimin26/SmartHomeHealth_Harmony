import { LengthMetrics } from "@kit.ArkUI";

/**
 * 家居
 */
@Component
export struct HomePage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State familyName: string = '--的家'
  @State currentIndex: number = 0;
  @State familyList: Array<string> = ['H', 'Z', '小H']
  @State roomList: Array<string> = ['客厅', '主卧', '次卧', '厨房']
  @State deviceList: Array<string> = ['主灯', '扫地机器人', '摄像头', '电视']

  build() {
    NavDestination() {
      Column() {
        this.TopFunBuilder()

        Tabs() {
          ForEach(this.roomList, (value: string, index: number) => {
            TabContent() {
              this.DevicePageBuilder()
            }
            .tabBar(this.TabItemBuilder(value, index))
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
      ForEach(this.familyList, (value: string, index: number) => {
        MenuItem({ content: value + '的家' })
          .onClick(() => {
            this.familyName = value + '的家'
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
  DevicePageBuilder() {
    Column() {
      Grid() {
        ForEach(this.deviceList, (value: string, index: number) => {
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
  DeviceBuilder(name: string) {
    Column() {
      Text(name).fontSize(16).fontWeight(FontWeight.Medium).fontColor(Color.Black)

      Text('在线').fontSize(14).fontWeight(FontWeight.Medium).fontColor('#80000000').margin({ top: 4 })

      Image($r('app.media.foreground')).margin({ top: 20 }).width(30).height(30)
    }
    .padding(20)
    .backgroundColor('#E0FFF0E6')
    .borderRadius(15)
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}