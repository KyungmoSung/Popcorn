//
//  Localize.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation

class Localize {
    // MARK: - Notification
    static private let currentLanguageKey = "CurrentLanguage"
    static private let currentRegionKey = "CurrentRegion"

    // MARK: - Language
    static var systemLanguage: Language {
        guard let languageCode = Locale.current.languageCode,
              let iso = ISO_639_1(rawValue: languageCode) else {
            return Language(code: .en)
        }
        
        return Language(code: iso)
    }
    
    static var currentLanguage: Language {
        get {
            if let data = UserDefaults.standard.value(forKey:currentLanguageKey) as? Data,
               let language = try? PropertyListDecoder().decode(Language.self, from: data) {
                return language
            } else {
                return systemLanguage
            }
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:currentLanguageKey)
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    // MARK: - Region
    static var systemRegion: Country {
        guard let regionCode = Locale.current.regionCode,
              let iso = ISO_3166_1(rawValue: regionCode) else {
            return Country(code: .US)
        }
        
        return Country(code: iso)
    }
    
    static var currentRegion: Country {
        get {
            if let data = UserDefaults.standard.value(forKey:currentRegionKey) as? Data,
               let region = try? PropertyListDecoder().decode(Country.self, from: data) {
                return region
            } else {
                return systemRegion
            }
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:currentRegionKey)
            NotificationCenter.default.post(name: .regionChanged, object: nil)
        }
    }
}
