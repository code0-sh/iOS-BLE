import CoreBluetooth

extension PeripheralManager: CBPeripheralManagerDelegate {
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
            characteristicDate?.value = date
            let nameValue = characteristics["name"]?.value
            let name = nameValue?.data(using: String.Encoding.utf8)
            characteristicName?.value = name
            let commentValue = characteristics["comment"]?.value
            let comment = commentValue?.data(using: String.Encoding.utf8)
            characteristicComment?.value = comment
            /// * アドバタイズするのはデバイスのローカル名とサービスのUUIDだけ
            /// * アドバタイズの容量はアプリケーションがフォアグラウンド状態で28バイトまででこの領域に入りきらないサービスUUIDは、特別な「オーバーフロー」領域に追加する。その場合検出するためには、明示的に当該UUIDを指定して走査しないといけない。
            let userName = UserDefaults.standard.string(forKey: "name") ?? "anonymous"
            let advertisementData: [String : Any] = [CBAdvertisementDataLocalNameKey: "\(userName) device",
                                                     CBAdvertisementDataServiceUUIDsKey: [serviceUUID]]
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
        if request.characteristic.uuid.isEqual(characteristicDate.uuid) {
            request.value = characteristicDate.value
            peripheralManager.respond(to: request, withResult: .success)
        }
        if request.characteristic.uuid.isEqual(characteristicName.uuid) {
            request.value = characteristicName.value
            peripheralManager.respond(to: request, withResult: .success)
        }
        if request.characteristic.uuid.isEqual(characteristicComment.uuid) {
            request.value = characteristicComment.value
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
    /**
     * Notify開始リクエストを受け取る
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Receive Notify start request.")
    }
    /**
     * Notify停止リクエストを受け取る
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Receive Notify stop request.")
    }
    /**
     * ペリフェラルマネージャにサービスを追加する
     */
    private func setupService() {
        /// サービスを生成
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
        characteristicDate = CBMutableCharacteristic(type: characteristicDateUUID,
                                                          properties: properties,
                                                          value: nil,
                                                          permissions: permissions)
        let characteristicNameUUID = CBUUID(string: nameUUID)
        characteristicName = CBMutableCharacteristic(type: characteristicNameUUID,
                                                          properties: properties,
                                                          value: nil,
                                                          permissions: permissions)
        let characteristicCommentUUID = CBUUID(string: commentUUID)
        characteristicComment = CBMutableCharacteristic(type: characteristicCommentUUID,
                                                             properties: properties,
                                                             value: nil,
                                                             permissions: permissions)
        service.characteristics = [characteristicDate, characteristicName, characteristicComment]
        peripheralManager.add(service)
    }
}
