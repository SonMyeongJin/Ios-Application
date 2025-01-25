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
    @State private var favorites: [String] = FavoritesManager.loadFavorites()
    
    var body: some View {
        let filteredScripts = Script.scripts(for: artist.rawValue, from: allScripts)
        
        
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
                    
                
                    // 즐겨찾기 버튼
                    Button(action: {
                        FavoritesManager.toggleFavorite(for: script.title) // 즐겨찾기 상태 변경
                        favorites = FavoritesManager.loadFavorites() // 상태 업데이트
                    }) {
                        Image(systemName: FavoritesManager.isFavorite(scriptID: script.title) ? "heart.fill" : "heart")
                            .foregroundColor(FavoritesManager.isFavorite(scriptID: script.title) ? .red : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle()) // 버튼과 리스트 선택 분리
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
