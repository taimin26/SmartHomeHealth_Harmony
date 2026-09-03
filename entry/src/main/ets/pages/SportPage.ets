/**
 * 运动
 */
@Component
export struct SportPage {
  @Consume('pageNav') navPathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("SportPage")
      }
      .width('100%')
      .height('100%')
    }.backgroundColor($r('app.color.transparent'))
  }
}