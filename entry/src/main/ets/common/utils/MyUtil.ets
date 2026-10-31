export class MyUtil {
  /**
   * 16位随机数字
   * @returns
   */
  static getRandomNumber16(): string {
    let sb = ''
    for (let i = 0; i < 16; i++) {
      // 0~9
      const num = Math.floor(Math.random() * 10)
      sb += num
    }
    return sb
  }

  /**
   * 16位随机数字 + 字母
   */
  static getRandomStr16(isAZ: boolean = false): string {
    let charPool = 'abcdefghijklmnopqrstuvwxyz0123456789';
    if (isAZ) {
      charPool = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    }
    let sb = ''
    for (let i = 0; i < 16; i++) {
      const num = Math.floor(Math.random() * 36)
      sb += charPool[num]
    }
    return sb
  }
}