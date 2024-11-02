//
//  HomeScreenViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 29/10/24.
//

import Foundation

@Observable class HomeScreenViewModel {
    private let teamService: TeamServiceProtocol
    
    private let id: UUID = UUID()
    private var isSetupDone: Bool = false
    private(set) var teamName: String = ""
    
    init(teamService: TeamServiceProtocol = TeamService.shared) {
        self.teamService = teamService
    }
    
    deinit {
        teamService.removeSubscriber(id)
    }
    
    func setup() {
        guard !isSetupDone else { return }
        
        setupSubscription()
        setupProperties()
        
        isSetupDone = true
    }
    
    private func setupSubscription() {
        teamService.addSubscriber(with: id) { [weak self] in
            self?.setupProperties()
        }
    }
    
    private func setupProperties() {
        teamName = teamService.myTeamName()
    }
}

