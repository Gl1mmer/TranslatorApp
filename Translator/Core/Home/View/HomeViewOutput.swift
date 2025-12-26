//
//  HomeViewOutput.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

protocol HomeViewOutput {
    func viewIsReady()
    func translate(text: String)
    func changeLanguage(of: TranslationBoxMode, to: Language)
    func addTextToFavorite(text: String)
}
