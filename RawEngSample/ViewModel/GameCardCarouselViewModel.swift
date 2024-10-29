//
//  GameCardCarouselViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 27/10/24.
//

import Foundation
import Combine

extension GameCardCarouselView {
    @Observable
    class ViewModel {
        private(set) var teamService: TeamServiceProtocol
        private(set) var scheduleSerivce: ScheduleServiceProtocol
        
        private var schedules: [Schedule] {
            scheduleSerivce.schedules
        }

        private(set) var gameCardData: GameCardData?
        
        private(set) var futureGames: [Schedule] = []
        private(set) var upcomingGame: Schedule?
        private(set) var pastGames: [Schedule] = []
        
        enum GameCard: Hashable {
            case past(Schedule)
            case upcoming(Schedule)
            case future(Schedule)
            case promotion(Int)
        }
        
        private(set) var cardSequence: [GameCard] = []
        
        private var cancellable: Any?
        
        init(teamService: TeamServiceProtocol = TeamService.shared, scheduleService: ScheduleServiceProtocol = ScheduleService.shared) {
            self.teamService = teamService
            self.scheduleSerivce = scheduleService
            
            Task {
                await self.getGameCardData()
              
                await MainActor.run {
                    setupSubscriptions()
                }
            }
        }
        
        deinit {
            if let cancellable = cancellable {
                NotificationCenter.default.removeObserver(cancellable)
            }
        }
        
        private func setupSubscriptions() {
            cancellable = NotificationCenter.default
                .addObserver(forName: .schedulesDidUpdate, object: nil, queue: .main) { [weak self] _ in
                    self?.setup()
                }
        }
        
        func setup() {
            setupPastGames()
            setupUpcomingGameAndFutureGames()
            
            for game in pastGames {
                cardSequence.append(.past(game))
            }
            
            if let game = upcomingGame {
                cardSequence.append(.upcoming(game))
            }
            
            for game in futureGames {
                cardSequence.append(.future(game))
            }
    
            let sortedPromoCards =  gameCardData?.promotion_cards.sorted {$0.position > $1.position}
            
            for promotionCard in sortedPromoCards ?? [] {
                let index = promotionCard.position - 1
                
                if index <= cardSequence.count {
                    cardSequence.insert(.promotion(index), at: index)
                } else {
                    cardSequence.append(.promotion(index))
                }
            }
        }
        
        func setupUpcomingGameAndFutureGames() {
            let currentDate = Date()
            var allFutureGames = schedules.filter { schedule in
                guard let gameDate = schedule.gametime.toDateFromISO8601() else {
                    return false
                }
                
                return gameDate > currentDate
            }
            
            upcomingGame = allFutureGames.last
            
            guard let numberOfFutureGames = gameCardData?.game_card_config.future_game_count else {
                return
            }
            
            allFutureGames = allFutureGames.dropLast()
            
            futureGames = Array(allFutureGames.suffix(numberOfFutureGames))
        }
        
        func setupPastGames() {
            guard let numberOfPastGames = gameCardData?.game_card_config.past_game_count else {
                return
            }
            let currentDate = Date()
            let allPastGames = schedules.filter { schedule in
                guard let gameDate = schedule.gametime.toDateFromISO8601() else {
                    return false
                }
                
                return gameDate < currentDate
            }
            pastGames = Array(allPastGames.prefix(numberOfPastGames))
        }
        
        func getGameCardData() async {
            
            guard let url = Bundle.main.url(forResource: "Game Card Data", withExtension: "json") else {
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(GameCardResponse.self, from: data)
                gameCardData = response.data
                
            } catch {
                print(error)
            }
        }
    }
}
