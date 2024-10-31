//
//  TeamService.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

protocol TeamServiceProtocol: AnyObject {
    func myTeamName() -> String
    func isMyTeamPlayingAtHome(_ schedule: Schedule) -> Bool
    func getIconDataForTeam(_ tid: String) async throws -> Data?
    func refresh() async
}

class TeamService: TeamServiceProtocol {
    
    static let shared: TeamService = TeamService()
    private let _myTeamId: String = "1610612748"
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private var teams: [Team] = [] {
        didSet {
            NotificationCenter.default.post(name: .schedulesDidUpdate, object: nil)
        }
    }
    
    private init() {
        Task { [weak self] in
            await self?.setup()
        }
    }

    private func setup() async {
        let teams = await getTeams()
        await MainActor.run { [weak self] in
            self?.teams = teams
        }
    }
    
    func refresh() async {
        await setup()
    }
    
    private func getTeams() async -> [Team] {
        guard let url = Bundle.main.url(forResource: "teams", withExtension: "json") else { return [] }
        
        do {
            let teamResponse: TeamsResponse = try await networkManager.getModel(from: url)
            return teamResponse.data.teams
            
        } catch {
            print(error)
        }
        
        return []
    }
    
    func getIconDataForTeam(_ tid: String) async throws -> Data? {
        guard let urlString = iconUrlStringForTeamId(tid), let url = URL(string: urlString) else { return nil }
        
        return try await networkManager.getData(from: url)
    }
    
    func isMyTeamPlayingAtHome(_ schedule: Schedule) -> Bool {
        return (schedule.v.tid == myTeamId()) ? false : true
    }
    
    func myTeamId() -> String {
        return _myTeamId
    }
    
    func myTeamName() -> String {
        teams.first { team in
            team.tid == myTeamId()
        }?.ta ?? "TEAM"
    }
    
    private func iconUrlStringForTeamId(_ id: String) -> String? {
        return teams.first { team in
            team.tid == id
        }?.logo
    }
}
