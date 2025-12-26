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

class TranslationBoxView: UIView {
    
    private let mode: TranslationBoxMode
        
    private let languageButton = {
        $0.setTitle("English (USA)", for: .normal)
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
        return $0
    }(UIButton())
    
    private let textView: UITextView = {
        $0.text = "Enter your text"
        $0.backgroundColor = .clear
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .systemGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())
    

    init(delegate: UITextViewDelegate?, mode: TranslationBoxMode) {
        self.mode = mode
        super.init(frame: .zero)
        textView.delegate = delegate
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = (mode == .output) ? false : true

        setupSubviews()
        
    }
    
    private func setupSubviews() {
        addSubview(languageButton)
        addSubview(textView)

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
        ])
    }
    
    func updateText(_ text: String) {
        textView.text = text
    }
    
    func updateLanguageTitle(_ title: String) {
        languageButton.setTitle(title, for: .normal)
    }

    func updatePlaceholder(_ text: String) {
        if textView.textColor == .systemGray {
            textView.text = text
        }
    }
    
    func setLanguageMenu(_ menu: UIMenu) {
        languageButton.menu = menu
        languageButton.showsMenuAsPrimaryAction = true
    }
    
}


