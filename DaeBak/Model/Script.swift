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
    
    init(title: String, script_KOR: String = "null", script_JPN: String = "null") {
        self.title = title
        self.script_KOR = script_KOR
        self.script_JPN = script_JPN
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
            // DecodableScript에서 Script로 변환
            return decodableScripts.map { DecodableScript in
                Script(title: DecodableScript.title, script_KOR: DecodableScript.script_KOR, script_JPN: DecodableScript.script_JPN)
            }
        } catch {
            print("JSON 디코딩 에러: \(error)")
            return []
        }
    }
}

// JSON 디코딩/인코딩을 위한 별도 구조체
struct DecodableScript: Codable {
    let title: String
    let script_KOR: String
    let script_JPN: String
}
