import UIKit

class InputFieldView: UIView, UITextFieldDelegate {
    private weak var textField: UITextField!
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createTextField()
        createSendButton()
    }
    /// 入力欄生成
    private func createTextField() {
        textField = UITextField()
        textField.placeholder = "コメント欄"
        textField.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.frame.width - Constants.frameMargin,
                                 height: Constants.textFieldHeight)
        textField.center.x = self.frame.width / 2
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.accessibilityIdentifier = "textField"
        addSubview(textField!)
    }
    /// 送信ボタン生成
    private func createSendButton() {
        let sendButton = UIButton()
        sendButton.setTitle("送信", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.frame = CGRect(x: 0,
                                  y: Constants.textFieldHeight + Constants.frameMargin,
                                  width: self.frame.width - Constants.frameMargin,
                                  height: Constants.buttonHeight)
        sendButton.center.x = self.frame.width / 2
        sendButton.layer.cornerRadius = Constants.buttonCornerRadius
        sendButton.backgroundColor = UIColor.blue
        sendButton.addTarget(self,
                             action: #selector(touchOKButton),
                             for: .touchUpInside)
        sendButton.accessibilityIdentifier = "sendButton"
        addSubview(sendButton)
        print("self.frame.height:\(self.frame.height)")
    }
    // MARK: delegate
    /// 送信ボタンをタッチ
    func touchOKButton() {
        print("送信")
        textField.text = ""
    }
    /// TextFieldを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
