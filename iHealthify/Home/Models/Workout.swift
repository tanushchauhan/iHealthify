//
//  Workout.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/11/25.
//

import SwiftUI

struct Workout: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let duration: String
    let date: Date
    let calories: String
    let color: Color
}
