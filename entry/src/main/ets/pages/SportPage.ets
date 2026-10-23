import { LengthMetrics } from '@kit.ArkUI';
import { getSportList, SportBean } from '../common/bean/SportBean';

/**
 * 运动
 */
@Component
export struct SportPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  private bannerList: Resource[] = [
    $r('app.media.banner_1'),
    $r('app.media.banner_2'),
    $r('app.media.banner_3'),
  ]
  @State stepTarget: number = 10000
  @State stepValue: number = 8000
  @State stepProgress: number = 0.8
  @State private sportList: SportBean[] = getSportList()
  @State likeNum: number = 1000
  @State saveNum: number = 19

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          this.TopFunBuilder()

          Column() {
            Swiper() {
              ForEach(this.bannerList, (res: Resource) => {
                Image(res)
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.Cover)
              }, (res: Resource) => res.id.toString())
            }
            .autoPlay(true)
            .interval(3000)
            .loop(true)
            .duration(300)
            .indicator(
              new DotIndicator()
                .color(Color.Gray)
                .selectedColor(Color.White)
                .itemWidth(6)
                .itemHeight(6)
                .selectedItemWidth(16)
                .selectedItemHeight(6)
                .space(LengthMetrics.vp(8))
                .bottom(10)
            )
            .borderRadius(16)
            .height(200)
            .width('100%')

            Row() {
              Text('运动步数').fontSize(18).fontWeight(FontWeight.Bold)

              Text(this.stepValue + '步').fontSize(18).fontWeight(FontWeight.Bold)
            }
            .margin({ top: 30 })
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

            Progress({
              value: this.stepProgress,
              total: 1,
              type: ProgressType.Linear
            })
              .color(Color.Blue)
              .backgroundColor($r('app.color.gray_e5'))
              .style({
                strokeWidth: 10,
                strokeRadius: 5,
              })
              .margin({ top: 30 })
              .width('100%')
              .height(10)

            Text('发现')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 30, bottom: 20 })
              .textAlign(TextAlign.Start)
              .width('100%')

            List({ space: 12 }) {
              ForEach(this.sportList, (value: SportBean, index: number) => {
                ListItem() {
                  SportCardItem({ item: value })
                }
              });
            }
            .listDirection(Axis.Vertical)
            .scrollBar(BarState.Off)
            .width('100%')

          }
          .padding({ top: 30, left: 20, right: 20 })
        }
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .padding({ bottom: 30 })
      .margin({ top: 60 })
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.transparent'))
    .width('100%')
    .height('100%')
  }

  @Builder
  TopFunBuilder() {
    Row() {
      Text('运动')
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.Black)

      Text('+').fontSize(35).fontColor(Color.Black).bindMenu(this.AddMenuBuilder())
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 20, right: 20 })
    .width('100%')
  }

  @Builder
  AddMenuBuilder() {
    Menu() {
      MenuItem({ content: "设置目标步数" })
        .onClick(() => {

        })
    }
  }
}

@Component
struct SportCardItem {
  @Consume('pageNav') navPathStack: NavPathStack;
  @ObjectLink item: SportBean;

  build() {
    Column() {
      Image(this.item.image)
        .borderRadius({ topLeft: 16, topRight: 16 })
        .width('100%')

      Text(this.item.title)
        .fontSize(18)
        .textAlign(TextAlign.Start)
        .padding({ left: 10, right: 10 })
        .margin({ top: 10 })
        .width('100%')

      Row() {
        if (this.item.isLike) {
          SymbolGlyph($r('sys.symbol.heart_fill'))
            .fontSize(20)
            .onClick(() => {
              this.item.isLike = !this.item.isLike
              this.item.like += this.item.isLike ? 1 : -1
            })
        } else {
          SymbolGlyph($r('sys.symbol.heart'))
            .fontSize(20)
            .onClick(() => {
              this.item.isLike = !this.item.isLike
              this.item.like += this.item.isLike ? 1 : -1
            })
        }
        Text(`${this.item.like}`).margin({ right: 20 })

        if (this.item.isSave) {
          SymbolGlyph($r('sys.symbol.star_fill'))
            .fontSize(20)
            .onClick(() => {
              this.item.isSave = !this.item.isSave
              this.item.save += this.item.isSave ? 1 : -1
            })
        } else {
          SymbolGlyph($r('sys.symbol.star'))
            .fontSize(20)
            .onClick(() => {
              this.item.isSave = !this.item.isSave
              this.item.save += this.item.isSave ? 1 : -1
            })
        }
        Text(`${this.item.save}`)
      }
      .justifyContent(FlexAlign.End)
      .padding(10)
      .width('100%')
    }
    .onClick(() => {
      this.navPathStack.pushPathByName('VideoPage', this.item.url)
    })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .width('100%')
  }
}