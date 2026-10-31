import { StoreRUtil } from "./StoreRUtil";
import { relationalStore, ValueType } from "@kit.ArkData";
import { Logger } from "../utils/Logger";
import { MyUtil } from "../utils/MyUtil";


/**
 * 自动化主实体 Smart
 */
export class Smart {
  smartId: string
  name: string
  icon: string
  isSwitchOn: boolean
  conditions: Condition[]
  actions: Action[]

  constructor(
    smartId: string,
    name: string,
    icon: string,
    isSwitchOn: boolean,
    conditions: Condition[],
    actions: Action[]
  ) {
    this.smartId = smartId
    this.name = name
    this.icon = icon
    this.isSwitchOn = isSwitchOn
    this.conditions = conditions
    this.actions = actions
  }
}

/**
 * 条件
 * type 1=设备 2=定时 3=系统
 */
export class Condition {
  type: number
  smartDevice: SmartDevice | null
  smartTimer: SmartTimer | null
  smartSystem: SmartSystem | null

  constructor(
    type: number,
    smartDevice: SmartDevice | null,
    smartTimer: SmartTimer | null,
    smartSystem: SmartSystem | null
  ) {
    this.type = type
    this.smartDevice = smartDevice
    this.smartTimer = smartTimer
    this.smartSystem = smartSystem
  }
}

/**
 * 动作
 * type 1=设备 3=系统
 */
export class Action {
  type: number
  smartDevice: SmartDevice | null
  smartSystem: SmartSystem | null

  constructor(
    type: number,
    smartDevice: SmartDevice | null,
    smartSystem: SmartSystem | null
  ) {
    this.type = type
    this.smartDevice = smartDevice
    this.smartSystem = smartSystem
  }
}

/**
 * 设备操作
 */
export class SmartDevice {
  deviceId: string
  deviceName: string
  productId: string
  operate: string

  constructor(deviceId: string, deviceName: string, productId: string, operate: string) {
    this.deviceId = deviceId
    this.deviceName = deviceName
    this.productId = productId
    this.operate = operate
  }
}

/**
 * 定时操作
 */
export class SmartTimer {
  time: string // 2000-01-01 12:30:00
  cycle: string // 1-0-0-0-0-0-0  周一执行

  constructor(time: string, cycle: string) {
    this.time = time
    this.cycle = cycle
  }
}

/**
 * 系统操作
 */
export class SmartSystem {
  type: number // 1=打开应用 2=提醒和语音 3=唤醒语音助手
  operate: string

  constructor(type: number, operate: string) {
    this.type = type
    this.operate = operate
  }
}

export function smartToBucket(smart: Smart): relationalStore.ValuesBucket {
  return {
    smartId: smart.smartId,
    name: smart.name,
    icon: smart.icon,
    isSwitchOn: smart.isSwitchOn ? 1 : 0,
    conditions: JSON.stringify(smart.conditions),
    actions: JSON.stringify(smart.actions)
  }
}

export function bucketToSmart(bucket: relationalStore.ValuesBucket): Smart {
  const conditions: Condition[] = JSON.parse(bucket.conditions as string)
  const actions: Action[] = JSON.parse(bucket.actions as string)

  return new Smart(
    bucket.smartId as string,
    bucket.name as string,
    bucket.icon as string,
    Boolean(bucket.isSwitchOn),
    conditions,
    actions
  )
}

export class SmartDB {
  static async insertTest() {
    let data: Smart[] = getSmartList()
    for (let i = 0; i < data.length; i++) {
      await SmartDB.insert(data[i])
    }
  }

  static async insert(smart: Smart) {
    const value: relationalStore.ValuesBucket = smartToBucket(smart)
    await StoreRUtil.getIns().insert(StoreRUtil.table_smart, value)
  }

  static async queryAll(): Promise<Smart[]> {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_smart);
    const buckets: relationalStore.ValuesBucket[] = await StoreRUtil.getIns().query(predicates)
    let dataArray: Smart[] = []
    for (let i = 0; i < buckets.length; i++) {
      dataArray[i] = bucketToSmart(buckets[i])
    }
    Logger.info('StoreRUtil', 'queryAll--' + JSON.stringify(dataArray))
    return dataArray
  }
}

export function getSmartList(): Smart[] {
  const conditions: Condition[] = [
    new Condition(1, new SmartDevice("", "主灯", "", ""), null, null)
  ];
  const actions: Action[] = [
    new Action(3, null, new SmartSystem(1, "打开音乐"))
  ];

  return [
    new Smart(MyUtil.getRandomNumber16(), "回家", "", true, conditions, actions),
    new Smart(MyUtil.getRandomNumber16(), "离家", "", true, conditions, actions),
    new Smart(MyUtil.getRandomNumber16(), "观影模式", "", false, conditions, actions),
  ];
}