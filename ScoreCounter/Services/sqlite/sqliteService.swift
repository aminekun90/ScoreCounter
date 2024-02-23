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
            print("Connection to SQLite...")
            if let path = Bundle.main.path(forResource: "db", ofType: "sqlite") {
                self.db = try Connection(path)
                self.migrate()
            } else {
                print("Database file not found.")
            }
            print("Connection successfull")
        }catch{
            print(error)
        }
    }
    private func migrate (){
        do{
            print("Migration init...")
            self.migManager = SQLiteMigrationManager(db: self.db,migrations: [])
            
            if !migManager.hasMigrationsTable() {
              try migManager.createMigrationsTable()
                print("Migration table created")
            } else {
                print("No migration needed")
            }
        }catch{
            print(error)
        }
       
    }
    
    
}
