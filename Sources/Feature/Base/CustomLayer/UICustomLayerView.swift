import UIKit
import SnapKit
import YandexMapsMobile

final class UICustomLayerView: UIView {
    
    @objc final let map: YMKMapView = {
        guard let map = YMKMapView(frame: .zero, vulkanPreferred: true) else { fatalError("YMKMapView not initialized") }
        map.mapWindow.map.mapType = .vectorMap
        return map
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
    }

    private func setupConstraints() {
        self.map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
