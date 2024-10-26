//
//  ScheduleView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

struct ScheduleView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel = ViewModel()
    @State private var id = ""
    
    private enum GameStatus: Int {
        case future = 1
        case live = 2
        case past = 3
    }
    
    var body: some View {
        ScrollViewReader { scrollReader in
            GeometryReader { scrollViewGeometry in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach (viewModel.schedules, id: \.self) { schedule in
                            VStack {
                                if let status = schedule.st, let game = GameStatus(rawValue:  status) {
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
                            .id(schedule.uid)
                            .background(GeometryReader { geometry in
                                Color.clear.preference(
                                    key: PreferenceKey.self,
                                    value: geometry.frame(in: .global).minY
                                )
                            })
                            .onPreferenceChange(PreferenceKey.self) { position in
                                let scrollViewMinY = scrollViewGeometry.frame(in: .global).minY
                                // + content margin + some threshold
                                let triggerAreaThreshold = scrollViewMinY + 20 + 20
                                let minY = position
                                let newMonYear = schedule.readableGameMonYear
                                if viewModel.currentMonth != newMonYear && minY > scrollViewMinY && minY < triggerAreaThreshold {
                                    viewModel.currentMonth = newMonYear
                                }
                            }
                        }
                    }
                }
                .contentMargins(.top, 20, for: .scrollContent)
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                HStack {
                    Button(action: {
                        let id = viewModel.nextMonthId()
                        print(id as Any)
                        scrollReader.scrollTo(id, anchor: .top)
                    }, label: {
                        Image(systemName: "chevron.up")
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    })
                    
                    Text(viewModel.currentMonth)
                        .font(.subheadline)
                    
                    Button(action: {
                        let id = viewModel.previousMonthId()
                        print(id as Any)
                        scrollReader.scrollTo(id, anchor: .top)
                    }, label: {
                        Image(systemName: "chevron.down")
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                    
                }
                .padding(5)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(Color("MonthPicker"))
            }
        }
        .onAppear {
            viewModel.getScheduleData()
        }
    }
}

#Preview {
    ScheduleView()
}
