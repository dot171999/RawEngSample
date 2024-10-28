//
//  GameCardCarouselViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 27/10/24.
//

import Foundation

extension GameCardCarouselView {
    @Observable
    class ViewModel {
        var schedules: [Schedule] = []
        var gameCardData: GameCardData?
        
        var futureGames: [Schedule] = []
        var upcomingGame: Schedule?
        var pastGames: [Schedule] = []
        
        enum GameCard: Hashable {
            case past(Schedule)
            case upcoming(Schedule)
            case future(Schedule)
            case promotion(Int)
        }
        
        var cardSequence: [GameCard] = []
        
        init() {
            Task {
                await self.getGameCardData()
                await self.getScheduleData()
                await MainActor.run {
                    setup()
                }
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
        
        func getScheduleData() async {
            guard let url = Bundle.main.url(forResource: "Schedule", withExtension: "json") else {
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(ScheduleResponse.self, from: data)
                
                self.schedules = response.data?.schedules?.sorted {
                    guard let date1 = $0.gametime.toDateFromISO8601(),
                          let date2 = $1.gametime.toDateFromISO8601() else {
                        return false
                    }
                    return date1 > date2
                } ?? []
                
            } catch {
                print(error)
            }
        }
    }
}
