import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    var serviceCentralManager: ServiceCentralManager?
    var servicePeripheralManager: ServicePeripheralManager?
    
    var isWriteState = false
    var isReadState = false
    
    @IBOutlet weak var writeTextField: UITextField!
    @IBOutlet weak var characteristicLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeTextField.text = ""
        characteristicLabel.text = ""
    }
    
    /**
     * ペリフェラルのスキャンを開始する
     */
    @IBAction func startScan(_ sender: UIButton) {
        print("startScan")
        isReadState = true
        // セントラルマネージャを生成
        self.serviceCentralManager = ServiceCentralManager()
        serviceCentralManager?.delegate = self
    }
    /**
     * ペリフェラルのスキャンを停止する
     */
    @IBAction func stopScan(_ sender: UIButton) {
        print("stopScan")
        self.serviceCentralManager?.centralManager.stopScan()
    }
    /**
     * 書き込み
     */
    @IBAction func write(_ sender: UIButton) {
        print("write")
        isWriteState = true
        // セントラルマネージャを生成
        self.serviceCentralManager = ServiceCentralManager()
        serviceCentralManager?.delegate = self
    }
    
    /**
     * ペリフェラルマネージャオブジェクトを起動する
     */
    @IBAction func startAdvertising(_ sender: UIButton) {
        servicePeripheralManager = ServicePeripheralManager()
    }
    /**
     *アドバタイズを停止する
     */
    @IBAction func stopAdvertising(_ sender: UIButton) {
        print("Stop advertisement")
        servicePeripheralManager?.peripheralManager?.stopAdvertising()
    }
}

extension ViewController: ServiceCentralManagerDelegate {
    func dealWithCharacteristic(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        // 読み取り
        if characteristic.properties.contains(.read) && isReadState == true {
            isReadState = false
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
    // 特性の値をラベルに表示する
    func displayCharacteristicValue(value: String) {
        characteristicLabel.text = value
    }
}
