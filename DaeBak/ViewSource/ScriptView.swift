//
//  ScriptView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import SwiftUI

struct ScriptView: View {
    @State var script: Script
    
    var body: some View {
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
        
    }
}

#Preview {
    let testScripts = Script.loadFromJSON(fileName: "testScript")
    guard let firstScript = testScripts.first else {
        fatalError("테스트 JSON 파일에서 데이터를 읽어오지 못했습니다.")
    }
    return ScriptView(script: firstScript)
}
