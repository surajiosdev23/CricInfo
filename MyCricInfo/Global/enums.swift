//
//  enums.swift
//  MyCricInfo
//
//  Created by suraj jadhav on 14/10/23.
//

import Foundation
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}
enum BowlingStyle: String {
    case ob = "Off Break"
    case lb = "Leg Break"
    case lbg = "Leg Break Googly"
    case slc = "Slow Left Arm Chinaman"
    case slo = "Slow Left Arm Orthodox"
    case rf = "Right Arm Fast"
    case rfm = "Right Arm Fast Medium"
    case rmf = "Right Arm Fast Medium "
    case rm = "Right Arm Medium"
    case lf = "Left Arm Fast"
    case lfm = "Left Arm Fast Medium"
    case lmf = "Left Arm Fast Medium "
    case lm = "Left Arm Medium"
    
    var displayName: String {
        switch self {
        case .ob:
            return "Off Break"
        case .lb:
            return "Leg Break"
        case .lbg:
            return "Leg Break Googly"
        case .slc:
            return "Slow Left Arm Chinaman"
        case .slo:
            return "Slow Left Arm Orthodox"
        case .rf:
            return "Right Arm Fast"
        case .rfm:
            return "Right Arm Fast Medium"
        case .rmf:
            return "Right Arm Fast Medium"
        case .rm:
            return "Right Arm Medium"
        case .lf:
            return "Left Arm Fast"
        case .lfm:
            return "Left Arm Fast Medium"
        case .lm:
            return "Left Arm Medium"
        case .lmf:
            return "Left Arm Fast Medium"
        }
    }
    
    static func bowlingStyle(for displayName: String) -> BowlingStyle? {
        return BowlingStyle(rawValue: displayName)
    }
}
