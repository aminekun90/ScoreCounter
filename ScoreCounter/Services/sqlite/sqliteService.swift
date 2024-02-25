//
//  sqliteService.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SQLite
import SQLiteMigrationManager
class SqliteService {
    static let shared = SqliteService()
    private var db:Connection!
    private var migManager:SQLiteMigrationManager!
    private var dbPath:String!
    init (){
        do{
            let fileManager = FileManager.default
            
            self.dbPath = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("db.sqlite")
                .path
            
            if !fileManager.fileExists(atPath: dbPath) {
                let dbResourcePath = Bundle.main.path(forResource: "db", ofType: "sqlite")!
                try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            }
            print("Connection to SQLite...")
            self.db = try Connection(dbPath)
            self.migrate()
            
            print("Connection successfull")
        }catch{
            print(error)
        }
    }
    
    private func migrate() {
        do {
            print("Migration init...")
            self.migManager = SQLiteMigrationManager(db: self.db, migrations: [SeedDb()])
            
            if !migManager.hasMigrationsTable() {
                try migManager.createMigrationsTable()
                print("Migration table created")
            }
            
            // Print migration status
            print("hasMigrationsTable() \(self.migManager.hasMigrationsTable())")
            print("currentVersion()     \(self.migManager.currentVersion())")
            print("originVersion()      \(self.migManager.originVersion())")
            print("appliedVersions()    \(self.migManager.appliedVersions())")
            print("pendingMigrations()  \(self.migManager.pendingMigrations())")
            print("needsMigration()     \(self.migManager.needsMigration())")
            if(self.migManager.needsMigration())
            {
                // Apply pending migrations
                try migManager.migrateDatabase()
                print("Migrations applied")
            }
            
            
        } catch {
            print(error)
        }
    }
    
    public func loadAppSettings() -> AppSettings {
        let appSettings = AppSettings()
        let settings = Table("settings")
        let id = Expression<Int64>("id")  // New primary ID column
        let vibrate = Expression<Bool>("vibrate")
        let keepScreenOn = Expression<Bool>("keepScreenOn")
        let appearance = Expression<String>("appearance")
        let increments = Expression<IncrementsArray>("increments")
        
        do {
            if let setting = try db.pluck(settings) {
                appSettings.id = try setting.get(id)
                appSettings.vibrate = try setting.get(vibrate)
                appSettings.keepScreenOn = try setting.get(keepScreenOn)
                appSettings.appearance = AppAppearance(rawValue: try setting.get(appearance)) ?? .system
                appSettings.increments = try setting.get(increments)
            }
            
        } catch {
            print(error)
        }
        
        return appSettings
    }
    
    public func saveAppSettings(appSettings: AppSettings) {
        let settings = Table("settings")
        let id = Expression<Int64>("id")  // New primary ID column
        let vibrate = Expression<Bool>("vibrate")
        let keepScreenOn = Expression<Bool>("keepScreenOn")
        let appearance = Expression<String>("appearance")
        let increments = Expression<IncrementsArray>("increments")
        
        do {
            let oldSettings = settings.filter(id == appSettings.id)
            print("old settings \(oldSettings)")
            // Assuming there is only one row, you can update it
            try db.run(oldSettings.update(
                vibrate <- appSettings.vibrate,
                keepScreenOn <- appSettings.keepScreenOn,
                appearance <- appSettings.appearance.rawValue,
                increments <- appSettings.increments
            ))
            print("Save Done \(appSettings)")
        } catch {
            print(error)
        }
    }
}
