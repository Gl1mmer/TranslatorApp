//
//  Language.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 26.12.2025.
//
import Foundation

struct Language: Equatable {
    let code: LanguageCodes
    let title: String
    let placeholder: String
    
    static func getLanguages() -> [Language] {
        return [
            Language(
                code: .kazakh,
                title: "Қазақша (Қазақстан)",
                placeholder: "Мәтінді енгізіңіз"
            ),
            Language(
                code: .english,
                title: "English (USA)",
                placeholder: "Enter your text"
            ),
            Language(
                code: .russion,
                title: "Русский (Россия)",
                placeholder: "Введите текст"
            )
        ]
    }
    
    static func from(rawCode: String) -> Language? {
        guard let code = LanguageCodes(rawValue: rawCode) else { return nil }
        return getLanguages().first { $0.code == code }
    }
}
