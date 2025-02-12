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
                ProgressView("로딩중...")
                    .onAppear {
                        loadScripts()
                    }
            } else {
                TabView(selection: $selectedTab) {
                    // 모든 목록 탭 (네트워크에서 가져온 전체 스크립트)
                    ListView(scripts: scripts)
                        .tabItem {
                            Label("모든 목록", systemImage: "list.bullet")
                        }
                        .tag(Tab.allScripts)
                    
                    // 즐겨찾기 탭 (FavoritesManager를 통해 필터링; 기존 기능 활용)
                    ListView(scripts: FavoritesManager.favoriteScripts(from: scripts))
                        .tabItem {
                            Label("즐겨찾기", systemImage: "heart.fill")
                        }
                        .tag(Tab.favorites)
                }
                .navigationTitle("\(artist.rawValue)의 스크립트 목록")
            }
        }
    }
    
    /// 선택한 아티스트의 스크립트 목록을 네트워크에서 로드합니다.
    private func loadScripts() {
        Script.fetchList(artist: artist.rawValue) { fetchedScripts in
            DispatchQueue.main.async {
                self.scripts = fetchedScripts
                self.isLoading = false
            }
        }
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
