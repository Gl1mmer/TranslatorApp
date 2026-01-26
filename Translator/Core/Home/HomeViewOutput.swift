//
//  HomeViewOutput.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

protocol HomeViewOutput {
    func viewIsReady()
    
    func translate(text: String)
    func changeLanguage(of: TranslationBoxMode, to: Language)
    func toggleFavourite()
    func getFavorite(at index: Int)
    
    //MARK: - for tableView
    var numberOfItems: Int { get }
    func item(at index: Int) -> Translation
}
