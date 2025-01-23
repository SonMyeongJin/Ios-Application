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
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.headline)
                .padding()
            
            YoutubeView(youtubeURL: script.youtube_url)
            
            Text("자막")
                .font(.headline)
            
            ScriptView(script: script)
            
            Spacer()
        }
        .padding()
       // .navigationTitle("Script Details")
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

