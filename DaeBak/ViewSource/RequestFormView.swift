import SwiftUI
import MessageUI

struct RequestFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var requestedArtist: String = ""
    @State private var videoTitle: String = ""
    @State private var showingConfirmation: Bool = false
    @State private var showingEmailComposer: Bool = false
    @State private var canSendEmail: Bool = false
    
    let supportEmail = "smj2802@naver.com"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("動画リクエスト")) {
                    TextField("アーティスト", text: $requestedArtist)
                    TextField("動画タイトル", text: $videoTitle)
                }
                
                Section {
                    Button("リクエストする") {
                        sendRequest()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 156/255, green: 102/255, blue: 68/255))
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("リクエスト後、1週間以内に動画を追加いたします。リクエスト後も動画がアップロードされない場合は、下記のメールアドレスまでご連絡いただければ幸いです。")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text(supportEmail)
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("動画リクエスト")
            .navigationBarItems(trailing: Button("キャンセル") {
                dismiss()
            })
            .sheet(isPresented: $showingEmailComposer) {
                EmailComposer(
                    recipient: supportEmail,
                    subject: "動画リクエスト: \(requestedArtist)",
                    body: "アーティスト: \(requestedArtist)\n動画タイトル: \(videoTitle)",
                    isPresented: $showingEmailComposer
                )
            }
            .alert(canSendEmail ? "リクエストが完了しました" : "メールを送信できません", isPresented: $showingConfirmation) {
                Button("確認") {
                    if canSendEmail {
                        dismiss()
                    }
                }
            } message: {
                Text(canSendEmail ? "リクエストありがとうございます。" : "メールアプリが設定されていません。\(supportEmail)に直接メールを送ってください。")
            }
        }
    }
    
    private func sendRequest() {
        if MFMailComposeViewController.canSendMail() {
            showingEmailComposer = true
            canSendEmail = true
        } else {
            sendEmailWithMailApp()
        }
    }
    
    private func sendEmailWithMailApp() {
        let subject = "動画リクエスト: \(requestedArtist)"
        let body = "アーティスト: \(requestedArtist)\n動画タイトル: \(videoTitle)"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let emailUrl = URL(string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)")
        
        if let url = emailUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            showingConfirmation = true
            canSendEmail = true
        } else {
            canSendEmail = false
            showingConfirmation = true
        }
    }
}

struct EmailComposer: UIViewControllerRepresentable {
    let recipient: String
    let subject: String
    let body: String
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients([recipient])
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: EmailComposer
        
        init(_ parent: EmailComposer) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isPresented = false
        }
    }
}
