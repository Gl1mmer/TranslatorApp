//
//  ViewOutputDelegate.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

protocol ProfileViewOutput {
    func getProfileDataFromDatabase()
    func getRandomImage()
    func checkAndSaveNewTextFor(_ field: UserField, text: String)
}
