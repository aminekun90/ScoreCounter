//
//  sqliteService.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SwiftUI
import SQLite
import SQLiteMigrationManager

class SqliteService {
    static let shared = SqliteService()
    private var db: Connection!
    private var migManager: SQLiteMigrationManager!
    private var dbPath: String!
    
    init() {
            let fileManager = FileManager.default
            
            // Get the documents directory
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let scoreCounterDirectory = documentsDirectory.appendingPathComponent("ScoreCounter")
                
                do {
                    // Ensure ScoreCounter directory exists
                    try fileManager.createDirectory(at: scoreCounterDirectory, withIntermediateDirectories: true, attributes: nil)
                    
                    // Set the new dbPath
                    self.dbPath = scoreCounterDirectory.appendingPathComponent("db.sqlite").path
                    
                    if !fileManager.fileExists(atPath: dbPath) {
                        // Copy SQLite file to the new path
                        let dbResourcePath = Bundle.main.path(forResource: "db", ofType: "sqlite")!
                        
                        do {
                            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
                            print("SQLite file copied to \(String(describing: dbPath))")
                        } catch {
                            print("Failed to copy SQLite file: \(error)")
                        }
                    }
                    
                    print("Connection to SQLite...")
                    self.db = try Connection(dbPath)
                    self.migrate()
                    
                    print("Connection successful")
                } catch {
                    print("Failed to create ScoreCounter directory: \(error)")
                }
            } else {
                print("Documents directory not found.")
            }
        
    }
    
    
    private func migrate() {
        do {
            print("Migration init...")
            self.migManager = SQLiteMigrationManager(db: self.db, migrations: [SeedDb(),DeckMigration(),PlayerMigration()])
            
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
    
    // MARK: - Deck CRUD Operations
    
    public func addDeck(deck: Deck) {
        let deckTable = Table("Deck")
        let name = Expression<String>("name")
        let winningScore = Expression<Int>("winningScore")
        let increment = Expression<Int64>("increment")
        let enableWinningScore = Expression<Bool>("enableWinningScore")
        let enableWinningAnimation = Expression<Bool>("enableWinningAnimation")
        let winingLogic = Expression<String>("winingLogic")
        
        do {
            let insert = deckTable.insert(
                name <- deck.name,
                winningScore <- deck.winningScore,
                increment <- deck.increment,
                enableWinningScore <- deck.enableWinningScore,
                enableWinningAnimation <- deck.enableWinningAnimation,
                winingLogic <- deck.winingLogic.rawValue
            )
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    public func getDecks(completion: @escaping ([Deck]) -> Void) {
        let deckTable = Table("Deck")
        let id = Expression<UUID>("id")
        let name = Expression<String>("name")
        let winningScore = Expression<Int>("winningScore")
        let increment = Expression<Int64>("increment")
        let enableWinningScore = Expression<Bool>("enableWinningScore")
        let enableWinningAnimation = Expression<Bool>("enableWinningAnimation")
        let winingLogic = Expression<String>("winingLogic")
        
       
        do {
            var decks = [Deck]()
            
            try db.transaction {
                let deckRows = try db.prepare(deckTable)
                for deckRow in deckRows {
                    var deck = try Deck(
                        id:deckRow.get(id),
                        name: deckRow.get(name),
                        winningScore: deckRow.get(winningScore),
                        increment: deckRow.get(increment),
                        enableWinningScore: deckRow.get(enableWinningScore),
                        enableWinningAnimation: deckRow.get(enableWinningAnimation),
                        winingLogic: WinningLogic(rawValue: deckRow.get(winingLogic)) ?? .normal
                    )
                    
                    // Fetch players for the current deck
                    
                    
                    deck.players = getPlayers(deckId: deck.id)
                    print("Players : \(deck.players.count)")
                    decks.append(deck)
                }
            }
            
            completion(decks)
        } catch {
            print(error)
            completion([])
        }
    }
    
    public func updateDeck(deck: Deck) {
        let deckTable = Table("Deck")
        let id = Expression<UUID>("id")
        let name = Expression<String>("name")
        let winningScore = Expression<Int>("winningScore")
        let increment = Expression<Int64>("increment")
        let enableWinningScore = Expression<Bool>("enableWinningScore")
        let enableWinningAnimation = Expression<Bool>("enableWinningAnimation")
        let winingLogic = Expression<String>("winingLogic")
        
        // Define player expressions
        let playerTable = Table("Player")
        let playerId = Expression<UUID>("id")
        let playerTitle = Expression<String>("title")
        let playerScore = Expression<Int64>("score")
        let playerColor = Expression<String?>("color")
        let playerImage = Expression<String>("image")
        let deckId = Expression<UUID>("deckId")
        
        do {
            
            try db.run(deckTable.upsert(
                id <- deck.id,
                name <- deck.name,
                winningScore <- deck.winningScore,
                increment <- deck.increment,
                enableWinningScore <- deck.enableWinningScore,
                enableWinningAnimation <- deck.enableWinningAnimation,
                winingLogic <- deck.winingLogic.rawValue, onConflictOf: id
            ))
            print("deck upserted \(deck.name)")
            print("upserting players \(deck.players.count)")
            for player in deck.players {
                do {
                    print("COLOR: \(player.color)")
                    // Use upsert for player
                    try db.run(playerTable.upsert(
                        playerId <- player.id,
                        playerTitle <- player.title,
                        playerScore <- player.score,
                        playerColor <- player.color.toHex(),
                        playerImage <- player.image,
                        deckId <- deck.id,
                        onConflictOf: playerId
                    ))
                    print("player upserted \(player.title)")
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    public func removeDeck(deckID: UUID) {
        let deckTable = Table("Deck")
        let playerTable = Table("Player")
        let id = Expression<UUID>("id")
        let deckIdColumn = Expression<UUID>("deckId")

        do {
            // Delete players associated with the deck
            try db.run(playerTable.filter(deckIdColumn == deckID).delete())
            print("Players for Deck with ID \(deckID) deleted")

            // Delete the deck itself
            let deckToDelete = deckTable.filter(id == deckID)
            try db.run(deckToDelete.delete())
            print("Deck with ID \(deckID) deleted")
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Player CRUD Operations
    
    public func addPlayer(player: Player, deckId: UUID) throws {
        let playerTable = Table("Player")
        let image = Expression<String>("image")
        let title = Expression<String>("title")
        let score = Expression<Int64>("score")
        let color = Expression<String?>("color")
        let deckIdColumn = Expression<UUID>("deckId")
        
        do {
            print("COLOR: \(player.color), DECKID: \(deckId)")
            let insert = playerTable.insert(
                image <- player.image,
                title <- player.title,
                score <- player.score,
                color <- player.color.toHex(),
                deckIdColumn <- deckId
            )
            try db.run(insert)
        } catch {
            print(error)
            throw error // rethrow the error
        }
    }
    
    public func getPlayers(deckId: UUID) -> [Player] {
        let playerTable = Table("Player")
        let image = Expression<String>("image")
        let title = Expression<String>("title")
        let score = Expression<Int64>("score")
        let color = Expression<String?>("color")
        let id = Expression<UUID>("id")
        let deckIdColumn = Expression<UUID>("deckId")
        
        do {
            let players = try db.prepare(playerTable.filter(deckIdColumn == deckId))
            print("Player in db : \( players)")
            return try players.map { row in
                let playerColor: Color
                if let colorString = try row.get(color), let color = Color(hex: colorString) {
                    playerColor = color
                } else {
                    // Use a default color or handle the case where color is nil
                    playerColor = Color.gray
                }
                
                return Player(
                    id: try row.get(id),
                    image: try row.get(image),
                    title: try row.get(title),
                    score: try row.get(score),
                    color: playerColor
                )
            }
            
        } catch {
            print(error)
            return []
        }
    }
    public func removePlayers(playerIDs: [UUID]) {
        let playerTable = Table("Player")
        let id = Expression<UUID>("id")
        
        do {
            for playerID in playerIDs {
                let playerToDelete = playerTable.filter(id == playerID)
                try db.run(playerToDelete.delete())
                print("Player with ID \(playerID) deleted")
            }
        } catch {
            print(error)
        }
    }

}
