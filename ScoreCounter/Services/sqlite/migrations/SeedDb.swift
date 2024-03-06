//
//  SwiftMigration.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 23/02/2024.
//

import Foundation
import SQLiteMigrationManager
import SQLite
import SwiftUI

public class IncrementsArray: Codable,MutableCollection,ObservableObject,Value {
    @Published public var values: [Int64] = []
    // Conform to MutableCollection
    public var startIndex: Int { values.startIndex }
    public var endIndex: Int { values.endIndex }
    
    public static var declaredDatatype: String {
        return String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ datatypeValue: String) -> IncrementsArray {
        let data = datatypeValue.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try! decoder.decode(IncrementsArray.self, from: data)
    }
    
    public var datatypeValue: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
    
    
    public subscript(position: Int) -> Int64 {
        get { return values[position] }
        set { values[position] = newValue }
    }
    
    // Required for MutableCollection conformance
    public func index(after i: Int) -> Int {
        return values.index(after: i)
    }
    
    init(values: [Int64] = []) {
            self.values = values
        }
    required public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.values = try container.decode([Int64].self, forKey: .values)
      }
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(values, forKey: .values)
        }
    private enum CodingKeys: String, CodingKey {
           case values
       }
}

struct SeedDb: Migration {
    var version: Int64 = 2024_02_24_12_00_00
    
    func migrateDatabase(_ db: Connection) throws {
            let settings = Table("settings")
            let id = Expression<Int64>("id")  // New primary ID column
            let appearance = Expression<AppAppearance>("appearance")
            let vibrate = Expression<Bool>("vibrate")
            let keepScreenOn = Expression<Bool>("keepScreenOn")
            let increments = Expression<IncrementsArray>("increments")

            try db.run(settings.create { table in
                table.column(id, primaryKey: .autoincrement)  // Primary ID column
                table.column(appearance, defaultValue: AppAppearance.system)
                table.column(vibrate, defaultValue: false)
                table.column(keepScreenOn, defaultValue: false)
                table.column(increments, defaultValue: IncrementsArray(values: [1, 5, 10]))
            })

            // Insert initial values
            let initialSettings = settings.insert(appearance <- AppAppearance.system, vibrate <- false, keepScreenOn <- false, increments <- IncrementsArray(values: [1, 5, 10]))
            try db.run(initialSettings)
        }
}
