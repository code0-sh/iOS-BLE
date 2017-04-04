import UIKit
import CoreGraphics

class CommentBalloonView: UIView {
    let triangleSideLength: CGFloat = 20
    let triangleHeight: CGFloat = 20
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        /// コンテキストを取得
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(GlobalColor.colorBalloon.cgColor)
        contextBalloonPath(context: context, rect: rect)
    }
    private func contextBalloonPath(context: CGContext, rect: CGRect) {
        let triangleTopCorner = (x: rect.maxX - triangleSideLength,
                                 y: (rect.maxY + triangleHeight) / 2)
        let triangleCenterCorner = (x: rect.maxX,
                                    y: rect.maxY / 2)
        let triangleBottomCorner = (x: rect.maxX - triangleSideLength,
                                    y: (rect.maxY - triangleHeight) / 2)
        /// 塗りつぶし
        context.addRect(CGRect(x: 0,
                               y: 0,
                               width: Constants.commentComponentSideLength - triangleSideLength,
                               height: Constants.commentComponentHeightLength))
        context.fillPath()
        context.move(to: CGPoint(x: triangleBottomCorner.x, y: triangleBottomCorner.y))
        context.addLine(to: CGPoint(x: triangleCenterCorner.x, y: triangleCenterCorner.y))
        context.addLine(to: CGPoint(x: triangleTopCorner.x, y: triangleTopCorner.y))
        context.fillPath()
    }
}
