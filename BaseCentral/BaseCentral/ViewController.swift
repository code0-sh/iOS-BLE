import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    let serviceUUID = CBUUID(string: "FFF0")
    
    @IBAction func startScan(_ sender: UIButton) {
        print("startScan")
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @IBAction func stopScan(_ sender: UIButton) {
        print("stopScan")
        self.centralManager.stopScan()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        default:
            return
        }
    }
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Name of BLE device discovered: \(String(describing: peripheral.name))")
        self.peripheral = peripheral
        self.centralManager.connect(peripheral, options: nil)
    }
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successful connection of peripheral")
        
        // サービス検索結果を受け取るためのデリデートをセット
        peripheral.delegate = self
        // サービス探索開始
        peripheral.discoverServices([serviceUUID])
    }
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Peripheral connection fails")
    }
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services  else {
            return
        }
        print("\(services.count)個のサービスを発見! \(services)")
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        print("\(characteristics.count)個のキャラスタリスティクを発見! \(characteristics)")
        for characteristic in characteristics {
            if characteristic.properties == CBCharacteristicProperties.read {
                // キャラクタリスティクを読み出す
                print("プロパティがReadのものに対して読み出し開始")
                peripheral.readValue(for: characteristic)
            }
        }
    }
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        print("読み出し成功 service uuid: \(characteristic.service.uuid.uuidString), characteristic uuid: \(characteristic.uuid.uuidString), value: \(value)")
        self.centralManager.cancelPeripheralConnection(peripheral)
        
    }
}





