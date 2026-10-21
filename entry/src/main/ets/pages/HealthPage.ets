import {
  EntryOhos,
  Highlight,
  JArrayList,
  LegendForm,
  LegendHorizontalAlignment,
  LineChart,
  LineChartModel,
  LineData,
  LineDataSet,
  Mode,
  OnChartValueSelectedListener,
  XAxisPosition
} from "@ohos/mpchart";

/**
 * 健康
 */
@Component
export struct HealthPage {
  @Consume('pageNav') navPathStack: NavPathStack;
  @State healthList: Array<string> = ['心率', '血压', '体重', '睡眠']
  @State selectedIndex: number = 0
  private model: LineChartModel = new LineChartModel();

  aboutToAppear() {
    this.initChart();

    /*const dataSet1 = new LineDataSet(list1,"A线");
    const dataSet2 = new LineDataSet(list2,"B线");
    const lineData = new LineData();
    lineData.addDataSet(dataSet1);
    lineData.addDataSet(dataSet2);
    this.model.setData(lineData);*/

    /*xAxis.setValueFormatter({
      getFormattedValue: (value: number):string => {
        const labels = ["周一","周二","周三","周四","周五","周六","周日"];
        const idx = Math.round(value);
        if(idx >=0 && idx < labels.length){
          return labels[idx];
        }
        return "";
      }
    } as IAxisValueFormatter)*/

    /*this.model.getData()?.notifyDataChanged();
    this.model.notifyDataSetChanged();*/

  }

  aboutToDisappear() {
    this.model.clearJobs();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          this.TopFunBuilder()

          Row() {
            Image($r('app.media.ic_launcher')).width(50).height(50)

            Text('未登录').fontSize(18).margin({ left: 20 })

            Blank()

            Text('90分').fontSize(30).fontColor($r('app.color.main_blue'))
          }
          .padding(20)
          .width('100%')

          List({ space: 12 }) {
            ForEach(this.healthList, (value: string, index: number) => {
              ListItem() {
                this.HealthBuilder(value, index)
              }.onClick(() => {
                this.selectedIndex = index
              })
            });
          }
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .padding({ left: 20, right: 20 })
          .margin({ top: 10 })
          .height(150)
          .width('100%')

          LineChart({ model: this.model })
            .padding({ left: 20, right: 20 })
            .margin({ top: 10 })
            .width('100%')
            .height(300)

          Column() {
            Text('健康分析').fontSize(18).fontWeight(FontWeight.Bold)

            Text("（仅为参考文案，以实际项目为准）\n\n" +
              "您的血压处于理想正常血压范围，说明心脏泵血和血管弹性状态良好，心血管负担较轻，是比较健康的血压水平。\n" +
              "\n温馨提示：\n" +
              "1、该数值对大多数成年人来说是非常健康的状态，继续保持即可。\n" +
              "2、若平时没有头晕、乏力、眼前发黑、站立不稳等不适，无需担心。\n" +
              "3、若经常出现头晕、乏力等症状，可适当增加营养、规律饮水，必要时咨询医生。\n")
              .fontSize(16)
              .margin({ top: 10 })
          }
          .padding({ left: 30, right: 30 })
          .margin({ top: 30})
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .height(300)

        }
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .padding({ bottom: 30 })
      .margin({ top: 60 })
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.bg'))
  }

  @Builder
  TopFunBuilder() {
    Row() {
      Text('健康')
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
      MenuItem({ content: "添加设备" })
        .onClick(() => {

        })
    }
  }

  @Builder
  HealthBuilder(name: string, index: number) {
    Column() {
      SymbolGlyph($r('sys.symbol.heart_fill'))
        .fontSize(24)
        .fontColor([index == this.selectedIndex ? Color.White : Color.Gray])

      Text(name).fontSize(16).fontColor(index == this.selectedIndex ? Color.White : Color.Black).margin({ top: 8 })

      Text('85').fontSize(22).fontColor(index == this.selectedIndex ? Color.White : Color.Black).margin({ top: 12 })

      Text('9:30').fontSize(14).fontColor(index == this.selectedIndex ? Color.White : Color.Gray).margin({ top: 4 })
    }
    .backgroundColor(index == this.selectedIndex ? '#FF2196F3' : Color.White)
    .borderRadius(15)
    .justifyContent(FlexAlign.Center)
    .height(150)
    .width(90)
  }

  initChart() {
    // 动画
    this.model.animateY(600);

    // 图表描述
    this.model.getDescription()?.setEnabled(false);

    // 图例
    this.model.getLegend()?.setEnabled(true);
    this.model.getLegend()?.setForm(LegendForm.LINE);
    this.model.getLegend()?.setFormSize(15); //横线长度
    this.model.getLegend()?.setFormLineWidth(2); //横线宽度
    this.model.getLegend()?.setHorizontalAlignment(LegendHorizontalAlignment.CENTER);
    this.model.getLegend()?.setTextSize(14);
    this.model.getLegend()?.setXEntrySpace(20); //图例之间水平间距
    this.model.getLegend()?.setFormToTextSpace(6); //图标和文字的距离
    this.model.setExtraBottomOffset(15) //离X轴的距离

    // X轴配置
    const xAxis = this.model.getXAxis();
    xAxis?.setPosition(XAxisPosition.BOTTOM);
    xAxis?.setSpaceMin(0.5); // X轴从0.5个单位格开始
    xAxis?.setSpaceMax(0.5); // X轴离0.5个单位格结束
    xAxis?.setDrawGridLines(true);
    xAxis?.setGridLineWidth(0.5)
    xAxis?.setGridColor(0xFFE0E0E0);
    xAxis?.setAxisLineWidth(1);
    xAxis?.setAxisLineColor(0xFFE0E0E0);

    // Y轴配置
    this.model.getAxisRight()?.setEnabled(false);
    const leftY = this.model.getAxisLeft();
    leftY?.setAxisMinimum(0);
    leftY?.setDrawGridLines(true);
    leftY?.setGridLineWidth(0.5)
    leftY?.setGridColor(0xFFE0E0E0);
    leftY?.setAxisLineWidth(0.5);
    leftY?.setAxisLineColor(0xFFE0E0E0);

    // 手势：缩放、横向拖拽
    this.model.setScaleEnabled(false);
    this.model.setDragXEnabled(false);

    // 构建数据
    const entries = new JArrayList<EntryOhos>();
    // x索引，y数值
    entries.add(new EntryOhos(1, 80));
    entries.add(new EntryOhos(2, 70));
    entries.add(new EntryOhos(3, 80));
    entries.add(new EntryOhos(4, 70));
    entries.add(new EntryOhos(5, 80));
    entries.add(new EntryOhos(6, 70));

    // 数据集：一条折线对应一个DataSet
    const dataSet = new LineDataSet(entries, "数据1");
    dataSet.setDrawValues(false);
    dataSet.setColorByColor(0xFF6B35); //折线颜色
    dataSet.setLineWidth(2);
    dataSet.setDrawCircles(false);
    dataSet.setCircleColor(0xFF6B35);
    dataSet.setCircleRadius(2);
    dataSet.setDrawFilled(false);
    dataSet.setMode(Mode.LINEAR); //LINEAR直线 / CUBIC_BEZIER平滑曲线
    dataSet.setHighLightColor(0xFF6B35); //点击选中高亮线颜色


    // 构建数据
    const entries2 = new JArrayList<EntryOhos>();
    // x索引，y数值
    entries2.add(new EntryOhos(1, 50));
    entries2.add(new EntryOhos(2, 40));
    entries2.add(new EntryOhos(3, 50));
    entries2.add(new EntryOhos(4, 40));
    entries2.add(new EntryOhos(5, 50));
    entries2.add(new EntryOhos(6, 40));

    // 数据集：一条折线对应一个DataSet
    const dataSet2 = new LineDataSet(entries2, "数据2");
    dataSet2.setDrawValues(false);
    dataSet2.setColorByColor(0xFF00B8A9); //折线颜色
    dataSet2.setLineWidth(2);
    dataSet2.setDrawCircles(false);
    dataSet2.setCircleColor(0xFF00B8A9);
    dataSet2.setCircleRadius(2);
    dataSet2.setDrawFilled(false);
    dataSet2.setMode(Mode.LINEAR); //LINEAR直线 / CUBIC_BEZIER平滑曲线
    dataSet2.setHighLightColor(0xFF00B8A9); //点击选中高亮线颜色


    // 组装data
    const lineData = new LineData();
    lineData.addDataSet(dataSet);
    lineData.addDataSet(dataSet2);
    this.model.setData(lineData);

    // 点击选中监听（tooltip业务在这里处理）
    const selectListener: OnChartValueSelectedListener = {
      onValueSelected: (e: EntryOhos, h: Highlight) => {
        console.info(`选中 x=${e.getX()}, y=${e.getY()}`);
      },
      onNothingSelected: () => {
        console.info("取消选中");
      }
    }
    this.model.setOnChartValueSelectedListener(selectListener);
  }
}