import CoreBluetooth

extension ViewController: CentralManagerDelegate {
    // 特性の値をラベルに表示する
    func displayCharacteristicValue(user: User) {
        let user = User(date: user.date, name: user.name, comment: user.comment)
        addComment(user: user)
    }
}
