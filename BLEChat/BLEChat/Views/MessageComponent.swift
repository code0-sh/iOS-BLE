import UIKit

class MessageComponent: UIView {
    private var comment: String
    private var iconName: String
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createComponent()
    }
    
    init(frame: CGRect, comment: String, iconName: String) {
        self.comment = comment
        self.iconName = iconName
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// コンポーネント生成
    private func createComponent() {
        let frame = CGRect(x: (self.frame.width - 200) / 2,
                           y: 0,
                           width: Constants.messageComponentSideLength,
                           height: Constants.messageComponentHeightLength)
        let balloon = MessageBalloonView(frame: frame)
        balloon.backgroundColor = UIColor.white
        
        let comment = MessageLabel(CGRect(x: 0,
                                          y: 0,
                                          width: Constants.messageComponentSideLength - balloon.triangleSideLength,
                                          height: Constants.messageComponentHeightLength),
                                   comment: self.comment)
        balloon.addSubview(comment)
        
        let icon = MessageIconImageView(frame, name: self.iconName)
        balloon.addSubview(icon)
        
        self.addSubview(balloon)
    }
}
