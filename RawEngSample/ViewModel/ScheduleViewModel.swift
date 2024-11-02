//
//  ScheduleViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

@Observable class ScheduleViewModel {
    private var teamService: TeamServiceProtocol
    private var scheduleSerivce: ScheduleServiceProtocol
    
    private let id: UUID = UUID()
    private var isSetupDone: Bool = false
    
    var currentHeaderMonth: String = "Loading" {
        didSet {
            print("mon from: ", oldValue," to: ", currentHeaderMonth)
        }
    }
    private(set) var schedules: [Schedule] = []
    private(set) var gameMonths: [String] = []
    private(set) var upcomingGameId: String = ""
    
    init(teamService: TeamServiceProtocol = TeamService.shared, scheduleService: ScheduleServiceProtocol = ScheduleService.shared) {
        self.teamService = teamService
        self.scheduleSerivce = scheduleService
    }
    
    deinit {
        scheduleSerivce.removeSubscriber(id)
    }
    
    func setup() {
        guard !isSetupDone else { return }
        
        setupSubscription()
        setupProperties()
        isSetupDone = true
    }
    
    private func setupSubscription() {
        scheduleSerivce.addSubscriber(with: id) { [weak self] in
            self?.setupProperties()
        }
    }
    
    private func setupProperties() {
        schedules = scheduleSerivce.schedules
        gameMonths = uniqueGameMonths(from: schedules)
        upcomingGameId = nextUpcomingGameId()
    }
    
    private func nextUpcomingGameId() -> String {
        let currentDate = Date()
        let allFutureGames = schedules.filter { schedule in
            guard let gameDate = schedule.gametime.toDateFromISO8601() else { return false }
            return gameDate > currentDate
        }
        
        return allFutureGames.last?.uid ?? ""
    }
    
    func refresh() async {
        await scheduleSerivce.refresh()
        await teamService.refresh()
    }
    
    func previousMonthId() -> String? {
        guard let currentIndex = gameMonths.firstIndex(of: currentHeaderMonth) else { return nil }
        
        let nextIndex = currentIndex + 1
        guard nextIndex < gameMonths.count else {
            return nil
        }
        print("prev | curr:", currentHeaderMonth, " new: ", gameMonths[nextIndex])
        currentHeaderMonth = gameMonths[nextIndex]
        
        return schedules.first { schedule in
            schedule.readableGameMonthAndYear == gameMonths[nextIndex]
        }?.uid
    }
    
    func nextMonthId() -> String? {
        guard let currentIndex = gameMonths.firstIndex(of: currentHeaderMonth) else { return nil }
        
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return schedules.first?.uid }
        print("next | curr:", currentHeaderMonth, " new: ", gameMonths[previousIndex])
        currentHeaderMonth = gameMonths[previousIndex]
        
        return schedules.first { schedule in
            schedule.readableGameMonthAndYear == gameMonths[previousIndex]
        }?.uid
    }
    
    func myTeamPlayingAtHome(_ schedule: Schedule) -> Bool {
        return teamService.isMyTeamPlayingAtHome(schedule)
    }
    
    private func uniqueGameMonths(from schedules: [Schedule]) -> [String] {
        schedules.map({ schedule in
            schedule.readableGameMonthAndYear
        }).unique()
    }
}

