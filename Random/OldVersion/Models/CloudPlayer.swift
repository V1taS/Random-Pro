//
//  CloudPlayer.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 29.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import CloudKit
import UIKit

struct CloudPlayer {
    
    // MARK: - Public variables
    
    public static let recordType = "Players"
    
    public var record: CKRecord
    
    public var name: String {
        get {
            return self.record.value(forKey: CloudPlayer.keyName) as? String ?? ""
        }
        set {
            self.record.setValue(newValue, forKey: CloudPlayer.keyName)
        }
    }
    
    public var photo: String {
        get {
            return self.record.value(forKey: CloudPlayer.keyPhoto) as? String ?? ""
        }
        set {
            self.record.setValue(newValue, forKey: CloudPlayer.keyPhoto)
        }
    }
    
    public var id: String {
        get {
            return self.record.value(forKey: CloudPlayer.keyId) as? String ?? ""
        }
        set {
            self.record.setValue(newValue, forKey: CloudPlayer.keyId)
        }
    }
    
    public var team: String {
        get {
            return self.record.value(forKey: CloudPlayer.keyTeam) as? String ?? ""
        }
        set {
            self.record.setValue(newValue, forKey: CloudPlayer.keyTeam)
        }
    }
    
    // MARK: - Private variables
    
    private static let keyName = "name"
    private static let keyPhoto = "photo"
    private static let keyId = "id"
    private static let keyTeam = "team"
    
    // MARK: - Init
    
    init(record: CKRecord) {
        self.record = record
    }
    
    init() {
        record = CKRecord(recordType: CloudPlayer.recordType)
    }
}
