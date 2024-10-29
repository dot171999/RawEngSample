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
                                    let myTeamPlayingAtHome = viewModel.teamService.isMyTeamPlayingAtHome(schedule)
                                    switch game {
                                    case .future:
                                        FutureGameScheduleView(for: schedule, myTeamPlayingAtHome)
                                    case .live:
                                        LiveGameScheduleView(for: schedule, myTeamPlayingAtHome)
                                    case .past:
                                        PastGameScheduleView(for: schedule, myTeamPlayingAtHome)
                                    }
                                }
                            }
                            .id(schedule.uid)
                            .background(GeometryReader { geometry in
                                Color.clear.preference(
                                    key: ScheduleMonthHeaderPreferenceKey.self,
                                    value: ScheduleMonthHeaderScrollInfo(minY: geometry.frame(in: .global).minY, month: schedule.readableGameMonYear)
                                )
                            })
                            .onPreferenceChange(ScheduleMonthHeaderPreferenceKey.self) { scrollInfo in
                                let scrollViewMinY = scrollViewGeometry.frame(in: .global).minY
                                // + content margin + some threshold
                                let triggerAreaThreshold = scrollViewMinY + 20 + 20
                                let minY = scrollInfo.minY
                                let newMonYear = scrollInfo.month
                                
                                if viewModel.currentHeaderMonth != newMonYear && minY > scrollViewMinY && minY < triggerAreaThreshold {
                                    viewModel.currentHeaderMonth = schedule.readableGameMonYear
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
                        scrollReader.scrollTo(id, anchor: .top)
                    }, label: {
                        Image(systemName: "chevron.up")
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    })
                    
                    Text(viewModel.currentHeaderMonth)
                        .font(.subheadline)
                    
                    Button(action: {
                        let id = viewModel.previousMonthId()
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
    }
}

extension ScheduleView {
    private struct ScheduleMonthHeaderScrollInfo: Hashable {
        let minY: CGFloat
        let month: String
    }
    
    private struct ScheduleMonthHeaderPreferenceKey: PreferenceKey {
        static var defaultValue: ScheduleMonthHeaderScrollInfo = ScheduleMonthHeaderScrollInfo(minY: 0, month: "")
        
        static func reduce(value: inout ScheduleMonthHeaderScrollInfo, nextValue: () -> ScheduleMonthHeaderScrollInfo) {
            
        }
    }
}

#Preview {
    ScheduleView()
}
