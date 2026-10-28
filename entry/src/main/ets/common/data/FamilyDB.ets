import { StoreRUtil } from "../utils/StoreRUtil";
import { relationalStore } from "@kit.ArkData";
import { Logger } from "../utils/Logger";

export class Family {
  familyId: string;
  familyName: string

  constructor(familyId: string, familyName: string) {
    this.familyId = familyId;
    this.familyName = familyName
  }
}

export class FamilyDB {
  static insert(family: Family) {
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(family));
    StoreRUtil.getIns().insert(StoreRUtil.table_family, value)
  }

  static queryAll() {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_family);
    StoreRUtil.getIns().query(predicates).then((data) => {
      Logger.info('StoreRUtil', 'queryAll--' + JSON.stringify(data))
      let dataArray: Family[] = JSON.parse(JSON.stringify(data))
    })
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