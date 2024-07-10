//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/10/24.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
//        defaultNavView
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink(destination:
                    Text("Destination")
                    .customNavigationTitle("Second screen")
                    .customNavigationSubtitle("Subtitle should be showing")
                ) {
                    Text("Navigate")
                }
            }
            .customNavBarItems(title: "New title!", subtitle: "type shi", backButtonHidden: true)
        }
    }
}

#Preview {
    AppNavBarView()
}

extension AppNavBarView {
    
    private var defaultNavView: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink {
                    Text("Destination")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden(false)
                } label: {
                    Text("Navigate")
                }

            }
            .navigationTitle("Nav title here")
        }
    }
    
}
