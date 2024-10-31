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
    private var cancellable: Any?
    
    var currentHeaderMonth: String = "Loading" {
        didSet {
            print("mon from: ", oldValue," to: ", currentHeaderMonth)
        }
    }
    private(set) var schedules: [Schedule] = []
    private(set) var gameMonths: [String] = []
    
    @ObservationIgnored var isSetupDone: Bool = false
    
    init(teamService: TeamServiceProtocol = TeamService.shared, scheduleService: ScheduleServiceProtocol = ScheduleService.shared) {
        self.teamService = teamService
        self.scheduleSerivce = scheduleService
    }
    
    deinit {
        if let cancellable = cancellable {
            NotificationCenter.default.removeObserver(cancellable)
        }
    }
    
    func setup() {
        setupSubscription()
        schedules = scheduleSerivce.schedules
        gameMonths = uniqueGameMonths(from: schedules)
    }
    
    func refresh() async {
        await scheduleSerivce.refresh()
        await teamService.refresh()
    }
    
    private func setupSubscription() {
        if let cancellable = cancellable { NotificationCenter.default.removeObserver(cancellable) }
        cancellable = NotificationCenter.default.addObserver(forName: .schedulesDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.setup()
        }
    }
    
    func previousMonthId() -> String? {
        
        guard let currentIndex = gameMonths.firstIndex(of: currentHeaderMonth) else {
            return nil
        }
        
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

