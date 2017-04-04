import UIKit
import AVFoundation

class ViewController: UIViewController {
    var users: [User] = []
    var centralManager: CentralManager?
    var peripheralManager: PeripheralManager?
    var inputComponent: InputComponent!
    private var tableView: UITableView!
    private var barHeight: CGFloat = 0
    private var maxCommentCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Status Barの高さを取得する
        barHeight = UIApplication.shared.statusBarFrame.size.height
        tableView = UITableView(frame: CGRect.zero)
        /// Cellの登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        layoutTableView()
        layoutInputFieldView()
        /// 表示エリアの最大コメント数を更新する
        maxCommentCount = Int(
            floor(
                (self.view.frame.height - Constants.inputComponentHeight) / (Constants.commentComponentHeightLength + Constants.frameMargin)
            )
        )
    }
    private func layoutTableView() {
        tableView.frame.origin.y = barHeight
        tableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - Constants.inputComponentHeight)
    }
    private func layoutInputFieldView() {
        inputComponent.frame.origin.y = self.view.frame.height - Constants.inputComponentHeight
        inputComponent.frame.size = CGSize(width: self.view.frame.width, height: Constants.inputComponentHeight)
        inputComponent.textField.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.frame.width - Constants.frameMargin,
                                 height: Constants.textFieldHeight)
        inputComponent.textField.center.x = self.view.frame.width / 2
        inputComponent.sendButton.frame = CGRect(x: 0,
                                                 y: Constants.textFieldHeight + Constants.frameMargin,
                                                 width: self.view.frame.width - Constants.frameMargin,
                                                 height: Constants.buttonHeight)
        inputComponent.sendButton.center.x = self.view.frame.width / 2
        inputComponent.settingButton.frame = CGRect(x: 0,
                                                 y: Constants.textFieldHeight + Constants.frameMargin * 2 + Constants.buttonHeight,
                                                 width: self.view.frame.width - Constants.frameMargin,
                                                 height: Constants.buttonHeight)
        inputComponent.settingButton.center.x = self.view.frame.width / 2
    }
    /**
     * コメントを追加する
     */
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
    /**
     * コメントを読み上げる
     */
    func readComment(comment: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: comment)
        synthesizer.speak(utterance)
    }
    /**
     * ペリフェラルマネージャを生成する
     */
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
