//
//  TeamService.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

protocol TeamServiceProtocol: AnyObject {
    func myTeamId() -> String
    func iconUrlForTeamId(_ id: String) -> String?
    func myTeamName() -> String
    func isMyTeamPlayingAtHome(_ schedule: Schedule) -> Bool
}

@Observable
class TeamService: TeamServiceProtocol {
    
    private let _myTeamId: String = "1610612748"
    static let shared: TeamService = TeamService()
    private var teams: [Team] = []
    
    private init() {
        teams = loadTeamData()
    }
    
    private func loadTeamData() -> [Team] {
        
        guard let url = Bundle.main.url(forResource: "teams", withExtension: "json") else {
            return []
        }
        
        do {
            
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(TeamsResponse.self, from: data)
            
            return response.data.teams
            
        } catch {
            print(error)
        }
        
        return []
    }
    
    func isMyTeamPlayingAtHome(_ schedule: Schedule) -> Bool {
        return (schedule.v.tid == myTeamId()) ? false : true
    }
    
    func myTeamId() -> String {
        return _myTeamId
    }
    
    func iconUrlForTeamId(_ id: String) -> String? {
        return teams.first { team in
            team.tid == id
        }?.logo
    }
    
    func myTeamName() -> String {
        teams.first { team in
            team.tid == myTeamId()
        }?.ta ?? "TEAM"
    }
}
