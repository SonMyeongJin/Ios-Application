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
    
    // 현재 선택된 탭을 관리하는 상태 변수
    @State private var selectedTab: Tab = .allScripts
    
    // 탭 종류 정의
    enum Tab {
        case allScripts
        case favorites
    }
    
    var body: some View {
        VStack {
            // 탭 뷰
            TabView(selection: $selectedTab) {
                // 모든 목록 탭
                ListView(scripts: Script.scripts(for: artist.rawValue, from: allScripts))
                    .tabItem {
                        Label("모든 목록", systemImage: "list.bullet")
                    }
                    .tag(Tab.allScripts)
                
                // 즐겨찾기 목록 탭
                ListView(scripts: FavoritesManager.favoriteScripts(from: allScripts))
                    .tabItem {
                        Label("즐겨찾기", systemImage: "heart.fill")
                    }
                    .tag(Tab.favorites)
                
            }
            .navigationTitle("\(artist.rawValue)의 스크립트 목록")

        }
    }
    
    // 리스트 뷰를 재사용하기 위한 하위 뷰
    private struct ListView: View {
        let scripts: [Script]
        
        var body: some View {
            List(scripts) { script in
                NavigationLink(destination: DetailPage(script: script)) {
                    ScriptRowView(script: script)
                }
                .listRowBackground(Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
            }
        }
    }
}

#Preview {
    let scripts: [Script] = Script.loadFromJSON(fileName: "testScript")
    return ScriptListView(artist: .BTS, allScripts: scripts)
}
