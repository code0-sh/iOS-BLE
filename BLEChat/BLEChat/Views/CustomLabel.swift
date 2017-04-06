import UIKit

final class CustomLabel: UILabel {
    init(_ rect: CGRect) {
        super.init(frame: rect)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        self.text = ""
        self.textColor = UIColor.white
        self.font = UIFont.boldSystemFont(ofSize: 16)
    }
}
