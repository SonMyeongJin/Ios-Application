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
    
    var body: some View {
        VStack{
            
            Text(script.title)
                   .font(.largeTitle)
                   .fontWeight(.bold)
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
            
            
            YoutubeView(youtubeURL: script.youtube_url)
            
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
            
            ScriptView(script: script)
                .border(Color.gray, width: 6)
            
            Spacer()
        }
        .padding()
        //.navigationTitle("")
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

