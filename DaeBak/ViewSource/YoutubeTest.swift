//
//  Test.swift
//  DaeBak
//
//  Created by 손명진 on 1/17/25.
//

import SwiftUI
import YouTubePlayerKit

struct YoutubeTest: View {

    @StateObject
    var youTubePlayer: YouTubePlayer = "https://www.youtube.com/watch?v=f-8vau3NfMY"

    var body: some View {
        YouTubePlayerView(self.youTubePlayer) { state in
            // Overlay ViewBuilder closure to place an overlay View
            // for the current `YouTubePlayer.State`
            switch state {
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(let error):
                Text(verbatim: "YouTube player couldn't be loaded")
            }
        }
    }

}

