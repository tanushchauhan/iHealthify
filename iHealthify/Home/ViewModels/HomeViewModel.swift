//
//  HomeViewModel.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let healthKitManager = HealthKitManager.shared
    
    @Published var cals = 0
    @Published var active = 0
    @Published var stand = 0
    @Published var activities: [Activity] = []
    @Published var workouts: [Workout] = []
    @Published var showAlert = false
    
    init() {
            Task {
                do {
                    try await healthKitManager.requestAccess()
                    
                    async let fetchCalories: () = try await getCalsToday()
                    async let fetchExercise: () = try await getExerciseTimeToday()
                    async let fetchStand: () = try await getStandToday()
                    async let fetchSteps: () = try await getStepsToday()
                    async let fetchActivities: () = try await getActivitesCurrentweek()
                    async let fetchWorkouts: () = try await getRecentWorkouts()
                    
                    let (_, _, _, _, _, _) = (try await fetchCalories, try await fetchExercise, try await fetchStand, try await fetchSteps, try await fetchActivities, try await fetchWorkouts)
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert =  true
                    }
                }
            }
            
        }
    
    func getCalsToday()async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManager.calsBurnedToday{ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let calories):
                    DispatchQueue.main.async {
                        self.cals = Int(calories)
                        let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", color: .red, val: calories.numString())
                        self.activities.append(activity)
                        self.reorderActivities()
                        continuation.resume()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", color: .red, val: "---")
                        self.activities.append(activity)
                        self.reorderActivities()
                        continuation.resume(throwing: failure)
                    }
                }
            }
        }) as Void
    }
    
    func getExerciseTimeToday()async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManager.exerciseTimeToday { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let exercise):
                    DispatchQueue.main.async {
                        self.active = Int(exercise)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func getStandToday()async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManager.standHoursToday { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let hours):
                    DispatchQueue.main.async {
                        self.stand = hours
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func getStepsToday()async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManager.stepsToday { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let activity):
                    DispatchQueue.main.async {
                        self.activities.append(activity)
                        self.reorderActivities()
                        continuation.resume()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.activities.append(Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", color: .green, val: "---"))
                        self.reorderActivities()
                        continuation.resume(throwing: failure)
                    }
                }
            }
        }) as Void
    }
    
    func getActivitesCurrentweek() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManager.workoutsStatsCurrentWeek { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let activities):
                    DispatchQueue.main.async {
                        self.activities.append(contentsOf: activities)
                        self.reorderActivities()
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    //helper
    // Reorder function to ensure Calories Burned and Steps always come first in the correct order
    
    func reorderActivities() {
        // Separate out Calories Burned and Steps
        let caloriesActivity = self.activities.first { $0.title == "Calories Burned" }
        let stepsActivity = self.activities.first { $0.title == "Today Steps" }

        // Filter out existing Calories Burned and Steps (if any) to avoid duplicates
        self.activities = self.activities.filter { $0.title != "Calories Burned" && $0.title != "Today Steps" }

        // Reinsert them at the beginning in the correct order
        if let calories = caloriesActivity {
            self.activities.insert(calories, at: 0)
            if let steps = stepsActivity {
                self.activities.insert(steps, at: 1)  // Steps come second
            }
        }
        else {
            if let steps = stepsActivity {
                self.activities.insert(steps, at: 0)  // Steps come second
            }
            
        }

    }
    
    func getRecentWorkouts() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManager.workoutsMonth(month: Date()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let workouts):
                    DispatchQueue.main.async {
                        self.workouts = Array(workouts.prefix(4))
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
}
