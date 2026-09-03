/**
 * 我的
 */
@Component
export struct MinePage {
  @Consume('pageNav') navPathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("MinePage")
      }
      .width('100%')
      .height('100%')
    }.backgroundColor($r('app.color.transparent'))
  }
}