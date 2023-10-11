import UIKit
import SnapKit
import YandexMapsMobile

final class UILocationView: UIView {
    
    private enum Metrics {

        static let smallInset: CGFloat = 8
        static let middleInset: CGFloat = 16
        
        static let trackPanelHeight: CGFloat = 64
        static let trackPanelCornerRadius: CGFloat = 16
        static let trackPanelOpacity: Float = 0.95
    }
    
    @objc final let map: YMKMapView = {
        guard let map = YMKMapView(frame: .zero, vulkanPreferred: true) else { fatalError("YMKMapView not initialized") }
        map.mapWindow.map.mapType = .vectorMap
        return map
    }()
    
    lazy final var locationLayer : YMKUserLocationLayer = {
        let locationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: self.map.mapWindow)
        return locationLayer
    }()
    
    final let progressView: UIView = {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return $0
    }(UIView())
    
    private final let progressIndicator: UIActivityIndicatorView = {
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    final let trackPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Metrics.trackPanelCornerRadius
        view.layer.opacity = Metrics.trackPanelOpacity
        return view
    }()
    final let trackTitle = UILabel()
    final let trackButton = UISwitch()
    
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
        
        self.addSubview(self.trackPanel)
        self.trackPanel.addSubview(self.trackTitle)
        self.trackPanel.addSubview(self.trackButton)
        
        self.progressView.addSubview(progressIndicator)
        self.addSubview(progressView)
    }

    private func setupConstraints() {
        self.map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.trackPanel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(Metrics.smallInset + Metrics.middleInset)
            make.height.equalTo(Metrics.trackPanelHeight)
        }
        self.trackTitle.snp.makeConstraints { make in
            make.leading.equalTo(self.trackPanel).inset(Metrics.middleInset)
            make.trailing.equalTo(self.trackButton)
            make.centerY.equalTo(self.trackPanel)
        }
        self.trackButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.trackPanel).inset(Metrics.middleInset)
            make.centerY.equalTo(self.trackPanel)
        }
        self.progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.progressIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
