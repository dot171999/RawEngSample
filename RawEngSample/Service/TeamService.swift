//
//  TeamService.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

class TeamService {
    
    static let shared = TeamService()
    private var teams: [Team] = []
    
    private init() {
        self.getTeamData()
    }
    
    func getTeamData() {
        
        guard let url = Bundle.main.url(forResource: "teams", withExtension: "json") else {
            return
        }
        
        do {
            
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(TeamsResponse.self, from: data)
            
            self.teams = response.data.teams
            
        } catch {
            print(error)
        }
    }
    
    func urlForTeamId(_ id: String) -> String? {
        return teams.first { team in
            team.tid == id
        }?.logo
    }
}
