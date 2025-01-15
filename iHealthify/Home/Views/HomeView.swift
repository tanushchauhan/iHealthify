//
//  HomeView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State var showAllActivities = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading){
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    HStack{
                        
                        Spacer()
                        
                        
                        VStack(alignment: .leading){
                            VStack(alignment: .leading, spacing: 8){
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("\(viewModel.cals)")
                                    .bold()
                                
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text("\(viewModel.active)")
                                    .bold()
                                
                            }
                            .padding(.bottom)
                            VStack(alignment: .leading, spacing: 8){
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.blue)
                                
                                Text("\(viewModel.stand)")
                                    .bold()
                                
                            }
                        }
                        Spacer()
                        
                        ZStack{
                            RingsView(percentage: $viewModel.cals, color: .red, goal: 600)
                            
                            RingsView(percentage: $viewModel.active, color: .green, goal: 60)
                                .padding(.all, 20) // 20 because the width of the line is 20
                            
                            RingsView(percentage: $viewModel.stand, color: .blue, goal: 12)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack{
                        Text("Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        Button {
                            showAllActivities.toggle()
                        } label: {
                            Text("Show more")
                                .padding(.all, 20)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: [GridItem(spacing: 20), GridItem(spacing: 20)]) {
                            ForEach(viewModel.activities.prefix(showAllActivities == true ? 13 : 4), id: \.title){ a in
                                ActivityCell(activity: a)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack{
                        Text("Recent Workouts")
                            .font(.title2)
                        
                        Spacer()
                        
                        NavigationLink {
                            MonthWorkoutsView()
                        } label: {
                            Text("Show more")
                                .padding(.all, 20)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(viewModel.workouts, id: \.title){ a in
                            WorkoutCell(workout: a)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .alert("Oops", isPresented: $viewModel.showAlert, actions: {
            Button(role: .cancel) {
                viewModel.showAlert = false
            } label: {
                Text("Ok")
            }
        }, message: {
            Text("An issue occurred while retrieving some of your data. Please note that certain health tracking features require an Apple Watch.")
        })
    }
}

#Preview {
    HomeView()
}
