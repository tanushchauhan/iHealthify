//
//  MonthWorkoutsViewModel.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//


import Foundation


class MonthWorkoutsViewModel: ObservableObject {
    
    @Published var selectedMonth = 0
    @Published var selectedDate = Date()
    var fetchedMonths: Set<String> = []
    
    @Published var workouts = [Workout]()
    @Published var currentMonthWorkouts = [Workout]()
    
    @Published var showAlert = false
    
    init() {
        Task {
            do {
                try await fetchWorkoutsForMonth()
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert = true
                }
            }
        }
    }
    
    func updateSelectedDate() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
        
        if fetchedMonths.contains(selectedDate.monthAndYearFormat()) {
            self.currentMonthWorkouts = workouts.filter( { $0.date.monthAndYearFormat() == selectedDate.monthAndYearFormat() } )
        } else {
            Task {
                do {
                    try await fetchWorkoutsForMonth()
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func fetchWorkoutsForMonth() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            HealthKitManager.shared.workoutsMonth(month: selectedDate) { result in
                switch result {
                case .success(let workouts):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.workouts.append(contentsOf: workouts)
                        self.fetchedMonths.insert(self.selectedDate.monthAndYearFormat())
                        self.currentMonthWorkouts = self.workouts.filter( { $0.date.monthAndYearFormat() == self.selectedDate.monthAndYearFormat() } )
                        continuation.resume()
                    }
                case .failure(_):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                        continuation.resume()
                    }
                }
            }
        }) as Void
    }
    
}
