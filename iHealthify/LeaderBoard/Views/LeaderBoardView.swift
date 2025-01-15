//
//  LeaderBoardView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import SwiftUI

struct LeaderBoardView: View {
    @AppStorage("username") var username: String?
    @StateObject var viewModel = LeaderBoardViewModel()
    
    @Binding var showTerms: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .trailing) {
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.setTheBoard()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: 28, height: 28)
                            .padding(.trailing)
                    }
                }.padding(.top, 20)
                
                HStack {
                    Text("Name")
                        .bold()
                        .foregroundColor(.primary) // Adapts to dark mode
                    
                    Spacer()
                    
                    
                    Text("Steps(Since Monday)")
                        .bold()
                        .foregroundColor(.primary) // Adapts to dark mode
                }
                .padding()
                
                LazyVStack(spacing: 24) {
                    ForEach(Array(viewModel.leaderResult.top10.enumerated()), id: \.element.id) { (idx, person) in
                        HStack {
                            Text("\(idx + 1).")
                                .foregroundColor(.primary) // Adapts to dark mode
                            
                            Text(person.username)
                                .foregroundColor(username == person.username ? .green : .primary) // Highlight current user
                            
                            if username == person.username {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                            
                            Spacer()
                            
                            Text("\(person.count)")
                                .foregroundColor(.primary) // Adapts to dark mode
                        }
                        .padding(.horizontal)
                    }
                }
                
                if let user = viewModel.leaderResult.user {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    HStack {
                        Text(user.username)
                            .foregroundColor(.primary) // Adapts to dark mode
                        
                        Spacer()
                        
                        Text("\(user.count)")
                            .foregroundColor(.primary) // Adapts to dark mode
                    }
                    .padding(.horizontal)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .alert("Oops", isPresented: $viewModel.showAlert, actions: {
                Button(role: .cancel) {
                    viewModel.showAlert = false
                } label: {
                    Text("Ok")
                }
            }, message: {
                Text("There was an issue loading the leaderboard data. Please try again later.")
            })
            
            if showTerms {
                Color.black.opacity(0.6) // Background overlay for dark mode
                    .ignoresSafeArea()
                
                TermsView(showTerms: $showTerms)
                    .background(Color(.systemBackground)) // Adapt background to dark/light mode
                    .cornerRadius(12)
                    .padding()
                    .shadow(radius: 10) // Add some shadow to make it stand out
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: showTerms) {
            if !showTerms && username != nil {
                viewModel.setTheBoard()
            }
        }
    }
}
