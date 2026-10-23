import { Logger } from "../common/utils/Logger";
import { SystemUtil } from "../common/utils/SystemUtil";
import EntryAbility from "../entryability/EntryAbility";

@Builder
export function VideoPageBuilder(): void {
  VideoPage();
}

@Entry
@Component
struct VideoPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State videoUrl: string = ''
  private videoCtrl: VideoController = new VideoController()

  aboutToAppear(): void {
    SystemUtil.setWindowFullScreen(EntryAbility.windowStage, false)
  }

  aboutToDisappear(): void {
    SystemUtil.setWindowFullScreen(EntryAbility.windowStage, true)
    this.videoCtrl.stop()
  }

  build() {
    NavDestination() {
      Video({
        src: this.videoUrl,
        controller: this.videoCtrl
      })
        .width('100%')
        .aspectRatio(16 / 9)
        .controls(true)
        .loop(true)
        .autoPlay(true)
        .objectFit(ImageFit.Contain)
        .onError((err) => {
          Logger.debug('VideoPage', err.message)
        })
    }
    .onReady((ctx: NavDestinationContext) => {
      this.videoUrl = ctx.pathInfo.param as string
    })
    .title('VideoPage')
    .height('100%')
    .width('100%')
  }
}