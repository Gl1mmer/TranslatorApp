//
//  Presenter.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

class HomePresenter {
    
    private let availableLanguages: [Language] = Language.getLanguages()
    
    private var favourites: [String : Translation] = [ : ]
    private var favouriteKeys: [String] = []
    
    private var currentTranslation: Translation?
    private var currentInputText: String = ""
    private lazy var sourceLanguage: Language = availableLanguages[0]
    private lazy var targetLanguage: Language = availableLanguages[1]
    
    private var workItem: DispatchWorkItem?
    
    private let translationService: TranslationServiceProtocol
    private let coreDataMngr: CoreDataManagerProtocol
    private let udm: UserDefManagerProtocol
    
    private weak var input: HomeViewInput?
    
    init(input: HomeViewInput, translationService: TranslationServiceProtocol, coreDataMngr: CoreDataManagerProtocol, userDefMngr: UserDefManagerProtocol) {
        self.input = input
        self.translationService = translationService
        self.coreDataMngr = coreDataMngr
        self.udm = userDefMngr
        getSavedData()
    }
    
    private func getSavedData() {
        getSavedOrDefaultLangFor(type: .source)
        getSavedOrDefaultLangFor(type: .target)
        getSavedFavourites()
    }
    
    private func isFavourite(key: String) -> Bool {
        favourites[key] != nil
    }
    
    private func toEncode(text: String, from: Language, to: Language) -> String {
        "\(text)|\(from.code.rawValue)|\(to.code.rawValue)"
    }
    
    private func makeTranslation(text: String, res: String) -> Translation {
        Translation(sourceText: text,
                    translatedText: res,
                    sourceLang: sourceLanguage,
                    targetLang: targetLanguage
                    )
    }
    
    private func saveTranslation(_ translation: Translation) {
        let key = toEncode(text: translation.sourceText, from: translation.sourceLang, to: translation.targetLang)
        guard favourites[key] == nil else { return }
        
        coreDataMngr.saveFavourite(translation)
        favouriteKeys.append(key)
        favourites[key] = translation
    }
    
    private func deleteTranslation(_ translation: Translation) {
        coreDataMngr.deleteFavourite(translation)
        let key = toEncode(text: translation.sourceText, from: translation.sourceLang, to: translation.targetLang)
        if let ind = favouriteKeys.firstIndex(of: key) {
            favouriteKeys.remove(at: ind)
        }
        favourites.removeValue(forKey: key)
    }
    
    private func handleIfEmpty(text: String) -> Bool {
        let checkForEmptyText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !checkForEmptyText.isEmpty else {
            input?.showTranslatedText("")
            input?.updateFavouriteButton(isFavourite: false)
            input?.setFavouriteEnabled(false)
            currentTranslation = nil
            return true
        }
        return false
    }
    private func isTranslationInFavourites(text: String) -> Bool {
        let key = toEncode(text: text, from: sourceLanguage, to: targetLanguage)
        let isFav = isFavourite(key: key)
        input?.updateFavouriteButton(isFavourite: isFav)
        if (isFav) {
            self.input?.showTranslatedText(favourites[key]!.translatedText)
            input?.updateFavouriteButton(isFavourite: true)
            input?.setFavouriteEnabled(true)
            if let translation = favourites[key] {
                currentTranslation = translation
            }
            return true
        }
        return false
    }
    private func getSavedOrDefaultLangFor(type: LanguageType) {
        guard let sourceCode = udm.getLanguageCode(type: type) else { return }
        if let source = availableLanguages.first(where: { $0.code.rawValue == sourceCode }) {
            sourceLanguage = source
        }
    }
    private func getSavedFavourites() {
        let saved = coreDataMngr.loadFavourites()
        for translation in saved {
            let key = toEncode(text: translation.sourceText, from: translation.sourceLang, to: translation.targetLang)
            favourites[key] = translation
            favouriteKeys.append(key)
        }
    }
}

extension HomePresenter: HomeViewOutput {
    var numberOfItems: Int {
        favouriteKeys.count
    }
    
    func item(at index: Int) -> Translation {
        favourites[favouriteKeys[index]]!
    }
    
    func viewIsReady() {
        input?.configureLanguages(availableLanguages)
        input?.updateInputLanguage(sourceLanguage)
        input?.updateOutputLanguage(targetLanguage)
    }
    
    func translate(text: String) {
        currentInputText = text
        
        guard !handleIfEmpty(text: text) else {
            workItem?.cancel()
            return
        }
        
        guard !isTranslationInFavourites(text: text) else {
            workItem?.cancel()
            return
        }
        
        workItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.translationService.translate(
                text: text,
                from: sourceLanguage.code.rawValue,
                to: targetLanguage.code.rawValue
            ) { result in
                switch result {
                case.success(let res):
                    guard text == self.currentInputText else { return }
                    
                    let translation = self.makeTranslation(text: text, res: res)
                    self.currentTranslation = translation
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.input?.showTranslatedText(res)
                        self?.input?.updateFavouriteButton(isFavourite: false)
                        self?.input?.setFavouriteEnabled(true)
                    }
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        workItem = newWorkItem
        DispatchQueue.global().asyncAfter(
            deadline: .now() + .milliseconds(500),
            execute: newWorkItem
        )
    }
    
    func changeLanguage(of mode: TranslationBoxMode, to language: Language) {
        switch mode {
        case .input:
            sourceLanguage = language
            input?.updateInputLanguage(language)
            udm.saveLanguageCode(type: .source, value: language.code.rawValue)
        case .output:
            targetLanguage = language
            input?.updateOutputLanguage(language)
            udm.saveLanguageCode(type: .target, value: language.code.rawValue)
        }
        translate(text: currentInputText)
    }
    
    func toggleFavourite() {
        guard let currentTranslation else {
            print("Could not save the translation to favorites")
            return
        }
        let key = toEncode(text: currentTranslation.sourceText, from: currentTranslation.sourceLang, to: currentTranslation.targetLang)
        let favState = isFavourite(key: key)
        switch favState {
            case false:
                saveTranslation(currentTranslation)
            case true:
                deleteTranslation(currentTranslation)
        }
        input?.updateFavouriteButton(isFavourite: !favState)
        input?.reloadData()
    }
    
    func getFavorite(at index: Int) {
        let fav = favourites[favouriteKeys[index]]!
        if currentTranslation == fav { return }
        
        currentTranslation = fav
        currentInputText = fav.sourceText
        
        sourceLanguage = fav.sourceLang
        targetLanguage = fav.targetLang
        
        input?.updateInputLanguage(sourceLanguage)
        input?.updateOutputLanguage(targetLanguage)
        
        udm.saveLanguageCode(type: .source, value: sourceLanguage.code.rawValue)
        udm.saveLanguageCode(type: .target, value: targetLanguage.code.rawValue)
        
        input?.setFavouriteTextToInputBox(text: fav.sourceText)
        
        input?.showTranslatedText(fav.translatedText)
        input?.updateFavouriteButton(isFavourite: true)
        input?.setFavouriteEnabled(true)
    }
    
}
