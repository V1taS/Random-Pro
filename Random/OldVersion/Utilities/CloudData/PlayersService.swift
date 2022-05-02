//
//  PlayersService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 29.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import CloudKit
import UIKit
import CoreData

final class PlayersService {
    
    // MARK: - Public variables
   
    public var onChange : (([CloudPlayer]) -> Void)?
    
    public var onError : ((Error) -> Void)?
    
    public var notificationQueue = OperationQueue.main
    
    lazy public var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "")
        
        container.loadPersistentStores(completionHandler: { _,_ in })
        
        let options = NSPersistentCloudKitContainerSchemaInitializationOptions()
        try? container.initializeCloudKitSchema(options: options)
                
        return container
    }()
    
    // MARK: - Private variables
    
    private let database = CKContainer.default().privateCloudDatabase
    private var records: [CKRecord] = []
    private var insertedObjects: [CloudPlayer] = []
    private var deletedObjectIds: Set<CKRecord.ID> = []
    
    private func handle(error: Error) {
        self.notificationQueue.addOperation {
            self.onError?(error)
        }
    }
    
    private var players: [CloudPlayer] = [] {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?(self.players)
            }
        }
    }
    
    func addPlayer(id: String, name: String, photo: String, team: String?) {
        var player = CloudPlayer()
        player.name = name
        player.photo = photo
        player.id = id
        
        if let team = team {
            player.team = team
        }
        
        database.save(player.record) { _, error in
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
        self.insertedObjects.append(player)
        self.updatePlayers()
    }
    
    public func deletePlayer(at index : Int) {
        fetchPlayers { [weak self] _ in
            guard let self = self else { return }
            let recordId = self.players[index].record.recordID
            self.database.delete(withRecordID: recordId) { _, error in
                guard error == nil else {
                    self.handle(error: error!)
                    return
                }
            }
            self.deletedObjectIds.insert(recordId)
            self.updatePlayers()
        }
    }
    
    public func deleteAllPlayers(_ completion: (() -> Void)? = nil) {
        let query = CKQuery(recordType: CloudPlayer.recordType, predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            guard let self = self else { return }
            
            for record in records ?? [] {
                
                self.database.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
                    guard let recordId = recordId else { return }
                    self.database.delete(withRecordID: recordId) { _, error in }
                })
            }
            completion?()
        }
        self.players = []
        self.records = []
        self.insertedObjects = []
        self.deletedObjectIds = []
    }
    
    public func fetchPlayers(completion: (([CloudPlayer]) -> Void)? = nil) {
        let query = CKQuery(recordType: CloudPlayer.recordType, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            
            guard let records = records, error == nil else {
                self.handle(error: error!)
                return
            }
            
            self.players = records.map { record in
                return CloudPlayer(record: record)
            }
            self.records = records
            self.updatePlayers()
            completion?(self.players)
        }
    }
    
    private func updatePlayers() {
        
        var knownIds = Set(records.map { $0.recordID })
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var players = records.map { record in CloudPlayer(record: record) }
        
        players.append(contentsOf: self.insertedObjects)
        players.removeAll { player in
            deletedObjectIds.contains(player.record.recordID)
        }
        
        self.players = players
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
}
