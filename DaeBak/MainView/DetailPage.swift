//
//  DetailPage.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import SwiftUI
import YouTubePlayerKit

struct DetailPage: View {
    @State var script: Script
    @StateObject private var youTubePlayer = YouTubePlayer("")
    @State private var isLoadingDetail: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            VStack {
                if isLoadingDetail {
                    ProgressView("Loading...")
                        .onAppear {
                            loadDetail()
                        }
                } else {
                    if isLandscape {
                        // 가로모드
                        HStack(alignment: .top, spacing: 24) {
                            YoutubeView(youtubeURL: script.youtube_url, youTubePlayer: youTubePlayer)
                                .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 0.7)
                                .clipped()
                            ScriptView(script: script, youTubePlayer: youTubePlayer, fixedWidth: geometry.size.width * 0.4)
                                .border(Color.gray, width: 6)
                                .frame(height: geometry.size.height * 0.8)
                        }
                    } else {
                        // 세로모드
                        
                        // 제목 뷰
                        Text(script.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 156 / 255, green: 102 / 255, blue: 68 / 255))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal,20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
                                    .padding(.horizontal, 20)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                            )
                        // YouTubePlayer 뷰
                        YoutubeView(youtubeURL: script.youtube_url, youTubePlayer: youTubePlayer)
                        // "자막" 제목
                        Text("[韓国語 - 日本語] 字幕")
                            .font(.headline)
                            .foregroundColor(Color(red: 156 / 255, green: 102 / 255, blue: 68 / 255))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
                                    .padding(.horizontal, 20)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                            )
                        // 스크립트 자막 뷰
                        ScriptView(script: script, youTubePlayer: youTubePlayer)
                            .border(Color.gray, width: 6)
                        Spacer()
                    }
                }
            }
            .padding()
            .globalBackground()
        }
    }
    
    // 전달받은 Script의 상세 정보를 네트워크에서 로드하여 업데이트
    private func loadDetail() {
        Script.fetchDetail(fileName: script.detailFileName) { detailedScript in
            DispatchQueue.main.async {
                if let detailedScript = detailedScript {
                    self.script = detailedScript
                }
                self.isLoadingDetail = false
            }
        }
    }
    
    // 유튜브 URL에서 videoID를 추출하는 함수
    private func extractVideoID(from url: String) -> String? {
        guard let components = URLComponents(string: url),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
}

#Preview {
    let testScripts = Script.loadFromJSON(fileName: "testScript")
    guard let firstScript = testScripts.first else {
        fatalError("테스트 JSON 파일에서 데이터를 읽어오지 못했습니다.")
    }
    return DetailPage(script: firstScript)
}

#Preview("Second Script Preview") {
    let testScripts = Script.loadFromJSON(fileName: "testScript")
    guard testScripts.indices.contains(1) else {
        fatalError("테스트 JSON 파일에서 두 번째 데이터를 읽어오지 못했습니다.")
    }
    return DetailPage(script: testScripts[1])
}
