import UIKit

class ViewController: UIViewController {
    
    let myItems = ["TEST1", "TEST2", "TEST3"]
    private var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Status Barの高さを取得する
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得する
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: barHeight,
                                              width: displayWidth,
                                              height: displayHeight))
        tableView.register(CustomCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
}
