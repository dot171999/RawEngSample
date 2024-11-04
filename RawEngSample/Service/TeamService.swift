//
//  TeamService.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

protocol TeamServiceProtocol: AnyObject {
    func addSubscriber(with id: UUID, _ callback: @escaping () -> Void)
    func removeSubscriber(_ id: UUID)
    func refresh() async
    func myTeamName() -> String
    func isMyTeamPlayingAtHome(_ schedule: Schedule) -> Bool
    func getIconDataForTeam(_ tid: String) async -> Data?
}

class TeamService: TeamServiceProtocol {
    
    static let shared: TeamService = TeamService()
    private let _myTeamId: String = "1610612748"
    
    private let networkManager: NetworkManagerProtocol
    private let urlProvider: URLProviderProtocol
    
    private var teams: [Team] = [] {
        didSet {
            notifySubscribers()
        }
    }
    private var subscribers: [UUID: () -> Void] = [:]
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager(), urlProvider: URLProviderProtocol = DefaultURLProvider()) {
        self.networkManager = networkManager
        self.urlProvider = urlProvider
        
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
    
    func addSubscriber(with id: UUID, _ callback: @escaping () -> Void) {
        subscribers[id] = callback
    }
    
    func removeSubscriber(_ id: UUID) {
        subscribers.removeValue(forKey: id)
    }
    
    private func notifySubscribers() {
        for subscriber in subscribers.values {
            subscriber()
        }
    }
    
    private func getTeams() async -> [Team] {
        guard let url = urlProvider.endpoint(for: .teams) else { return [] }
        
        let result: Result<TeamsResponse, NetworkManagerError> = await networkManager.getModel(from: url)
        
        switch result {
        case .success(let teamResponse):
            return teamResponse.data.teams
        case .failure(_):
            return []
        }
    }
    
    func getIconDataForTeam(_ tid: String) async -> Data? {
        guard let urlString = iconUrlStringForTeamId(tid), let url = URL(string: urlString) else { return nil }
        
        let result = await networkManager.getData(from: url)
        
        switch result {
        case .success(let data):
            return data
        case .failure(_):
            return nil
        }
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
