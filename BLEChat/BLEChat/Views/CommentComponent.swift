import UIKit

class CommentComponent: UIView {
    private var user: User
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createComponent()
    }
    init(frame: CGRect, user: User) {
        self.user = user
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     * コンポーネント生成する
     */
    private func createComponent() {
        let frame = CGRect(x: (self.frame.width - Constants.commentComponentSideLength) / 2,
                           y: 0,
                           width: Constants.commentComponentSideLength,
                           height: Constants.commentComponentHeightLength)
        let balloon = CommentBalloonView(frame: frame)
        if user.distance == 0 {
            balloon.fillColor = GlobalColor.defalutColorBalloon
        } else {
            balloon.fillColor = UIColor.hsl(distance: user.distance)
        }
        balloon.backgroundColor = UIColor.white
        /// 日付
        let date = CustomLabel(CGRect.zero, data: user.date)
        date.sizeToFit()
        /// 名前
        let name = CustomLabel(CGRect.zero, data: user.name)
        name.layer.position.y = date.frame.size.height
        name.sizeToFit()
        /// コメント
        let comment = CustomLabel(CGRect.zero, data: user.comment)
        comment.frame.size.width = Constants.commentComponentSideLength - balloon.triangleSideLength
        comment.layer.position.y = date.frame.size.height + name.frame.size.height
        comment.numberOfLines = 0
        comment.sizeToFit()
        balloon.addSubview(date)
        balloon.addSubview(name)
        balloon.addSubview(comment)
        balloon.clipsToBounds = true
        self.addSubview(balloon)
    }
}
