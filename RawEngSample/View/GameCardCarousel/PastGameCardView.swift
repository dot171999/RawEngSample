//
//  PastGameCardView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 28/10/24.
//

import SwiftUI

struct PastGameCardView: View {
    let backGameCard: GameCardData.PastGame?
    let schedule: Schedule
    var atHome: Bool {
        return (schedule.v.tid == homeTeamTid) ? false : true
    }
    
    var body: some View {
        ZStack {
            let urlString = backGameCard?.background_image.url
            AsyncImage(url: URL(string: urlString ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
            } placeholder: {
                Color.gray
            }
            .containerRelativeFrame(.horizontal)
            
            LinearGradient(colors: [.black.opacity(0), .black.opacity(0.4)], startPoint: .center, endPoint: .bottom)
            
            VStack {
                Spacer()
                HStack {
                    VStack {
                        ResizableAsyncImageView(schedule.v.tid)
                        Text(schedule.v.ta)
                            .fontWeight(.semibold)
                    }
                    
                    VStack {
                        HStack {
                            Text(schedule.v.s ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(atHome ? "VS" : "@")
                                .italic()
                                .fontWeight(.black)
                                .padding(.horizontal)
                            Text(schedule.h.s ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    VStack {
                        ResizableAsyncImageView(schedule.h.tid)
                        Text(schedule.h.ta)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.vertical)
                
                Button(action: {
                    
                }, label: {
                    let buttonText = backGameCard?.button.cta_text ?? ""
                    Text(buttonText)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                })
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color("GameCardButton"))
                .clipShape(.rect(cornerRadius: 30))
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

