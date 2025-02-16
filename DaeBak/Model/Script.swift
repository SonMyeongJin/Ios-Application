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
                // 서버 응답에는 fileName 정보가 없으므로 ScriptListItem은 title, youtube_url, artist만 포함합니다.
                let fileList = try JSONDecoder().decode([ScriptListItem].self, from: data)
                
                // 파일명에서 번호를 추출하여 오름차순 정렬 (목록 정렬과 동일한 기준 사용)
                let sortedFileList = fileList.sorted { lhs, rhs in
                    self.extractFileNumber(from: lhs.title) < self.extractFileNumber(from: rhs.title)
                }
                
                if let matchingIndex = sortedFileList.firstIndex(where: { $0.youtube_url == self.youtube_url }) {
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
    // Script.swift 내부에 추가 (fetchFileName()와 함께 사용)
    private func extractFileNumber(from title: String) -> Int {
        // 파일명이 "BTS_17.json" 형식이라고 가정
        let pattern = "(?<=_)(\\d+)(?=\\.json)"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return 0
        }
        let nsTitle = title as NSString
        if let match = regex.firstMatch(in: title, options: [], range: NSRange(location: 0, length: nsTitle.length)) {
            if let range = Range(match.range(at: 1), in: title) {
                return Int(title[range]) ?? 0
            }
        }
        return 0
    }



    
    // MARK: - 스크립트 파싱 (시간 스탬프 포함)
    
    static let timeStampRegex: NSRegularExpression = {
        return try! NSRegularExpression(
            pattern: "[\\(（]\\s*\\d{1,2}\\s*(?:[:\u{FF1A}])\\s*\\d{2}\\s*[\\)）]",
            options: []
        )
    }()

    static let timeRegex: NSRegularExpression = {
        return try! NSRegularExpression(
            pattern: "[\\(（]\\s*(\\d{1,2})\\s*(?:[:\u{FF1A}])\\s*(\\d{2})\\s*[\\)）]",
            options: []
        )
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
    
    private func parseScript(_ script: String) -> [(time: String, text: String)] {
        // 수정된 패턴: 여는 괄호 ( 또는 （, 닫는 괄호 ) 또는 ）,
        // 시간 부분에서는 일반 콜론(:)과 전각 콜론(：) 모두 허용합니다.
        let pattern = "([\\(（]\\s*\\d{1,2}\\s*(?:[:\u{FF1A}])\\s*\\d{2}\\s*[\\)）])(.*?)(?=[\\(（]\\s*\\d{1,2}\\s*(?:[:\u{FF1A}])\\s*\\d{2}\\s*[\\)）]|$)"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) else {
            return []
        }
        
        let nsScript = script as NSString
        let results = regex.matches(in: script, options: [], range: NSRange(location: 0, length: nsScript.length))
        
        return results.map { match in
            let time = nsScript.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespacesAndNewlines)
            let text = nsScript.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)
            return (time, text)
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

extension Script {
    /// 한국어와 일본어 스크립트를 병합합니다.
    /// - Parameter tolerance: 두 타임스탬프가 같은 시간대로 판단할 허용 오차 (초)
    /// - Returns: (time, seconds, korText, jpnText) 튜플 배열
    func mergeScripts(tolerance: Double = 1.0) -> [(time: String, seconds: Double, korText: String, jpnText: String)] {
        // 두 언어의 파싱 결과
        let korParsed = self.parseScript(self.script_KOR)    // [(time, text)]
        let jpnParsed = self.parseScript(self.script_JPN)
        let korTimes = self.parseTimestamp(self.script_KOR)  // [(time, seconds)]
        let jpnTimes = self.parseTimestamp(self.script_JPN)
        
        var merged: [(time: String, seconds: Double, korText: String, jpnText: String)] = []
        var i = 0
        var j = 0
        
        while i < korParsed.count || j < jpnParsed.count {
            if i < korParsed.count && j < jpnParsed.count {
                let korSec = korTimes[i].seconds
                let jpnSec = jpnTimes[j].seconds
                let diff = abs(korSec - jpnSec)
                
                if diff < tolerance {
                    // 같은 시간대로 판단 (한국어의 타임스탬프 사용)
                    merged.append((time: korParsed[i].time, seconds: korSec, korText: korParsed[i].text, jpnText: jpnParsed[j].text))
                    i += 1
                    j += 1
                } else if korSec < jpnSec {
                    merged.append((time: korParsed[i].time, seconds: korSec, korText: korParsed[i].text, jpnText: ""))
                    i += 1
                } else {
                    merged.append((time: jpnParsed[j].time, seconds: jpnSec, korText: "", jpnText: jpnParsed[j].text))
                    j += 1
                }
            } else if i < korParsed.count {
                merged.append((time: korParsed[i].time, seconds: korTimes[i].seconds, korText: korParsed[i].text, jpnText: ""))
                i += 1
            } else if j < jpnParsed.count {
                merged.append((time: jpnParsed[j].time, seconds: jpnTimes[j].seconds, korText: "", jpnText: jpnParsed[j].text))
                j += 1
            }
        }
        return merged
    }
    
    /// 병합된 스크립트를 바로 사용할 수 있도록 한 계산 프로퍼티
    var mergedScript: [(time: String, seconds: Double, korText: String, jpnText: String)] {
        return mergeScripts()
    }
}

// 숫자를 문자열에서 추출하는 헬퍼 함수
func extractNumber(from text: String) -> Int {
    // 문자열에서 모든 숫자 문자를 추출해서 하나의 문자열로 만든 후 정수로 변환
    let digits = text.compactMap { $0.wholeNumberValue }
    let numberString = digits.map(String.init).joined()
    return Int(numberString) ?? 0
}



/// 서버 API 응답을 위한 Codable 구조체
struct DecodableScript: Codable {
    let title: String
    let script_KOR: String?
    let script_JPN: String?
    let youtube_url: String
    let artist: String
}
