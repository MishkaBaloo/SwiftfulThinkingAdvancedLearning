//
//  UnitTestingBootcampView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/15/24.
//

/*
 1. Unit Tests (Any code that not a View; like ViewModel, DataService, Utility; Cover everything except UI)
 - test the business logic in your app
 More common and more important then UI Tests
 
 2. UI Tests
 - tests the UI o your app
 
 */

import SwiftUI



struct UnitTestingBootcampView: View {
    
    @StateObject private var vm: UnitTestingBootcampViewModel
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

#Preview {
    UnitTestingBootcampView(isPremium: true)
}
