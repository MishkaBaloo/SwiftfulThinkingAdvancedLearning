//
//  PreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/3/24.
//

import SwiftUI

struct PreferenceKeyBootcamp: View {
    
    @State private var text: String = "Hello, world"
    
    var body: some View {
        NavigationStack {
            VStack {
                secondaryScreen(text: text)
                    .navigationTitle("Navigation Title")
            }
        }
        .onPreferenceChange(customTitlePreferenceKey.self, perform: { value in
            self.text = value
        })
    }
}

extension View {
    
    func customTitle(_ text: String) -> some View {
            preference(key: customTitlePreferenceKey.self, value: text)
    }
    
}

#Preview {
    PreferenceKeyBootcamp()
}

struct secondaryScreen: View {
    
    let text: String
    @State private var newValue: String = ""
    
    var body: some View {
        Text(text)
            .onAppear(perform: getDataFromDataBase)
            .customTitle(newValue)
    }
    
    func getDataFromDataBase() {
        // download some fake data
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.newValue = "New value from database"
        }
    }
}

struct customTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
}
