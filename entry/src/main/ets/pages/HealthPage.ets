/**
 * 健康
 */
@Component
export struct HealthPage {
  @Consume('pageNav') navPathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text("HealthPage")
      }
      .width('100%')
      .height('100%')
    }
  }
}