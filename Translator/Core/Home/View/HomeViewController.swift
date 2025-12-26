//
//  HomeViewController.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 19.12.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    lazy var output: HomeViewOutput = HomePresenter(delegate: self)
    
    private lazy var translationInputView = TranslationBoxView(delegate: self, mode: .input)
    private lazy var translationOutputView = TranslationBoxView(delegate: nil, mode: .output)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DevHouse iOS"
        setupUI()
        output.viewIsReady()
    }
}

extension HomeViewController {
    private func setupUI() {
        view.addSubview(translationInputView)
        view.addSubview(translationOutputView)

        NSLayoutConstraint.activate([
            translationInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            translationInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            translationInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            translationInputView.heightAnchor.constraint(equalToConstant: 200),
            
            translationOutputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            translationOutputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            translationOutputView.topAnchor.constraint(equalTo: translationInputView.bottomAnchor, constant: 5),
            translationOutputView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func makeLanguageMenu(for mode: TranslationBoxMode, with languages: [Language]) -> UIMenu {
        let actions = languages.map { language in
            UIAction(title: language.title) { [weak self] _ in
                self?.output.changeLanguage(of: mode, to: language)
            }
        }
        return UIMenu(title: "Choose language", children: actions)
    }

}

extension HomeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text ?? "-")
        output.translate(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
//            textView.text = placeholderText
            textView.textColor = .systemGray
        }
        textView.resignFirstResponder()
    }
}

extension HomeViewController: HomeViewInput {
    func updateInputLanguage(_ language: Language) {
        translationInputView.updateLanguageTitle(language.title)
        translationInputView.updatePlaceholder(language.placeholder)
    }
    
    func updateOutputLanguage(_ language: Language) {
        translationOutputView.updateLanguageTitle(language.title)
        translationOutputView.updatePlaceholder(language.placeholder)
    }
    
    func configureLanguages(_ languages: [Language]) {
        translationInputView.setLanguageMenu(makeLanguageMenu(for: .input, with: languages))
        translationOutputView.setLanguageMenu(makeLanguageMenu(for: .output, with: languages))
    }
    
    func showTranslatedText(_ text: String) {
        translationOutputView.updateText(text)
    }
}
