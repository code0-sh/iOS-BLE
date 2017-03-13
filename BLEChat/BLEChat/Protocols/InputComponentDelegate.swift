protocol InputComponentDelegate: class {
    /// コメントを追加する
    func postComment(user: User)
    /// 設定画面に遷移する
    func moveSetting()
}
