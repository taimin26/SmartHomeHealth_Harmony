/**
 * 智能
 */
@Component
export struct SmartPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State smartList: Array<string> = ['回家', '离家', '观影模式']

  build() {
    NavDestination() {
      Column() {
        this.TopFunBuilder()

        Grid() {
          ForEach(this.smartList, (value: string, index: number) => {
            GridItem() {
              this.SmartBuilder(value)
            }
          });
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(20)
        .rowsGap(20)
        .padding(20)
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
      Text('智能')
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)

      Text('+').fontSize(35).fontColor(Color.Black).onClick(() => {

      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 60, left: 20, right: 20 })
    .width('100%')
  }

  @Builder
  SmartBuilder(name: string) {
    Column() {
      Row() {
        Text(name).fontSize(16).fontWeight(FontWeight.Medium).fontColor(Color.Black)

        SymbolGlyph($r('sys.symbol.chevron_right'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')

      Row() {
        Image($r('app.media.foreground')).width(30).height(30)

        Toggle({ type: ToggleType.Switch, isOn: false })
      }
      .margin({ top: 20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')
    }
    .padding(20)
    .backgroundColor('#E0FFF0E6')
    .borderRadius(15)
    .width('100%')
  }
}