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
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>)->Void)
    
}
//MARK: - CLASS
class UnsplashService: PhotoServiceProtocol {
    private let api_key = APIKeys.unsplash

    private let unsplashUrl = "https://api.unsplash.com/photos/random?client_id="
    private let udm = UserDefManager()

    func fetchRandomPhoto(completion: @escaping (Result<UIImage, any Error>) -> ()) {
        guard let url = URL(string: unsplashUrl + api_key) else {
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
                let url = photoURL.urls.regular
                self.udm.saveAvatarPhotoURL(url)
                self.downloadImage(from: url) { result in
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
    
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, Error>)->Void) {
        guard let url = URL(string: url) else {
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
