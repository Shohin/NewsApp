//
//  RStorageService.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation
import RealmSwift

typealias RObjectTransformer = Object & DataTransformer

struct FetchResult<T: RObjectTransformer> {
    let items: [T]
    let totalResultsCount: Int
}

final class RStorageService {
    static let shared = RStorageService()
    
    func setupDefault() {
        let config = Realm.Configuration(
          // Set the new schema version. This must be greater than the previously used
          // version (if you've never set a schema version before, the version is 0).
          schemaVersion: 0,
          
          // Set the block which will be called automatically when opening a Realm with
          // a schema version lower than the one set above
          migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    private var newRealm: Realm {
        try! Realm()
    }
    
    func fetchData<T: RObjectTransformer>() -> [T] {
        newRealm.objects(T.self).map { $0 }
    }
    
    func fetchData<T: RObjectTransformer>(start: Int, end: Int) -> FetchResult<T> {
        let itemsRes = newRealm.objects(T.self)
        return FetchResult(items: Array(itemsRes[start..<end]), totalResultsCount: itemsRes.count)
    }
    
    func fetchData<T: RObjectTransformer>(id: String) -> T? {
        newRealm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func save<T: RObjectTransformer>(data: T) throws {
        let realm = newRealm
        try safeWrite(realm: realm) {
            realm.add(data, update: .modified)
        }
    }
    
    func save<T: RObjectTransformer>(data: [T]) throws {
        try data.forEach { try save(data: $0) }
    }
    
    func deleteAll<T: RObjectTransformer>(object: T.Type, predicate: ((T) -> Bool)? = nil) throws {
        let realm = newRealm
        try safeWrite(realm: realm) {
            if let predicate {
                realm.delete(realm.objects(T.self).filter(predicate))
            } else {
                realm.delete(realm.objects(T.self))
            }
        }
    }
    
    func safeUpdate(block: @escaping () -> Void) throws {
        try safeWrite(realm: newRealm, block)
    }
    
    private func safeWrite(realm: Realm, _ block: (() throws -> Void)) throws {
        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
    
    private init() {}
}
