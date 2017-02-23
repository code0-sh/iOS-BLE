import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    let serviceUUID = CBUUID(string: "FFF0")
    
    /**
     * ペリフェラルのスキャンを開始する
     */
    @IBAction func startScan(_ sender: UIButton) {
        print("startScan")
        // セントラルマネージャを生成
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    /**
     * ペリフェラルのスキャンを停止する
     */
    @IBAction func stopScan(_ sender: UIButton) {
        print("stopScan")
        self.centralManager.stopScan()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /**
     * セントラルマネージャが生成された際のデリゲートメソッド
     */
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        default:
            return
        }
    }
    /**
     * ペリフェラルを検出した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Name of BLE device discovered: \(String(describing: peripheral.name))")
        self.peripheral = peripheral
        self.centralManager.connect(peripheral, options: nil)
    }
    /**
     * ペリフェラルの接続に成功した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successful connect to the peripheral.")
        
        // サービス検索結果を受け取るためのデリデートをセット
        peripheral.delegate = self
        // サービス探索開始
        peripheral.discoverServices([serviceUUID])
    }
    /**
     * ペリフェラルの接続に失敗した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failure to connect to peripheral.")
    }
    /**
     * 接続したペリフェラルのサービスを検出した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("Failed to detect service.")
            return
        }
        guard let services = peripheral.services  else {
            return
        }
        print("Discover \(services.count) services! \(services)")
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    /**
     * 接続したペリフェラルのサービスの特性を検出した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        print("Discover \(characteristics.count) characteristics! \(characteristics)")
        for characteristic in characteristics {
            if characteristic.properties == CBCharacteristicProperties.read {
                // キャラクタリスティクを読み出す
                print("Start reading data with property read.")
                peripheral.readValue(for: characteristic)
            }
        }
    }
    /**
     * 接続したペリフェラルのサービスの特性の値の読み取りが終了した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        print("Successful reading of characteristic values. service uuid: \(characteristic.service.uuid.uuidString), characteristic uuid: \(characteristic.uuid.uuidString), value: \(value)")
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}
