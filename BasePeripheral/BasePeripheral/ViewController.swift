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
        case .poweredOn:
            // サービスを作成してペリフェラルマネージャに登録する
            setupService()
            
            // キャラクタリスティクに値を設定する
            // * ペリフェラルマネージャにサービスを追加してから値を設定すること
            let value = "HOGEHOGE"
            let data = value.data(using: String.Encoding.utf8)
            self.characteristic.value = data
            
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
     * セントラルからの読み要求に応答する際のデリゲートメソッド
     */
    internal func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Receive a Read Request from Central.")
        print("characteristic.service.uuid:\(request.characteristic.service.uuid)")
        print("characteristic.uuid:\(request.characteristic.uuid)")
        
        if request.characteristic.uuid.isEqual(self.characteristic.uuid) {
            request.value = self.characteristic.value
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
    /**
     * サービスを作成してペリフェラルマネージャに登録する
     */
    private func setupService() {
        let serviceUUID = CBUUID(string: "FFF0")
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        let characteristicUUID = CBUUID(string: "FFF1")
        // * 重要なデータについてはペアリングした機器からのアクセスのみを許可する
        let properties: CBCharacteristicProperties = [.read]
        let permissions: CBAttributePermissions = [.readable]
        
        self.characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                      properties: properties,
                                                      value: nil,
                                                      permissions: permissions)
        
        service.characteristics = [self.characteristic]
        self.serviceUUIDs.append(serviceUUID)
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
        print("Stop advertisement")
        peripheralManager.stopAdvertising()
    }
}
