import UIKit
import SnapKit

final class UIAboutView: UIView {
    
    private enum Metrics {

        static let middleInset: CGFloat = 16
        static let iconBorderWidth: CGFloat = 1
        static let iconCornerRadius: CGFloat = 16
        static let iconSize: CGFloat = 100
    }
    
    final let icon: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Metrics.iconBorderWidth
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = Metrics.iconCornerRadius
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    final let label: UILabel = {
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground

        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.addSubview(self.icon)
        self.addSubview(self.label)
    }

    private func setupConstraints() {
        self.icon.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.middleInset)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.size.equalTo(Metrics.iconSize)
        }
        self.label.snp.makeConstraints { make in
            make.top.equalTo(self.icon.snp.bottom).inset(-Metrics.middleInset)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(Metrics.middleInset)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(Metrics.middleInset)
        }
    }
}
