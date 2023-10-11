import SnapKit
import UIKit
import YandexMapsMobile

final class UISuggestTableViewCell: UITableViewCell {
    
    private enum Metrics {

        static let smallInset: CGFloat = 12
        static let middleInset: CGFloat = 16
    }
    
    private final let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.contentView.addSubview(self.label)
    }
    
    private func setupConstraints() {
        self.label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metrics.smallInset)
            make.leading.trailing.equalToSuperview().inset(Metrics.middleInset)
        }
    }
    
    func setData(_ item: YMKSuggestItem) {
        self.label.text = item.displayText
    }
}
