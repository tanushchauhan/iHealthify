//
//  LeaderBoardViewModel.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import Foundation


class LeaderBoardViewModel: ObservableObject {
    
    @Published var leaderResult = LeaderBoardResult(user: nil, top10: [])
    
    @Published var showAlert = false

    
    init() {
        setTheBoard()
    }
    
    func setTheBoard() {
        Task {
            do {
                try await updateBoardForCurrentUser()
                let result = try await getLeaderBoard()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.leaderResult = result
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert = true
                }
            }
        }
    }
    
    struct LeaderBoardResult {
        let user: LeaderBoardUser?
        let top10: [LeaderBoardUser]
    }
    
    private func getLeaderBoard() async throws -> LeaderBoardResult {
        let leaders = try await DatabaseManager.shared.getLeaderBoards()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: { $0.username == username }) {
            let user = leaders.first(where: { $0.username == username })
            return LeaderBoardResult(user: user, top10: top10)
        } else {
            return LeaderBoardResult(user: nil, top10: top10)
        }
    }
    
    enum LeaderboardViewModelError: Error {
        case unableToFetchUsername
    }
    
    private func updateBoardForCurrentUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw LeaderboardViewModelError.unableToFetchUsername
        }
        
        let steps = try await getCurrentWeekStepCount()
        try await DatabaseManager.shared.updateTheLeaderBoard(leader: LeaderBoardUser(username: username, count: Int(steps)))
        
    }
    
    private func getCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthKitManager.shared.getCurrentWeekStepCount { result in
                continuation.resume(with: result)
            }
        })
    }
}
