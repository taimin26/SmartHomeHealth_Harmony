/**
 * 运动页面数据
 */
@Observed
export class SportBean {
  id: number
  image: Resource;
  title: string;
  url: string;
  like: number;
  save: number;
  isLike: boolean;
  isSave: boolean;

  constructor(id: number, image: Resource, title: string, url: string, like: number, save: number,
    isLike: boolean, isSave: boolean) {
    this.id = id
    this.image = image;
    this.title = title;
    this.url = url;
    this.like = like;
    this.save = save;
    this.isLike = isLike;
    this.isSave = isSave;
  }
}

export function getSportList(): SportBean[] {
  return [
    new SportBean(1, $r('app.media.sport_1'), "定制个人训练计划，新手零基础也能落地",
      "https://googledownloads.cn/cn-devsite/qX6zmKY4KP0.mp4", 1000, 19, false, false),
    new SportBean(2, $r('app.media.sport_2'), "减脂、跑步、瑜伽到底选哪个？",
      "https://googledownloads.cn/cn-devsite/qX6zmKY4KP0.mp4", 1500, 50, false, false),
    new SportBean(3, $r('app.media.sport_3'), "新手建议，开启智慧生活",
      "https://googledownloads.cn/cn-devsite/qX6zmKY4KP0.mp4", 500, 10, false, false),
    new SportBean(4, $r('app.media.sport_4'), "健康生活，享受乐趣",
      "https://googledownloads.cn/cn-devsite/qX6zmKY4KP0.mp4", 800, 30, false, false),
    new SportBean(5, $r('app.media.sport_5'), "打开新玩法，打卡积分",
      "https://googledownloads.cn/cn-devsite/qX6zmKY4KP0.mp4", 100, 5, false, false),
    new SportBean(6, $r('app.media.sport_6'), "零基础瑜伽入门，分阶课程跟着做",
      "https://googledownloads.cn/cn-devsite/qX6zmKY4KP0.mp4", 600, 15, false, false),
  ]
}
