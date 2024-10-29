//
//  ScheduleService.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 29/10/24.
//

import Foundation
import Combine

protocol ScheduleServiceProtocol: AnyObject {
    var schedules: [Schedule] { get }
    var gameMonths: [String] { get }
}

@Observable
class ScheduleService:  ScheduleServiceProtocol {
    
    static let shared: ScheduleService = ScheduleService()
    private(set) var schedules: [Schedule] = [] {
        didSet {
            NotificationCenter.default.post(name: .schedulesDidUpdate, object: nil)
        }
    }
    
    private(set) var gameMonths: [String] = []
    
    init() {
        setup()
    }
     
    private func setup() {
        Task {
            await loadScheduleData()
        }
    }
    
    private func loadScheduleData() async {
        try? await Task.sleep(for: .seconds(1))
        
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
            
            gameMonths = schedules.map({ schedule in
                schedule.readableGameMonYear
            }).unique()
            
        } catch {
            print(error)
        }
    }
}
