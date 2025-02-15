//
//  CloudKitPushNotificationsBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 2/14/25.
//

import SwiftUI
import CloudKit

// protocols
// generics
// futures

final class CloudKitPushNotifciationBootcampViewModel: ObservableObject {
    
    
    func requestNotificationPermissions() {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { succes, error in
            if let error = error {
                print(error)
            } else if succes {
                print("Notification permission success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission failure.")
            }
        }
    }
    
    func subscribeToNotifications() {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new fruit!"
        notification.alertBody = "Open the app to chek your fruits."
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().privateCloudDatabase.save(subscription) { returnedSubscriptions, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications")
            }
        }
    }
    
    func unsubscribeToNotifications() {
        
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions()
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubsribed!")
            }
        }
    }
    
}

struct CloudKitPushNotificationsBootcamp: View {
    
    @StateObject private var vm = CloudKitPushNotifciationBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            
            Button("Request notification permissions") {
                vm.requestNotificationPermissions()
            }
            
            Button("Subscribe to notifications") {
                vm.subscribeToNotifications()
            }
            
            Button("Unsubscribe to notifications") {
                vm.unsubscribeToNotifications()
            }
        }
    }
}

#Preview {
    CloudKitPushNotificationsBootcamp()
}
