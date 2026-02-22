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

    func translate(text: String,
                   from: String,
                   to: String,
                   completion: @escaping (Result<String, Error>) -> Void
    ) {
        var components = URLComponents(string:
            "https://translation.googleapis.com/language/translate/v2"
        )
        
        components?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "target", value: to),
            URLQueryItem(name: "source", value: from),
            URLQueryItem(name: "key", value: googleApi)
        ]
        
        guard let url = components?.url else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let translation = try JSONDecoder().decode(TranslationAPIModel.self, from: data)
                let res = translation.data.translations.first!.translatedText ?? ""
                completion(.success(res))
            } catch {
                completion(.failure(ServiceError.decodingFailed))
            }
        }.resume()

    }
}
