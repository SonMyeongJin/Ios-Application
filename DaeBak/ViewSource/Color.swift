//
//  GlobalBackground.swift
//  DaeBak
//
//  Created by 손명진 on 2/2/25.
//

import SwiftUI

// 로딩 배경 진한 갈색
struct LoadingBackground: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            (isDarkMode ? Color(red: 34/255, green: 14/255, blue: 2/255) : Color(red: 68 / 255, green: 28 / 255, blue: 4 / 255))
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 기본 뱁경 옅은 갈색
struct GlobalBackground: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            (isDarkMode ? Color(red: 94/255, green: 74/255, blue: 59/255) : Color(red: 188 / 255, green: 148 / 255, blue: 118 / 255))
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 목록, 스크립트 부분 베이지 색
struct ScriptBackground: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    func body(content: Content) -> some View {
        ZStack {
            (isDarkMode ? Color(red: 105/255, green: 95/255, blue: 85/255) : Color(red: 205 / 255, green: 190 / 255, blue: 176 / 255))
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// 제목 글씨 색상
struct TitleColor: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    func body(content: Content) -> some View {
        content
            .foregroundColor(isDarkMode ? Color(red: 200/255, green: 120/255, blue: 60/255) : Color(red: 241 / 255, green: 163 / 255, blue: 92 / 255))
    }
}

// 컨텐츠 글씨 색상
struct ContentColor: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    func body(content: Content) -> some View {
        content
            .foregroundColor(isDarkMode ? Color(red: 200/255, green: 170/255, blue: 140/255) : Color(red: 247 / 255, green: 200 / 255, blue: 171 / 255))
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
