import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let balloon = createBalloon(cell: cell)
        cell.contentView.addSubview(balloon)
        
        return cell
    }
    
    private func createBalloon(cell: UITableViewCell) -> BalloonView {
        let frame = CGRect(x: (cell.bounds.size.width - 200) / 2, y: 100, width: 280, height: 100)
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
}
