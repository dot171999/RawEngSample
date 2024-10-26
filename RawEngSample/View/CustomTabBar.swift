//
//  CustomTabBar.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

import SwiftUI

enum Tab: String, CaseIterable {
    case schedule = "Schedule"
    case games = "Games"
}

struct CustomTabBar: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    VStack {
                        Text(tab.rawValue)
                        if selectedTab == tab {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(Color("TabSelector"))
                                .matchedGeometryEffect(id: "ActiveTab", in: animation)
                        } else {
                            Rectangle()
                                .frame(height: 2)
                                .opacity(0)
                        }
                    }
                    .animation(.snappy, value: selectedTab)
                    .onTapGesture {
                            selectedTab = tab
                    }
                }
            }
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(Color("TabSeperator"))
                .padding(.top, 3)
                .padding(.bottom, 1)
        }
        .background( Color(colorScheme == .dark ? .black : .white))
    }
    
}

#Preview {
    CustomTabBar(selectedTab: .constant(Tab.schedule))
}
