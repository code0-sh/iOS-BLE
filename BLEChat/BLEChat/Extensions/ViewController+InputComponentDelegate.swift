import UIKit

extension ViewController: InputComponentDelegate {
    /// コメントを投稿する
    ///
    /// - Parameter user: User
    func postComment(user: User) {
        guard (peripheralManager?.peripheralManager.isAdvertising) != nil else {
            print("Advertisement is stopped.")
            return
        }
        /// 特性値の再設定
        /// コメント
        self.updateComment()
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async {
                /// 日付
                self.updateDate()
            }
        }

        /// 入力欄をクリアする
        inputComponent.textField.text = ""
        /// コメントを追加する
        addComment(user: user)
        /// コメントを読み上げる
        readComment(comment: user.comment)
    }
    /// 設定画面に遷移する
    func moveSetting() {
        /// アドバタイズを停止する
        peripheralManager?.peripheralManager?.stopAdvertising()
        peripheralManager?.peripheralManager.removeAllServices()
        let storyboard: UIStoryboard = self.storyboard!
        guard let vc = storyboard.instantiateViewController(withIdentifier: "setting") as? SettingViewController else {
            return
        }
        vc.isResetName = true
        present(vc, animated: true, completion: nil)
    }
}
