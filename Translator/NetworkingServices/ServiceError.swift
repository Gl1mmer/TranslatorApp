//
//  ServiceError.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 01.02.2026.
//
import Foundation

enum ServiceError: Error {
    case invalidURL
    case noData
    case decodingFailed
    
    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingFailed:
                return "Failed to decode response"
            }
        }
}
