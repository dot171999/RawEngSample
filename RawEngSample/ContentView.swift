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
            .task {
                viewModel.getScheduleData()
                viewModel.getTeamData()
            }
        }
    }
    
    
    
    @ViewBuilder
    func PastGameView(for schedule: Schedule,_ atHome: Bool) -> some View {
        
        ZStack {
            Color.teal.opacity(0.2)
            
            VStack {
                HStack {
                    Text(atHome ? "HOME" : "AWAY")
                    Text("| " + (schedule.gametime?.toFormattedDate() ?? "") + " |")
                    Text(schedule.stt?.capitalized ?? "")
                }
                HStack {
                    VStack {
                        teamImage(atHome ? schedule.v.tid : homeTeamTid)
                        Text("MIA")
                    }
                    VStack {
                        HStack {
                            Text((atHome ? schedule.v.s : schedule.h.s) ?? "")
                            Text(atHome ? "VS" : "@")
                            Text((atHome ? schedule.h.s : schedule.v.s) ?? "")
                        }
                    }
                    VStack {
                        teamImage(atHome ? homeTeamTid : schedule.h.tid)
                        Text("MIA")
                    }
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    func LiveGameView(for schedule: Schedule,_ atHome: Bool) -> some View {
        ZStack {
            Color.teal.opacity(0.2)
            
            VStack {
                HStack {
                    Text(atHome ? "HOME" : "AWAY")
                    Text("| " + (schedule.gametime?.toFormattedDate() ?? "") + " |")
                    Text("Final")
                }
                HStack {
                    VStack {
                        teamImage(atHome ? schedule.v.tid : homeTeamTid)
                        Text("MIA")
                    }
                    VStack {
                        Text("Live")
                        HStack {
                            Text((atHome ? schedule.v.s : schedule.h.s) ?? "")
                            Text(atHome ? "VS" : "@")
                            Text((atHome ? schedule.h.s : schedule.v.s) ?? "")
                        }
                    }
                    VStack {
                        teamImage(atHome ? homeTeamTid : schedule.h.tid)
                        Text("MIA")
                    }
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    func FutureGameView(for schedule: Schedule,_ atHome: Bool) -> some View {
        ZStack {
            Color.teal.opacity(0.2)
            
            VStack {
                HStack {
                    Text(atHome ? "HOME" : "AWAY")
                    Text("| " + (schedule.gametime?.toFormattedDate() ?? "") + " |")
                    Text(schedule.stt?.capitalized ?? "")
                        .font(.footnote)
                }
                HStack {
                    HStack {
                        teamImage(atHome ? schedule.v.tid : homeTeamTid)
                        Text("MIA")
                    }
                    VStack {
                        HStack {
                            Text(atHome ? "VS" : "@")
                        }
                    }
                    HStack {
                        Text("MIA")
                        teamImage(atHome ? homeTeamTid : schedule.h.tid)
                    }
                }
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    func teamImage(_ tid: String, size: CGFloat = 50) -> some View {
        
            
        AsyncImage(url: URL(string: viewModel.urlForTeamId(tid) ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Color.gray
        }
        .frame(width: size, height: size)
    }
}

extension ContentView {
    @Observable
    class ViewModel {
        var schedules: [Schedule] = []
        var teams: [Team] = []
        
        func urlForTeamId(_ id: String) -> String? {
            return teams.first { team in
                team.tid == id
            }?.logo
        }
        
        func checkingIfPlayingAtHome(_ schedule: Schedule) -> Bool {
            return (schedule.v.tid == homeTeamTid) ? false : true
        }
        
        func getScheduleData() {
            
            guard let url = Bundle.main.url(forResource: "Schedule", withExtension: "json") else {
                return
            }
            do {
               
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(ScheduleResponse.self, from: data)
                
                self.schedules = response.data?.schedules ?? []
                
            } catch {
               print(error)
            }
        }
        
        func getTeamData() {
            
            guard let url = Bundle.main.url(forResource: "teams", withExtension: "json") else {
                return
            }
            
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(TeamData.self, from: data)
                
                self.teams = response.data.teams
                
            } catch {
                print(error)
            }
        }
    }
}


extension String {
    func toFormattedDate() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
       
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let components = calendar.dateComponents([.year, .month], from: date)

        guard let firstOfMonth = calendar.date(from: components) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEE MMM dd"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: firstOfMonth).uppercased()
    }
}

#Preview {
    ContentView()
}
