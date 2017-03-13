import Foundation

extension ViewController: PeripheralManagerDelegate {
    /**
     * コメントを更新する
     */
    func updateComment() {
        let commentValue = inputComponent.textField.text
        guard let comment = commentValue?.data(using: String.Encoding.utf8) else {
            return
        }
        peripheralManager?.characteristicComment.value = comment
        /// セントラルに通知
        guard let characteristicComment = peripheralManager?.characteristicComment else {
            return
        }
        peripheralManager?.peripheralManager.updateValue(comment, for: characteristicComment, onSubscribedCentrals: nil)
    }
    /**
     * 日付を更新する
     */
    func updateDate() {
        let dateValue = NSDate().dateString()
        guard let date = dateValue.data(using: String.Encoding.utf8) else {
            return
        }
        peripheralManager?.characteristicDate.value = date
        /// セントラルに通知
        guard let characteristicDate = peripheralManager?.characteristicDate else {
            return
        }
        peripheralManager?.peripheralManager.updateValue(date, for: characteristicDate, onSubscribedCentrals: nil)
    }
}
