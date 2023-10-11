import UIKit

final class UIInsetsTextField: UITextField {

    private enum Metrics {

        static let inset: CGFloat = 16
    }

    private let contentInsets = UIEdgeInsets(
        top: Metrics.inset,
        left: Metrics.inset,
        bottom: Metrics.inset,
        right: Metrics.inset
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }
}
