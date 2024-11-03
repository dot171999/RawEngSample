//
//  GameCardView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 28/10/24.
//

import SwiftUI

struct GameCardView: View {
    
    enum FutureOrUpcomingGameCard {
        case future(GameCardData.FutureGame?)
        case upcoming(GameCardData.UpcomingGame?)
    }
    
    private let gameCard: FutureOrUpcomingGameCard
    private let schedule: Schedule
    private var atHome: Bool
    
    private var background_image: GameCardData.GameCardBackgroundImage?
    private var button: GameCardData.GameCardButton?
    
    private var isUpcomingGame: Bool {
        if case .upcoming = gameCard {
            return true
        } else {
            return false
        }
    }
    
    init(_ gameCard: FutureOrUpcomingGameCard, schedule: Schedule, _ atHome: Bool) {
        self.gameCard = gameCard
        self.schedule = schedule
        self.atHome = atHome
        
        switch gameCard {
        case .future(let futureGame):
            background_image = futureGame?.background_image
            button = futureGame?.button
        case .upcoming(let upcomingGame):
            background_image = upcomingGame?.background_image
            button = upcomingGame?.button
        }
    }
    
    var body: some View {
        ZStack {
            Color("TempBack")
            
            let urlString = background_image?.url
            AsyncImage(url: URL(string: urlString ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .containerRelativeFrame(.horizontal)
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        ResizableAsyncImageView(schedule.v.tid, size: 45)
                        ResizableAsyncImageView(schedule.h.tid , size: 45)
                    }
                    
                    HStack {
                        HStack {
                            Text(schedule.v.ta)
                        }
                        VStack {
                            HStack {
                                Text(atHome ? "VS" : "@")
                            }
                        }
                        HStack {
                            Text(schedule.h.ta)
                        }
                    }
                    .font(.title2)
                    .fontWeight(.black)
                    .italic()
                    
                    HStack(spacing: 0) {
                        Text(atHome ? "HOME" : "AWAY")
                        Text(" | " + (schedule.readableGameDate) + " | ")
                        
                        Text(schedule.readableGameTime)
                    }
                    
                    .font(.footnote)
                    
                }
                .foregroundStyle(isUpcomingGame ? .black : .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
                
                VStack(spacing: 0) {
                    if let gameDate = schedule.gametime.toDateFromISO8601() {
                        HStack {
                            CountdownTimerView(gameDate: gameDate)
                                .padding(.bottom)
                            Spacer()
                        }
                    }
                    if let url = schedule.buy_ticket_url, url.isEmpty {
                        Button(action: {
                            
                        }, label: {
                            let buttonText = button?.cta_text ?? ""
                            Text(buttonText)
                                .fontWeight(.medium)
                                .foregroundStyle(.black)
                            Text("ticketmaster")
                                .italic()
                                .fontWeight(.semibold)
                        })
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 30))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}
