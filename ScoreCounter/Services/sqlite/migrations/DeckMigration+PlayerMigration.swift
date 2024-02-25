//
//  DeckMigration+PlayerMigration.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 25/02/2024.
//


import Foundation
import SQLiteMigrationManager
import SQLite

struct DeckMigration: Migration {
    var version: Int64 = 2024_02_25_12_00_00

    func migrateDatabase(_ db: Connection) throws {
        let deckTable = Table("Deck")
        try db.run(deckTable.create { t in
            t.column(Expression<UUID>("id"), primaryKey: true)
            t.column(Expression<String>("name"))
            t.column(Expression<Int>("winningScore"))
            t.column(Expression<Int64>("increment"))
            t.column(Expression<Bool>("enableWinningScore"))
            t.column(Expression<Bool>("enableWinningAnimation"))
            t.column(Expression<String>("winingLogic"))
        })
    }
}

struct PlayerMigration: Migration {
    var version: Int64 = 2024_02_25_12_05_00

    func migrateDatabase(_ db: Connection) throws {
            try db.run("""
                CREATE TABLE IF NOT EXISTS Player (
                    id TEXT PRIMARY KEY,
                    image TEXT,
                    title TEXT,
                    score INTEGER,
                    color TEXT,
                    deckId TEXT,
                    FOREIGN KEY(deckId) REFERENCES Deck(id) ON DELETE CASCADE
                )
            """)
        }
}
