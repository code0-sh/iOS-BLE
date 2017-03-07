import UIKit

class CommentLabel: UILabel {
    init(_ rect: CGRect, comment: String) {
        super.init(frame: rect)
        self.text = comment
        self.textColor = UIColor.white
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.textAlignment = .left
        // 複数行表示
        self.numberOfLines = 0
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
