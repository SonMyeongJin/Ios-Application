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
            Color(red: 188 / 255, green: 148 / 255, blue: 118 / 255)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 목록, 스크립트 부분 베이지 색
struct ScriptBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 제목 글씨 색상
struct TitleColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(red: 241 / 255, green: 163 / 255, blue: 92 / 255))
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
    func scriptBackground() -> some View {
        self.modifier(ScriptBackground())
    }
}
