import UIKit

class CustomCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let balloon = createBalloon()
        self.addSubview(balloon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func createBalloon() -> BalloonView {
        let frame = CGRect(x: (self.bounds.size.width - 200) / 2, y: 100, width: 280, height: 100)
        let balloon = BalloonView(frame: frame)
        balloon.backgroundColor = UIColor.white
        
        let comment = CommentLabel(CGRect(x: 0,
                                          y: 0,
                                          width: 280 - balloon.triangleSideLength,
                                          height: 100),
                                   comment: "コメントコメント")
        balloon.addSubview(comment)
        
        let icon = IconImageView(frame: frame, name: "Icon")
        balloon.addSubview(icon)
        
        return balloon
    }
}
