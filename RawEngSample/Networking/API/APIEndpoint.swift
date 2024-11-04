//
//  APIEndpoint.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 03/11/24.
//

import Foundation

enum APIEndpoint {
    case teams
    case schedule
    case gameCardData
    
    var path: String {
        switch self {
        case .teams:
            return "Teams"
        case .schedule:
            return "Schedule"
        case .gameCardData:
            return "Game_Card_Data"
        }
    }
}
