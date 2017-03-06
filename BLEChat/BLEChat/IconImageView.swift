import UIKit

class IconImageView: UIImageView {
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.frame.size = CGSize(width: 100, height: 100)
        self.frame.origin.y =  0
        self.layer.cornerRadius = 50
        self.image = UIImage(named: name)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
