import { Logger } from '../utils/Logger';
import { relationalStore } from '@kit.ArkData';

/**
 * 数据库 relationalStore
 */

const TAG: string = 'StoreRUtil'

export class StoreRUtil {
  private static ins: StoreRUtil
  private store: relationalStore.RdbStore | undefined = undefined;
  private dbName: string = 'app_db'
  public static table_user: string = 'users'
  public static table_family: string = 'family'
  public static table_rooms: string = 'rooms'
  public static table_devices: string = 'devices'
  public static table_smart: string = 'smart'

  private constructor() {
  }

  static getIns(): StoreRUtil {
    if (!StoreRUtil.ins) {
      StoreRUtil.ins = new StoreRUtil();
    }
    return StoreRUtil.ins;
  }

  /**
   * 初始化
   */
  init(context: Context) {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: this.dbName + '.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
      encrypt: false, // 指定数据库是否加密
      customDir: 'dbDir', // 数据库目录：context.databaseDir + '/rdb/' + dbDir
      isReadOnly: false // 为false，可读可写；为true时，只读
    };

    // 表结构
    const SQL_user =
      'CREATE TABLE IF NOT EXISTS ' + StoreRUtil.table_user +
        ' (ID INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT NOT NULL, name TEXT NOT NULL, age INTEGER)';

    const SQL_family =
      'CREATE TABLE IF NOT EXISTS ' + StoreRUtil.table_family +
        ' (ID INTEGER PRIMARY KEY AUTOINCREMENT, familyId TEXT NOT NULL, familyName TEXT NOT NULL)';

    const SQL_rooms =
      'CREATE TABLE IF NOT EXISTS ' + StoreRUtil.table_rooms +
        ' (ID INTEGER PRIMARY KEY AUTOINCREMENT, roomId TEXT NOT NULL, roomName TEXT NOT NULL)';

    const SQL_devices =
      'CREATE TABLE IF NOT EXISTS ' + StoreRUtil.table_devices +
        ' (ID INTEGER PRIMARY KEY AUTOINCREMENT, deviceId TEXT NOT NULL, belongRoomId TEXT NOT NULL' +
        ', deviceName TEXT, productId TEXT, hardwareId TEXT, icon TEXT, status TEXT, isSwitchOn INTEGER NOT NULL DEFAULT 0)';

    const SQL_smart =
      'CREATE TABLE IF NOT EXISTS ' + StoreRUtil.table_smart +
        ' (ID INTEGER PRIMARY KEY AUTOINCREMENT, smartId TEXT NOT NULL, name TEXT NOT NULL, icon TEXT, isSwitchOn INTEGER NOT NULL DEFAULT 0, conditions TEXT, actions TEXT)';


    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        Logger.error(TAG, `Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      Logger.info(TAG, 'Succeeded in getting RdbStore.');
      this.store = store
      // 初始化成功后，再操作：增删改查

      // 当数据库创建时，数据库默认版本为0
      if (store.version === 0) {
        store.executeSql(SQL_user);
        store.executeSql(SQL_family);
        store.executeSql(SQL_rooms);
        store.executeSql(SQL_devices);
        store.executeSql(SQL_smart);
        store.version = 1;
      }

    });
  }

  /**
   * 插入数据
   */
  async insert(tableName: string, value: relationalStore.ValuesBucket): Promise<number> {
    if (!this.store) {
      return 0
    }
    let number = 0;
    try {
      number = await this.store.insert(tableName, value)
      Logger.info(TAG, `Succeeded insert. ${number}`);
    } catch (err) {
      Logger.error(TAG, `Failed to insert data. Code:${err.code}, message:${err.message}`);
    }
    return number
  }

  /**
   * 查询数据
   */
  async query(predicates: relationalStore.RdbPredicates): Promise<relationalStore.ValuesBucket[]> {
    if (!this.store) {
      return [];
    }
    let resultSet: relationalStore.ResultSet | null = null;
    const buckets: relationalStore.ValuesBucket[] = [];
    try {
      resultSet = await this.store.query(predicates, []);
      while (resultSet.goToNextRow()) {
        buckets.push(resultSet.getRow());
      }
    } catch (err) {
      Logger.error(TAG, `Failed to query data. Code:${err.code}, message:${err.message}`);
    } finally {
      if (resultSet) {
        resultSet.close();
      }
    }
    return buckets;
  }

  /**
   * 修改数据
   */
  update(predicates: relationalStore.RdbPredicates, value: relationalStore.ValuesBucket) {
    if (this.store) {
      this.store.update(value, predicates, (err: BusinessError, rows: number) => {
        if (err) {
          Logger.error(TAG, `Failed to update data. Code:${err.code}, message:${err.message}`);
          return
        }
        Logger.info(TAG, `Succeeded in updating data. row count: ${rows}`);
      })
    }
  }

  /**
   * 删除数据
   */
  delete(predicates: relationalStore.RdbPredicates) {
    if (this.store) {
      this.store.delete(predicates, (err: BusinessError, rows: number) => {
        if (err) {
          Logger.error(TAG, `Failed to delete data. Code:${err.code}, message:${err.message}`);
          return
        }
        Logger.info(TAG, `Succeeded in delete data. row count: ${rows}`);
      })
    }
  }

  /**
   * 删除数据表
   */
  deleteTable(tableName: string) {
    if (this.store) {
      const SQL = 'DROP TABLE IF EXISTS ' + tableName;
      this.store.executeSql(SQL, (err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `Failed to drop table. Code:${err.code}, message:${err.message}`);
          return;
        }
        Logger.info(TAG, 'Succeeded in dropping table.');
      });
    }
  }

  /**
   * 删除数据库
   */
  deleteDB(context: Context) {
    relationalStore.deleteRdbStore(context, this.dbName, (err: BusinessError) => {
      if (err) {
        Logger.error(TAG, `Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
        return
      }
      Logger.info(TAG, 'Succeeded in deleting RdbStore.');
    });
  }
}