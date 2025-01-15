//
//  ActivityCell.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import SwiftUI

struct ActivityCell: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6) // Dynamic color for light and dark mode
                .cornerRadius(15)
            VStack{
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 8){
                        Text(activity.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text(activity.subtitle)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.color)
                }
                
                Text(activity.val)
                    .font(.title)
                    .bold()
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCell(activity: Activity(title: "Today Steps", subtitle: "Goal 32,544", image: "figure.walk", color: .green, val: "5432"))
}
