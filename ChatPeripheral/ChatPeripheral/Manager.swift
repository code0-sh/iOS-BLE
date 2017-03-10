import CoreBluetooth

protocol ManagerDelegate {
    func displayCharacteristicValue(value: String)
}

class Manager: NSObject {
    var peripheralManager: CBPeripheralManager!
    var serviceUUIDs: [CBUUID] = []
    
    var characteristicDate: CBMutableCharacteristic!
    var characteristicName: CBMutableCharacteristic!
    var characteristicComment: CBMutableCharacteristic!
    
    var service: CBMutableService!
    
    var characteristics: [String: Characteristic] = [:]
    
    var delegate : ManagerDelegate!
    
    /// サービスを作成してペリフェラルマネージャに登録する
    init(date: Characteristic, name: Characteristic, comment: Characteristic) {
        self.characteristics["date"] = date
        self.characteristics["name"] = name
        self.characteristics["comment"] = comment
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
}

extension Manager: CBPeripheralManagerDelegate {
    /**
     * ペリフェラルマネージャが生成された際のデリゲートメソッド
     */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            /// サービスを作成してペリフェラルマネージャに登録する
            setupService()
            
            /// キャラクタリスティクに値を設定する
            /// * ペリフェラルマネージャにサービスを追加してから値を設定すること
            let dateValue = characteristics["date"]?.value
            let date = dateValue?.data(using: String.Encoding.utf8)
            self.characteristicDate?.value = date
            
            let nameValue = characteristics["name"]?.value
            let name = nameValue?.data(using: String.Encoding.utf8)
            self.characteristicName?.value = name
            
            let commentValue = characteristics["comment"]?.value
            let comment = commentValue?.data(using: String.Encoding.utf8)
            self.characteristicComment?.value = comment
            
            /// * アドバタイズするのはデバイスのローカル名とサービスのUUIDだけ
            /// * アドバタイズの容量はアプリケーションがフォアグラウンド状態で28バイトまででこの領域に入りきらないサービスUUIDは、特別な「オーバーフロー」領域に追加する。その場合検出するためには、明示的に当該UUIDを指定して走査しないといけない。
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
        
        if request.characteristic.uuid.isEqual(self.characteristicDate.uuid) {
            request.value = self.characteristicDate.value
            self.peripheralManager.respond(to: request, withResult: .success)
        }
        if request.characteristic.uuid.isEqual(self.characteristicName.uuid) {
            request.value = self.characteristicName.value
            self.peripheralManager.respond(to: request, withResult: .success)
        }
        if request.characteristic.uuid.isEqual(self.characteristicComment.uuid) {
            request.value = self.characteristicComment.value
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
    /**
     * Notify開始リクエストを受け取る
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Notify開始リクエストを受信")
    }
    /**
     * Notify停止リクエストを受け取る
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Notify停止リクエストを受信")
    }
    private func setupService() {
        let serviceUUID = CBUUID(string: "FFF0")
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        
        /// * 重要なデータについてはペアリングした機器からのアクセスのみを許可する
        let properties: CBCharacteristicProperties = [.notify, .read]
        let permissions: CBAttributePermissions = [.readable]
        
        guard let dateUUID = characteristics["date"]?.UUID else {
            return
        }
        guard let nameUUID = characteristics["name"]?.UUID else {
            return
        }
        guard let commentUUID = characteristics["comment"]?.UUID else {
            return
        }
        let characteristicDateUUID = CBUUID(string: dateUUID)
        self.characteristicDate = CBMutableCharacteristic(type: characteristicDateUUID,
                                                      properties: properties,
                                                      value: nil,
                                                      permissions: permissions)
        let characteristicNameUUID = CBUUID(string: nameUUID)
        self.characteristicName = CBMutableCharacteristic(type: characteristicNameUUID,
                                                          properties: properties,
                                                          value: nil,
                                                          permissions: permissions)
        let characteristicCommentUUID = CBUUID(string: commentUUID)
        self.characteristicComment = CBMutableCharacteristic(type: characteristicCommentUUID,
                                                          properties: properties,
                                                          value: nil,
                                                          permissions: permissions)
        
        service.characteristics = [characteristicDate, characteristicName, characteristicComment]
        self.serviceUUIDs.append(serviceUUID)
        peripheralManager.add(service)
    }
}
