import CoreBluetooth

extension ViewController: CentralManagerDelegate {
    // 特性の値をラベルに表示する
    func displayCharacteristicValue(comment: String) {
        let user = User(date: NSDate().dateString(), name: "omura.523", comment: comment)
        addComment(user: user)
    }
}
