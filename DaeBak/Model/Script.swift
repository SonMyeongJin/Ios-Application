//
//  Script.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import Foundation
import SwiftData

@Model
class Script {
    var title: String
    var script_KOR: String
    var script_JPN: String
    var youtube_url: String
    var artist: String // 추가된 artist 속성
    
    init(title: String, script_KOR: String = "null", script_JPN: String = "null", youtube_url: String = "", artist: String = "Unknown") {
        self.title = title
        self.script_KOR = script_KOR
        self.script_JPN = script_JPN
        self.youtube_url = youtube_url
        self.artist = artist
    }
    
    // 각 줄을 시간 스탬프와 텍스트로 나눈 배열 (한국어)
    var timeStampedKOR: [(time: String, text: String)] {
        parseScript(script_KOR)
    }
    
    // 각 줄을 시간 스탬프와 텍스트로 나눈 배열 (일본어)
    var timeStampedJPN: [(time: String, text: String)] {
        parseScript(script_JPN)
    }
    
    // 시간 스탬프 파싱 함수
    private func parseScript(_ script: String) -> [(time: String, text: String)] {
        let lines = script.components(separatedBy: "\n") // 줄 단위로 분리
        return lines.compactMap { line in
            guard let range = line.range(of: "\\(\\d{1,2}:\\d{2}\\)", options: .regularExpression),
                  !range.isEmpty else { return nil }
            let time = String(line[range]) // 시간 스탬프 추출
            let text = line.replacingOccurrences(of: time, with: "").trimmingCharacters(in: .whitespaces)
            return (time, text)
        }
    }
    
    // JSON 파일에서 데이터 읽기 함수
    static func loadFromJSON(fileName: String) -> [Script] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다: \(fileName)")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodableScripts = try decoder.decode([DecodableScript].self, from: data)
            return decodableScripts.map { DecodableScript in
                Script(
                    title: DecodableScript.title,
                    script_KOR: DecodableScript.script_KOR,
                    script_JPN: DecodableScript.script_JPN,
                    youtube_url: DecodableScript.youtube_url,
                    artist: DecodableScript.artist
                )
            }
        } catch {
            print("JSON 디코딩 에러: \(error)")
            return []
        }
    }
    
    // 특정 아티스트의 스크립트 필터링 함수
    static func scripts(for artist: String, from scripts: [Script]) -> [Script] {
        return scripts.filter { $0.artist == artist }
    }
}

struct DecodableScript: Codable {
    let title: String
    let script_KOR: String
    let script_JPN: String
    let youtube_url: String
    let artist: String
}
