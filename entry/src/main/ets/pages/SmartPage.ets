/**
 * 智能
 */
@Component
export struct SmartPage {
  @Consume('pageNav') navPathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("SmartPage")
      }
      .width('100%')
      .height('100%')
    }.backgroundColor($r('app.color.transparent'))
  }
}