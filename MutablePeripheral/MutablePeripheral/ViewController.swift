import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    @IBOutlet weak var updateTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    
    var servicePeripheralManager: ServicePeripheralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valueLabel.text = ""
    }
    /**
     * ペリフェラルマネージャオブジェクトを起動する
     */
    @IBAction func startAdvertising(_ sender: UIButton) {
        let settings = CharacteristicSettings(UUID: "00001234-0001-1000-8000-00805f9b34fb", value: "HOGEHOGE")
        servicePeripheralManager = ServicePeripheralManager(characteristicSettings: settings)
        servicePeripheralManager?.delegate = self
    }
    /**
     *アドバタイズを停止する
     */
    @IBAction func stopAdvertising(_ sender: UIButton) {
        print("Stop advertisement.")
        servicePeripheralManager?.peripheralManager?.stopAdvertising()
    }
    /**
     *特性値を更新する
     */
    @IBAction func update(_ sender: UIButton) {
        guard (servicePeripheralManager?.peripheralManager.isAdvertising) != nil else {
            print("Advertisement is stopped.")
            return
        }
        
        // 特性値の再設定
        let value = updateTextField.text
        guard let data = value?.data(using: String.Encoding.utf8) else {
            return
        }
        servicePeripheralManager?.characteristic.value = data
        
        
        // セントラルに通知
        guard let characteristic = servicePeripheralManager?.characteristic else {
            return
        }
        servicePeripheralManager?.peripheralManager.updateValue(data, for: characteristic, onSubscribedCentrals: nil)
        
        // ラベルに値を反映して入力欄をクリアする
        valueLabel.text = value
        updateTextField.text = ""
        
    }
}

extension ViewController: ServicePeripheralManagerDelegate {
    // 特性の値をラベルに表示する
    func displayCharacteristicValue(value: String) {
        valueLabel.text = value
    }
}

final class CharacteristicSettings {
    var UUID: String
    var value: String
    init(UUID: String, value: String) {
        self.UUID = UUID
        self.value = value
    }
}
