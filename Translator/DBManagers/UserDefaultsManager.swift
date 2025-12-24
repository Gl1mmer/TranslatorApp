//
//  UserDefaultsManager.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 23.12.2025.
//

import Foundation

protocol UserDefManagerProtocol {
    func getStringFor(key: UserField) -> String?
    func saveStringFor(key: UserField, value: String)
}

class UserDefManager: UserDefManagerProtocol {
    private let defaults = UserDefaults.standard

    func saveStringFor(key: UserField, value: String) {
        defaults.set(value, forKey: key.rawValue)
    }

    func getStringFor(key: UserField) -> String? {
        defaults.string(forKey: key.rawValue)
    }
    
    
}
