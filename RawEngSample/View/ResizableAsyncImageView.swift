//
//  ResizableAsyncImageView.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import SwiftUI

struct ResizableAsyncImageView: View {
    private let tid: String
    private let size: CGFloat
    
    init(_ tid: String, size: CGFloat = 50) {
        self.tid = tid
        self.size = size
    }
    
    var body: some View {
        let urlString = TeamService.shared.iconUrlForTeamId(tid) ?? ""
        AsyncImage(url: URL(string: urlString)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
        }
        .frame(width: size, height: size)
    }
}

