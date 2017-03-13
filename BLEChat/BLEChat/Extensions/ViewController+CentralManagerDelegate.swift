import CoreBluetooth

extension ViewController: CentralManagerDelegate {
    /**
     * 特性値の読み取りが終了した際のデリゲートメソッド
     */
    func readEndNotificationFromCentralManager(user: User) {
        let user = User(date: user.date, name: user.name, comment: user.comment)
        /// コメントを追加する
        addComment(user: user)
    }
}
