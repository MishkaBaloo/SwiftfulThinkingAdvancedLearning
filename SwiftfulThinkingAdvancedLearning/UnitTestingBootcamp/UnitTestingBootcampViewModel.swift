//
//  UnitTestingBootcampViewModel.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/15/24.
//

import Foundation
import SwiftUI

class UnitTestingBootcampViewModel: ObservableObject {
    
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    
    init(isPremium: Bool) {
        self.isPremium = isPremium
    }
    
    func addItem(item: String) {
        guard !item.isEmpty else { return }
        self.dataArray.append(item)
    }
    
    func selectedItem(item: String) {
        if let x = dataArray.first(where: {$0 == item}) {
            selectedItem = x
        }
    }
}
