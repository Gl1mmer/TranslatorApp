//
//  HomeViewController.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 19.12.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    lazy var output: HomeViewOutput = HomePresenter(delegate: self)
    
    private lazy var translationInputView = TranslationBoxView(mode: .input, delegate: self)
    private lazy var translationOutputView = TranslationBoxView(mode: .output, delegate: self)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DevHouse iOS"
        setupUI()
        output.viewIsReady()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false // important
            view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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

extension HomeViewController: HomeViewInput {
    func configureLanguages(_ languages: [Language]) {
        translationInputView.configureLanguageMenu(makeLanguageMenu(for: .input, with: languages))
        translationOutputView.configureLanguageMenu(makeLanguageMenu(for: .output, with: languages))
    }
    func updateInputLanguage(_ language: Language) {
        translationInputView.setLanguageTitle(language.title)
    }
    
    func updateOutputLanguage(_ language: Language) {
        translationOutputView.setLanguageTitle(language.title)
    }
    func showTranslatedText(_ text: String) {
        translationOutputView.setText(text)
    }
}

extension HomeViewController: TranslationBoxProtocol {
    func translationBoxDidChangeText(text: String) {
        output.translate(text: text)
    }
    
}
