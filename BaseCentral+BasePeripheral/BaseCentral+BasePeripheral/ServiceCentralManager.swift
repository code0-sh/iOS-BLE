import UIKit
import CoreBluetooth

protocol ServiceCentralManagerDelegate {
    func dealWithCharacteristic(peripheral: CBPeripheral, characteristic: CBCharacteristic)
    func displayCharacteristicValue(value: String)
}

class ServiceCentralManager: NSObject {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var delegate : ServiceCentralManagerDelegate!
    let serviceUUID = CBUUID(string: "FFF0")
    let characteristicUUID = CBUUID(string: "FFF1")
    
    // サービスを作成してペリフェラルマネージャに登録する
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
}

extension ServiceCentralManager: CBCentralManagerDelegate, CBPeripheralDelegate {
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
        print("サービスを検出")
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
            self.delegate?.dealWithCharacteristic(peripheral: peripheral, characteristic: characteristic)
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
        self.delegate?.displayCharacteristicValue(value: value as String)
        
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
