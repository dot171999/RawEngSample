//
//  ResizableAsyncImageViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 30/10/24.
//

import Foundation

@Observable class ResizableAsyncImageViewModel {
    private var teamService: TeamServiceProtocol
    private(set) var imageData: Data?
    
    init(teamService: TeamServiceProtocol = TeamService.shared) {
        self.teamService = teamService
    }
    
    func loadImageDataFor(_ tid: String) async {
        let data = await teamService.getIconDataForTeam(tid)
        await MainActor.run { [weak self] in
            self?.imageData = data
        }
    }
}

