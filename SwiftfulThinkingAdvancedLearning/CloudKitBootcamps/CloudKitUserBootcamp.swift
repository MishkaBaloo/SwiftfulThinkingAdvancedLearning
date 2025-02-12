//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 2/12/25.
//

import SwiftUI
import CloudKit

class CloudKitUserBootcampViewModel: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    @Published var permissionStatus: Bool = false
    
    init() {
        getiCloudStatus()
        requestPermission()
        fetchiCloudUserRecordID()
    }
    
    func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccontNotDetermine.rawValue
                case .available:
                    self?.isSignedInToiCloud = true
                case .restricted:
                    self?.error = CloudKitError.iCloudAccontRestricted.rawValue
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccontNotFound.rawValue
                default:
                    self?.error = CloudKitError.iCloudAccontUnknown.rawValue
                }
            }
        }
    }
    
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.discoverCloudUser(id: id)
            }
        }
    }
    
    func discoverCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccontNotFound
        case iCloudAccontNotDetermine
        case iCloudAccontRestricted
        case iCloudAccontUnknown
    }
    
    func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self?.permissionStatus = true
                }
            }
        }
    }
}

struct CloudKitUserBootcamp: View {
    
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    
    var body: some View {
        Text("IS SIGNED IN:\(vm.isSignedInToiCloud.description.uppercased())")
        Text(vm.error)
        Text("Persmisson: \(vm.permissionStatus.description.uppercased())")
        Text("NAME: \(vm.userName)")
    }
}

#Preview {
    CloudKitUserBootcamp()
}
