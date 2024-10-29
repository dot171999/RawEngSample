//
//  PromoCardView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 27/10/24.
//

import SwiftUI

struct PromoCardView: View {
    private let pos: Int
    
    init(pos: Int) {
        self.pos = pos
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(LinearGradient(colors: [.red, .green], startPoint: .top, endPoint: .bottom))
            VStack {
                Text("PROMOTION CARD")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(.black)
                Text("Position \(pos)")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    PromoCardView(pos: 1)
}
