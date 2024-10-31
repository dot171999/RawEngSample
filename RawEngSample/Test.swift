//
//  Test.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 24/10/24.
//

import SwiftUI

struct InnerModel {
    var name: String = "InnerModel"
}

@Observable
class TestViewModel {
    var innerModel = InnerModel()
    var done = false
}

struct Test: View {
    @State var vm = TestViewModel()
    var body: some View {
        VStack {
            Text(vm.innerModel.name)
            let _ = print("11")
            Button {
                vm.innerModel.name = "new1"
            } label: {
                Text("Button")
            }
        }
        .task {
            if !vm.done {
                print("helo")
                vm.innerModel.name = "new"
                vm.done = true
            }
        }

    }
}

#Preview {
    Test()
}
