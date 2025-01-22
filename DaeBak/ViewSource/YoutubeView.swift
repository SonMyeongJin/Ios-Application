//
//  YoutubeView.swift
//  DaeBak
//
//  Created by 손명진 on 1/23/25.
//

import SwiftUI
import YouTubePlayerKit

struct YoutubeView: View {
    let youtubeURL: String // URL을 전달받기 위해 프로퍼티 추가
    @StateObject private var youTubePlayer = YouTubePlayer("")

    var body: some View {
        VStack {
            YouTubePlayerView(self.youTubePlayer) { state in
                switch state {
                case .idle:
                    ProgressView() // 로딩 중
                case .ready:
                    EmptyView() // 준비 완료
                case .error:
                    Text("YouTube 영상을 불러올 수 없습니다.")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                self.youTubePlayer.source = .url(youtubeURL) // URL 설정
            }
        }
        .frame(height: 200) // 플레이어 크기 설정
    }
}

#Preview {
    let scripts = Script.loadFromJSON(fileName: "testScript")
    guard let firstScript = scripts.first else {
        fatalError("testScript.json에서 데이터를 불러올 수 없습니다.")
    }
    return YoutubeView(youtubeURL: firstScript.youtube_url)
}
