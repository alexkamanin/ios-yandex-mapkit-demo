import UIKit
import SnapKit
import YandexMapsMobile

final class UIPanoramaView: UIView {
    
    private enum Metrics {
        
        static let smallInset: CGFloat = 8
        
        static let yearButtonWidth: CGFloat = 100
        static let yearButtonCornerRadius: CGFloat = 8
        static let yearButtonVerticalInset: CGFloat = 8
        static let yearButtonHorizontalInset: CGFloat = 16
    }
    
    final let panoView: YMKPanoView = YMKPanoView(frame: .zero, vulkanPreferred: true)
    final let yearButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = Metrics.yearButtonCornerRadius
        button.contentEdgeInsets = UIEdgeInsets(
            top: Metrics.yearButtonVerticalInset,
            left: Metrics.yearButtonHorizontalInset,
            bottom: Metrics.yearButtonVerticalInset,
            right: Metrics.yearButtonHorizontalInset
        )
        return button
    }()
    
    var clickListener: ((YMKHistoricalPanorama) -> Void)?
    var items: [PanaromaItem]?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.yearButton.addInteraction(UIContextMenuInteraction(delegate: self))
        
        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.addSubview(self.panoView)
        self.addSubview(self.yearButton)
    }

    private func setupConstraints() {
        self.panoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.yearButton.snp.makeConstraints { make in
            make.top.equalTo(self.layoutMarginsGuide).inset(Metrics.smallInset)
            make.trailing.equalTo(self).inset(Metrics.smallInset)
            make.width.equalTo(Metrics.yearButtonWidth)
        }
    }
}

extension UIPanoramaView: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let items = self.items else {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: nil)
        }
        
        let actions = items.map { item in
            let name: String = item.panorama.name
            let image: UIImage? = item.selected ? .checkmark : nil
            let handler: (UIAction) -> Void = { _ in self.clickListener?(item.panorama) }
            
            return UIAction(title: name, image: image, handler: handler)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in UIMenu(children: actions) }
    }
}
