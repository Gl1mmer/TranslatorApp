//
//  Presenter.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

class HomePresenter {
    
    private let availableLanguages: [Language] = [
        Language(
            code: "kk",
            title: "Қазақша (Қазақстан)",
            placeholder: "Мәтінді енгізіңіз"
        ),
        Language(
            code: "en",
            title: "English (USA)",
            placeholder: "Enter your text"
        ),
        Language(
            code: "ru",
            title: "Русский (Россия)",
            placeholder: "Введите текст"
        )
    ]
    
    private var sourceLanguage: Language
    private var targetLanguage: Language
    
    weak var input: HomeViewInput?
    
    init(delegate: HomeViewInput) {
        self.input = delegate
        sourceLanguage = availableLanguages[1]
        targetLanguage = availableLanguages[0]
    }
    
}

extension HomePresenter: HomeViewOutput {
    func viewIsReady() {
        input?.configureLanguages(availableLanguages)
        input?.updateInputLanguage(sourceLanguage)
        input?.updateOutputLanguage(targetLanguage)
    }
    
    func translate(text: String) {
        input?.showTranslatedText(text)
    }
    
    func changeLanguage(of mode: TranslationBoxMode, to language: Language) {
        switch mode {
        case .input:
            sourceLanguage = language
            input?.updateInputLanguage(language)
        case .output:
            targetLanguage = language
            input?.updateOutputLanguage(language)
        }
    }
    
    func addTextToFavorite(text: String) {
        
    }
}
