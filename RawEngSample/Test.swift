//
//  Test.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import SwiftUI

struct NumericPreferenceKey1: PreferenceKey {
    static var defaultValue: Int = 0
    
    static func reduce(value: inout Int, nextValue: () -> Int) {
        print("reduce called with value:", value)
        value += nextValue()
    }
}

struct Test: View {
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<100) { i in
                    Rectangle()
                        .frame(width: 100, height: 50 )
                }
            }
        }
        
        .onPreferenceChange(NumericPreferenceKey1.self, perform: { value in
                    print("hello", value)
        })
    }
    
}



#Preview {
    Test()
}
