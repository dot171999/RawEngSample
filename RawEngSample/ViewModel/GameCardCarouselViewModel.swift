//
//  GameCardCarouselViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 27/10/24.
//

import Foundation

@Observable class GameCardCarouselViewModel {
    private let teamService: TeamServiceProtocol
    private let scheduleSerivce: ScheduleServiceProtocol
    private let networkManager: NetworkManagerProtocol
    
    private let id: UUID = UUID()
    private var isSetupDone: Bool = false
    
    private var schedules: [Schedule] {
        scheduleSerivce.schedules
    }
    private(set) var gameCardData: GameCardData?
    private(set) var foucsCard: Int = 1
    
    private var futureGames: [Schedule] = []
    private var upcomingGame: Schedule?
    private var pastGames: [Schedule] = []
    private(set) var cardSequence: [GameCard] = []
    
    enum GameCard: Hashable {
        case past(Schedule)
        case upcoming(Schedule)
        case future(Schedule)
        case promotion(Int)
    }
    
    init(teamService: TeamServiceProtocol = TeamService.shared, scheduleService: ScheduleServiceProtocol = ScheduleService.shared, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.teamService = teamService
        self.scheduleSerivce = scheduleService
        self.networkManager = networkManager
    }
    
    deinit {
        scheduleSerivce.removeSubscriber(id)
    }
    
    @MainActor
    func setup() async {
        guard !isSetupDone else { return }
        
        setupSubscription()
        await setupProperties()
        
        isSetupDone = true
    }
    
    private func setupSubscription() {
        scheduleSerivce.addSubscriber(with: id) { [weak self] in
            guard self?.gameCardData != nil else { return }
            self?.cleanSlate()
            self?.setupCards()
        }
    }
    
    private func setupProperties() async {
        let gameCardData = await getGameCardData()
        
        if let data = gameCardData {
            self.gameCardData = data
            self.setupCards()
            self.foucsCard = data.game_card_config.focus_card
        }
    }
    
    private func getGameCardData() async ->  GameCardData? {
        guard let url = Bundle.main.url(forResource: "Game Card Data", withExtension: "json") else { return nil }
        
        do {
            let gameCardResponse: GameCardResponse = try await networkManager.getModel(from: url)
            return gameCardResponse.data
        } catch {
            print(error)
        }
        return nil
    }
    
    private func setupCards() {
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
        
        let sortedPromoCards =  gameCardData?.promotion_cards.sorted { $0.position < $1.position }
        
        for promotionCard in sortedPromoCards ?? [] {
            let index = promotionCard.position - 1
            
            if index <= cardSequence.count {
                cardSequence.insert(.promotion(index), at: index)
            } else {
                cardSequence.append(.promotion(index))
            }
        }
    }
    
    private func setupUpcomingGameAndFutureGames() {
        let currentDate = Date()
        var allFutureGames = schedules.filter { schedule in
            guard let gameDate = schedule.gametime.toDateFromISO8601() else { return false }
            return gameDate > currentDate
        }
        
        upcomingGame = allFutureGames.last
        
        guard let numberOfFutureGames = gameCardData?.game_card_config.future_game_count else { return }
        
        allFutureGames = allFutureGames.dropLast()
        
        futureGames = Array(allFutureGames.suffix(numberOfFutureGames))
    }
    
    private func setupPastGames() {
        guard let numberOfPastGames = gameCardData?.game_card_config.past_game_count else { return }
        let currentDate = Date()
        let allPastGames = schedules.filter { schedule in
            guard let gameDate = schedule.gametime.toDateFromISO8601() else { return false }
            return gameDate < currentDate
        }
        pastGames = Array(allPastGames.prefix(numberOfPastGames))
    }
    
    func myTeamPlayingAtHome(_ schedule: Schedule) -> Bool {
        return teamService.isMyTeamPlayingAtHome(schedule)
    }
    
    private func cleanSlate() {
        futureGames = []
        upcomingGame = nil
        pastGames = []
        cardSequence = []
    }
}

