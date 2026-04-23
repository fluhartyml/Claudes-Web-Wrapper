//
//  FeedbackView.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI
#if canImport(MessageUI)
import MessageUI
#endif

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackType = "Bug Report"
    @State private var feedbackText = ""
    @State private var showMailCompose = false
    @State private var showMailUnavailable = false

    private let feedbackTypes = ["Bug Report", "Feature Request"]
    private let feedbackEmail = "michael.fluharty@mac.com"

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $feedbackType) {
                    ForEach(feedbackTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(.segmented)

                Section("Your Feedback") {
                    TextEditor(text: $feedbackText)
                        .frame(minHeight: 150)
                }

                Button("Send") {
                    sendFeedback()
                }
                .disabled(feedbackText.isEmpty)
            }
            .navigationTitle("Send Feedback")
            #if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showMailCompose) {
                MailComposeView(
                    recipient: feedbackEmail,
                    subject: subjectLine,
                    body: feedbackText + "\n\n" + deviceInfo
                )
            }
            #else
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            #endif
            .alert("Mail Not Available", isPresented: $showMailUnavailable) {
                Button("OK") {}
            } message: {
                Text("Email \(feedbackEmail) directly.")
            }
        }
        #if os(iOS) || os(visionOS)
        .navigationViewStyle(.stack)
        #endif
    }

    private var subjectLine: String {
        "Claude's Web Wrapper \(feedbackType) — v\(appVersion)"
    }

    private func sendFeedback() {
        #if canImport(MessageUI) && !os(macOS)
        if MFMailComposeViewController.canSendMail() {
            showMailCompose = true
        } else {
            showMailUnavailable = true
        }
        #else
        let subject = subjectLine.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = feedbackText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "mailto:\(feedbackEmail)?subject=\(subject)&body=\(body)") {
            #if os(macOS)
            NSWorkspace.shared.open(url)
            #endif
            dismiss()
        }
        #endif
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }

    #if os(iOS) || os(visionOS)
    private var deviceInfo: String {
        let device = UIDevice.current
        return """
        --- Device Info ---
        App: Claude's Web Wrapper v\(appVersion)
        System: \(device.systemName) \(device.systemVersion)
        Locale: \(Locale.current.identifier)
        """
    }
    #else
    private var deviceInfo: String {
        let info = ProcessInfo.processInfo
        return """
        --- Device Info ---
        App: Claude's Web Wrapper v\(appVersion)
        System: macOS \(info.operatingSystemVersionString)
        Locale: \(Locale.current.identifier)
        """
    }
    #endif
}

#if canImport(MessageUI) && !os(macOS)
struct MailComposeView: UIViewControllerRepresentable {
    let recipient: String
    let subject: String
    let body: String
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients([recipient])
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(dismiss: dismiss) }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let dismiss: DismissAction
        init(dismiss: DismissAction) { self.dismiss = dismiss }
        func mailComposeController(_ controller: MFMailComposeViewController,
                                    didFinishWith result: MFMailComposeResult,
                                    error: Error?) {
            dismiss()
        }
    }
}
#endif
