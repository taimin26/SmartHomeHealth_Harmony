import { StoreRUtil } from "../utils/StoreRUtil";
import { relationalStore } from "@kit.ArkData";
import { Logger } from "../utils/Logger";

export class User {
  userId: string;
  name: string;
  age: number

  constructor(userId: string, name: string, age: number) {
    this.userId = userId;
    this.name = name;
    this.age = age;
  }
}

export class UserDB {
  static insert(user: User) {
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(user));
    StoreRUtil.getIns().insert(StoreRUtil.table_user, value)
  }

  static queryAll() {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_user);
    StoreRUtil.getIns().query(predicates).then((data) => {
      Logger.info('StoreRUtil', 'queryAll--' + JSON.stringify(data))
      let dataArray: User[] = JSON.parse(JSON.stringify(data))
    })
  }

  static update(user: User) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_user);
    predicates.equalTo('userId', user.userId);
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(user));
    StoreRUtil.getIns().update(predicates, value)
  }

  static delete(userId: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_user);
    predicates.equalTo('userId', userId);
    StoreRUtil.getIns().delete(predicates)
  }

  static deleteTable() {
    StoreRUtil.getIns().deleteTable(StoreRUtil.table_user)
  }

  static deleteDB(context: Context) {
    StoreRUtil.getIns().deleteDB(context)
  }
}