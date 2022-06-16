import UIKit


class PaddingLabel: UILabel {
    var inset = UIEdgeInsets() {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + inset.left + inset.right, height: originalSize.height + inset.top + inset.bottom)
    }

    override public func drawText(in rect: CGRect) {
        return super.drawText(in: rect.inset(by: inset))
    }
    
    override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}

