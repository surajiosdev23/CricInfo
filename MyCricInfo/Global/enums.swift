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
    case decodingError
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .decodingError: return "JSON Decoding Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}
