import UIKit
import CoreBluetooth

protocol ServicePeripheralManagerDelegate {
    func displayCharacteristicValue(value: String)
}

class ServicePeripheralManager: NSObject {
    var peripheralManager: CBPeripheralManager!
    var serviceUUIDs: [CBUUID] = []
    var characteristic: CBMutableCharacteristic!
    var service: CBMutableService!
    var characteristicSettings: CharacteristicSettings
    var delegate : ServicePeripheralManagerDelegate!
    
    // サービスを作成してペリフェラルマネージャに登録する
    init(characteristicSettings: CharacteristicSettings) {
        self.characteristicSettings = characteristicSettings
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
}

extension ServicePeripheralManager: CBPeripheralManagerDelegate {
    /**
     * ペリフェラルマネージャが生成された際のデリゲートメソッド
     */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            // サービスを作成してペリフェラルマネージャに登録する
            setupService()
            
            // キャラクタリスティクに値を設定する
            // * ペリフェラルマネージャにサービスを追加してから値を設定すること
            let value = characteristicSettings.value
            let data = value.data(using: String.Encoding.utf8)
            self.characteristic?.value = data
            
            // * アドバタイズするのはデバイスのローカル名とサービスのUUIDだけ
            // * アドバタイズの容量はアプリケーションがフォアグラウンド状態で28バイトまででこの領域に入りきらないサービスUUIDは、特別な「オーバーフロー」領域に追加する。その場合検出するためには、明示的に当該UUIDを指定して走査しないといけない。
            let advertisementData: [String : Any] = [CBAdvertisementDataLocalNameKey: "Test Device",
                                                     CBAdvertisementDataServiceUUIDsKey: self.serviceUUIDs]
            peripheralManager.startAdvertising(advertisementData)
        default:
            break
        }
    }
    /**
     * サービスを登録した際のデリゲートメソッド
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
            print("Failed to add service.")
            return
        }
        print("Successful addition of service.")
    }
    /**
     * アドバタイズを始めた際のデリゲートメソッド
     */
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            print("Failed to start advertisement.")
            return
        }
        print("Successful advertisement start.")
    }
    /**
     * セントラルからの読み込み要求に応答する際のデリゲートメソッド
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Receive a Read Request from Central.")
        print("characteristic.service.uuid:\(request.characteristic.service.uuid)")
        print("characteristic.uuid:\(request.characteristic.uuid)")
        
        if request.characteristic.uuid.isEqual(self.characteristic.uuid) {
            request.value = self.characteristic.value
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
    /**
     * セントラルからの書き込み要求に応答する際のデリゲートメソッド
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("Receive a Write Request from Central.")
        for request in requests {
            if request.characteristic.uuid.isEqual(self.characteristic.uuid) {
                self.characteristic.value = request.value
            }
        }
        // 要求に応答する
        self.peripheralManager.respond(to: requests[0], withResult: .success)
        
        // 通知を更新する
        guard let value = self.characteristic.value else {
            return
        }
        self.peripheralManager.updateValue(value, for: self.characteristic!, onSubscribedCentrals: nil)
        
        // セントラルから書き込みがあったらラベルを更新する
        guard let valueString = NSString(data: value, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        self.delegate?.displayCharacteristicValue(value: valueString as String)
    }
    /**
     * Notify開始リクエストを受け取る
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Notify開始リクエストを受信")
        print("Notify中のセントラル:\(String(describing: self.characteristic.subscribedCentrals))")
    }
    /**
     * Notify停止リクエストを受け取る
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Notify停止リクエストを受信")
        print("Notify中のセントラル:\(String(describing: self.characteristic.subscribedCentrals))")
    }
    private func setupService() {
        let serviceUUID = CBUUID(string: "00001234-0000-1000-8000-00805f9b34fb")
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        let characteristicUUID = CBUUID(string: characteristicSettings.UUID)
        // * 重要なデータについてはペアリングした機器からのアクセスのみを許可する
        let properties: CBCharacteristicProperties = [.notify, .read, .write]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        
        self.characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                      properties: properties,
                                                      value: nil,
                                                      permissions: permissions)
        
        service.characteristics = [self.characteristic!]
        self.serviceUUIDs.append(serviceUUID)
        peripheralManager.add(service)
    }
}
