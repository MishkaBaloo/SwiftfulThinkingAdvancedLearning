//
//  CustomNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/10/24.
//

import SwiftUI

struct CustomNavBarView: View {
    
    @Environment(\.dismiss) var presentationMode
    let showBackButton: Bool
    let title: String
    let subtitle: String?
    
    
    var body: some View {
        HStack {
            if showBackButton {
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if showBackButton {
                backButton
                    .opacity(0)
            }
        }
        .padding()
        .tint(.white)
        .foregroundStyle(Color.white)
        .font(.headline)
        .background(Color.blue.ignoresSafeArea(edges: .top))
    }
}

#Preview {
    VStack {
        CustomNavBarView(showBackButton: true, title: "Title here", subtitle: "Subtitle goes here ")
        Spacer()
    }
}

extension CustomNavBarView {
    
    private var backButton: some View {
        Button(action: {
            presentationMode.callAsFunction()
        }, label: {
            Image(systemName: "chevron.left")
        })
    }
    
    
    private var titleSection: some View {
        VStack(spacing: 4, content: {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
            }
        })
    }
}
