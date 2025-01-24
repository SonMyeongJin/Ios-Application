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
        
        NavigationStack{
            List(filteredScripts) { script in
                NavigationLink(destination: DetailPage(script: script)) { // DetailPage로 이동
                    HStack {
                        // 썸네일 이미지
                        if let videoID = extractVideoID(from: script.youtube_url) {
                            AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(videoID)/hqdefault.jpg")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 45)
                                    .cornerRadius(5)
                            } placeholder: {
                                ProgressView() // 로딩 중 표시
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 45)
                                .cornerRadius(5)
                        }
                        
                        // 스크립트 제목
                        Text(script.title)
                            .font(.headline)
                            .padding(.leading, 8)
                    }
                }
            }
        }
        .navigationTitle("\(artist.rawValue)의 스크립트 목록")
    }
    
    // 유튜브 URL에서 videoID 추출 함수
    private func extractVideoID(from url: String) -> String? {
        guard let components = URLComponents(string: url),
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
    
}

#Preview {
    let scripts: [Script] = Script.loadFromJSON(fileName: "testScript")
    return ScriptListView(artist: .BTS, allScripts: scripts)
}
