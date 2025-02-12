//
//  Script.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import Foundation
import SwiftData

class Script: Identifiable, ObservableObject {
    var id = UUID()
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
    
    /// 상세 정보 호출 시 사용할 파일명을 결정하는 computed property
    var detailFileName: String {
        if youtube_url.contains("6xz1bay-6dQ") {
            return "BTS_2.json"
        } else if youtube_url.contains("COcgp6xk76c") {
            return "BTS_1.json"
        } else if youtube_url.contains("kl-NaR9E8nA") {
            return "BTS_3.json"
        } else if youtube_url.contains("oK7LiJxmL84") {
            return "BTS_4.json"
        } else {
            return "testScript" // fallback
        }
    }
    
    // MARK: - 스크립트 파싱 (시간 스탬프 포함)
    
    // 정규식 객체 미리 생성 (재사용)
    static let timeStampRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\(\\d{1,2}:\\d{2}\\)", options: [])
    }()
    
    static let timeRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\((\\d{1,2}):(\\d{2})\\)", options: [])
    }()
    
    // **저장 프로퍼티**에 lazy 적용 (캐싱)
    private lazy var cachedTimeStampedKOR: [(time: String, text: String)] = {
        return self.parseScript(self.script_KOR)
    }()
    
    private lazy var cachedTimeStampedJPN: [(time: String, text: String)] = {
        return self.parseScript(self.script_JPN)
    }()
    
    private lazy var cachedTimeStamps: [(time: String, seconds: Double)] = {
        return self.parseTimestamp(self.script_KOR)
    }()
    
    // computed property (lazy 키워드 없이)로 캐싱된 값을 반환
    var timeStampedKOR: [(time: String, text: String)] {
        return cachedTimeStampedKOR
    }
    
    var timeStampedJPN: [(time: String, text: String)] {
        return cachedTimeStampedJPN
    }
    
    var timeStamps: [(time: String, seconds: Double)] {
        return cachedTimeStamps
    }
    
    /// 스크립트 문자열에서 (MM:SS) 형태의 시간 스탬프를 찾아 분리합니다.
    private func parseScript(_ script: String) -> [(time: String, text: String)] {
        let lines = script.components(separatedBy: "\n")
        return lines.compactMap { line in
            let nsLine = line as NSString
            let range = NSRange(location: 0, length: nsLine.length)
            guard let match = Script.timeStampRegex.firstMatch(in: line, options: [], range: range) else {
                return nil
            }
            if let swiftRange = Range(match.range, in: line) {
                let time = String(line[swiftRange])
                let text = line.replacingOccurrences(of: time, with: "").trimmingCharacters(in: .whitespaces)
                return (time, text)
            }
            return nil
        }
    }
    
    /// `(MM:SS)` 형태의 시간 스탬프를 초로 변환합니다.
    private func parseTimestamp(_ script: String) -> [(time: String, seconds: Double)] {
        let nsString = script as NSString
        let results = Script.timeRegex.matches(in: script, options: [], range: NSRange(location: 0, length: nsString.length))
        
        var timeStamps: [(time: String, seconds: Double)] = []
        for match in results {
            let timeString = nsString.substring(with: match.range)
            if let minuteRange = Range(match.range(at: 1), in: script),
               let secondRange = Range(match.range(at: 2), in: script) {
                let minutes = Double(script[minuteRange]) ?? 0
                let seconds = Double(script[secondRange]) ?? 0
                let totalSeconds = minutes * 60 + seconds
                timeStamps.append((time: timeString, seconds: totalSeconds))
            }
        }
        return timeStamps
    }
    
    // MARK: - 로컬 JSON 로딩 (테스트용)
    
    static func loadFromJSON(fileName: String) -> [Script] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다: \(fileName)")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodableScripts = try decoder.decode([DecodableScript].self, from: data)
            return decodableScripts.map { ds in
                Script(
                    title: ds.title,
                    script_KOR: ds.script_KOR ?? "null",
                    script_JPN: ds.script_JPN ?? "null",
                    youtube_url: ds.youtube_url,
                    artist: ds.artist
                )
            }
        } catch {
            print("JSON 디코딩 에러: \(error)")
            return []
        }
    }
    
    // MARK: - 네트워크 API 호출
    
    /// 상세 페이지 API 호출 (단일 스크립트)
    static func fetchDetail(fileName: String, completion: @escaping (Script?) -> Void) {
        let urlString = "http://54.180.90.233:8080/api/script/json?fileName=\(fileName)"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL: \(urlString)")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("디테일 API 호출 에러: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("디테일 API: 데이터 없음")
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                let ds = try decoder.decode(DecodableScript.self, from: data)
                let script = Script(
                    title: ds.title,
                    script_KOR: ds.script_KOR ?? "null",
                    script_JPN: ds.script_JPN ?? "null",
                    youtube_url: ds.youtube_url,
                    artist: ds.artist
                )
                completion(script)
            } catch {
                print("디테일 API 디코딩 에러: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    /// 목록 페이지 API 호출 (해당 아티스트의 스크립트 목록)
    static func fetchList(artist: String, completion: @escaping ([Script]) -> Void) {
        let urlString = "http://54.180.90.233:8080/api/list/\(artist)"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL: \(urlString)")
            completion([])
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("목록 API 호출 에러: \(error)")
                completion([])
                return
            }
            guard let data = data else {
                print("목록 API: 데이터 없음")
                completion([])
                return
            }
            do {
                let decoder = JSONDecoder()
                let dsArray = try decoder.decode([DecodableScript].self, from: data)
                let scripts = dsArray.map { ds in
                    Script(
                        title: ds.title,
                        script_KOR: ds.script_KOR ?? "null",
                        script_JPN: ds.script_JPN ?? "null",
                        youtube_url: ds.youtube_url,
                        artist: ds.artist
                    )
                }
                print("가져온 스크립트 개수: \(scripts.count)")
                completion(scripts)
            } catch {
                print("목록 API 디코딩 에러: \(error)")
                completion([])
            }
        }.resume()
    }
}

/// 서버 API 응답을 위한 Codable 구조체
struct DecodableScript: Codable {
    let title: String
    let script_KOR: String?
    let script_JPN: String?
    let youtube_url: String
    let artist: String
}
