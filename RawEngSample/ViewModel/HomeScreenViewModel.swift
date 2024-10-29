//
//  HomeScreenViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 29/10/24.
//

import Foundation

extension HomeScreen {
    @Observable
    class ViewModel {
        let teamService: TeamServiceProtocol
        
        init(teamService: TeamServiceProtocol = TeamService.shared) {
            self.teamService = teamService
        }
    }
}
