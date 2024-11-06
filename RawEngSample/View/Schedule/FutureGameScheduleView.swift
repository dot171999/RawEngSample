//
//  FutureGameScheduleView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

struct FutureGameScheduleView: View {
    private var schedule: Schedule
    private var atHome: Bool
    
    init(for schedule: Schedule, _ atHome: Bool) {
        self.schedule = schedule
        self.atHome = atHome
    }
    
    var body: some View {
        ZStack {
            Color("GameView")
            
            VStack {
                HStack {
                    Text(atHome ? "HOME" : "AWAY")
                    Text("|  " + (schedule.readableGameDate) + "  |")
                    
                    Text(schedule.readableGameTime)
                }
                .font(.footnote)
                HStack {
                    HStack {
                        ResizableAsyncImageView(schedule.v.tid)
                        Text(schedule.v.ta)
                            .font(.title2)
                            .fontWeight(.black)
                            .italic()
                    }
                    VStack {
                        HStack {
                            Text(atHome ? "VS" : "@")
                        }
                    }
                    .padding(.horizontal)
                    HStack {
                        Text(schedule.h.ta)
                            .font(.title2)
                            .fontWeight(.black)
                            .italic()
                        ResizableAsyncImageView(schedule.h.tid)
                    }
                }
                
                if let url = schedule.buy_ticket_url, !url.isEmpty {
                    Button {
                        // Buy Ticket
                    } label: {
                        Text("BUY TICKETS ON")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("ticketmaster")
                            .font(.footnote)
                            .italic()
                            .fontWeight(.semibold)
                    }
                    .tint(.black)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 20))
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    var schedules: [Schedule] = []
    let url = Bundle.main.url(forResource: "Schedule", withExtension: "json")
    
    let data = try! Data(contentsOf: url!)
    let decoder = JSONDecoder()
    
    let response = try! decoder.decode(ScheduleResponse.self, from: data)
    
    schedules = response.data.schedules
    
    return FutureGameScheduleView(for: schedules.first { schedule in
        schedule.st! == 1
    }!, false)
    .fixedSize()
}
