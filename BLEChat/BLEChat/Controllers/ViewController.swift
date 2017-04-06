import UIKit
import AVFoundation

class ViewController: UIViewController {
    var users: [User] = []
    var centralManager: CentralManager?
    var peripheralManager: PeripheralManager?
    var inputComponent: InputComponent!
    var stubCell: CustomTableViewCell!
    private var tableView: UITableView!
    private var barHeight: CGFloat = 0
    private var maxCommentCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Status Barの高さを取得する
        barHeight = UIApplication.shared.statusBarFrame.size.height
        tableView = UITableView(frame: CGRect.zero)
        /// Cellの登録
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        stubCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell
        /// UITableViewの境界線を消す
        tableView.separatorStyle = .none
        /// UITableView全体のセルを選択不可能にする
        tableView.allowsSelection = false
        /// DataSourceの設定
        tableView.dataSource = self
        /// Delegateを設定
        tableView.delegate = self
        self.view.addSubview(tableView)
        inputComponent = InputComponent(frame: CGRect.zero)
        inputComponent.delegate = self
        self.view.addSubview(inputComponent)
        constrainView()
    }
    override func viewDidAppear(_ animated: Bool) {
        /// セントラルマネージャを生成する
        centralManager = CentralManager()
        centralManager?.delegate = self
        /// ペリフェラルマネージャを生成する
        startAdvertising()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /// 表示エリアの最大コメント数を更新する
        maxCommentCount = Int(
            floor(
                (self.view.frame.height - Constants.inputComponentHeight) / (Constants.commentComponentHeightLength + Constants.frameMargin)
            )
        )
    }
    /// コンストレイント
    private func constrainView() {
        /// テーブルエリア
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: barHeight).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        /// 入力エリア
        inputComponent.translatesAutoresizingMaskIntoConstraints = false
        inputComponent.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        inputComponent.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        inputComponent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        inputComponent.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    /// コメントを追加する
    ///
    /// - Parameter user: User
    func addComment(user: User) {
        print("user:\(user)")
        users.append(user)
        tableView.reloadData()
        /// 最新コメントが表示されるようにスクロールする
        if users.count > maxCommentCount {
            tableView.setContentOffset(CGPoint(x: 0,
                                               y: tableView.contentSize.height - tableView.frame.size.height),
                                       animated: false)
        }
    }
    /// コメントを読み上げる
    ///
    /// - Parameter comment: String
    func readComment(comment: String) {
//        let synthesizer = AVSpeechSynthesizer()
//        let utterance = AVSpeechUtterance(string: comment)
//        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
//        utterance.rate = 0.5
//        synthesizer.speak(utterance)
    }
    /// ペリフェラルマネージャを生成する
    private func startAdvertising() {
        let userDefaults = UserDefaults.standard
        guard let defaultName = userDefaults.string(forKey: "name") else {
            return
        }
        let defaultSettings = [
            "date": ["UUID": Constants.dateUUID, "value": NSDate().dateString()],
            "name": ["UUID": Constants.nameUUID, "value": defaultName],
            "comment": ["UUID": Constants.commentUUID, "value": "\(defaultName)さんがチャットに参加しました。"]
        ]
        guard let dateSettings = defaultSettings["date"] else {
            return
        }
        guard let nameSettings = defaultSettings["name"] else {
            return
        }
        guard let commentSettings = defaultSettings["comment"] else {
            return
        }
        let date = Characteristic(data: dateSettings)
        let name = Characteristic(data: nameSettings)
        let comment = Characteristic(data: commentSettings)
        peripheralManager = PeripheralManager(date: date, name: name, comment: comment)
    }
}
