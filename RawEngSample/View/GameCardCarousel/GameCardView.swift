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
    
    let gameCard: FutureOrUpcomingGameCard
    
    let schedule: Schedule
    var background_image: GameCardData.GameCardBackgroundImage?
    var button: GameCardData.GameCardButton?
    
    var isUpcomingGame: Bool {
        if case .upcoming = gameCard {
            return true
        } else {
            return false
        }
    }
    
    init(_ gameCard: FutureOrUpcomingGameCard, schedule: Schedule) {
        self.gameCard = gameCard
        self.schedule = schedule
        
        switch gameCard {
        case .future(let futureGame):
            background_image = futureGame?.background_image
            button = futureGame?.button
        case .upcoming(let upcomingGame):
            background_image = upcomingGame?.background_image
            button = upcomingGame?.button
        }
    }
    
    var atHome: Bool {
        return (schedule.v.tid == homeTeamTid) ? false : true
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
                        ResizableAsyncImageView(atHome ? schedule.v.tid : homeTeamTid, size: 45)
                        ResizableAsyncImageView(atHome ? homeTeamTid : schedule.h.tid , size: 45)
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
                
                VStack {
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
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
        }
    }
}
