//
//  CurrentAppVersionListService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import CloudKit
import UIKit
import CoreData

final class CurrentAppVersionListService {
    
    // MARK: - Public variables
   
    public var onChange : (([CloudCurrentAppVersion]) -> Void)?
    
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
    
    private let database = CKContainer.default().publicCloudDatabase
    private var records: [CKRecord] = []
    private var insertedObjects: [CloudCurrentAppVersion] = []
    private var deletedObjectIds: Set<CKRecord.ID> = []
    
    private func handle(error: Error) {
        self.notificationQueue.addOperation {
            self.onError?(error)
        }
    }
    
    private var list: [CloudCurrentAppVersion] = [] {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?(self.list)
            }
        }
    }
    
    func add(element: String) {
        var list = CloudCurrentAppVersion()
        list.element = element
        
        database.save(list.record) { _, error in
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
        self.insertedObjects.append(list)
        self.updateList()
    }
    
    public func deleteElement(at index : Int) {
        fetchList { [weak self] _ in
            guard let self = self else { return }
            let recordId = self.list[index].record.recordID
            self.database.delete(withRecordID: recordId) { _, error in
                guard error == nil else {
                    self.handle(error: error!)
                    return
                }
            }
            self.deletedObjectIds.insert(recordId)
            self.updateList()
        }
    }
    
    public func deleteAllElements(_ completion: (() -> Void)? = nil) {
        let query = CKQuery(recordType: CloudCurrentAppVersion.recordType, predicate: NSPredicate(value: true))
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
        self.list = []
        self.records = []
        self.insertedObjects = []
        self.deletedObjectIds = []
    }
    
    public func fetchList(completion: (([CloudCurrentAppVersion]) -> Void)? = nil) {
        let query = CKQuery(recordType: CloudCurrentAppVersion.recordType, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            
            guard let records = records, error == nil else {
                self.handle(error: error!)
                return
            }
            
            self.list = records.map { record in
                return CloudCurrentAppVersion(record: record)
            }
            self.records = records
            self.updateList()
            completion?(self.list)
        }
    }
    
    private func updateList() {
        
        var knownIds = Set(records.map { $0.recordID })
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { errand in
            knownIds.contains(errand.record.recordID)
        }
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var list = records.map { record in CloudCurrentAppVersion(record: record) }
        
        list.append(contentsOf: self.insertedObjects)
        list.removeAll { element in
            deletedObjectIds.contains(element.record.recordID)
        }
        
        self.list = list
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
}


