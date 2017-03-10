import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    @IBOutlet weak var updateTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var manager: Manager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearLabel()
    }
    /**
     * ペリフェラルマネージャオブジェクトを起動する
     */
    @IBAction func startAdvertising(_ sender: UIButton) {
        let defaultSettings = [
            "date": ["UUID": "FFF1", "value": NSDate().dateString()],
            "name": ["UUID": "FFF2", "value": "omura.522"],
            "comment": ["UUID": "FFF3", "value": "HOGEHOGE"]
        ]
        
        guard let dateSettings = defaultSettings["date"] else {
            return
        }
        guard let nameSettings = defaultSettings["name"] else {
            return
        }
        guard let commentSettings = defaultSettings["comment"] else {
            return
        }
        
        let date = Characteristic(data: dateSettings)
        let name = Characteristic(data: nameSettings)
        let comment = Characteristic(data: commentSettings)
        manager = Manager(date: date, name: name, comment: comment)
        manager?.delegate = self
    }
    /**
     *アドバタイズを停止する
     */
    @IBAction func stopAdvertising(_ sender: UIButton) {
        print("Stop advertisement.")
        manager?.peripheralManager?.stopAdvertising()
    }
    /**
     *特性値を更新する
     */
    @IBAction func update(_ sender: UIButton) {
        guard (manager?.peripheralManager.isAdvertising) != nil else {
            print("Advertisement is stopped.")
            return
        }
        /// 特性値の再設定
        /// コメント
        updateComment()
        /// 日付
        updateDate()
        /// 名前
        displayName()
        
        /// 入力欄をクリアする
        updateTextField.text = ""
    }
    /// コメントを更新する
    private func updateComment() {
        let commentValue = updateTextField.text
        guard let comment = commentValue?.data(using: String.Encoding.utf8) else {
            return
        }
        manager?.characteristicComment.value = comment
        
        /// セントラルに通知
        guard let characteristicComment = manager?.characteristicComment else {
            return
        }
        manager?.peripheralManager.updateValue(comment, for: characteristicComment, onSubscribedCentrals: nil)
        commentLabel.text = commentValue
    }
    /// 日付を更新する
    private func updateDate() {
        let dateValue = NSDate().dateString()
        guard let date = dateValue.data(using: String.Encoding.utf8) else {
            return
        }
        manager?.characteristicDate.value = date
        
        /// セントラルに通知
        guard let characteristicDate = manager?.characteristicDate else {
            return
        }
        manager?.peripheralManager.updateValue(date, for: characteristicDate, onSubscribedCentrals: nil)
        dateLabel.text = dateValue
    }
    /// 名前を表示する
    private func displayName() {
        guard let value = manager?.characteristicName.value, let name = NSString(data: value, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        nameLabel.text = name as String
    }
    /// ラベルをクリアする
    private func clearLabel() {
        dateLabel.text = "defalut"
        nameLabel.text = "defalut"
        commentLabel.text = "defalut"
    }
}

extension ViewController: ManagerDelegate {
    /// 特性の値をラベルに表示する
    func displayCharacteristicValue(value: String) {
        commentLabel.text = value
    }
}

final class Characteristic {
    var UUID: String
    var value: String
    init(data: [String: String]) {
        self.UUID = data["UUID"] ?? ""
        self.value = data["value"] ?? ""
    }
}
