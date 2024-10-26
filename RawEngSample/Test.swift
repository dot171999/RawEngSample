//
//  Test.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import SwiftUI
struct PreferenceKey: SwiftUI.PreferenceKey {
    static var defaultValue: CGFloat { .zero }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // No-op
    }
}

struct Test: View {
    let array: [Int] = {
        var temp: [Int] = []
        for i in 0...50 {
            temp.append(i)
        }
        return temp
    }()
    @State var index = 0
    var body: some View {
        VStack {
            Color.red
            
        }
        //.ignoresSafeArea()
       
    }
    
}



#Preview {
    Test()
}
