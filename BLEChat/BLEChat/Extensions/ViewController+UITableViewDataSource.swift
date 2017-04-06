import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.update(date: users[indexPath.row].date,
                    name: users[indexPath.row].name,
                    comment: users[indexPath.row].comment,
                    distance: users[indexPath.row].distance)
        cell.layoutIfNeeded()
//        print("cell:\(cell?.cellHeight ?? 0)")
        return cell
    }
}
