//
//  GoogleTranslatorService.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 29.12.2025.
//

import Foundation

protocol TranslationServiceProtocol {
    func translate(text: String, from: String, to: String, completion: @escaping (Result<String, Error>) -> Void)
}

class GoogleTranslatorService: TranslationServiceProtocol {
    let googleApi = APIKeys.google

    func translate(text: String, from: String, to: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://translation.googleapis.com/language/translate/v2?q=\(text)&target=\(to)&source=\(from)&key=\(googleApi)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let translation = try JSONDecoder().decode(TranslationAPIModel.self, from: data)
                completion(.success(translation.data.translations.first!.translatedText))
            } catch {
                completion(.failure(ServiceError.decodingFailed))
            }
        }.resume()

    }
}
