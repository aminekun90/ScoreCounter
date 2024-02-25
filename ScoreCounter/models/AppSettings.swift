//
//  AppOptions.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation

import SQLite

public enum AppAppearance:String {
    case dark
    case light
    case system
}
extension AppAppearance: Value {
    public static var declaredDatatype: String {
        return String.declaredDatatype
    }

    public static func fromDatatypeValue(_ datatypeValue: String) -> AppAppearance {
        return AppAppearance(rawValue: datatypeValue) ?? .system
    }

    public var datatypeValue: String {
        return rawValue
    }
}

public class AppSettings {
    var id: Int64 = 1 // Assuming the default id = 1
    var vibrate:Bool = true
    var keepScreenOn:Bool = true
    var appearance:AppAppearance = AppAppearance.system
    var increments: IncrementsArray = IncrementsArray(values: [1, 5, 10])
    
    var appVersion:String!
    
    init(){
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        
    }
    
}
