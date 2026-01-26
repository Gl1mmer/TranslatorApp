//
//  Untitled.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//
import UIKit

enum TranslationBoxMode {
    case input
    case output
}

protocol TranslationBoxProtocol: AnyObject {
    func translationBoxDidChangeText(text: String)
    func favouriteButtonTapped()
}

class TranslationBoxView: UIView {
    
    private weak var delegate: TranslationBoxProtocol?
    private let mode: TranslationBoxMode
        
    private let languageButton = {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .vertical)
        return $0
    }(UIButton())
    
    private lazy var bookmarkButton = {
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
        $0.tintColor = .black
        $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let textView: UITextView = {
        $0.backgroundColor = .clear
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())
    
    private let placeholderLabel: UILabel = {
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    init(mode: TranslationBoxMode, delegate: TranslationBoxProtocol? = nil) {
        self.mode = mode
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        textView.delegate = self
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = (mode == .output) ? false : true

        setupSubviews()
        updatePlaceholderVisibility()
        
    }
    
    private func setupSubviews() {
        addSubview(languageButton)
        addSubview(textView)
        textView.addSubview(placeholderLabel)

        if mode == .input {
            addSubview(bookmarkButton)
            NSLayoutConstraint.activate([
                bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
                bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 22),
                bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
                bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
            ])
        }
        
        NSLayoutConstraint.activate([
            languageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            languageButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -67),
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 62),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: textView.bottomAnchor, constant: -8)

        ])

    }
    
    private func updatePlaceholderVisibility() {
        let isTextEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        placeholderLabel.isHidden = !isTextEmpty
        if mode == .input {
            bookmarkButton.isHidden = isTextEmpty
        }
    }
    
    @objc private func favouriteButtonTapped() {
        delegate?.favouriteButtonTapped()
    }

    //MARK: - public functions
    func configureLanguageMenu(_ menu: UIMenu) {
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
    }
    func setLanguageTitle(_ title: String) {
        languageButton.setTitle(title, for: .normal)
    }
    func setPlaceholder(_ text: String) {
        placeholderLabel.text = text
        updatePlaceholderVisibility()
    }
    func setText(_ text: String) {
        textView.text = text
        updatePlaceholderVisibility()
    }
    func updateFavouriteButton(_ state: Bool) {
        guard mode == .input else { return }
        let imageName = state ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    func setFavouriteEnabled(_ enabled: Bool) {
        bookmarkButton.isEnabled = enabled
        bookmarkButton.tintColor = enabled ? .black : .systemGray4
    }
}

//MARK: - TextView delegate
extension TranslationBoxView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        if mode == .input {
            setFavouriteEnabled(false)
            delegate?.translationBoxDidChangeText(text: textView.text)
        }
    }
}

