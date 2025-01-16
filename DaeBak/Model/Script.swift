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
    var script_KOR: String = "null"
    var script_JPN: String = "null"
    var youtube_url: String = ""

    init(title: String, script_KOR: String = "null", script_JPN: String = "null", youtube_url: String = "") {
        self.title = title
        self.script_KOR = script_KOR
        self.script_JPN = script_JPN
        self.youtube_url = youtube_url
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
                    youtube_url: DecodableScript.youtube_url
                )
            }
        } catch {
            print("JSON 디코딩 에러: \(error)")
            return []
        }
    }
}

struct DecodableScript: Codable {
    let title: String
    let script_KOR: String
    let script_JPN: String
    let youtube_url: String
}
