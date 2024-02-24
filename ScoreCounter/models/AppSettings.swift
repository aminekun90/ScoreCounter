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
    var vibrate:Bool = true
    var keepScreenOn:Bool = true
    var appearance:AppAppearance = AppAppearance.system
    var increments:[Int]=[5,10,15,30]
    
    var appVersion:String!
    
    init(){
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        
    }
    
}
