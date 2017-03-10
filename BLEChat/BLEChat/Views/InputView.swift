import UIKit

class InputView: UIView, UITextFieldDelegate {
    weak var delegate: InputViewDelegate?
    var textField: UITextField! = UITextField()
    var sendButton: UIButton! = UIButton()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createTextField()
        createSendButton()
    }
    /// 入力欄生成
    private func createTextField() {
        textField.placeholder = "コメント欄"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        addSubview(textField!)
    }
    /// 送信ボタン生成
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
    // MARK: delegate
    /// 送信ボタンをタッチ
    func touchSendButton() {
        print("送信")
        
        let date = NSDate().dateString()
        let name = "omura.522"
        guard let comment = textField.text else {
            return
        }
        
        let user = User(date: date, name: name, comment: comment)
        
        self.delegate?.addComment(user: user)
        textField.text = ""
    }
    /// TextFieldを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
