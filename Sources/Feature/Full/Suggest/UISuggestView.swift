import UIKit
import SnapKit

final class UISuggestView: UIView {
    
    private enum Metrics {

        static let middleInset: CGFloat = 16
        static let searchFieldCornerRadius: CGFloat = 16
    }
    
    final let searchField: UITextField = {
        let textField = UIInsetsTextField()
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = Metrics.searchFieldCornerRadius
        textField.clipsToBounds = true
        return textField
    }()
    
    final let suggestTable = UISuggestTableView()
    
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
        self.addSubview(self.searchField)
        self.addSubview(self.suggestTable)
    }

    private func setupConstraints() {
        self.searchField.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
        }
        self.suggestTable.snp.makeConstraints { make in
            make.top.equalTo(self.searchField.snp.bottom).inset(-Metrics.middleInset)
            make.bottom.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metrics.middleInset)
        }
    }
}
