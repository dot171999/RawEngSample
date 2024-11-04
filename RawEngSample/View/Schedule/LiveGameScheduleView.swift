//
//  LiveGameScheduleView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

struct LiveGameScheduleView: View {
    @Environment(\.colorScheme) private var colorScheme
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
                    Text(schedule.stt ?? "")
                    Text(" | ")
                    Text(schedule.cl ?? "")
                }
                .font(.footnote)
                HStack {
                    VStack {
                        ResizableAsyncImageView(schedule.v.tid, size: 60)
                        Text(schedule.v.ta)
                            .fontWeight(.black)
                            .italic()
                    }
                    VStack {
                        Text("LIVE")
                            .font(.footnote)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(colorScheme == .light ? .white.opacity(0.8) : .black.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 10))
                        
                        HStack {
                            Text((atHome ? schedule.v.s : schedule.h.s) ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(atHome ? "VS" : "@")
                                
                                .padding(.horizontal, 5)
                            Text((atHome ? schedule.h.s : schedule.v.s) ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        ResizableAsyncImageView(schedule.h.tid , size: 60)
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
    
    schedules = response.data.schedules
    
    return LiveGameScheduleView(for: schedules.first { schedule in
        schedule.st! == 2
    }!, true)
    .fixedSize()
}
