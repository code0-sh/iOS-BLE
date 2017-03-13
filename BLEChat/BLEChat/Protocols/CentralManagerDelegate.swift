import CoreBluetooth

protocol CentralManagerDelegate {
    /// 特性値の読み取りが終了した際のデリゲートメソッド
    func readEndNotificationFromCentralManager(user: User)
}
