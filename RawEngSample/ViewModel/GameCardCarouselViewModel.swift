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
    private let urlProvider: URLProviderProtocol
    
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
    
    init(teamService: TeamServiceProtocol = TeamService.shared, scheduleService: ScheduleServiceProtocol = ScheduleService.shared, networkManager: NetworkManagerProtocol = NetworkManager(), urlProvider: URLProviderProtocol = DefaultURLProvider()) {
        self.teamService = teamService
        self.scheduleSerivce = scheduleService
        self.networkManager = networkManager
        self.urlProvider = urlProvider
    }
    
    deinit {
        scheduleSerivce.removeSubscriber(id)
    }
    
    @MainActor
    func setup() async {
        guard !isSetupDone else { return }
        
        setupSubscription()
        if let gameCardData = await getGameCardData() {
            setupProperties(data: gameCardData)
        }
        isSetupDone = true
    }
    
    private func setupSubscription() {
        scheduleSerivce.addSubscriber(with: id) { [weak self] in
            guard self?.gameCardData != nil else { return }
            self?.cleanSlate()
            self?.setupCards()
        }
    }
    
    private func setupProperties(data: GameCardData) {
        self.gameCardData = data
        self.setupCards()
        self.foucsCard = data.game_card_config.focus_card
    }
    
    private func getGameCardData() async ->  GameCardData? {
        guard let url = urlProvider.endpoint(for: .gameCardData) else { return nil }
        
        let result: Result<GameCardResponse, NetworkManagerError> = await networkManager.getModel(from: url)
        
        switch result {
        case .success(let gameCardResponse):
            return gameCardResponse.data
        case .failure(_):
            return nil
        }
    }
    
    private func setupCards() {
        setupPastGames()
        setupUpcomingGameAndFutureGames()
        
        var cardSequence: [GameCard] = []
        
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
        
        self.cardSequence = cardSequence
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
    }
}

