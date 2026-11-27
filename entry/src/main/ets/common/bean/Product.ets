/**
 * 产品数据类
 */
export class Product {
  productName: string;
  productId: string;

  constructor(productName: string, productId: string) {
    this.productName = productName;
    this.productId = productId;
  }
}

export function getProductList(): Product[] {
  return [
    new Product('灯', 'light'),
    new Product('窗帘', 'curtain'),
    new Product('电视', 'tv'),
    new Product('空调', 'air-conditioner'),
    new Product('插座', 'socket'),
    new Product('扫地机器人', 'floor-robot'),
    new Product('摄像头', 'camera'),
    new Product('空气净化器', 'air-cleaner'),
    new Product('晾衣机', 'electric-clothes-hanger'),
    new Product('智能门锁', 'door-lock'),
    new Product('体脂秤', 'body-fat-scale'),
    new Product('血压计', 'blood-pressure-monitor')
  ];
}

