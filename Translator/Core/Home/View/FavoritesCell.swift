//
//  FavouriteTableViewCell.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 29.12.2025.
//

import UIKit

protocol FavoritesCellProtocol: AnyObject {
    func didTapOpen(at index: Int)
}

class FavoritesCell: UITableViewCell {
    static let identifier = String(describing: FavoritesCell.self)
    private var index: Int?
    private weak var delegate: FavoritesCellProtocol?
    
    private let mainLabel: UILabel = {
        $0.font = .systemFont(ofSize: 17)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let secondaryLabel: UILabel = {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .secondaryLabel
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var moreButton = {
        $0.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [mainLabel, secondaryLabel, moreButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 22),
            moreButton.heightAnchor.constraint(equalToConstant: 22),
            ])
    }
    
    @objc private func moreButtonTapped() {
        guard let index = index else { return }
        delegate?.didTapOpen(at: index)
    }
    
    func configure(with: Translation, delegate: FavoritesCellProtocol, index: Int) {
        mainLabel.text = with.sourceText
        secondaryLabel.text = "\(with.sourceLang.title) -> \(with.targetLang.title)"
        self.delegate = delegate
        self.index = index
    }
    
}
