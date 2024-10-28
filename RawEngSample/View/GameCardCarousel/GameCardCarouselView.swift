//
//  GameCardCarouselView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI


struct GameCardCarouselView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    Group {
                        ForEach(viewModel.cardSequence, id: \.self) { gameCard in
                            switch gameCard {
                            case .past(let schedule):
                                PastGameCardView(backGameCard: viewModel.gameCardData?.past_game_card, schedule: schedule)
                            case .upcoming(let schedule):
                                GameCardView(.upcoming(viewModel.gameCardData?.upcoming_game), schedule: schedule)
                            case .future(let schedule):
                                GameCardView(.future(viewModel.gameCardData?.future_game), schedule: schedule)
                            case .promotion(let index):
                                PromoCardView(pos: index + 1)
                            }
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
        }
        .padding(.top)
    }
}

#Preview {
    GameCardCarouselView()
}
