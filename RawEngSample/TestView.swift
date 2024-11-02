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
    var prop: String {
        innerModel.name
    }
}

struct Test: View {
    @State var vm = TestViewModel()
    var body: some View {
        VStack {
            let _ = print("name to be printed")
            Text(vm.innerModel.name)
            let _ = print("name printed")
            Button {
                vm.innerModel.name = "new1"
            } label: {
                Text("Button")
            }
            let _ = print("button rerendered")
            let _ = Self._printChanges()
        }
    }
}

#Preview {
    Test()
}
