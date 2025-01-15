//
//  HealthKitManager.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import Foundation
import HealthKit

extension Date {
    static var startOfToday: Date {
        Calendar.current.startOfDay(for: Date())
    }
    static var startOfWeek: Date {
        var comps = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        comps.weekday = 2 // starting from this week's monday
        return Calendar.current.date(from: comps) ?? Date()
    }
    func getMonthStartAndEndDate() -> (Date, Date){
        let startDateComp = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        
        let startDate = Calendar.current.date(from: startDateComp) ?? self
        let endDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        
        return (startDate, endDate)
    }
    
    func getFormattedWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    static var threeMonthsAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    func monthAndYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter.string(from: self)
    }
    
    func dateFormatMonday() -> String {
        let monday = Date.startOfWeek
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: monday)
    }
}

extension Double {
    func numString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

class HealthKitManager {
    
    static let shared  =  HealthKitManager()
    let healthStore = HKHealthStore()
    
    private init() {
        Task {
            do {
                try await requestAccess()
            } catch {
                DispatchQueue.main.async {
                    presentAlert(title: "Oops", message: "We couldn't access your health data. Please grant permission to continue using the app seamlessly.")
                }
            }
        }
    }
    
    func requestAccess() async throws {
        let cals = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workout = HKSampleType.workoutType()
        
        try await healthStore.requestAuthorization(toShare: [], read: Set(arrayLiteral: cals, exercise, stand, steps, workout))
    }
    
    func calsBurnedToday(completion: @escaping (Result<Double, Error>) -> Void){
        let cals = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfToday, end: Date())
        let query = HKStatisticsQuery(quantityType: cals, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
                           
            let calCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calCount))
        }
        
        healthStore.execute(query)
    }
    
    func exerciseTimeToday(completion: @escaping (Result<Double, Error>) -> Void){
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfToday, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
                           
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        
        healthStore.execute(query)
    }
    
    func standHoursToday(completion: @escaping (Result<Int, Error>) -> Void){
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfToday, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, result, error in
            
            guard let samples = result as? [HKCategorySample], error == nil else {
                completion(.failure(error!))
                return
            }
            
            let sCount = samples.filter({ $0.value == 0 }).count
            
            completion(.success(sCount))
            
        }
        
        healthStore.execute(query)
    }
    
    func stepsToday(completion: @escaping (Result<Activity, Error>) -> Void){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfToday, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
                           
            let steps = quantity.doubleValue(for: .count())
            completion(.success(Activity(title: "Today Steps", subtitle: "Goal: 7000", image: "figure.walk", color: .green, val: steps.numString())))
        }
        
        healthStore.execute(query)
    }
    
    func workoutsStatsCurrentWeek(completion: @escaping (Result<[Activity], Error>) -> Void){
        let workout = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, result, error in
            
            guard let workouts = result as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var runningCount: Int = 0
            var cyclingCount: Int = 0
            var swimmingCount: Int = 0
            var walkingCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            var yogaCount: Int = 0
            var otherCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
                
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .cycling {
                    cyclingCount += duration
                } else if workout.workoutActivityType == .swimming {
                    swimmingCount += duration
                } else if workout.workoutActivityType == .walking {
                    walkingCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                } else if workout.workoutActivityType == .yoga {
                    yogaCount += duration
                } else {
                    otherCount += duration
                }
            }

            completion(.success(self.genActivitesFromDuration(running: runningCount, cycling: cyclingCount, swimming: swimmingCount, walking: walkingCount, strengthTraining: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount, yoga: yogaCount, other: otherCount)))
            
            
        }
        
        healthStore.execute(query)
    }
    
    //helper function
    func genActivitesFromDuration(running: Int, cycling: Int, swimming: Int, walking: Int, strengthTraining: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int, yoga: Int, other: Int) -> [Activity] {
        return [
            Activity(title: "Running", subtitle: "This week", image: "figure.run", color: .green, val: "\(running)")
            , Activity(title: "Cycling", subtitle: "This week", image: "figure.indoor.cycle", color: .blue, val: "\(cycling)")
            , Activity(title: "Swimming", subtitle: "This week", image: "figure.open.water.swim", color: .red, val: "\(swimming)")
            , Activity(title: "Walking", subtitle: "This week", image: "figure.walk", color: .yellow, val: "\(walking)")
            , Activity(title: "Strength Training", subtitle: "This week", image: "figure.strengthtraining.functional", color: .purple, val: "\(strengthTraining)")
            , Activity(title: "Soccer", subtitle: "This week", image: "figure.soccer", color: .orange, val: "\(soccer)")
            , Activity(title: "Basketball", subtitle: "This week", image: "figure.basketball", color: .green, val: "\(basketball)")
            , Activity(title: "Stairs", subtitle: "This week", image: "figure.stairs", color: .blue, val: "\(stairs)")
            , Activity(title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", color: .purple, val: "\(kickboxing)")
            , Activity(title: "Yoga", subtitle: "This week", image: "figure.yoga", color: .orange, val: "\(yoga)")
            , Activity(title: "Other", subtitle: "This week", image: "figure.stand", color: .gray, val: "\(other)")
        ]
    }
    
    func workoutsMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void){
        let workout = HKSampleType.workoutType()
        let (start, end) = month.getMonthStartAndEndDate() // Taking all the workouts of the current month
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let sortD = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortD]){ _, result, error in
            
            guard let workout = result as? [HKWorkout], error == nil else {
                completion(.failure(error!))
                return
            }
            
            let wArray = workout.map { workout in
                let activeEnergyType = HKQuantityType(.activeEnergyBurned)
                if let statistics = workout.statistics(for: activeEnergyType) {
                    let totalEnergyBurned = statistics.sumQuantity()
                    let calories = totalEnergyBurned?.doubleValue(for: .kilocalorie())
                    let caloriesString = calories?.numString() ?? "-"
                    return Workout(
                        title: workout.workoutActivityType.name,
                        image: workout.workoutActivityType.sfsymbol,
                        duration: "\(Int(workout.duration) / 60) mins",
                        date: workout.startDate,
                        calories: caloriesString + " kcal",
                        color: workout.workoutActivityType.color
                    )
                } else {
                    return Workout(
                        title: workout.workoutActivityType.name,
                        image: workout.workoutActivityType.sfsymbol,
                        duration: "\(Int(workout.duration) / 60) mins",
                        date: workout.startDate,
                        calories: "- kcal",
                        color: workout.workoutActivityType.color
                    )
                }
            }
            
            completion(.success(wArray))
            
        }
        healthStore.execute(query)
    }
}

extension HealthKitManager {

    struct AnnualStepDataResult {
        let yearToDateSteps: [MStep]
        let pastYearSteps: [MStep]
    }

    func fetchYTDAndOneYearChartData(completion: @escaping (Result<AnnualStepDataResult, Error>) -> Void) {
        let stepType = HKQuantityType(.stepCount)
        let calendar = Calendar.current

        var pastYearStepData = [MStep]()
        var yearToDateStepData = [MStep]()

        for monthOffset in 0...11 {
            let targetMonth = calendar.date(byAdding: .month, value: -monthOffset, to: Date()) ?? Date()
            let (startOfMonth, endOfMonth) = targetMonth.getMonthStartAndEndDate()
            let dateRangePredicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: dateRangePredicate) { _, results, error in
                if let error = error, error.localizedDescription != "No data available for the specified predicate." {
                    completion(.failure(error))
                }
                
                let totalSteps = results?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                
                
                let stepEntry = MStep(date: targetMonth, count: Int(totalSteps))
                pastYearStepData.append(stepEntry)
                
                if calendar.component(.year, from: Date()) == calendar.component(.year, from: targetMonth) {
                    yearToDateStepData.append(stepEntry)
                }

                if monthOffset == 11 {
                    completion(.success(AnnualStepDataResult(yearToDateSteps: yearToDateStepData, pastYearSteps: pastYearStepData)))
                }
            }
            healthStore.execute(query)
        }
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DStep], Error>) -> Void) {
        let stepType = HKQuantityType(.stepCount)
        let dailyInterval = DateComponents(day: 1)

        let stepQuery = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: dailyInterval)

        stepQuery.initialResultsHandler = { _, results, error in
            guard let result = results, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var dailyStepData = [DStep]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailyStepData.append(DStep(date: statistics.startDate, count: Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
            }
            completion(.success(dailyStepData))
        }
        healthStore.execute(stepQuery)
    }

}

extension HealthKitManager {
    func getCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(steps))
        }
        
        healthStore.execute(query)
    }
    
}
