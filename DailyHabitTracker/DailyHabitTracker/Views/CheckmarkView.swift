import UIKit

final class CheckmarkView: UIView {
    private let shapeLayer = CAShapeLayer()
    private var isChecked = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        shapeLayer.path = checkmarkPath(in: bounds).cgPath
    }

    func setChecked(_ checked: Bool, animated: Bool) {
        isChecked = checked

        if checked {
            if animated {
                animateCheck()
            } else {
                shapeLayer.strokeEnd = 1
                shapeLayer.opacity = 1
            }
        } else {
            shapeLayer.removeAllAnimations()
            layer.removeAllAnimations()
            shapeLayer.strokeEnd = 0
            shapeLayer.opacity = 0
        }
    }

    private func configure() {
        backgroundColor = .clear
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.strokeEnd = 0
        shapeLayer.opacity = 0
        layer.addSublayer(shapeLayer)
    }

    private func animateCheck() {
        shapeLayer.removeAllAnimations()
        layer.removeAllAnimations()

        shapeLayer.strokeEnd = 1
        shapeLayer.opacity = 1

        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = 0.25
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        shapeLayer.add(strokeAnimation, forKey: "stroke")

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.9
        scaleAnimation.toValue = 1
        scaleAnimation.duration = 0.25
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        layer.add(scaleAnimation, forKey: "scale")
    }

    private func checkmarkPath(in rect: CGRect) -> UIBezierPath {
        let insetRect = rect.insetBy(dx: rect.width * 0.2, dy: rect.height * 0.2)
        let start = CGPoint(x: insetRect.minX, y: insetRect.midY)
        let mid = CGPoint(x: insetRect.midX * 0.95, y: insetRect.maxY)
        let end = CGPoint(x: insetRect.maxX, y: insetRect.minY)

        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: mid)
        path.addLine(to: end)
        return path
    }
}
