//
//  GlobalBackground.swift
//  DaeBak
//
//  Created by 손명진 on 2/2/25.
//

import SwiftUI

// 로딩 배경 진한 갈색
struct LoadingBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(red: 68 / 255, green: 28 / 255, blue: 4 / 255)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 기본 뱁경 옅은 갈색
struct GlobalBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(red: 143 / 255, green: 119 / 255, blue: 104 / 255)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 제목 글씨 색상
struct TitleColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(red: 236 / 255, green: 127 / 255, blue: 60 / 255))
    }
}

// 컨텐츠 글씨 색상
struct ContentColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(red: 247 / 255, green: 200 / 255, blue: 171 / 255))
    }
}



extension View {
    func globalBackground() -> some View {
        self.modifier(GlobalBackground())
    }
    func loadingBackground() -> some View {
        self.modifier(LoadingBackground())
    }
    func titleColor() -> some View {
        self.modifier(TitleColor())
    }
    func contentColor() -> some View {
        self.modifier(ContentColor())
    }
}
