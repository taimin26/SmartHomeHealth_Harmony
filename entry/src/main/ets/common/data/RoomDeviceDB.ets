import { StoreRUtil } from "./StoreRUtil";
import { relationalStore } from "@kit.ArkData";
import { Logger } from "../utils/Logger";
import { MyUtil } from "../utils/MyUtil";

export class Room {
  roomId: string;
  roomName: string;

  constructor(roomId: string, roomName: string) {
    this.roomId = roomId;
    this.roomName = roomName;
  }
}

export class Device {
  deviceId: string;
  belongRoomId: string;
  deviceName: string;
  productId: string;
  hardwareId: string;
  icon: string;
  status: string;
  isSwitchOn: boolean;

  constructor(deviceId: string, belongRoomId: string, deviceName: string, productId: string,
    hardwareId: string, icon: string, status: string, isSwitchOn: boolean) {
    this.deviceId = deviceId;
    this.belongRoomId = belongRoomId;
    this.deviceName = deviceName;
    this.productId = productId;
    this.hardwareId = hardwareId;
    this.icon = icon;
    this.status = status;
    this.isSwitchOn = isSwitchOn;
  }
}

export class RoomDevices {
  room: Room;
  devices: Array<Device>;

  constructor(room: Room, devices: Array<Device>) {
    this.room = room;
    this.devices = devices;
  }
}

export class RoomDeviceDao {
  static async insertTest() {
    let dataRoom: RoomDevices[] = getDeviceList()
    for (let i = 0; i < dataRoom.length; i++) {
      let data: Device[] = dataRoom[i].devices
      for (let j = 0; j < data.length; j++) {
        await RoomDeviceDao.insertDevice(data[j])
      }
    }
  }

  static async getAllRooms(): Promise<Room[]> {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_rooms);
    const data = await StoreRUtil.getIns().query(predicates)
    let dataArray: Room[] = JSON.parse(JSON.stringify(data))
    return dataArray
  }

  static async getDevicesByRoomId(roomId: string): Promise<Device[]> {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    predicates.equalTo('belongRoomId', roomId);
    const data = await StoreRUtil.getIns().query(predicates)
    let dataArray: Device[] = JSON.parse(JSON.stringify(data))
    return dataArray;
  }

  static async getRoom(roomId: string): Promise<Room> {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_rooms);
    predicates.equalTo('roomId', roomId);
    const data = await StoreRUtil.getIns().query(predicates)
    let dataArray: Room = JSON.parse(JSON.stringify(data))
    return dataArray
  }

  static async getAllRoomsWithDevices(): Promise<RoomDevices[]> {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_rooms);
    const roomBuckets = await StoreRUtil.getIns().query(predicates);
    const roomDevicesList: RoomDevices[] = [];
    for (const rb of roomBuckets) {
      const room = new Room(rb.roomId as string, rb.roomName as string);
      const devices = await RoomDeviceDao.getDevicesByRoomId(room.roomId);
      roomDevicesList.push(new RoomDevices(room, devices));
    }
    return roomDevicesList;
  }

  static async insertRoom(room: Room) {
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(room));
    await StoreRUtil.getIns().insert(StoreRUtil.table_rooms, value)
  }

  static async insertDevice(device: Device) {
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(device));
    await StoreRUtil.getIns().insert(StoreRUtil.table_devices, value)
  }

  static deleteAllRooms() {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_rooms);
    StoreRUtil.getIns().delete(predicates)
  }

  static deleteAllDevices() {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    StoreRUtil.getIns().delete(predicates)
  }

  static deleteRoom(roomId: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_rooms);
    predicates.equalTo('roomId', roomId);
    StoreRUtil.getIns().delete(predicates)
  }

  static deleteDevices(deviceId: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    predicates.equalTo('deviceId', deviceId);
    StoreRUtil.getIns().delete(predicates)
  }

  static deleteDevicesInRoom(roomId: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    predicates.equalTo('belongRoomId', roomId);
    StoreRUtil.getIns().delete(predicates)
  }

  static updateDevice(device: Device) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    predicates.equalTo('deviceId', device.deviceId);
    const value: relationalStore.ValuesBucket = JSON.parse(JSON.stringify(device));
    StoreRUtil.getIns().update(predicates, value)
  }

  static updateDeviceName(deviceId: string, deviceName: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    predicates.equalTo('deviceId', deviceId);
    const value: relationalStore.ValuesBucket = {
      deviceName: deviceName
    };
    StoreRUtil.getIns().update(predicates, value)
  }

  static updateDeviceRoomId(deviceId: string, belongRoomId: string) {
    let predicates = new relationalStore.RdbPredicates(StoreRUtil.table_devices);
    predicates.equalTo('deviceId', deviceId);
    const value: relationalStore.ValuesBucket = {
      belongRoomId: belongRoomId
    };
    StoreRUtil.getIns().update(predicates, value)
  }
}

export function getDeviceList(): RoomDevices[] {
  return [
    new RoomDevices(new Room("1", "客厅"), [
      new Device(MyUtil.getRandomStr16(), "1", "主灯", "light", MyUtil.getRandomStr16(true), "", "1", true),
      new Device(MyUtil.getRandomStr16(), "1", "扫地机器人", "floor-robot", MyUtil.getRandomStr16(true), "", "0",
        false),
      new Device(MyUtil.getRandomStr16(), "1", "摄像头", "camera", MyUtil.getRandomStr16(true), "", "1", false),
      new Device(MyUtil.getRandomStr16(), "1", "电视", "tv", MyUtil.getRandomStr16(true), "", "1", false)
    ]),
    new RoomDevices(new Room("2", "主卧"), [
      new Device(MyUtil.getRandomStr16(), "2", "主灯", "light", MyUtil.getRandomStr16(true), "", "1", true),
      new Device(MyUtil.getRandomStr16(), "2", "空调", "air-conditioner", MyUtil.getRandomStr16(true), "", "1", false),
      new Device(MyUtil.getRandomStr16(), "2", "窗帘", "curtain", MyUtil.getRandomStr16(true), "", "1", true)
    ]),
    new RoomDevices(new Room("3", "次卧"), [
      new Device(MyUtil.getRandomStr16(), "3", "主灯", "light", MyUtil.getRandomStr16(true), "", "1", true),
      new Device(MyUtil.getRandomStr16(), "3", "空调", "air-conditioner", MyUtil.getRandomStr16(true), "", "1", false),
      new Device(MyUtil.getRandomStr16(), "3", "窗帘", "curtain", MyUtil.getRandomStr16(true), "", "1", true)
    ]),
    new RoomDevices(new Room("4", "厨房"), [
      new Device(MyUtil.getRandomStr16(), "4", "主灯", "light", MyUtil.getRandomStr16(true), "", "1", true)
    ])
  ]
}