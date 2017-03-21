import CoreBluetooth

class PeripheralManager: NSObject {
    var peripheralManager: CBPeripheralManager!
    var characteristicDate: CBMutableCharacteristic!
    var characteristicName: CBMutableCharacteristic!
    var characteristicComment: CBMutableCharacteristic!
    var service: CBMutableService!
    var characteristics: [String: Characteristic] = [:]
    var delegate: PeripheralManagerDelegate!
    let serviceUUID = CBUUID(string: Constants.serviceUUID)
    /// サービスを作成してペリフェラルマネージャに登録する
    init(date: Characteristic, name: Characteristic, comment: Characteristic) {
        self.characteristics["date"] = date
        self.characteristics["name"] = name
        self.characteristics["comment"] = comment
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
}
