//
//  Untitled.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 30.12.2025.
//

import Foundation

struct TranslationAPIModel: Codable {
    let data: DataClassAPI
}

struct DataClassAPI: Codable {
    let translations: [TranslationAPI]
}

struct TranslationAPI: Codable {
    let translatedText: String
}
