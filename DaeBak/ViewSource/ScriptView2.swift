//
//  ScriptView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//
import SwiftUI
import YouTubePlayerKit

struct ScriptView2: View {
    @State var script: Script
    @StateObject private var youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=psL_5RIBqnY"
    
    
    var body: some View {
        
        VStack {
            // 유튜브 플레이어
            YouTubePlayerView(self.youTubePlayer) { state in
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error:
                    Text("YouTube 영상을 불러올 수 없습니다.")
                        .foregroundColor(.red)
                }
            }
            .frame(height: 200)
            
            
            // 타임스탬프 리스트 (List를 ScrollView 밖으로 이동)
            List(script.timeStamps, id: \.seconds) { timestamp in
                Button(action: {
                    let timeMeasurement = Measurement(value: timestamp.seconds, unit: UnitDuration.seconds)
                    youTubePlayer.seek(to: timeMeasurement, allowSeekAhead: true) { result in
                        switch result {
                        case .success:
                            print("Moved to \(timestamp.time)")
                        case .failure(let error):
                            print("Error seeking: \(error)")
                        }
                    }
                }) {
                    Text("Jump to \(timestamp.time)")
                        .font(.headline)
                }
            }
            .frame(height: 200) // 리스트 높이 제한
            
            ScrollView {
                ForEach(0..<max(script.timeStampedKOR.count, script.timeStampedJPN.count), id: \.self) { index in
                    HStack(alignment: .top, spacing: 8) {
                        // 한국어 자막
                        if script.timeStampedKOR.indices.contains(index) {
                            let korScript = script.timeStampedKOR[index]
                            
                            VStack(alignment: .leading) {
                                // 🎯 `script.timeStamps` 배열이 해당 index를 포함하는지 확인 후 버튼 추가
                                if script.timeStamps.indices.contains(index) {
                                    let timestamp = script.timeStamps[index]
                                    Button(action: {
                                        let timeMeasurement = Measurement(value: timestamp.seconds, unit: UnitDuration.seconds)
                                        youTubePlayer.seek(to: timeMeasurement, allowSeekAhead: true) { result in
                                            switch result {
                                            case .success:
                                                print("Moved to \(timestamp.time)")
                                            case .failure(let error):
                                                print("Error seeking: \(error)")
                                            }
                                        }
                                    }) {
                                        Text(timestamp.time) // ✅ 안전하게 접근 가능
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Text(korScript.text) // ✅ 한국어 자막
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                        
                        // 일본어 자막
                        if script.timeStampedJPN.indices.contains(index) {
                            let jpnScript = script.timeStampedJPN[index]
                            VStack(alignment: .trailing) {
                                Text(jpnScript.time) // ✅ 일본어 타임스탬프
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(jpnScript.text) // ✅ 일본어 자막
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .padding()
            }
            .frame(height: 400)
            .scriptBackground()
        }
    }
}

#Preview {
    let testScripts = Script.loadFromJSON(fileName: "testScript")
    guard testScripts.count > 1 else {
        fatalError("테스트 JSON 파일에 두 번째 데이터가 없습니다.")
    }
    return ScriptView2(script: testScripts[1])
}

