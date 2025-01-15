//
//  DatabaseManager.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() { }
    
    //change to private later
     let database = Firestore.firestore()
    private let weeklyLeaderboard = "\(Date().dateFormatMonday())-leaderboard"
    
    // Get the Leader Board
    func getLeaderBoards() async throws -> [LeaderBoardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderBoardUser.self) })
    }
    
    // Update the leader board for the user
    func updateTheLeaderBoard(leader: LeaderBoardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
}

