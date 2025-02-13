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
    
    @Published var detailFileName: String = "testScript.json" // 기본값
    
    init(title: String,
         script_KOR: String = "null",
         script_JPN: String = "null",
         youtube_url: String = "",
         artist: String = "Unknown") {
        self.title = title
        self.script_KOR = script_KOR
        self.script_JPN = script_JPN
        self.youtube_url = youtube_url
        self.artist = artist

        fetchFileName() // 생성 시 파일명 가져오기
    }
    
    /// 🎯 서버에서 JSON 리스트를 가져와서 youtube_url과 매칭되는 항목의 순서(index)를 사용하여 파일명을 생성하는 함수
    /// (예: 배열에서 첫 번째 항목이면 "BTS_1.json", 두 번째면 "BTS_2.json")
    func fetchFileName() {
        guard let url = URL(string: "http://54.180.90.233:8080/api/list/\(artist)") else {
            print("❌ 잘못된 API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ 데이터 요청 실패: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // 서버 응답에는 fileName 정보가 없으므로 ScriptListItem은 title, youtube_url, artist 만 포함합니다.
                let fileList = try JSONDecoder().decode([ScriptListItem].self, from: data)
                
                if let matchingIndex = fileList.firstIndex(where: { $0.youtube_url == self.youtube_url }) {
                    // 배열 인덱스는 0부터 시작하므로, 파일명에 사용할 index는 matchingIndex + 1
                    let fileName = "\(self.artist)_\(matchingIndex + 1).json"
                    DispatchQueue.main.async {
                        self.detailFileName = fileName
                    }
                }
            } catch {
                print("❌ JSON 디코딩 실패: \(error)")
            }
        }.resume()
    }
    
    // MARK: - 스크립트 파싱 (시간 스탬프 포함)
    
    static let timeStampRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\(\\d{1,2}:\\d{2}\\)", options: [])
    }()
    
    static let timeRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\((\\d{1,2}):(\\d{2})\\)", options: [])
    }()
    
    // 캐싱된 파싱 결과
    private lazy var cachedTimeStampedKOR: [(time: String, text: String)] = {
        return self.parseScript(self.script_KOR)
    }()
    
    private lazy var cachedTimeStampedJPN: [(time: String, text: String)] = {
        return self.parseScript(self.script_JPN)
    }()
    
    private lazy var cachedTimeStamps: [(time: String, seconds: Double)] = {
        return self.parseTimestamp(self.script_KOR)
    }()
    
    var timeStampedKOR: [(time: String, text: String)] {
        return cachedTimeStampedKOR
    }
    
    var timeStampedJPN: [(time: String, text: String)] {
        return cachedTimeStampedJPN
    }
    
    var timeStamps: [(time: String, seconds: Double)] {
        return cachedTimeStamps
    }
    
    /// 스크립트에서 (MM:SS) 형태의 시간 스탬프와 텍스트를 분리
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
    
    /// 스크립트 내의 (MM:SS) 형태의 시간 스탬프를 초 단위로 변환
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
    
    /// 상세 스크립트 API 호출 (단일 스크립트)
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
    
    /// 목록 API 호출 (해당 아티스트의 스크립트 목록)
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
    
    /// 서버 응답에는 fileName 정보가 없으므로 ScriptListItem은 title, youtube_url, artist 만 포함합니다.
    struct ScriptListItem: Codable {
        let title: String
        let youtube_url: String
        let artist: String
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
