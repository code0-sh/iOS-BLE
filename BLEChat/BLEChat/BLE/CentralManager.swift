import CoreBluetooth

class CentralManager: NSObject {
    var centralManager: CBCentralManager!
    var peripherals = [CBPeripheral]()
    var delegate: CentralManagerDelegate!
    var isReaded = false
    let user: User = User()
    let serviceUUID = CBUUID(string: Constants.serviceUUID)
    let characteristicDateUUID = CBUUID(string: Constants.dateUUID)
    let characteristicNameUUID = CBUUID(string: Constants.nameUUID)
    let characteristicCommentUUID = CBUUID(string: Constants.commentUUID)
    /// サービスを作成してペリフェラルマネージャに登録する
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
}
