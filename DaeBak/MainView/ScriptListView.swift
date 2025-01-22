//
//  ScriptpListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/23/25.
//

import SwiftUI

struct ScriptListView: View {
    let artist: Artist
    let allScripts: [Script]
    
    var body: some View {
        let filteredScripts = Script.scripts(for: artist.rawValue, from: allScripts)
        
        List(filteredScripts) { script in
            NavigationLink(destination: DetailPage(script: script)) { // DetailPage로 이동
                Text(script.title)
                    .font(.headline)
            }
        }
        .navigationTitle("\(artist.rawValue)의 스크립트 목록")
    }
}

#Preview {
    // 테스트용 Artist
    let testArtist = Artist.BTS
    
    // 테스트용 Script 데이터
    let testScripts = [
        Script(
            title: "Dynamite",
            script_KOR: "[0:05] 안녕하세요",
            script_JPN: "[0:05] こんにちは",
            youtube_url: "https://www.youtube.com/watch?v=gdZLi9oWNZg",
            artist: "BTS"
        ),
        Script(
            title: "Butter",
            script_KOR: "[0:10] 반갑습니다",
            script_JPN: "[0:10] はじめまして",
            youtube_url: "https://www.youtube.com/watch?v=WMweEpGlu_U",
            artist: "BTS"
        )
    ]
    
    return ScriptListView(artist: testArtist, allScripts: testScripts)
}
