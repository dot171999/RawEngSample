//
//  ContentView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import SwiftUI

let homeTeamTid = "1610612748"

struct ContentView: View {
    @State private var selectedTab: Tab = .schedule
    
    var body: some View {
        VStack(spacing: 0) {
            Text("TEAM")
                .italic()
                .font(.title)
                .fontWeight(.black)
                .frame(maxWidth: .infinity)
            
           CustomTabBar(selectedTab: $selectedTab)
                .padding(.top)
            
            TabView(selection: $selectedTab) {
                
                ScheduleView()
                .tag(Tab.schedule)
                
                GameCardCarouselView()
                    .tag(Tab.games)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
