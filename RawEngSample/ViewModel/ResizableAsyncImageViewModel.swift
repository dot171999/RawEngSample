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
    
    @MainActor
    func imageDataFor(_ tid: String) async {
        do {
            let data = try await teamService.getIconDataForTeam(tid)
            imageData = data
        } catch {
            print("error: ", error)
        }
    }
}

