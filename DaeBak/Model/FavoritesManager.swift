//
//  FavoritesManager.swift
//  DaeBak
//
//  Created by 손명진 on 1/25/25.
//

import Foundation

struct FavoritesManager {
    private static let key = "favoriteScripts"

    // 즐겨찾기 상태 토글
    static func toggleFavorite(for scriptID: String) {
        var favorites = loadFavorites()
        if favorites.contains(scriptID) {
            favorites.removeAll { $0 == scriptID }
        } else {
            favorites.append(scriptID)
        }
        saveFavorites(favorites)
    }

    // 특정 스크립트가 즐겨찾기인지 확인
    static func isFavorite(scriptID: String) -> Bool {
        return loadFavorites().contains(scriptID)
    }

    // 즐겨찾기 상태 저장
    private static func saveFavorites(_ favorites: [String]) {
        UserDefaults.standard.set(favorites, forKey: key)
    }

    // 즐겨찾기 상태 로드
    static func loadFavorites() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    // 즐겨찾기된 스크립트만 필터링하는 메서드
      static func favoriteScripts(from scripts: [Script]) -> [Script] {
          return scripts.filter { isFavorite(scriptID: $0.title) }
      }
}
