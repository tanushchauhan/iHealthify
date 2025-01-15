//
//  AppTabView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import SwiftUI

struct AppTabView: View {
    @State var selectedTab = "Home"
    @AppStorage("username") var username: String?
    @State var showTerms = true
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            ChartsView()
                .tag("Historic")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    
                }
            LeaderBoardView(showTerms: $showTerms)
                .tag("Leaderboard")
                .tabItem {
                    Image(systemName: "list.bullet")
                }
            
            ProfileView()
                .tag("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .tint(.green)
        .onAppear {
            showTerms = username == nil
        }
    }
}

#Preview {
    AppTabView()
}
