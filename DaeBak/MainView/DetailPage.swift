//
//  ScriptView.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import SwiftUI
import YouTubePlayerKit


struct DetailPage: View {
    @State var script: Script
    @StateObject private var youTubePlayer = YouTubePlayer("") // YouTubePlayer 인스턴스 생성
    
    var body: some View {
        VStack {
            Text(script.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 156 / 255, green: 102 / 255, blue: 68 / 255))
                .multilineTextAlignment(.center)
                .lineLimit(1) // 최대 2줄까지 표시
                .truncationMode(.tail) // 끝부분에서 "..."으로 표시
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
                        .padding(.horizontal, 20)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                )
            
            // YouTubePlayer 인스턴스를 YoutubeView에 전달
            YoutubeView(youtubeURL: script.youtube_url, youTubePlayer: youTubePlayer)
            
            Text("자막")
                .font(.headline)
                .foregroundColor(Color(red: 156 / 255, green: 102 / 255, blue: 68 / 255))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .maximum(30, 130))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
                        .padding(.horizontal, 20)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                )
            
            // YouTubePlayer 인스턴스를 ScriptView에 전달
            ScriptView(script: script, youTubePlayer: youTubePlayer)
                .border(Color.gray, width: 6)
            
            Spacer()
        }
        .padding()
        .globalBackground()
    }
    // YouTube URL에서 videoID 추출 함수
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

