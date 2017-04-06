import UIKit

final class InputComponent: UIView, UITextFieldDelegate {
    weak var delegate: InputComponentDelegate?
    weak var textField: UITextField!
    private var sendButton: UIButton!
    private var settingButton: UIButton!
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createTextField()
        createSendButton()
        createSettingButton()
        constrainView()
    }
    /// 入力欄生成
    private func createTextField() {
        textField = UITextField()
        textField.placeholder = "コメント欄"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        addSubview(textField!)
    }
    /// 送信ボタン生成
    private func createSendButton() {
        sendButton = UIButton()
        sendButton.setTitle("送信", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.layer.cornerRadius = Constants.buttonCornerRadius
        sendButton.backgroundColor = UIColor.blue
        sendButton.addTarget(self,
                             action: #selector(touchSendButton),
                             for: .touchUpInside)
        sendButton.isExclusiveTouch = true
        addSubview(sendButton)
    }
    /// 設定ボタン生成
    private func createSettingButton() {
        settingButton = UIButton()
        settingButton.setTitle("設定", for: .normal)
        settingButton.setTitleColor(UIColor.white, for: .normal)
        settingButton.layer.cornerRadius = Constants.buttonCornerRadius
        settingButton.backgroundColor = UIColor.green
        settingButton.addTarget(self,
                                action: #selector(touchSettingButton),
                                for: .touchUpInside)
        settingButton.isExclusiveTouch = true
        addSubview(settingButton)
    }
    /// コンストレイント
    private func constrainView() {
        /// 入力欄
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -10).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        /// 送信ボタン
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: settingButton.topAnchor, constant: -10).isActive = true
        sendButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        /// 設定ボタン
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 10).isActive = true
        settingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    // MARK: delegate
    /// 送信ボタンをタッチ
    func touchSendButton() {
        guard let name = UserDefaults.standard.string(forKey: "name") else {
            return
        }
        guard let comment = textField.text else {
            return
        }
        let date = NSDate().dateString()
        let user = User(date: date, name: name, comment: comment, distance: 0)
        self.delegate?.postComment(user: user)
        textField.text = ""
    }
    /// 設定ボタンをタッチ
    func touchSettingButton() {
        self.delegate?.moveSetting()
    }
    /// TextFieldを閉じる
    ///
    /// - Parameter textField: UITextField
    /// - Returns: Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
