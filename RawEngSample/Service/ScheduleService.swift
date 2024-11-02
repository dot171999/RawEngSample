//
//  ScheduleService.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 29/10/24.
//

import Foundation

protocol ScheduleServiceProtocol: AnyObject {
    var schedules: [Schedule] { get }
    func addSubscriber(with id: UUID, _ callback: @escaping () -> Void)
    func removeSubscriber(_ id: UUID)
    func refresh() async
}

class ScheduleService:  ScheduleServiceProtocol {
    
    static let shared: ScheduleService = ScheduleService()
    private var networkManager: NetworkManagerProtocol = NetworkManager()
    
    private(set) var schedules: [Schedule] = [] {
        didSet {
            notifySubscribers()
        }
    }
    
    private var subscribers: [UUID: () -> Void] = [:]
    
    init() {
        Task { [weak self] in
            await self?.setup()
        }
    }
     
    private func setup() async {
        let schedules = await getSchedules()
        let sortedSchedules = sortSchedules(schedules)
        
        await MainActor.run { [weak self] in
            self?.schedules = sortedSchedules
        }
    }
    
    func refresh() async {
       await setup()
    }
    
    func addSubscriber(with id: UUID, _ callback: @escaping () -> Void) {
        subscribers[id] = callback
    }
    
    func removeSubscriber(_ id: UUID) {
        subscribers.removeValue(forKey: id)
    }
    
    private func notifySubscribers() {
        for subscriber in subscribers.values {
            subscriber()
        }
    }
    
    private func getSchedules() async -> [Schedule] {
        guard let url = Bundle.main.url(forResource: "Schedule", withExtension: "json") else {
            return []
        }
        
        do {
            let response: ScheduleResponse = try await networkManager.getModel(from: url)
            return response.data?.schedules ?? []
        } catch {
            print(error)
        }
        
        return []
    }
    
    private func sortSchedules(_ schedules: [Schedule]) -> [Schedule] {
        schedules.sorted {
            guard let date1 = $0.gametime.toDateFromISO8601(),
                  let date2 = $1.gametime.toDateFromISO8601() else {
                return false
            }
            return date1 > date2
        }
    }
}