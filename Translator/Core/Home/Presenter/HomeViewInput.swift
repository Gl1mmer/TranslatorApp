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
}
