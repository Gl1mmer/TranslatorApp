//
//  CoreDataManager.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 03.01.2026.
//

import CoreData

protocol CoreDataManagerProtocol {
    func loadFavourites() -> [Translation]
    func saveFavourite(_ favourite: Translation)
    func deleteFavourite(_ favourite: Translation)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    private let storage: PersistentController

    private var context: NSManagedObjectContext {
        storage.context
    }

    init(storage: PersistentController = .shared) {
        self.storage = storage
    }
    
    func loadFavourites() -> [Translation] {
        let request: NSFetchRequest<CDTranslation> = CDTranslation.fetchRequest()
        
        do {
            let items = try context.fetch(request)
            return items.compactMap { $0.toDomain() }
        } catch {
            print("loadFavourites error:", error)
            return []
        }
    }
    
    func saveFavourite(_ favourite: Translation) {
        if fetchCD(matching: favourite) != nil { return }

        let cd = CDTranslation(context: context)
        cd.sourceText = favourite.sourceText
        cd.translatedText = favourite.translatedText
        cd.sourceLangCode = favourite.sourceLang.code.rawValue
        cd.targetLangCode = favourite.targetLang.code.rawValue
        
        storage.saveContext()
    }
    
    func deleteFavourite(_ favourite: Translation) {
        let request: NSFetchRequest<CDTranslation> = CDTranslation.fetchRequest()
        request.predicate = predicate(for: favourite)
        
        do {
            let matches = try context.fetch(request)
            matches.forEach { context.delete($0) }
            storage.saveContext()
        } catch {
            print("deleteFavourite error:", error)
        }
    }
    
    private func predicate(for tr: Translation) -> NSPredicate {
        NSPredicate(
            format: "sourceText == %@ AND translatedText == %@ AND sourceLangCode == %@ AND targetLangCode == %@",
            tr.sourceText,
            tr.translatedText,
            tr.sourceLang.code.rawValue,
            tr.targetLang.code.rawValue
        )
    }
    
    private func fetchCD(matching tr: Translation) -> CDTranslation? {
        let request: NSFetchRequest<CDTranslation> = CDTranslation.fetchRequest()
        request.predicate = predicate(for: tr)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
}
