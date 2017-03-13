import UIKit

class CustomLabel: UILabel {
    init(_ rect: CGRect, data: String) {
        super.init(frame: rect)
        self.text = data
        self.textColor = UIColor.white
        self.font = UIFont.boldSystemFont(ofSize: 16)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
