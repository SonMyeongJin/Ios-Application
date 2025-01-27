//
//  Artist.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import Foundation

enum Artist: String, CaseIterable, Identifiable {
    case BTS
    case ASTRO
    case SEVENTEEN
    case LESSERAFIM
    case AESPA
    case BLACKPINK

    var id: String { self.rawValue } // Identifiable을 위한 id
    
    // 추가 속성: 설명, 이미지 URL 등
    var description: String {
        switch self {
        case .BTS: return "방탄소년단"
        case .ASTRO: return "아스트로"
        case .SEVENTEEN: return "세븐틴"
        case .LESSERAFIM: return "르세라핌"
        case .AESPA: return "에스파"
        case .BLACKPINK: return "블랙핑크"
        }
    }
}
