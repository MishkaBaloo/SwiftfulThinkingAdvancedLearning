//
//  ViewModifierBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 6/26/24.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 10)
    }
    
}

extension View {
    
    func withDeafultButtonFormatting(backgroundColor: Color = .blue) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor:  backgroundColor))
    }
    
}

struct ViewModifierBootcamp: View {
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Hello, world!")
                .font(.headline)
                .withDeafultButtonFormatting(backgroundColor: .orange)
//                .modifier(DefaultButtonViewModifier())
                
            
            Text("Hello, everyone!")
                .font(.subheadline)
                .withDeafultButtonFormatting() // can call without color

            
            Text("Hello!!!")
                .font(.title)
                .withDeafultButtonFormatting(backgroundColor: .red)

        }
        .padding()
    }
}

#Preview {
    ViewModifierBootcamp()
}
