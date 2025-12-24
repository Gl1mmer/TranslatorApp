//
//  Presenter.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//

import Foundation

class HomePresenter {
    
    weak var input: HomeViewInput?
    
    init(delegate: HomeViewInput) {
        self.input = delegate
    }
    
}

extension HomePresenter: HomeViewOutput {
    func translateText(text: String) {
        input?.updateWithTranslatedText(text: text)
        
    }
}
