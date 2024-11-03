//
//  CountdownTimerView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 02/11/24.
//

import SwiftUI

struct CountdownTimerView: View {
    @State private var viewModel: CountdownTimerViewModel
    
    init(gameDate: Date) {
        self.viewModel = CountdownTimerViewModel(gameDate: gameDate)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Text(viewModel.remainingDays)
                    .font(.title3)
                    .fontWeight(.medium)
                Text("DAYS")
                    .font(.footnote)
            }
            .padding(.horizontal, 15)
            Rectangle()
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .foregroundStyle(.white.opacity(0.5))
            VStack {
                Text(viewModel.remainingHours)
                    .font(.title3)
                    .fontWeight(.medium)
                Text("HRS")
                    .font(.footnote)
            }
            .padding(.horizontal, 15)
            Rectangle()
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .foregroundStyle(.white.opacity(0.5))
            VStack {
                Text(viewModel.remainingMinutes)
                    .font(.title3)
                    .fontWeight(.medium)
                Text("MIN")
                    .font(.footnote)
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 60)
        .foregroundStyle(.white)
        .background(.black.opacity(0.8))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    let now = Date()
    let gamedate = Calendar.current.date(byAdding: .hour, value: 2, to: now)
    return CountdownTimerView(gameDate: gamedate!)
}
