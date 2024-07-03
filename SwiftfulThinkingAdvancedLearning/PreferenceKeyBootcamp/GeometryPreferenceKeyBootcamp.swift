//
//  GeometryPreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/3/24.
//

import SwiftUI

struct GeometryPreferenceKeyBootcamp: View {
    
    @State private var rectSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .frame(width: rectSize.width, height: rectSize.height)
                .background(Color.blue)
            Spacer()
            HStack {
                Rectangle()
                
                GeometryReader(content: { geometry in
                    Rectangle()
                        .updateRectangleGeometrySize(geometry.size)
                       
                })
                Rectangle()

            }
            .frame(height: 55)
        }
        .onPreferenceChange(RectangleGeometryPreferenceKey.self, perform: { value in
            self .rectSize = value
        })
    }
}

#Preview {
    GeometryPreferenceKeyBootcamp()
}

extension View {
    
    func updateRectangleGeometrySize(_ size: CGSize) -> some View {
        preference(key: RectangleGeometryPreferenceKey.self, value: size)
    }
    
}

struct RectangleGeometryPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}
