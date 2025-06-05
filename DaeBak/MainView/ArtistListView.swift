//
//  ArtistListView.swift
//  DaeBak
//
//  Created by 손명진 on 1/22/25.
//

import SwiftUI
import MessageUI

struct ArtistListView: View {
    @State private var isRequestSheetPresented: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            NavigationView {
                Group {
                    if isLandscape {
                        // 가로모드: HStack으로 배치
                        HStack(alignment: .top, spacing: 32) {
                            VStack(alignment: .leading, spacing: 24) {
                                // 다크모드 토글
                                HStack(spacing: 6) {
                                    Text("Dark Mode")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Toggle(isOn: $isDarkMode) {
                                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                            .foregroundColor(isDarkMode ? .yellow : .orange)
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: .brown))
                                    .frame(width: 60)
                                }
                                .padding(.vertical, 3)
                                .padding(.horizontal, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(.systemGray6).opacity(0.7))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.brown.opacity(0.4), lineWidth: 1)
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                                .padding(.leading, 10)
                                // 제목 뷰
                                TitleView(title: "K-POP の 魅力")
                                    .padding(.leading, 0)
                                // 신청하기 버튼
                                RequestButton(action: {
                                    isRequestSheetPresented = true
                                })
                                .padding(.bottom, 20)
                            }
                            .frame(width: geometry.size.width * 0.35)
                            // 아티스트 뷰
                            VStack(spacing: 0) {
                                ScrollView {
                                    LazyVGrid(columns: [
                                        GridItem(.flexible(), spacing: 20),
                                        GridItem(.flexible(), spacing: 20)
                                    ], spacing: 50) {
                                        ForEach(Artist.allCases) { artist in
                                            NavigationLink(destination: ScriptListView(artist: artist)) {
                                                MarkView(artist: artist)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .frame(width: geometry.size.width * 0.6)
                        }
                    } else {
                        // 기존 세로모드 레이아웃
                        VStack {
                            // 다크모드 토글 스위치
                            HStack(spacing: 6) {
                                Text("Dark Mode")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Toggle(isOn: $isDarkMode) {
                                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(isDarkMode ? .yellow : .orange)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .brown))
                                .frame(width: 60)
                            }
                            .padding(.vertical, 3)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color(.systemGray6).opacity(0.7))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.brown.opacity(0.4), lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top, 1)
                            .padding(.trailing, 10)
                            // 제목 뷰
                            TitleView(title: "K-POP の 魅力")
                            // 아티스트 뷰
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 20),
                                    GridItem(.flexible(), spacing: 20)
                                ], spacing: 50) {
                                    ForEach(Artist.allCases) { artist in
                                        NavigationLink(destination: ScriptListView(artist: artist)) {
                                            MarkView(artist: artist)
                                        }
                                    }
                                }
                                .padding()
                            }
                            // 신청하기 버튼
                            RequestButton(action: {
                                isRequestSheetPresented = true
                            })
                            .padding(.bottom, 20)
                        }
                    }
                }
                .globalBackground()
                .sheet(isPresented: $isRequestSheetPresented) {
                    RequestFormView()
                }
            }
        }
    }
}

// 하단에 신청하기 버튼 컴포넌트
struct RequestButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "video.badge.plus")
                    .font(.title2)
                Text("この動画もお願い！")
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 156/255, green: 102/255, blue: 68/255),
                        Color(red: 205/255, green: 190/255, blue: 176/255)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// 버튼 누를 때 애니메이션 효과를 위한 버튼 스타일
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

#Preview {
    ArtistListView()
}
