//
//  PastGameView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

struct PastGameView: View {
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
                    Text("|  " + schedule.readableGameDate + "  |")
                    Text(schedule.stt?.uppercased() ?? "")
                }
                .font(.footnote)
                HStack {
                    VStack {
                        ResizableAsyncImageView(schedule.v.tid)
                        Text(schedule.v.ta)
                            .fontWeight(.black)
                            .italic()
                    }
        
                    VStack {
                        HStack {
                            Text(schedule.v.s ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(atHome ? "VS" : "@")
                            Text(schedule.h.s ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)
        
                    VStack {
                        ResizableAsyncImageView(schedule.h.tid)
                        Text(schedule.h.ta)
                            .fontWeight(.black)
                            .italic()
                    }
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
    
    schedules = response.data!.schedules!
    
    return PastGameView(for: schedules.first { schedule in
        schedule.st! == 3
    }!, true)
    .fixedSize()
}
