import UIKit

class ViewController: UIViewController, InputFieldViewDelegate {
    var myItems: [String] = []
    private var tableView: UITableView!
    private var inputFieldView: InputFieldView!
    private var barHeight: CGFloat = 0
    
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
        
        inputFieldView = InputFieldView(frame: CGRect.zero)
        inputFieldView.delegate = self
        self.view.addSubview(inputFieldView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("回転")
        layoutTableView()
        layoutInputFieldView()
    }
    
    private func layoutTableView() {
        tableView.frame.origin.y = barHeight
        tableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - 200)
    }
    
    private func layoutInputFieldView() {
        inputFieldView.frame.origin.y = self.view.frame.height - 150
        inputFieldView.frame.size = CGSize(width: self.view.frame.width, height: 150)
        
        inputFieldView.sendButton.frame = CGRect(x: 0,
                                                 y: Constants.textFieldHeight + Constants.frameMargin,
                                                 width: self.view.frame.width - Constants.frameMargin,
                                                 height: Constants.buttonHeight)
        inputFieldView.sendButton.center.x = self.view.frame.width / 2
        
        inputFieldView.textField.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.frame.width - Constants.frameMargin,
                                 height: Constants.textFieldHeight)
        inputFieldView.textField.center.x = self.view.frame.width / 2
    }
    
    func createBalloon(cell: UITableViewCell) -> BalloonView {
        let frame = CGRect(x: (self.view.frame.width - 200) / 2, y: 0, width: 280, height: 100)
        let balloon = BalloonView(frame: frame)
        balloon.backgroundColor = UIColor.white
        
        let comment = CommentLabel(CGRect(x: 0,
                                          y: 0,
                                          width: 280 - balloon.triangleSideLength,
                                          height: 100),
                                   comment: "コメントコメント")
        balloon.addSubview(comment)
        
        let icon = IconImageView(frame, name: "Icon")
        balloon.addSubview(icon)
        
        return balloon
    }
    
    func addComment() {
        myItems.insert("ADD TEST", at: 0)
        tableView.reloadData()
        /// 最新コメントが表示されるようにスクロールする
        if myItems.count > 3 {
            tableView.setContentOffset(CGPoint(x: 0,
                                               y: tableView.contentSize.height - tableView.frame.size.height),
                                       animated: false)
        }
    }
}
