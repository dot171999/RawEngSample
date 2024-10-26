//
//  Team.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import Foundation

struct TeamsResponse: Codable, Hashable {
    let data: TeamsData
}

struct TeamsData: Codable, Hashable {
    let teams: [Team]
}

struct Team: Codable, Hashable {
    let uid: String
    let year: Int
    let leagueID: String
    let seasonID: String
    let istGroup: String
    let tid: String
    let tn: String
    let ta: String
    let tc: String
    let di: String
    let co: String
    let sta: String
    let logo: String?
    let color: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case year
        case leagueID = "league_id"
        case seasonID = "season_id"
        case istGroup = "ist_group"
        case tid
        case tn
        case ta
        case tc
        case di
        case co
        case sta
        case logo
        case color
    }
}
