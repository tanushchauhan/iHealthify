//
//  FitnessProfileEditButton.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import SwiftUI


struct FitnessProfileEditButton: View {
    @State var title: String
    @State var backgroundColor: Color
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding()
                .frame(maxWidth: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                )
        }
    }
}
