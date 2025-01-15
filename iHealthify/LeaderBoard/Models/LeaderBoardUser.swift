//
//  LeaderBoardUser.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/15/25.
//

import Foundation

struct LeaderBoardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}
