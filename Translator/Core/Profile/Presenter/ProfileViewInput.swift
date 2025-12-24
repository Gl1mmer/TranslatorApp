//
//  ViewInputDelegate.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 20.12.2025.
//
import UIKit

protocol ProfileViewInput: AnyObject {
    func updateUIWithDataFromDB(name: String, surname: String, phone: String)
    func updateImage(with image: UIImage)
    func showValidationError(for field: UserField, previousValue: String)
}
