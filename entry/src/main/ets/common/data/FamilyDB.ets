import { StoreRUtil } from "./StoreRUtil";
import { relationalStore } from "@kit.ArkData";
import { Logger } from "../utils/Logger";
import { MyUtil } from "../utils/MyUtil";

export class Family {
  familyId: string
  familyName: string

  constructor(familyId: string, familyName: string) {
    this.familyId = familyId;
    this.familyName = familyName
  }
}

export class FamilyDB {
  static async insertTest() {
    let data: Family[] = getFamilyList()
    for (let i = 0; i < data.length; i++) {
      await FamilyDB.insert(data[i])
    }
  }

  static async insert(family: Family) {
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(family));
    await StoreRUtil.getIns().insert(StoreRUtil.table_family, value)
  }

  static async queryAll(): Promise<Family[]> {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_family);
    const data = await StoreRUtil.getIns().query(predicates)
    let dataArray: Family[] = JSON.parse(JSON.stringify(data))
    return dataArray
  }

  static update(family: Family) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_family);
    predicates.equalTo('familyId', family.familyId);
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(family));
    StoreRUtil.getIns().update(predicates, value)
  }

  static delete(familyId: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_family);
    predicates.equalTo('familyId', familyId);
    StoreRUtil.getIns().delete(predicates)
  }
}

export function getFamilyList(): Family[] {
  return [
    new Family(MyUtil.getRandomNumber16(), "H"),
    new Family(MyUtil.getRandomNumber16(), "Z"),
    new Family(MyUtil.getRandomNumber16(), "小H"),
  ];
}