//
//  ScriptView.swift
//  DaeBak
//
//  Created by 손명진 on 1/15/25.
//

import SwiftUI

struct ScriptView: View {
    @State var script: Script
    
    var body: some View {
        VStack{
            Text("Title")
                .font(.headline)
            TextField("Enter title", text: $script.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("한국어 자막")
                .font(.headline)
            TextEditor(text: $script.script_KOR)
                .border(Color.gray,width: 1)
                .frame(height: 100)
            
            Text("일본어 자막")
            TextEditor(text: $script.script_JPN)
                            .border(Color.gray, width: 1)
                            .frame(height: 100)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Script Details")
    }
}

#Preview {
    let testScripts = Script.loadFromJSON(fileName: "testScript")
       guard let firstScript = testScripts.first else {
           fatalError("테스트 JSON 파일에서 데이터를 읽어오지 못했습니다.")
       }
       return ScriptView(script: firstScript)
}
