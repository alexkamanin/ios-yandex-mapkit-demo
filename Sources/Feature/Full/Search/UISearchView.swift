import UIKit
import SnapKit
import YandexMapsMobile

final class UISearchView: UIView {
    
    private enum Metrics {
        
        static let middleInset: CGFloat = 16
        static let searchFieldCornerRadius: CGFloat = 16
    }
    
    @objc final let map: YMKMapView = {
        guard let map = YMKMapView(frame: .zero, vulkanPreferred: true) else { fatalError("YMKMapView not initialized") }
        map.mapWindow.map.mapType = .vectorMap
        return map
    }()
    
    final let searchField: UITextField = {
        let textField = UIInsetsTextField()
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = Metrics.searchFieldCornerRadius
        textField.layer.opacity = 0.95
        textField.clipsToBounds = true
        return textField
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.addSubview(self.map)
        self.addSubview(self.searchField)
    }

    private func setupConstraints() {
        self.map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.searchField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
        }
    }
}
