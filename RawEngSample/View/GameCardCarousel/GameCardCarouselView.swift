//
//  GameCardCarouselView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

struct GameCardCarouselView: View {
    @State private var viewModel = GameCardCarouselViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { scrollReader in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        Group {
                            ForEach(Array(viewModel.cardSequence.enumerated()), id: \.element) { cardIndex, gameCard in
                                Group {
                                    switch gameCard {
                                    case .past(let schedule):
                                        let myTeamPlayingAtHome = viewModel.myTeamPlayingAtHome(schedule)
                                        PastGameCardView(pastGameCard: viewModel.gameCardData?.past_game_card,
                                                         schedule: schedule, myTeamPlayingAtHome)
                                    case .upcoming(let schedule):
                                        let myTeamPlayingAtHome = viewModel.myTeamPlayingAtHome(schedule)
                                        GameCardView(.upcoming(viewModel.gameCardData?.upcoming_game),
                                                     schedule: schedule, myTeamPlayingAtHome)
                                    case .future(let schedule):
                                        let myTeamPlayingAtHome = viewModel.myTeamPlayingAtHome(schedule)
                                        GameCardView(.future(viewModel.gameCardData?.future_game),
                                                     schedule: schedule, myTeamPlayingAtHome)
                                    case .promotion(let index):
                                        PromoCardView(pos: index + 1)
                                    }
                                }
                                .id(cardIndex)
                            }
                        }
                        .frame(width: proxy.size.width - 60)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    .frame(height: proxy.size.width - 60)
                    .scrollTargetLayout()
                }
                .safeAreaPadding(.horizontal, 30)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .onChange(of: viewModel.foucsCard) { _, newValue in
                    let cardIndex = newValue - 1
                    scrollReader.scrollTo(cardIndex, anchor: .leading)
                }
            }
        }
        .padding(.top)
        .task {
            await viewModel.setup()
        }
    }
}

#Preview {
    GameCardCarouselView()
}
