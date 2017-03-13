import UIKit

class InputComponent: UIView, UITextFieldDelegate {
    weak var delegate: InputComponentDelegate?
    var textField: UITextField! = UITextField()
    var sendButton: UIButton! = UIButton()
    var settingButton: UIButton! = UIButton()
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createTextField()
        createSendButton()
        createSettingButton()
    }
    /**
     * 入力欄生成
     */
    private func createTextField() {
        textField.placeholder = "コメント欄"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        addSubview(textField!)
    }
    /**
     * 送信ボタン生成
     */
    private func createSendButton() {
        sendButton.setTitle("送信", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.layer.cornerRadius = Constants.buttonCornerRadius
        sendButton.backgroundColor = UIColor.blue
        sendButton.addTarget(self,
                             action: #selector(touchSendButton),
                             for: .touchUpInside)
        addSubview(sendButton)
    }
    /**
     * 設定ボタン生成
     */
    private func createSettingButton() {
        settingButton.setTitle("設定", for: .normal)
        settingButton.setTitleColor(UIColor.white, for: .normal)
        settingButton.layer.cornerRadius = Constants.buttonCornerRadius
        settingButton.backgroundColor = UIColor.green
        settingButton.addTarget(self,
                                action: #selector(touchSettingButton),
                                for: .touchUpInside)
        addSubview(settingButton)
    }
    // MARK: delegate
    /**
     * 送信ボタンをタッチ
     */
    func touchSendButton() {
        guard let name = UserDefaults.standard.string(forKey: "name") else {
            return
        }
        guard let comment = textField.text else {
            return
        }
        let date = NSDate().dateString()
        let user = User(date: date, name: name, comment: comment)
        self.delegate?.postComment(user: user)
        textField.text = ""
    }

    /**
     * 設定ボタンをタッチ
     */
    func touchSettingButton() {
        self.delegate?.moveSetting()
    }
    /**
     * TextFieldを閉じる
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
