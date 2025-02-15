//
//  ScriptListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/23/25.
//

import SwiftUI

struct ScriptListView: View {
    let artist: Artist
    @State private var scripts: [Script] = []
    @State private var selectedTab: Tab = .allScripts
    @State private var isLoading: Bool = true
    
    enum Tab {
        case allScripts, favorites
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .onAppear {
                        loadScripts()
                    }
            } else {
                TabView(selection: $selectedTab) {
                    // 모든 목록 탭 (네트워크에서 가져온 전체 스크립트)
                    ListView(scripts: scripts)
                        .tabItem {
                            Label("All List", systemImage: "list.bullet")
                        }
                        .tag(Tab.allScripts)
                    
                    // 즐겨찾기 탭 (FavoritesManager를 통해 필터링; 기존 기능 활용)
                    ListView(scripts: FavoritesManager.favoriteScripts(from: scripts))
                        .tabItem {
                            Label("Favorites", systemImage: "heart.fill")
                        }
                        .tag(Tab.favorites)
                }
                .navigationTitle("\(artist.rawValue)の話")
                .toolbar {
                    ToolbarItem(placement: .principal) { // 중앙 정렬
                        Text("[\(artist.rawValue)]の話")
                            .font(.system(size: 24, weight: .bold)) // 폰트 크기 & 굵기 조절
                            .foregroundColor(Color(red: 156 / 255, green: 102 / 255, blue: 68 / 255)) // 원하는 색상 적용
                    }
                }

            }
        }
    }
    
    private func loadScripts() {
        Script.fetchList(artist: artist.rawValue) { fetchedScripts in
            DispatchQueue.main.async {
                self.scripts = fetchedScripts.sorted {
                    $0.title.localizedStandardCompare($1.title) == .orderedAscending
                }
                self.isLoading = false
            }
        }
    }


    /// 제목에서 숫자를 추출하는 헬퍼 함수
    private func extractNumber(from title: String) -> Int {
        // 정규 표현식으로 첫 번째 등장하는 숫자 추출
        if let range = title.range(of: "\\d+", options: .regularExpression) {
            let numberString = String(title[range])
            return Int(numberString) ?? 0
        }
        return 0
    }

    
    /// 스크립트 목록을 표시하는 하위 뷰
    private struct ListView: View {
        let scripts: [Script]
        var body: some View {
            List(scripts) { script in
                NavigationLink(destination: DetailPage(script: script)) {
                    ScriptRowView(script: script) // 기존에 정의된 ScriptRowView 사용
                }
                .listRowBackground(Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
            }
            .scrollContentBackground(.hidden)
            .globalBackground()
        }
    }
}

#Preview {
    // 프리뷰에서는 로컬 JSON 파일(testScript)을 사용해 미리보기 가능
    return ScriptListView(artist: .BTS)
}
