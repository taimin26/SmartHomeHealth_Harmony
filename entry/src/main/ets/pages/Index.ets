import { HealthPage } from './HealthPage';
import { HomePage } from './HomePage';
import { MinePage } from './MinePage';
import { SmartPage } from './SmartPage';
import { SportPage } from './SportPage';
import { SymbolGlyphModifier } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  //导航
  @Provide('pageNav') navPathStack: NavPathStack = new NavPathStack()
  @State navTitle: string = '返回'
  @State isHideNav: boolean = true
  @State pagePotion: number = 0

  aboutToAppear(): void {

  }

  build() {
    Navigation(this.navPathStack) {
      RelativeContainer() {
        Image($r('app.media.bg_2'))
          .height('100%')
          .width('100%')

        if (this.pagePotion == 0) {
          HomePage()
        } else if (this.pagePotion == 1) {
          SmartPage()
        } else if (this.pagePotion == 2) {
          HealthPage()
        } else if (this.pagePotion == 3) {
          SportPage()
        } else if (this.pagePotion == 4) {
          MinePage()
        }
      }
      .height('100%')
      .width('100%')
    }
    .mode(NavigationMode.Auto)
    .titleMode(NavigationTitleMode.Mini)
    .title(this.navTitle)
    .hideTitleBar(this.isHideNav)
    .toolbarConfiguration(this.getToolBar())
    .padding({ bottom: 30 })
    .background('#F1F3F5')
  }

  /**
   * 底部工具栏
   */
  getToolBar(): ToolbarItem[] {
    let homeTool: ToolbarItem = {
      'value': "家居", 'symbolIcon': new SymbolGlyphModifier($r('sys.symbol.house_fill'))
    }
    let smartTool: ToolbarItem = {
      'value': "智能", 'symbolIcon': new SymbolGlyphModifier($r('sys.symbol.star_fill'))
    }
    let healthTool: ToolbarItem = {
      'value': "健康", 'symbolIcon': new SymbolGlyphModifier($r('sys.symbol.heart_fill'))
    }
    let sportTool: ToolbarItem = {
      'value': "运动", 'symbolIcon': new SymbolGlyphModifier($r('sys.symbol.hand_thumbsup_fill'))
    }
    let mineTool: ToolbarItem = {
      'value': "我的", 'symbolIcon': new SymbolGlyphModifier($r('sys.symbol.person_fill'))
    }
    let ToolBar: ToolbarItem[] = [homeTool, smartTool, healthTool, sportTool, mineTool]

    ToolBar.map((item, index) => {
      item.action = () => {
        this.pagePotion = index;
      }
    })

    return ToolBar
  }
}