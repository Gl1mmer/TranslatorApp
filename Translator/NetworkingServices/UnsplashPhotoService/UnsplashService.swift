//
//  UnsplashService.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 22.12.2025.
//
import Foundation

protocol PhotoServiceProtocol {
    func fetchRandomPhotoUrl(completion: @escaping (Result<String, Error>) -> ())
    func downloadImage(from url: String, completion: @escaping (Result<Data, Error>)->Void)
    
}

class UnsplashService: PhotoServiceProtocol {
    private let apiKey = APIKeys.unsplash

    private let unsplashUrl = "https://api.unsplash.com/photos/random?client_id="

    func fetchRandomPhotoUrl(completion: @escaping (Result<String, any Error>) -> ()) {
        guard let url = URL(string: unsplashUrl + apiKey) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let photoURL = try JSONDecoder().decode(ImageModel.self, from: data)
                let url = photoURL.urls.regular
                completion(.success(url))
            } catch {
                completion(.failure(ServiceError.decodingFailed))
            }
        }.resume()

    }
    
    func downloadImage(from url: String, completion: @escaping (Result<Data, Error>)->Void) {
        guard let url = URL(string: url) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
}
