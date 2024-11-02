//
//  ResizableAsyncImageView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI
import UIKit.UIImage

struct ResizableAsyncImageView: View {
    @State private var viewModel = ResizableAsyncImageViewModel()
    
    private let tid: String
    private let size: CGFloat
    
    init(_ tid: String, size: CGFloat = 50) {
        self.tid = tid
        self.size = size
    }
    
    var body: some View {
        VStack {
            if let data = viewModel.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .frame(width: size, height: size)
        .task {
            if viewModel.imageData == nil {
                await viewModel.imageDataFor(tid)
            }
        }
    }
}

