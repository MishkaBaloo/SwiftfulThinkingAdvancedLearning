//
//  CloudKitUtility.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 2/14/25.
//

import Foundation
import CloudKit
import Combine

class CloudKitUtility {
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccontNotFound
        case iCloudAccontNotDetermine
        case iCloudAccontRestricted
        case iCloudAccontUnknown
        case iCloudApplicationPermissionNotGranted
        case icloudCouldNotFetchUserRecordID
        case iCloudCouldNotDiscoverUserIdentity
    }
    
}

// MARK: USER FUNCTIONS

extension CloudKitUtility {
    
    static private func getiCloudStatus(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().accountStatus { returnedStatus, returnedError in
                switch returnedStatus {
                case .available:
                    completion(.success(true))
                case .couldNotDetermine:
                    completion(.failure(CloudKitError.iCloudAccontNotDetermine))
                case .restricted:
                    completion(.failure(CloudKitError.iCloudAccontRestricted))
                case .noAccount:
                    completion(.failure(CloudKitError.iCloudAccontNotFound))
                default:
                    completion(.failure(CloudKitError.iCloudAccontUnknown))
                }
        }
    }
    
    static func getiCloudStauts() -> Future<Bool,Error> {
        Future { promise in
            CloudKitUtility.getiCloudStatus { result in
                promise(result)
            }
        }
    }
    
    
    
    static private func requestApplicationPermission(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
                if returnedStatus == .granted {
                    completion(.success(true))
                } else {
                    completion(.failure(CloudKitError.iCloudApplicationPermissionNotGranted))
                }
        }
    }
    
    static func requestApplicationPermission() -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.requestApplicationPermission { result in
                promise(result)
            }
        }
    }
    
    static private func fetchUserRecordID(completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().fetchUserRecordID { returnedID, returnedError in
            if let id = returnedID {
                completion(.success(id))
            }  else if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.failure(CloudKitError.icloudCouldNotFetchUserRecordID))
            }
        }
    }
    
    static private func discoverUserIdentity(id: CKRecord.ID,completion: @escaping (Result<String, Error>) -> ()) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { returnedIdentity, returnedError in
            if let name = returnedIdentity?.nameComponents?.givenName {
                completion(.success(name))
            } else {
                completion(.failure(CloudKitError.iCloudCouldNotDiscoverUserIdentity))
            }
        }
    }
    
    static private func discoverUserIdentity(completion: @escaping (Result<String, Error>) -> ()) {
        fetchUserRecordID { fetchCompletion in
            switch fetchCompletion {
            case .success(let recordID):
                CloudKitUtility.discoverUserIdentity(id: recordID, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func discoverUserIdentity() -> Future<String, Error> {
        Future { promise in
            CloudKitUtility.discoverUserIdentity { result in
                promise(result)
            }
        }
    }

}

// MARK: CRUD FUNCTIONS

extension CloudKitUtility {
    
    static func fetch<T:CloudKitableProtocol>(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil) -> Future<[T], Error> {
        Future { promise in
            CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit) { (items: [T]) in
                promise(.success(items))
            }
        }
    }
    
    static private func fetch<T:CloudKitableProtocol>(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil,
        completion: @escaping (_ items: [T]) -> ()) {
        // Create opertion
        let operation = createOpretion(predicate: predicate, recordType: recordType, sortDescriptors: sortDescriptors, resultsLimit: resultsLimit)
        
        // Get items in query
        var returnedItems: [T] = []
        addRecordMatchedBlock(operation: operation) { item in
            returnedItems.append(item)
        }
        
        // Query completion
        addQueryResultBlock(operation: operation) { finished in
            completion(returnedItems)
        }
        
        // Execute operations
        add(operation: operation)
        
        
    }
    
    static private func createOpretion(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil) -> CKQueryOperation {
            let query = CKQuery(recordType: recordType, predicate: predicate)
            query.sortDescriptors = sortDescriptors
            let queryOperation = CKQueryOperation(query: query)
            if let limit = resultsLimit {
                queryOperation.resultsLimit = limit
            }
            return queryOperation
        }
    
    static private func addRecordMatchedBlock<T:CloudKitableProtocol>(operation: CKQueryOperation, completion: @escaping(_ item: T) -> ()) {
        operation.recordMatchedBlock = { (returnedrecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let item = T(record: record) else { return }
                completion(item)
            case .failure:
                break
            }
        }
    }
    
    static private func addQueryResultBlock(operation: CKQueryOperation, completion: @escaping (_ finished: Bool) -> ()) {
        operation.queryResultBlock = { returnedResult in
            completion(true)
        }
    }
    
    static private func add(operation: CKDatabaseOperation) {
            CKContainer.default().publicCloudDatabase.add(operation)
        }
    
    static func add<T:CloudKitableProtocol>(item: T, completion: @escaping (Result<Bool,Error>) -> ()) {
        
        // Get record
        let record = item.record
        
        // Save to CloudKit
        save(record: record, completion: completion)
    }
    
    static func update<T:CloudKitableProtocol>(item: T, completion: @escaping (Result<Bool,Error>) -> ()) {
        add(item: item, completion: completion)
    }

    
    static func save(record: CKRecord, completion: @escaping (Result<Bool,Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.save(record) {  returnedRecord, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static func delete<T:CloudKitableProtocol>(item: T) -> Future<Bool,Error> {
        Future { promise in
            CloudKitUtility.delete(item: item, completion: promise)
        }
    }
    
    static private func delete<T:CloudKitableProtocol>(item: T, completion: @escaping (Result<Bool,Error>) -> ()) {
        CloudKitUtility.delete(record: item.record, completion: completion)
    }
    
    static private func delete(record: CKRecord, completion: @escaping (Result<Bool,Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) {  returnedRecordId, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    
    
}


