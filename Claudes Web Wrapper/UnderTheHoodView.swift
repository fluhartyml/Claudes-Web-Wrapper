//
//  UnderTheHoodView.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//
//  Surfaces the app's source, architecture, and developer notes inside the
//  app itself so curious readers can study the implementation without opening
//  Xcode. Mirrors the book's "Under the Hood" convention for every
//  Claude Xcode 26 Swift Bible build-along.
//

import SwiftUI

struct UnderTheHoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFile: SourceFile?

    var body: some View {
        NavigationView {
            List {
                Section("Mission") {
                    Text(DeveloperNotes.mission)
                        .font(.body)
                }

                Section("Architecture") {
                    Text(DeveloperNotes.architecture)
                        .font(.body)
                }

                Section("Minimum Deployments") {
                    Text(DeveloperNotes.minimumDeployments)
                        .font(.body)
                }

                Section("Wrapped Destination") {
                    Text(DeveloperNotes.wrappedDestination)
                        .font(.body)
                }

                Section("Version History") {
                    Text(DeveloperNotes.versionHistory)
                        .font(.body)
                }

                Section("Source Files") {
                    ForEach(SourceFile.allFiles) { file in
                        Button {
                            selectedFile = file
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(file.name)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundStyle(.primary)
                                Text(file.description)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Under the Hood")
            #if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            #else
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            #endif
            .sheet(item: $selectedFile) { file in
                SourceFileViewer(file: file)
            }
        }
        #if os(iOS) || os(visionOS)
        .navigationViewStyle(.stack)
        #endif
    }
}

struct SourceFileViewer: View {
    let file: SourceFile
    @Environment(\.dismiss) private var dismiss
    @State private var copied = false

    var body: some View {
        NavigationView {
            ScrollView([.horizontal, .vertical]) {
                Text(file.source)
                    .font(.system(.callout, design: .monospaced))
                    .fixedSize(horizontal: true, vertical: false)
                    .textSelection(.enabled)
                    .padding()
            }
            .navigationTitle(file.name)
            #if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        copyToClipboard(file.source)
                    } label: {
                        Label(copied ? "Copied" : "Copy",
                              systemImage: copied ? "checkmark" : "doc.on.doc")
                    }
                }
            }
            #else
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        copyToClipboard(file.source)
                    } label: {
                        Label(copied ? "Copied" : "Copy",
                              systemImage: copied ? "checkmark" : "doc.on.doc")
                    }
                }
            }
            #endif
        }
        #if os(iOS) || os(visionOS)
        .navigationViewStyle(.stack)
        #endif
    }

    private func copyToClipboard(_ text: String) {
        #if os(iOS) || os(visionOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            copied = false
        }
    }
}

struct SourceFile: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let source: String

    static let allFiles: [SourceFile] = [
        SourceFile(
            name: "Claudes_Web_WrapperApp.swift",
            description: "App entry point — one WindowGroup, one ContentView",
            source: """
            import SwiftUI

            @main
            struct Claudes_Web_WrapperApp: App {
                var body: some Scene {
                    WindowGroup {
                        ContentView()
                    }
                }
            }
            """
        ),
        SourceFile(
            name: "ContentView.swift",
            description: "Main wrapper — WKWebView + toolbar + info menu",
            source: """
            import SwiftUI
            import WebKit

            struct ContentView: View {
                private let wikiURL = URL(string:
                    "https://github.com/fluhartyml/Claudes-Xcode-26-Swift-Bible/wiki")!

                @State private var webView = WKWebView()
                @State private var showAbout = false
                @State private var showUnderTheHood = false

                var body: some View {
                    NavigationView {
                        WebViewRepresentable(webView: webView)
                            .ignoresSafeArea(edges: .bottom)
                            .onAppear { webView.load(URLRequest(url: wikiURL)) }
                            .toolbar { ... back/forward/reload/home + info menu ... }
                    }
                }
            }
            """
        ),
        SourceFile(
            name: "WebViewRepresentable.swift",
            description: "SwiftUI bridge for WKWebView — iOS and macOS",
            source: """
            import SwiftUI
            import WebKit

            #if os(iOS) || os(visionOS)
            struct WebViewRepresentable: UIViewRepresentable {
                let webView: WKWebView

                func makeUIView(context: Context) -> WKWebView {
                    webView.allowsBackForwardNavigationGestures = true
                    return webView
                }

                func updateUIView(_ uiView: WKWebView, context: Context) {}
            }
            #elseif os(macOS)
            struct WebViewRepresentable: NSViewRepresentable {
                let webView: WKWebView

                func makeNSView(context: Context) -> WKWebView {
                    webView.allowsBackForwardNavigationGestures = true
                    return webView
                }

                func updateNSView(_ nsView: WKWebView, context: Context) {}
            }
            #endif
            """
        ),
        SourceFile(
            name: "AboutView.swift",
            description: "App info — icon, version, contact, feedback",
            source: """
            import SwiftUI

            struct AboutView: View {
                var body: some View {
                    NavigationView {
                        List {
                            // App icon + version
                            // Contact: author, fluharty.me, email
                            // Credits: Engineered with Claude by Anthropic
                            // Send Feedback button -> FeedbackView sheet
                        }
                        .navigationTitle("About")
                    }
                }
            }
            """
        ),
        SourceFile(
            name: "UnderTheHoodView.swift",
            description: "This view — mission, architecture, every source file",
            source: """
            import SwiftUI

            struct UnderTheHoodView: View {
                var body: some View {
                    NavigationView {
                        List {
                            // Mission, Architecture, Deployments, Destination,
                            // Version History (from DeveloperNotes)
                            // Source Files list -> SourceFileViewer sheet
                        }
                        .navigationTitle("Under the Hood")
                    }
                }
            }
            """
        ),
        SourceFile(
            name: "FeedbackView.swift",
            description: "Bug report / feature request email form",
            source: """
            import SwiftUI
            import MessageUI

            struct FeedbackView: View {
                var body: some View {
                    Form {
                        Picker("Type", selection: $feedbackType) { ... }
                        Section("Your Feedback") {
                            TextEditor(text: $feedbackText)
                        }
                        Button("Send") {
                            // MFMailComposeViewController on iOS,
                            // mailto: URL on macOS fallback
                        }
                    }
                }
            }
            """
        ),
        SourceFile(
            name: "DeveloperNotes.swift",
            description: "Canonical reference — mirrors wiki Developer-Notes.md",
            source: """
            enum DeveloperNotes {
                static let mission = "..."
                static let architecture = "..."
                static let minimumDeployments = "..."
                static let wrappedDestination = "..."
                static let versionHistory = "..."
            }
            """
        ),
    ]
}

#Preview {
    UnderTheHoodView()
}
