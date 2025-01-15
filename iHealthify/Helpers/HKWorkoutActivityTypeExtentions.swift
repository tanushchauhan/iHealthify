//
//  HKWorkoutActivityTypeExtentions.swift
//  iHealthify
//
//  Created by Tanush Chauhan on 1/12/25.
//

import HealthKit
import SwiftUI

extension HKWorkoutActivityType {

    // Human-readable name
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"

        // iOS 10
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining: return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"

        // iOS 11
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"

        // iOS 13
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"

        // Catch-all
        default:                            return "Other"
        }
    }

    // Associated color for each workout type (SwiftUI Color)
    var color: Color {
        switch self {
        case .americanFootball:             return Color.red
        case .archery:                      return Color.green
        case .australianFootball:           return Color.yellow
        case .badminton:                    return Color.blue
        case .baseball:                     return Color.orange
        case .basketball:                   return Color.purple
        case .bowling:                      return Color.pink
        case .boxing:                       return Color.teal
        case .climbing:                     return Color.brown
        case .crossTraining:                return Color.indigo
        case .curling:                      return Color.mint
        case .cycling:                      return Color.cyan
        case .dance:                        return Color.yellow
        case .danceInspiredTraining:        return Color.pink
        case .elliptical:                   return Color.orange
        case .equestrianSports:             return Color.brown
        case .fencing:                      return Color.gray
        case .fishing:                      return Color.blue
        case .functionalStrengthTraining:   return Color.purple
        case .golf:                         return Color.green
        case .gymnastics:                   return Color.pink
        case .handball:                     return Color.red
        case .hiking:                       return Color.brown
        case .hockey:                       return Color.blue
        case .hunting:                      return Color.green
        case .lacrosse:                     return Color.purple
        case .martialArts:                  return Color.orange
        case .mindAndBody:                  return Color.mint
        case .mixedMetabolicCardioTraining: return Color.cyan
        case .paddleSports:                 return Color.indigo
        case .play:                         return Color.blue
        case .preparationAndRecovery:       return Color.gray
        case .racquetball:                  return Color.red
        case .rowing:                       return Color.blue
        case .rugby:                        return Color.green
        case .running:                      return Color.orange
        case .sailing:                      return Color.blue
        case .skatingSports:                return Color.teal
        case .snowSports:                   return Color.gray
        case .soccer:                       return Color.green
        case .softball:                     return Color.orange
        case .squash:                       return Color.purple
        case .stairClimbing:                return Color.orange
        case .surfingSports:                return Color.blue
        case .swimming:                     return Color.cyan
        case .tableTennis:                  return Color.blue
        case .tennis:                       return Color.green
        case .trackAndField:                return Color.red
        case .traditionalStrengthTraining:  return Color.purple
        case .volleyball:                   return Color.orange
        case .walking:                      return Color.green
        case .waterFitness:                 return Color.blue
        case .waterPolo:                    return Color.cyan
        case .waterSports:                  return Color.blue
        case .wrestling:                    return Color.red
        case .yoga:                         return Color.mint

        // iOS 10
        case .barre:                        return Color.pink
        case .coreTraining:                 return Color.orange
        case .crossCountrySkiing:           return Color.cyan
        case .downhillSkiing:               return Color.blue
        case .flexibility:                  return Color.green
        case .highIntensityIntervalTraining: return Color.red
        case .jumpRope:                     return Color.yellow
        case .kickboxing:                   return Color.red
        case .pilates:                      return Color.purple
        case .snowboarding:                 return Color.gray
        case .stairs:                       return Color.orange
        case .stepTraining:                 return Color.blue
        case .wheelchairWalkPace:           return Color.teal
        case .wheelchairRunPace:            return Color.teal

        // iOS 11
        case .taiChi:                       return Color.mint
        case .mixedCardio:                  return Color.cyan
        case .handCycling:                  return Color.orange

        // iOS 13
        case .discSports:                   return Color.yellow
        case .fitnessGaming:                return Color.purple

        // Catch-all
        default:                            return Color.gray
        }
    }

    // SF Symbol name as a string for each workout type
    var sfsymbol: String {
            switch self {
            case .americanFootball:             return "sportscourt"
            case .archery:                      return "scope"
            case .australianFootball:           return "sportscourt"
            case .badminton:                    return "sportscourt"
            case .baseball:                     return "sportscourt"
            case .basketball:                   return "sportscourt"
            case .bowling:                      return "sportscourt"
            case .boxing:                       return "figure.boxing"
            case .climbing:                     return "figure.climbing"
            case .crossTraining:                return "figure.strengthtraining.traditional"
            case .curling:                      return "sportscourt"
            case .cycling:                      return "bicycle"
            case .dance:                        return "figure.dance"
            case .danceInspiredTraining:        return "figure.dance"
            case .elliptical:                   return "figure.stairs"
            case .equestrianSports:             return "figure.horseback.riding"
            case .fencing:                      return "figure.fencing"
            case .fishing:                      return "figure.fishing"
            case .functionalStrengthTraining:   return "dumbbell.fill"
            case .golf:                         return "figure.golf"
            case .gymnastics:                   return "sportscourt"
            case .handball:                     return "sportscourt"
            case .hiking:                       return "figure.hiking"
            case .hockey:                       return "sportscourt"
            case .hunting:                      return "scope"
            case .lacrosse:                     return "sportscourt"
            case .martialArts:                  return "figure.martial.arts"
            case .mindAndBody:                  return "figure.mind.and.body"
            case .mixedMetabolicCardioTraining: return "figure.strengthtraining.traditional"
            case .paddleSports:                 return "sportscourt"
            case .play:                         return "figure.play"
            case .preparationAndRecovery:       return "figure.cooldown"
            case .racquetball:                  return "sportscourt"
            case .rowing:                       return "figure.rowing"
            case .rugby:                        return "sportscourt"
            case .running:                      return "figure.run"
            case .sailing:                      return "sailboat"
            case .skatingSports:                return "figure.skating"
            case .snowSports:                   return "snowflake"
            case .soccer:                       return "sportscourt"
            case .softball:                     return "sportscourt"
            case .squash:                       return "sportscourt"
            case .stairClimbing:                return "figure.stairs"
            case .surfingSports:                return "figure.surfing"
            case .swimming:                     return "figure.pool.swim"
            case .tableTennis:                  return "sportscourt"
            case .tennis:                       return "figure.tennis"
            case .trackAndField:                return "sportscourt"
            case .traditionalStrengthTraining:  return "figure.strengthtraining.traditional"
            case .volleyball:                   return "sportscourt"
            case .walking:                      return "figure.walk"
            case .waterFitness:                 return "sportscourt"
            case .waterPolo:                    return "sportscourt"
            case .waterSports:                  return "sportscourt"
            case .wrestling:                    return "figure.wrestling"
            case .yoga:                         return "figure.yoga"
            default:                            return "figure.mind.and.body"
            }
        }
}
