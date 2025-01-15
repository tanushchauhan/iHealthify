//
//  HistoricDataView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import SwiftUI

struct HistoricDataView: View {
    @Binding var average: Int
    @Binding var total: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Average")
                    .font(.title2)
                
                Text("\(average)")
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(width: 100)
            .foregroundColor(.primary) // Adapts to light/dark mode
            .padding()
            .background(Color(.secondarySystemBackground)) // Adapts to light/dark mode
            .cornerRadius(10)
            
            Spacer()
            
            VStack(spacing: 16) {
                
                Text("Total")
                    .font(.title2)
                
                Text("\(total)")
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(width: 100)
            .foregroundColor(.primary) // Adapts to light/dark mode
            .padding()
            .background(Color(.secondarySystemBackground)) // Adapts to light/dark mode
            .cornerRadius(10)
            
            Spacer()
        }
    }
}

#Preview {
    HistoricDataView(average: .constant(3425), total: .constant(2344))
}

