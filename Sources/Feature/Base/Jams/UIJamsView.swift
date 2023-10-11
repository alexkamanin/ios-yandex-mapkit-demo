import UIKit
import SnapKit
import YandexMapsMobile

final class UIJamsView: UIView {
    
    private enum Metrics {

        static let smallInset: CGFloat = 8
        static let middleInset: CGFloat = 16
        
        static let jamsTitleSize: CGFloat = 48
        static let jamsTitleCornerRadius: CGFloat = 24
        static let jamsTitleFontSize: CGFloat = 24
        
        static let trafficPanelHeight: CGFloat = 64
        static let trafficPanelCornerRadius: CGFloat = 16
        static let trafficPanelOpacity: Float = 0.95
    }
    
    @objc final let map: YMKMapView = {
        guard let map = YMKMapView(frame: .zero, vulkanPreferred: true) else { fatalError("YMKMapView not initialized") }
        map.mapWindow.map.mapType = .vectorMap
        return map
    }()
    
    lazy final var trafficLayer : YMKTrafficLayer = {
        let trafficLayer = YMKMapKit.sharedInstance().createTrafficLayer(with: self.map.mapWindow)
        return trafficLayer
    }()
    
    final let jamsTitle: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = Metrics.jamsTitleCornerRadius
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: Metrics.jamsTitleFontSize)
        return label
    }()
    final let trafficPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Metrics.trafficPanelCornerRadius
        view.layer.opacity = Metrics.trafficPanelOpacity
        return view
    }()
    final let trafficTitle = UILabel()
    final let trafficButton = UISwitch()
    
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
        self.addSubview(self.jamsTitle)
        self.addSubview(self.trafficPanel)
        self.trafficPanel.addSubview(self.trafficTitle)
        self.trafficPanel.addSubview(self.trafficButton)
    }

    private func setupConstraints() {
        self.map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.trafficPanel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(Metrics.smallInset + Metrics.middleInset)
            make.height.equalTo(Metrics.trafficPanelHeight)
        }
        self.trafficTitle.snp.makeConstraints { make in
            make.leading.equalTo(self.trafficPanel).inset(Metrics.middleInset)
            make.trailing.equalTo(self.trafficButton)
            make.centerY.equalTo(self.trafficPanel)
        }
        self.trafficButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.trafficPanel).inset(Metrics.middleInset)
            make.centerY.equalTo(self.trafficPanel)
        }
        self.jamsTitle.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metrics.smallInset)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
            make.size.equalTo(Metrics.jamsTitleSize)
        }
    }
}
