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
            
            Text(script.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.headline)
                .padding()
            
            Test()
            
            Text("자막")
                .font(.headline)
            
            ScrollView{
                ForEach(0..<max(script.timeStampedKOR.count, script.timeStampedJPN.count), id: \.self) { index in
                    HStack(alignment: .top, spacing: 8) {
                        // 한국어 자막
                        if script.timeStampedKOR.indices.contains(index) {
                            VStack(alignment: .leading) {
                                Text(script.timeStampedKOR[index].time) // 시간 스탬프
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(script.timeStampedKOR[index].text) // 한국어 텍스트
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                        
                        // 일본어 자막
                        if script.timeStampedJPN.indices.contains(index) {
                            VStack(alignment: .trailing) {
                                Text(script.timeStampedJPN[index].time) // 시간 스탬프
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(script.timeStampedJPN[index].text) // 일본어 텍스트
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .padding()
            }
            .frame(height : 400)
            .border(Color.gray, width: 1)
            
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
