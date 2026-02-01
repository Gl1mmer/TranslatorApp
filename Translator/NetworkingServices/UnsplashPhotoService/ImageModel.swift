//
//  ImageModel.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 01.02.2026.
//
import Foundation

struct ImageModel: Codable {
    let urls: ImageURL
}
struct ImageURL: Codable {
    let regular: String
}
