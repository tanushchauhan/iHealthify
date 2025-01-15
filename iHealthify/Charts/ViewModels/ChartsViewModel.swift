//
//  ChartsViewModel.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import Foundation

import Foundation

class ChartsViewModel: ObservableObject {
    
    @Published var oneWeekChartData = [DStep]()
    @Published var oneWeekAverage = 0
    @Published var oneWeekTotal = 0
    
    @Published var oneMonthChartData = [DStep]()
    @Published var oneMonthAverage = 0
    @Published var oneMonthTotal = 0
    
    @Published var threeMonthsChartData = [DStep]()
    @Published var threeMonthAverage = 0
    @Published var threeMonthTotal = 0
    
    @Published var ytdChartData = [MStep]()
    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    @Published var oneYearChartData = [MStep]()
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0
    
    @Published var showAlert = false
    
    let healthKitManger = HealthKitManager.shared
    
    
    init() {
            Task {
                do {
                    async let oneWeek: () = try await fetchOneWeekStepData()
                    async let oneMonth: () = try await fetchOneMonthStepData()
                    async let threeMonths: () = try await fetchThreeMonthsStepData()
                    async let ytdAndOneYear: () = try await fetchYTDAndOneYearChartData()
                    
                    _ = (try await oneWeek, try await oneMonth, try await threeMonths, try await ytdAndOneYear)
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                    }
                }
            }
        }
    
    func calculateAverageAndTotalFromData(steps: [DStep]) -> (Int, Int) {
          let total = steps.reduce(0, { $0 + $1.count })
          let average = total / steps.count
          
          return (total, average)
      }
      
      func fetchOneWeekStepData() async throws {
          try await withCheckedThrowingContinuation({ continuation in
              healthKitManger.fetchDailySteps(startDate: .oneWeekAgo) { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .success(let steps):
                      DispatchQueue.main.async {
                          self.oneWeekChartData = steps
                          
                          (self.oneWeekTotal, self.oneWeekAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                          continuation.resume()
                      }
                  case .failure(let failure):
                      continuation.resume(throwing: failure)
                  }
              }
          }) as Void
      }
      
      func fetchOneMonthStepData() async throws {
          try await withCheckedThrowingContinuation({ continuation in
              healthKitManger.fetchDailySteps(startDate: .oneMonthAgo) {  [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .success(let steps):
                      DispatchQueue.main.async {
                          self.oneMonthChartData = steps
                          
                          (self.oneMonthTotal, self.oneMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                          continuation.resume()
                      }
                  case .failure(let failure):
                      continuation.resume(throwing: failure)
                  }
              }
          }) as Void
      }
      
      func fetchThreeMonthsStepData() async throws {
          try await withCheckedThrowingContinuation({ continuation in
              healthKitManger.fetchDailySteps(startDate: .threeMonthsAgo) { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .success(let steps):
                      DispatchQueue.main.async {
                          self.threeMonthsChartData = steps
                          
                          (self.threeMonthTotal, self.threeMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                          continuation.resume()
                      }
                  case .failure(let failure):
                      continuation.resume(throwing: failure)
                  }
              }
          }) as Void
      }
    
    func fetchYTDAndOneYearChartData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthKitManger.fetchYTDAndOneYearChartData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.ytdChartData = result.yearToDateSteps
                        self.oneYearChartData = result.pastYearSteps
                        
                        self.ytdTotal = self.ytdChartData.reduce(0, { $0 + $1.count })
                        self.oneYearTotal = self.oneYearChartData.reduce(0, { $0 + $1.count })
                        
                        self.ytdAverage = self.ytdTotal / Calendar.current.component(.month, from: Date())
                        self.oneYearAverage = self.oneYearTotal / 12
                        
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
}
