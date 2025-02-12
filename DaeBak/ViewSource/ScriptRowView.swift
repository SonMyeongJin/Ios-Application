//
//  ScriptRowView.swift
//  DaeBak
//
//  Created by 손명진 on 1/25/25.
//

import SwiftUI

struct ScriptRowView: View {
    let script: Script
    @State private var isFavorite: Bool

    init(script: Script) {
        self.script = script
        self._isFavorite = State(initialValue: FavoritesManager.isFavorite(scriptID: script.title))
    }

    var body: some View {
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
                .foregroundColor(Color(red: 156 / 255, green: 102 / 255, blue: 68 / 255))
                .lineLimit(2)

            Spacer()

            // 즐겨찾기 버튼
            Button(action: {
                FavoritesManager.toggleFavorite(for: script.title) // 즐겨찾기 상태 변경
                isFavorite.toggle() // 상태 업데이트
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .buttonStyle(BorderlessButtonStyle()) // 버튼과 리스트 선택 분리
        }
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
    // 테스트 스크립트 생성
    let testScript = Script(
        title: "Test Video",
        script_KOR: "[0:00] 안녕하세요\n[0:05] 날씨가 좋네요",
        script_JPN: "[0:00] こんにちは\n[0:05] 天気がいいですね",
        youtube_url: "https://www.youtube.com/watch?v=ThhKlp1t_PU",
        artist: "BTS"
    )
    return ScriptRowView(script: testScript)
}
