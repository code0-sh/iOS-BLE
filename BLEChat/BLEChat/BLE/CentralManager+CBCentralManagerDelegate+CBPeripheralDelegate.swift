import CoreBluetooth

extension CentralManager: CBCentralManagerDelegate, CBPeripheralDelegate {
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
        
        // UUIDを保存しておく
        let UUID = peripheral.identifier.uuidString
        UserDefaults.standard.set(UUID, forKey: "UUID")
        
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
            peripheral.discoverCharacteristics([characteristicDateUUID, characteristicNameUUID, characteristicCommentUUID],
                                               for: service)
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
            print("characteristic:\(characteristic)")
            // 読み取り
            if characteristic.properties.contains(.read) {
                print("Start reading data with property read.")
                // 特性の値を読み取る
                peripheral.readValue(for: characteristic)
            }
            // 通知
            if characteristic.properties.contains(.notify) {
                // 特性の値が変化したときに通知するよう申し込む
                print("Apply to notify when property values change.")
                peripheral.setNotifyValue(true, for: characteristic)
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
        print("characteristic.uuid:\(characteristic.uuid)")
        switch characteristic.uuid {
        case characteristicDateUUID:
            print("日付")
        case characteristicNameUUID:
            print("名前")
        case characteristicCommentUUID:
            print("コメント")
        default:
            return
        }
        self.delegate?.displayCharacteristicValue(comment: value as String)
        
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
}
