/**
 * 我的
 */
@Component
export struct MinePage {
  @Consume('pageNav') navPathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.ic_launcher')).height(60).width(60).margin({ left: 50 })

          Text('未登录').fontSize(18).margin({ left: 20 })
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .height(120)
        .width('100%')

        Column() {
          Row() {
            SymbolGlyph($r('sys.symbol.gearshape_fill'))

            Text('设置').margin({ left: 10 })
          }
          .justifyContent(FlexAlign.Start)
          .height(60)
          .width('100%')

          Column() {
          }.background($r('app.color.gray_e5')).padding({ left: 20 }).height(1).width('100%')

          Row() {
            SymbolGlyph($r('sys.symbol.quick_help'))

            Text('帮助').margin({ left: 10 })
          }
          .height(60)
          .justifyContent(FlexAlign.Start)
          .width('100%')
        }
        .borderRadius(16)
        .backgroundColor(Color.White)
        .margin({ top: 20 })
        .padding({
          left: 20,
          right: 20,
          top: 10,
          bottom: 10
        })
        .width('100%')

        Button('退出登录')
          .fontColor($r('app.color.main_blue'))
          .backgroundColor(Color.White)
          .borderRadius(24)
          .margin({ top: 30 })
          .height(50)
          .width('70%')

      }
      .padding({ top: 60, left: 20, right: 20 })
      .width('100%')
      .height('100%')
    }.backgroundColor($r('app.color.transparent'))
  }
}