//
//  HomeScreen.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selectedTab: Tab = .schedule
    
    enum Tab: String, CaseIterable {
        case schedule = "Schedule"
        case games = "Games"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(TeamService.shared.myTeamName())
                .italic()
                .font(.title)
                .fontWeight(.black)
                .frame(maxWidth: .infinity)
            
           HomeTabBarView(selectedTab: $selectedTab)
                .padding(.top)
            
            TabView(selection: $selectedTab) {
                
               ScheduleView()
                    .tag(Tab.schedule)
                
                GameCardCarouselView()
                    .tag(Tab.games)
                    .padding(.top)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    HomeScreen()
}
