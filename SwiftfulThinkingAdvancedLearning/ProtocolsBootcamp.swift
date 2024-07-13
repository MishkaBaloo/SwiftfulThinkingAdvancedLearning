//
//  ProtocolsBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 7/13/24.
//

import SwiftUI

struct DefaultColorTheme: ColorThemeProtocol {
    let primary: Color = .blue
    let secondary: Color = .white
    let tertiary: Color = .gray.opacity(0.4)
}

struct AlternativeColorTheme: ColorThemeProtocol {
    let primary: Color = .pink
    let secondary: Color = .white
    let tertiary: Color = .black
}

struct AnotherColorTheme: ColorThemeProtocol {
    var primary: Color = .blue
    var secondary: Color = .red
    var tertiary: Color = .purple
}

protocol ColorThemeProtocol { // set of rools that class need to have/setting
    var primary: Color { get } // reqirement that needs to be in ColorTheme
    var secondary: Color { get } // reqirement that needs to be in ColorTheme
    var tertiary: Color { get } // reqirement that needs to be in colorThemes
}

protocol ButtonTextProtocol {
    var buttonText: String { get }
}

protocol ButtonPressedProtocol {
    func buttonPressed()
}

protocol ButtonDataSourceProtocol: ButtonTextProtocol, ButtonPressedProtocol {
    
}

class DefaultDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "Protocols bootcamp!"
    
    func buttonPressed() {
        print("Button was pressed")
    }
}

class AlternativeDataSource: ButtonTextProtocol {
    var buttonText: String = "Protocols are lame"
}

struct ProtocolsBootcamp: View {
    
    let colorTheme: ColorThemeProtocol
    let dataSource: ButtonDataSourceProtocol
    
    var body: some View {
        ZStack {
            colorTheme.tertiary
                .ignoresSafeArea()
            
            Text(dataSource.buttonText)
                .font(.headline)
                .foregroundStyle(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .clipShape(.rect(cornerRadius: 10))
                .onTapGesture {
                    dataSource.buttonPressed()
                }
        }
    }
}

#Preview {
    ProtocolsBootcamp(colorTheme: DefaultColorTheme(), dataSource: DefaultDataSource())
}
