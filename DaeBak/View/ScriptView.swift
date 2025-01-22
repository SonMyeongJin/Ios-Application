//
//  ScriptView.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import SwiftUI
import YouTubePlayerKit


struct ScriptView: View {
    @State var script: Script
    
    var body: some View {
        VStack{
            
            Test()
            
            Text("Title")
                .font(.headline)
            TextField("Enter title", text: $script.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("한국어 자막")
                .font(.headline)
            TextEditor(text: $script.script_KOR)
                .border(Color.gray,width: 1)
                .frame(height: 100)
            
            Text("일본어 자막")
            TextEditor(text: $script.script_JPN)
                .border(Color.gray, width: 1)
                .frame(height: 100)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Script Details")
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
    return ScriptView(script: firstScript)
}
