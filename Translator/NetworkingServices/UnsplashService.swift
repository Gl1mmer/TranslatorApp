//
//  UnsplashService.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 22.12.2025.
//
import UIKit

//MARK: - MODEL
struct ImageModel: Codable {
    let urls: ImageURL
}
struct ImageURL: Codable {
    let regular: String
}
//MARK: - PROTOCOL
protocol PhotoServiceProtocol {
    func fetchRandomPhoto(completion: @escaping (Result<UIImage, Error>) -> ())
}
//MARK: - CLASS
class UnsplashService: PhotoServiceProtocol {
    let unsplashUrl = "https://api.unsplash.com/photos/random?client_id=VrJ3q28MCgH3cCsbrlBFPavv4lDt8WNm5rxrZfcAHU0"

    func fetchRandomPhoto(completion: @escaping (Result<UIImage, any Error>) -> ()) {
        guard let url = URL(string: unsplashUrl) else {
            completion(.failure("URL is invalid" as! Error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let photoURL = try JSONDecoder().decode(ImageModel.self, from: data)
                print(photoURL)
                self.downloadImage(from: photoURL) { result in
                    switch result {
                    case .success(let image):
                        completion(.success(image))
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()

    }
    
    func downloadImage(from url: ImageModel, completion: @escaping (Result<UIImage, Error>)->Void) {
        guard let url = URL(string: url.urls.regular) else {
            completion(.failure("URL is invalid" as! Error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data, error == nil else {
                completion(.failure(error!))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure("cannot get an image" as! Error))
                return
            }
            completion(.success(image))
        }
        task.resume()
    }
    
}
