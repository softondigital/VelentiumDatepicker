
import Foundation
import UIKit
import FSCalendar

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}
class DIYCalendarCell: FSCalendarCell {
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    var selectionColor: UIColor = UIColor.red {
        didSet {
            setNeedsLayout()
        }
    }
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        self.selectionColor = UIColor.red
        super.init(frame: frame)
        let image : UIImage = UIImage (named: "circle", in: Bundle(for: DateViewController.self), compatibleWith: nil)!
        let circleImageView = UIImageView(image: image)
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = self.selectionColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view;
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
        self.circleImageView.frame = self.bounds.insetBy(dx: 0, dy: -10)
        self.backgroundView?.frame = self.bounds.insetBy(dx: 0, dy: 0)
        self.selectionLayer.frame = self.contentView.bounds
        self.selectionLayer.fillColor = self.selectionColor.cgColor
        switch selectionType {
        case .middle:
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            break
        case .leftBorder:
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
            break
        case .rightBorder:
             self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
            break
        case .single:
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            break
        default:
            print ("Unexpected selection value")
        }
    }
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
}
