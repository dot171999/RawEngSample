//
//  HomeScreenViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 29/10/24.
//

import Foundation

@Observable class HomeScreenViewModel {
    private let teamService: TeamServiceProtocol
    private(set) var teamName: String = ""
    private var cancellable: Any?
    
    @ObservationIgnored var isSetupDone: Bool = false
    
    init(teamService: TeamServiceProtocol = TeamService.shared) {
        self.teamService = teamService
    }
    
    deinit {
        if let cancellable = cancellable {
            NotificationCenter.default.removeObserver(cancellable)
        }
    }
    
    func setup() {
        teamName = teamService.myTeamName()
        setupSubscription()
    }
    
    private func setupSubscription() {
        if let cancellable = cancellable { NotificationCenter.default.removeObserver(cancellable) }
        cancellable = NotificationCenter.default.addObserver(forName: .teamsDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.setup()
        }
    }
}

