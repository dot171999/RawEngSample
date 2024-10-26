//
//  ContentView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import SwiftUI

let homeTeamTid = "1610612748"

struct ContentView: View {
    @State private var viewModel = ViewModel()
    

    enum GameStatus: Int {
        case future = 1
        case live = 2
        case past = 3
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach (viewModel.schedules, id: \.self) { schedule in
                    if let game: GameStatus = GameStatus(rawValue: schedule.st ?? 1) {
                        let playingAtHome = viewModel.checkingIfPlayingAtHome(schedule)
                        switch game {
                        case .future:
                            FutureGameView(for: schedule, playingAtHome)
                        case .live:
                            LiveGameView(for: schedule, playingAtHome)
                        case .past:
                            PastGameView(for: schedule, playingAtHome)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                viewModel.getScheduleData()
                viewModel.getTeamData()
            }
        }
    }
    
    @ViewBuilder
    func PastGameView(for schedule: Schedule,_ atHome: Bool) -> some View {
        
        ZStack {
            Color(red: 44/255, green: 49/255, blue: 54/255)
            VStack {
                HStack {
                    Text(atHome ? "HOME" : "AWAY")
                    Text("|  " + (schedule.gametime?.toFormattedDate() ?? "") + "  |")
                    Text(schedule.stt?.uppercased() ?? "")
                }
                .font(.footnote)
                HStack {
                    VStack {
                        teamImage(schedule.v.tid)
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
                        teamImage(schedule.h.tid)
                        Text(schedule.h.ta)
                            .fontWeight(.black)
                            .italic()
                    }
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 15))
    }
    
    @ViewBuilder
    func LiveGameView(for schedule: Schedule,_ atHome: Bool) -> some View {
        ZStack {
            Color(red: 44/255, green: 49/255, blue: 54/255)
            
            VStack {
                HStack {
                    Text("3RD QTR")
                    Text(" | ")
                    Text("00:16.3")
                }
                .font(.footnote)
                HStack {
                    VStack {
                        teamImage(atHome ? schedule.v.tid : homeTeamTid, size: 60)
                        Text("MIA")
                            .fontWeight(.black)
                            .italic()
                    }
                    VStack {
                        Text("LIVE")
                            .font(.footnote)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.black.opacity(0.5))
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
                        teamImage(atHome ? homeTeamTid : schedule.h.tid , size: 60)
                        Text("MIA")
                            .fontWeight(.black)
                            .italic()
                    }
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 15))
    }
    
    @ViewBuilder
    func FutureGameView(for schedule: Schedule,_ atHome: Bool) -> some View {
        ZStack {
            Color(red: 44/255, green: 49/255, blue: 54/255)
            
            VStack {
                HStack {
                    Text(atHome ? "HOME" : "AWAY")
                    Text("|  " + (schedule.gametime?.toFormattedDate() ?? "") + "  |")
                    
                    Text(schedule.gametime?.toFormattedDate1() ?? "")
                }
                .font(.footnote)
                HStack {
                    HStack {
                        teamImage(atHome ? schedule.v.tid : homeTeamTid)
                        Text("MIA")
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
                        Text("MIA")
                            .font(.title2)
                            .fontWeight(.black)
                            .italic()
                        teamImage(atHome ? homeTeamTid : schedule.h.tid)
                    }
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 15))
    }
    
    @ViewBuilder
    func teamImage(_ tid: String, size: CGFloat = 50) -> some View {
        
        let urlString = viewModel.urlForTeamId(tid) ?? ""
         AsyncImage(url: URL(string: urlString)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Color.gray
        }
        .frame(width: size, height: size)
    }
}

extension String {
    
    func toFormattedDate() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
       
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEE MMM dd"
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date).uppercased()
    }
    
    func toFormattedDate1() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a" // Format for "7:30 PM"
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date).uppercased()
    }
}

#Preview {
    ContentView()
}
