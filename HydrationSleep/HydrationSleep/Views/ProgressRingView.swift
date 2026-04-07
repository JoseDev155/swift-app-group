//
//  ProgressRingView.swift
//  HydrationSleep
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class ProgressRingView: UIView {
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private var currentProgress: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let lineWidth: CGFloat = 6
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }

    func setProgress(_ progress: CGFloat, animated: Bool) {
        let clamped = min(max(progress, 0), 1)
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = currentProgress
            animation.toValue = clamped
            animation.duration = 0.35
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "strokeEnd")
        }
        progressLayer.strokeEnd = clamped
        currentProgress = clamped
    }

    func pulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.06
        animation.duration = 0.2
        animation.autoreverses = true
        animation.repeatCount = 2
        layer.add(animation, forKey: "pulse")
    }

    private func configureLayers() {
        trackLayer.strokeColor = UIColor.systemGray5.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 6
        trackLayer.lineCap = .round

        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 6
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0

        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 56, height: 56)
    }
}
