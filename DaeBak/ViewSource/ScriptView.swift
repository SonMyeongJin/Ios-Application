//
//  ScriptView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import SwiftUI
import YouTubePlayerKit

struct ScriptView: View {
    @State var script: Script
    @ObservedObject var youTubePlayer: YouTubePlayer // 외부에서 주입받은 YouTubePlayer
    @State private var autoScrollEnabled: Bool = false  // 자동 스크롤 on/off 토글
    @State private var currentHighlightedIndex: Int? = nil // 현재 하이라이트된 인덱스

    var body: some View {
        VStack {
            // 자동 스크롤 토글 스위치
            HStack {
                Toggle(isOn: $autoScrollEnabled) {
                    HStack(spacing: 8) {
                        Image(systemName: autoScrollEnabled ? "arrow.triangle.2.circlepath.circle.fill" : "arrow.triangle.2.circlepath.circle")
                            .font(.title2)
                            .foregroundColor(autoScrollEnabled ? Color(red: 0.5, green: 0.4, blue: 0.3) : Color.gray)
                        Text("Auto Scroll")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.3))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        // 부드러운 베이지 계열 그라데이션
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.96, green: 0.93, blue: 0.87), // 밝은 베이지
                                Color(red: 0.93, green: 0.89, blue: 0.80)  // 약간 어두운 베이지
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)

         
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(0..<max(script.timeStampedKOR.count, script.timeStampedJPN.count), id: \.self) { index in
                        HStack(alignment: .top, spacing: 8) {
                            // 한국어 자막 영역
                            if script.timeStampedKOR.indices.contains(index) {
                                let korScript = script.timeStampedKOR[index]
                                
                                VStack(alignment: .leading) {
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
                                            Text(timestamp.time)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Text(korScript.text)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            Spacer()
                            
                            // 일본어 자막 영역
                            if script.timeStampedJPN.indices.contains(index) {
                                let jpnScript = script.timeStampedJPN[index]
                                VStack(alignment: .trailing) {
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
                                            Text(timestamp.time)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Text(jpnScript.text)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .id(index) // 각 행에 id 부여 (ScrollViewReader에서 사용)
                        .background(
                            index == currentHighlightedIndex ? Color.yellow.opacity(0.3) : Color.clear
                        )
                    }
                    .padding()
                }
                .frame(height: 300)
                .scriptBackground()
                .onReceive(Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()) { _ in
                    if autoScrollEnabled {
                        Task {
                            do {
                                // 현재 재생 시간을 Measurement<UnitDuration>으로 받아옴
                                let currentTime = try await youTubePlayer.getCurrentTime()
                                let currentTimeInSeconds = currentTime.converted(to: .seconds).value
                                if let index = script.timeStamps.lastIndex(where: { $0.seconds <= currentTimeInSeconds }) {
                                    withAnimation {
                                        proxy.scrollTo(index, anchor: .center)
                                        currentHighlightedIndex = index
                                    }
                                }
                            } catch {
                                print("Error fetching current time: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let testScripts = Script.loadFromJSON(fileName: "testScript")
    guard testScripts.count > 1 else {
        fatalError("테스트 JSON 파일에 두 번째 데이터가 없습니다.")
    }
    
    let youTubePlayer = YouTubePlayer(
        source: .video(id: "dQw4w9WgXcQ"),
        configuration: .init(autoPlay: false)
    )
    
    return ScriptView(script: testScripts[1], youTubePlayer: youTubePlayer)
}
