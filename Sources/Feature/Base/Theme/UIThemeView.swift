import UIKit
import SnapKit
import YandexMapsMobile

final class UIThemeView: UIView {
    
    private enum Metrics {

        static let smallInset: CGFloat = 8
        static let middleInset: CGFloat = 16
        
        static let themePanelHeight: CGFloat = 64
        static let themePanelCornerRadius: CGFloat = 16
        static let themePanelOpacity: Float = 0.95
    }
    
    @objc final let map: YMKMapView = {
        guard let map = YMKMapView(frame: .zero, vulkanPreferred: true) else { fatalError("YMKMapView not initialized") }
        map.mapWindow.map.mapType = .vectorMap
        return map
    }()
    
    final let themePanel: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = Metrics.themePanelCornerRadius
        view.layer.opacity = Metrics.themePanelOpacity
        return view
    }()
    final let themeTitle = UILabel()
    final let themeButton = UISwitch()
    
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
        self.addSubview(self.themePanel)
        self.themePanel.addSubview(self.themeTitle)
        self.themePanel.addSubview(self.themeButton)
    }

    private func setupConstraints() {
        self.map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.themePanel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(Metrics.smallInset + Metrics.middleInset)
            make.height.equalTo(Metrics.themePanelHeight)
        }
        self.themeTitle.snp.makeConstraints { make in
            make.leading.equalTo(self.themePanel).inset(Metrics.middleInset)
            make.trailing.equalTo(self.themeButton)
            make.centerY.equalTo(self.themePanel)
        }
        self.themeButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.themePanel).inset(Metrics.middleInset)
            make.centerY.equalTo(self.themePanel)
        }
    }
}
