//
//  RingsView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import SwiftUI

struct RingsView: View {
    @Binding var percentage: Int
    var color: Color
    var goal: Int
    private let width: CGFloat = 20
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: CGFloat(percentage) / CGFloat(goal))
                .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 5)
        }
    }
}

#Preview {
    RingsView(percentage: .constant(100), color: .red, goal: 200)
}
