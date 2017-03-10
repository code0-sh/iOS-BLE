import CoreBluetooth

class CentralManager: NSObject {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var delegate : CentralManagerDelegate!
    let serviceUUID = CBUUID(string: "FFF0")
    let characteristicDateUUID = CBUUID(string: "FFF1")
    let characteristicNameUUID = CBUUID(string: "FFF2")
    let characteristicCommentUUID = CBUUID(string: "FFF3")
    
    // サービスを作成してペリフェラルマネージャに登録する
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
}
