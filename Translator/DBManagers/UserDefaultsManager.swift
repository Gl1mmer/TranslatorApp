//
//  UserDefaultsManager.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 23.12.2025.
//

import Foundation

protocol UserDefManagerProtocol {
    func getStringFor(field: UserField) -> String?
    func saveStringFor(field: UserField, value: String)
    
    func saveLanguageCode(type: LanguageType, value: String)
    func getLanguageCode(type: LanguageType) -> String?
    
    func saveAvatarPhotoURL(_ url: String)
    func getAvatarPhotoUrl() -> String?
}

enum LanguageType: String {
    case source = "source"
    case target = "target"
}

class UserDefManager: UserDefManagerProtocol {
    private let defaults = UserDefaults.standard

    func saveStringFor(field: UserField, value: String) {
        defaults.set(value, forKey: field.rawValue)
    }

    func getStringFor(field: UserField) -> String? {
        defaults.string(forKey: field.rawValue)
    }
    
    func saveLanguageCode(type: LanguageType, value: String) {
        defaults.set(value, forKey: type.rawValue)
    }
    func getLanguageCode(type: LanguageType) -> String? {
        defaults.string(forKey: type.rawValue)
    }
    func saveAvatarPhotoURL(_ url: String) {
        defaults.set(url, forKey: "avatarPhotoURL")
    }
    func getAvatarPhotoUrl() -> String? {
        defaults.string(forKey: "avatarPhotoURL")
    }
    
}
