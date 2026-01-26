//
//  CDTranslation+CoreDataClass.swift
//  Translator
//
//  Created by Amankeldi Zhetkergen on 23.01.2026.
//
//

public import Foundation
public import CoreData

public typealias CDTranslationCoreDataClassSet = NSSet

@objc(CDTranslation)
public class CDTranslation: NSManagedObject {

}

public typealias CDTranslationCoreDataPropertiesSet = NSSet

extension CDTranslation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTranslation> {
        return NSFetchRequest<CDTranslation>(entityName: "CDTranslation")
    } 

    @NSManaged public var sourceText: String?
    @NSManaged public var translatedText: String?
    @NSManaged public var sourceLangCode: String?
    @NSManaged public var targetLangCode: String?

    func toDomain() -> Translation? {
        guard
            let sourceText = sourceText,
            let translatedText = translatedText,
            let sourceCodeRaw = sourceLangCode,
            let targetCodeRaw = targetLangCode,
            let sourceLang = Language.from(rawCode: sourceCodeRaw),
            let targetLang = Language.from(rawCode: targetCodeRaw)
        else { return nil }
        
        return Translation(
            sourceText: sourceText,
            translatedText: translatedText,
            sourceLang: sourceLang,
            targetLang: targetLang
        )
    }
}
