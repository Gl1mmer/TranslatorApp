//
//  Presenter.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

enum UserField: String {
    case name = "Name"
    case surname = "Surname"
    case phoneNumber = "Phone number"
}

class ProfilePresenter {
    
    private weak var input: ProfileViewInput?
    private let networkingServ: PhotoServiceProtocol
    private let udm: UserDefManagerProtocol
    
    init(input: ProfileViewInput ,networkServ: PhotoServiceProtocol, userDefManager: UserDefManagerProtocol) {
        self.input = input
        self.networkingServ = networkServ
        self.udm = userDefManager
    }
    
    private func isValid(_ text: String, field: UserField) -> Bool {
        switch field {
            case .name, .surname:
                return containsOnlyLetters(text)
            case .phoneNumber:
                return isValidPhone(text)
        }
    }
    
    private func containsOnlyLetters(_ text: String) -> Bool {
        return !text.isEmpty && text.allSatisfy { $0.isLetter }
    }
    
    private func isValidPhone(_ text: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let range = NSRange(text.startIndex..., in: text)

        let matches = detector?.matches(in: text, options: [], range: range)
        return matches?.first?.resultType == .phoneNumber
    }

}

extension ProfilePresenter: ProfileViewOutput {
    func checkAndSaveNewTextFor(_ field: UserField, text: String) {
        guard !text.isEmpty else {
            udm.saveStringFor(field: field, value: text)
            return
        }
        
        guard isValid(text, field: field) else {
            let previousValue = udm.getStringFor(field: field)
            input?.showValidationError(for: field, previousValue: previousValue ?? "")
            return
        }
        
        udm.saveStringFor(field: field, value: text)
    }
    
    func getProfileDataFromDatabase() {
        let name = udm.getStringFor(field: UserField.name) ?? ""
        let surname = udm.getStringFor(field: UserField.surname) ?? ""
        let number = udm.getStringFor(field: UserField.phoneNumber) ?? ""
        input?.updateUIWithDataFromDB(name: name, surname: surname, phone: number)
        let avatarURL = udm.getAvatarPhotoUrl()
        if let avatarURL {
            networkingServ.downloadImage(from: avatarURL) { res in
                switch res {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.input?.updateImage(with: image)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getRandomImage() {
        networkingServ.fetchRandomPhoto { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.input?.updateImage(with: image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
