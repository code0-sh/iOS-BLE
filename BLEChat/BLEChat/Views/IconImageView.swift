import UIKit

class IconImageView: UIImageView {
    init(_ rect: CGRect, name: String) {
        super.init(frame: rect)
        self.frame.size = CGSize(width: 100, height: 100)
        self.frame.origin.y =  0
        self.frame.origin.x = 300
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 50
        self.image = UIImage(named: name)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
