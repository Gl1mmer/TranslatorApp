//
//  HomeViewInput.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import UIKit

protocol HomeViewInput: AnyObject {
    func configureLanguages(_ languages: [Language])
    func updateInputLanguage(_ language: Language)
    func updateOutputLanguage(_ language: Language)
    func showTranslatedText(_ text: String)
    func setFavouriteEnabled(_ enabled: Bool)

    func setFavouriteTextToInputBox(text: String) // just setInputBoxText
    
    func updateFavouriteButton(isFavourite: Bool)
    
    func reloadData()
}
