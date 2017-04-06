import UIKit

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        stubCell.update(date: users[indexPath.row].date,
                        name: users[indexPath.row].name,
                        comment: users[indexPath.row].comment,
                        distance: users[indexPath.row].distance)
        stubCell.layoutIfNeeded()
//        print("stubCell:\(stubCell.cellHeight)")
        return stubCell.cellHeight
    }
}
