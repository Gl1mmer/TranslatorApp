//
//  Assembly.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 27.01.2026.
//
import UIKit

final class Assembly {
    
    static func createProfileVC() -> ProfileViewController {
        let unsplashServ: PhotoServiceProtocol = UnsplashService()
        let udm: UserDefManagerProtocol = UserDefManager()
        
        let profileVC = ProfileViewController()
        let profilePresenter = ProfilePresenter(input: profileVC, networkServ: unsplashServ, userDefManager: udm)
        profileVC.output = profilePresenter
        return profileVC
    }
    
    static func createHomeVC() -> HomeViewController {
        let udm: UserDefManagerProtocol = UserDefManager()
        let translationService: TranslationServiceProtocol = GoogleTranslatorService()
        let coreDataMngr: CoreDataManagerProtocol = CoreDataManager()

        let homeVC = HomeViewController()
        let homePresenter = HomePresenter(input: homeVC, translationService: translationService, coreDataMngr: coreDataMngr, userDefMngr: udm)
        homeVC.output = homePresenter
        return homeVC
    }
}
