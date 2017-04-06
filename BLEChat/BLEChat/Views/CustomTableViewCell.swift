import UIKit

final class CustomTableViewCell: UITableViewCell {
    private var cellFrame: UIView!
    private var balloon: CommentBalloonView!
    private var dateLabel: CustomLabel!
    private var nameLabel: CustomLabel!
    private var commentLabel: CustomLabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 設定
    private func setup() {
        createView()
        setColor()
        addView()
        constrainView()
    }
    /// ビューの生成
    private func createView() {
        cellFrame = UIView()
        balloon = CommentBalloonView()
        dateLabel = CustomLabel(CGRect.zero)
        nameLabel = CustomLabel(CGRect.zero)
        commentLabel = CustomLabel(CGRect.zero)
    }
    /// ビューの背景色の設定
    private func setColor() {
        balloon.backgroundColor = UIColor.clear
    }
    /// ビューの追加
    private func addView() {
        balloon.addSubview(dateLabel)
        balloon.addSubview(nameLabel)
        balloon.addSubview(commentLabel)
        cellFrame.addSubview(balloon)
        self.contentView.addSubview(cellFrame)
    }
    /// コンストレイント
    private func constrainView() {
        /// フレーム
        cellFrame.translatesAutoresizingMaskIntoConstraints = false
        cellFrame.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        cellFrame.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        cellFrame.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        cellFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        /// 吹き出しレイアウト
        balloon.translatesAutoresizingMaskIntoConstraints = false
        balloon.topAnchor.constraint(equalTo: cellFrame.topAnchor, constant: 0).isActive = true
        balloon.widthAnchor.constraint(equalTo: cellFrame.widthAnchor).isActive = true
        balloon.centerXAnchor.constraint(equalTo: cellFrame.centerXAnchor).isActive = true
        /// 日付レイアウト
        dateLabel.numberOfLines = 0
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: balloon.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: balloon.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: balloon.trailingAnchor, constant: -20).isActive = true
        /// 名前レイアウト
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: balloon.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: balloon.trailingAnchor, constant: -20).isActive = true
        /// コメントレイアウト
        commentLabel.numberOfLines = 0
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: balloon.bottomAnchor, constant: -10).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: balloon.leadingAnchor, constant: 10).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: balloon.trailingAnchor, constant: -20).isActive = true
    }
    /// ラベルに値を設定
    ///
    /// - Parameters:
    ///   - date: 日付
    ///   - name: 名前
    ///   - comment: コメント
    private func setValue(date: String, name: String, comment: String) {
        dateLabel.text = date
        nameLabel.text = name
        commentLabel.text = comment
    }
    /// 吹き出しの色を設定
    ///
    /// - Parameter distance: RSSI
    private func setColor(distance: Int) {
        if distance == 0 {
            balloon.fillColor = GlobalColor.defalutColorBalloon
        } else {
            balloon.fillColor = UIColor.hsl(distance: distance)
        }
    }
    /// 更新
    ///
    /// - Parameters:
    ///   - date: 日付
    ///   - name: 名前
    ///   - comment: コメント
    ///   - distance: RSSI
    func update(date: String, name: String, comment: String, distance: Int) {
        setValue(date: date, name: name, comment: comment)
        setColor(distance: distance)
    }
    var cellHeight: CGFloat {
        return balloon.bounds.height
    }
}
