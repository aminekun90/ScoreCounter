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
    private var db:Connection!
    private var migManager:SQLiteMigrationManager!
    init (){
        do{
            let fileManager = FileManager.default

            let dbPath = try fileManager
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

            // Apply pending migrations
            try migManager.migrateDatabase()
            print("Migrations applied")

        } catch {
            print(error)
        }
    }
    public func loadAppsettings()->AppSettings{
        let appSettings = AppSettings()
        let settings = Table("settings")
        do{
            for setting in try db.prepare(settings) {
                    print("\(setting)")
                
            }
            
        }catch{
            print(error)
        }
        
        
        return appSettings;
    }
    
    
}
