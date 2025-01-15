//
//  MonthWorkoutsView.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//


import SwiftUI

struct MonthWorkoutsView: View {
    @StateObject var viewModel = MonthWorkoutsViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.selectedMonth -= 1
                    }
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.green)
                }

                Spacer()
                
                Text(viewModel.selectedDate.monthAndYearFormat())
                    .font(.title)
                    .frame(maxWidth: 250)
                Spacer()
                
                Button {
                    viewModel.selectedMonth += 1
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.green)
                        .opacity(viewModel.selectedMonth >= 0 ? 0.5 : 1)
                }
                .disabled(viewModel.selectedMonth >= 0)
                
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.currentMonthWorkouts, id: \.self) { workout in
                    WorkoutCell(workout: workout)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical)
        .onChange(of: viewModel.selectedMonth) { _ in
            viewModel.updateSelectedDate()
        }
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button(role: .cancel) {
                viewModel.showAlert = false
            } label: {
                Text("Ok")
            }
        } message: {
            Text("Unable to load workouts for \(viewModel.selectedDate.monthAndYearFormat()). Please make sure you have workouts for the selected month and try again")
        }

    }
}
