//
//  CustomCurvesBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Michael on 6/28/24.
//

import SwiftUI

struct CustomCurvesBootcamp: View {
    var body: some View {
        WaterShape()
            .fill(
                LinearGradient(
                    colors:[Color(uiColor: #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)), Color(uiColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            )
//            .stroke(lineWidth: 5)
//            .frame(width: 200, height: 200)
//            .rotationEffect(Angle(degrees: 90))
            .ignoresSafeArea()
    }
}

#Preview {
    CustomCurvesBootcamp()
}

struct ArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2 , // 50% of all
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 24),
                clockwise: true)
        }
    }
    
}

struct ShapeWithArc: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            // top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            // top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            // mide right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

            // bottom
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 180),
                clockwise: false)
//            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))


            // mid left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))

        }
    }
}

struct QuadSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.maxX - 50, y: rect.minY - 100))
        }
    }
}

struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.40))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.60))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}
