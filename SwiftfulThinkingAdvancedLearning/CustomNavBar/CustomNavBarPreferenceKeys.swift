//
//  CustomNavBarPreferenceKeys.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/10/24.
//

import Foundation
import SwiftUI

//@State private var showBackButton: Bool = true
//@State private var title: String = "Title" //""
//@State private var subtitle: String? = "Subtitle" //nil

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
}

struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
    
}

struct CustomNavBarBackButtonHiddenPreferenceKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
    
}

extension View {
    
//    .navigationTitle("Title 2")
//    .navigationBarBackButtonHidden(false)
    
    func customNavigationTitle(_ title: String) -> some View {
       preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    
    func customNavigationSubtitle(_ subtitle: String?) -> some View {
       preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
    }
    
    func customNavigationBarBackHidden(_ hidden: Bool) -> some View {
        preference(key: CustomNavBarBackButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func customNavBarItems(title: String = "", subtitle: String? = nil, backButtonHidden: Bool = false) -> some View {
        self
            .customNavigationTitle(title)
            .customNavigationSubtitle(subtitle)
            .customNavigationBarBackHidden(backButtonHidden)
    }
}
