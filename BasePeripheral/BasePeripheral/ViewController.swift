import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    var serviceUUIDs: [CBUUID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /**
     * ペリフェラルマネージャが生成された際のデリゲートメソッド
     */
    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        /// Bluetoothが起動中
        case .poweredOn:
            /// サービスを作成してペリフェラルマネージャに登録する
            setupService()
            
            /// キャラクタリスティクに値を設定する
            /// * ペリフェラルマネージャにサービスを追加してから値を設定すること
            let stringValue = "HOGEHOGE"
            let dataValue = stringValue.data(using: String.Encoding.utf8)
            characteristic.value = dataValue
            
            /// * アドバタイズするのはデバイスのローカル名とサービスのUUIDだけ
            /// * アドバタイズの容量はアプリケーションがフォアグラウンド状態で28バイトまででこの領域に入りきらないサービスUUIDは、特別な「オーバーフロー」領域に追加する。その場合検出するためには、明示的に当該UUIDを指定して走査しないといけない。
            let advertisementData: [String : Any] = [CBAdvertisementDataLocalNameKey: "Test Device",
                                                     CBAdvertisementDataServiceUUIDsKey: serviceUUIDs]
            peripheralManager.startAdvertising(advertisementData)
        default:
            break
        }
    }
    /**
     * サービスを登録した際のデリゲートメソッド
     */
    internal func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
            print("Failed to add service.")
            return
        }
        print("Successful addition of service.")
    }
    /**
     * アドバタイズを始めた際のデリゲートメソッド
     */
    internal func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            print("Failed to start advertisement.")
            return
        }
        print("Successful advertisement start.")
    }
    /**
     * セントラルからの読み込み要求に応答する際のデリゲートメソッド
     */
    internal func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Receive a Read Request from Central.")
        print("characteristic.service.uuid:\(request.characteristic.service.uuid)")
        print("characteristic.uuid:\(request.characteristic.uuid)")
        
        if request.characteristic.uuid.isEqual(characteristic.uuid) {
            request.value = characteristic.value
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
    /**
     * セントラルからの書き込み要求に応答する際のデリゲートメソッド
     */
    internal func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("Receive a Write Request from Central.")
        for request in requests {
            if request.characteristic.uuid.isEqual(characteristic.uuid) {
                characteristic.value = request.value
            }
        }
        /// 要求に応答する
        peripheralManager.respond(to: requests[0], withResult: .success)
        
        guard let value = characteristic.value else {
            return
        }
        /// 更新をセントラルに通知する
        peripheralManager.updateValue(value, for: characteristic, onSubscribedCentrals: nil)
    }
    /**
     * セントラルが特性値の通知を要求したときに呼び出されるデリゲートメソッド
     */
    internal func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Subscribeリクエストを受信")
        print("Subscribe中のセントラル: \(characteristic.uuid.uuidString)")
    }
    /**
     * サービスを作成してペリフェラルマネージャに登録する
     */
    private func setupService() {
        let serviceUUID = CBUUID(string: "00001234-0000-1000-8000-00805f9b34fb")
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        let characteristicUUID = CBUUID(string: "00001234-0001-1000-8000-00805f9b34fb")
        /// * 重要なデータについてはペアリングした機器からのアクセスのみを許可する
        let properties: CBCharacteristicProperties = [.notify, .read, .write]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        
        characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                 properties: properties,
                                                 value: nil,
                                                 permissions: permissions)
        
        service.characteristics = [characteristic]
        serviceUUIDs.append(serviceUUID)
        peripheralManager.add(service)
    }
    
    /**
     * ペリフェラルマネージャオブジェクトを起動する
     */
    @IBAction func startAdvertising(_ sender: UIButton) {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    /**
     *アドバタイズを停止する
     */
    @IBAction func stopAdvertising(_ sender: UIButton) {
        print("Stop advertisement.")
        peripheralManager.stopAdvertising()
    }
}
