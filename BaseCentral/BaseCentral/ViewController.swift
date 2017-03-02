import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    let serviceUUID = CBUUID(string: "FFF0")
    let characteristicUUID = CBUUID(string: "FFF1")
    var isWriteState = false
    var isReadState = false
    var isNotificationSate = false
    
    @IBOutlet weak var writeTextField: UITextField!
    @IBOutlet weak var characteristicLabel: UILabel!
    
    /**
     * ペリフェラルのスキャンを開始する
     */
    @IBAction func startScan(_ sender: UIButton) {
        print("startScan")
        isNotificationSate = false
        isReadState = true
        // セントラルマネージャを生成
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    /**
     * ペリフェラルのスキャンを停止する
     */
    @IBAction func stopScan(_ sender: UIButton) {
        print("stopScan")
        isNotificationSate = false
        self.centralManager.stopScan()
    }
    /**
     * 書き込み
     */
    @IBAction func write(_ sender: UIButton) {
        print("write")
        isWriteState = true
        // セントラルマネージャを生成
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        writeTextField.text = ""
        characteristicLabel.text = ""
    }
    /**
     * セントラルマネージャが生成された際のデリゲートメソッド
     */
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // CBUUIDオブジェクトの配列を指定すると該当するサービスをアドバタイズしているペリフェラルのみが返される
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
        // 接続先のペリフェラルが見つかったら、省電力のため、他のペリフェラルの走査は停止する
        self.centralManager.stopScan()
        
        self.peripheral = peripheral
        // 検出したペリフェラルに接続する
        self.centralManager.connect(peripheral, options: nil)
    }
    /**
     * ペリフェラルの接続に成功した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successful connect to the peripheral.")
        
        // ペリフェラルとのやり取りを始める前に、ペリフェラルのデリデートをセット
        peripheral.delegate = self
        // サービスの検出開始
        // 不要なサービスが多数見つかる場合、電池と時間が無駄になるので必要なサービスのUUIDを具体的に指定すると良い
        peripheral.discoverServices([serviceUUID])
    }
    /**
     * ペリフェラルの接続に失敗した際のデリゲートメソッド
     */
    internal func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failure to connect to peripheral.")
    }
    /**
     * サービスを検出した際のデリゲートメソッド
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
            // 特性をすべて検出する
            // 不要な特性が多数見つかる場合、電池と時間が無駄になるので必要な特性のUUIDを具体的に指定する
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }
    /**
     * 特性を検出した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        print("Discover \(characteristics.count) characteristics! \(characteristics)")
        for characteristic in characteristics {
            // 読み取り
            if characteristic.properties.contains(.read) && isReadState == true {
                isReadState = false
                print("Start reading data with property read.")
                // 特性の値を読み取る
                peripheral.readValue(for: characteristic)
            }
            // 通知
            if characteristic.properties.contains(.notify) && isNotificationSate == false {
                isNotificationSate = true
                // 特性の値が変化したときに通知するよう申し込む
                print("Apply to notify when property values change.")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            // 書き込み
            if characteristic.properties.contains(.write) && isWriteState == true {
                isWriteState = false
                print("Start writing data with property write.")
                // 特性値を書き込む
                guard let data = writeTextField.text?.data(using: String.Encoding.utf8) else {
                    return
                }
                peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                // 入力欄をクリアする
                writeTextField.text = ""
            }
        }
    }
    /**
     * 特性の値の読み取りが終了した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        guard let value = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        print("Successful reading of characteristic values. service uuid: \(characteristic.service.uuid.uuidString), characteristic uuid: \(characteristic.uuid.uuidString), value: \(value)")
        print("End reading.")
        
        // 特性の値をラベルに表示する
        characteristicLabel.text = value as String
    }
    /**
     * 通知の申し込みが終了した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        print("Notification application completed.")
    }
    /**
     * 特性の値の書き込みが終了した際のデリゲートメソッド
     */
    internal func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        // 特性の値は書き込み後の値が反映されない
//        guard let value = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
//            return
//        }
//        print("Successful writing of characteristic values. service uuid: \(characteristic.service.uuid.uuidString), characteristic uuid: \(characteristic.uuid.uuidString), value: \(value)")
        print("End writing.")
    }
}
