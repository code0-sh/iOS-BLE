import UIKit

class ViewController: UIViewController {
    
    let myItems = ["TEST1", "TEST2", "TEST3"]
    private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Status Barの高さを取得する
        let barHeight = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得する
        let displayWidth = self.view.frame.width
        let displayHeight = self.view.frame.height - 200
        
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: barHeight,
                                              width: displayWidth,
                                              height: displayHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // UITableViewの境界線を消す
        tableView.separatorStyle = .none
        // UITableView全体のセルを選択不可能にする
        tableView.allowsSelection = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        let inputFieldView = InputFieldView(frame: CGRect(x: 0,
                                                          y: self.view.frame.height - 200,
                                                          width: self.view.frame.width,
                                                          height: 150))
        self.view.addSubview(inputFieldView)
    }
}
