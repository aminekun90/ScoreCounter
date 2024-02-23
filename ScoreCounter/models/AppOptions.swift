//
//  AppOptions.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
public class SystemOptions {
    private var phoneTheme:Bool = true
    private var darkTheme:Bool = false
    private var appVersion:String!
    
    init(){
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
            print("App Version: \(String(describing: self.appVersion))");
    }
}
