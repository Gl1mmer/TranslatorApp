//
//  Untitled.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//
import UIKit

class BoxView: UIView {
        
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
    

    init(delegate: UITextViewDelegate?, boxType: Int) {
        super.init(frame: .zero)
        textView.delegate = delegate
        setupUI()
        if boxType == 2 {
            textView.isEditable = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoxView {
    
    private func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(languageButton)
        addSubview(bookmarkButton)
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            languageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            languageButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            textView.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: languageButton.bottomAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    func updateText(_ text: String) {
        textView.text = text
    }
}

