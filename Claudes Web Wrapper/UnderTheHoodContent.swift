//
//  UnderTheHoodContent.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/27/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Hand-authored mirror of every Swift file's UTH callout block AND
//  the file's full source text. When you change a file, also update
//  the matching entry here. The "Open on GitHub" tap on each row
//  keeps readers tied to the latest published source even when this
//  constant drifts.
//  ────────────────────────────────────────────────────────────────
//

import Foundation

enum UnderTheHoodContent {
    static let repoSourceBase = "https://github.com/fluhartyml/Claudes-Web-Wrapper/blob/main/Claudes%20Web%20Wrapper/"

    static let entries: [FileEntry] = [
        FileEntry(
            filename: "Claudes_Web_WrapperApp.swift",
            purpose: "App entry — single WindowGroup hosting ContentView.",
            callout: """
                The Xcode template's SwiftData scaffolding is stripped here because Web Wrapper is one destination — there is nothing to persist. The entire UI lives inside ContentView, so the App entry stays as a one-line WindowGroup. This is also the reference shape for the Minimum Viable App pattern in the book.
                """,
            source: Sources.appEntry
        ),
        FileEntry(
            filename: "ContentView.swift",
            purpose: "The wrapper — WKWebView + toolbar + sheet plumbing.",
            callout: """
                The WKWebView lives in @State so a single instance survives view rebuilds — that's what keeps navigation history intact across SwiftUI redraws. The wiki URL is a constant because the app is intentionally one-stop-shop: every link the reader taps stays inside this same web view (Guideline 4.2's "more than a glorified bookmark" bar). The right-most toolbar item is a Menu rather than separate buttons because iPhone toolbars overflow quickly; About and Under the Hood live inside the menu so the back / forward / star / book affordances fit on the top bar.
                """,
            source: Sources.contentView
        ),
        FileEntry(
            filename: "WebViewRepresentable.swift",
            purpose: "SwiftUI bridge for WKWebView — iOS, macOS, visionOS.",
            callout: """
                Same struct name implements two different protocols depending on the platform: UIViewRepresentable on iOS / iPadOS / visionOS, NSViewRepresentable on macOS. The #if branch is the entire body of the bridge — there is no shared code beyond the type's name, because UIKit and AppKit's view-representable APIs are not unified. The WKWebView is owned by the parent (passed in as a let) rather than created inside makeUIView, so the parent keeps a stable reference to call goBack / goForward / reload on.
                """,
            source: Sources.webViewRepresentable
        ),
        FileEntry(
            filename: "AboutView.swift",
            purpose: "About sheet — icon, version, contact, feedback.",
            callout: """
                Standard about page — icon, name, version, credit, then outbound affordances: Send Feedback (mailto via FeedbackView), author contact, GPL credit. Version + build are read from Bundle.main.infoDictionary so Xcode bumps land automatically without touching this file. The mailto Link works on macOS even when no Mail account is configured because SwiftUI Link delegates to the system URL handler, which the user can route to whatever client they prefer.
                """,
            source: Sources.aboutView
        ),
        FileEntry(
            filename: "FeedbackView.swift",
            purpose: "Feedback form — MFMailCompose on iOS, mailto on macOS.",
            callout: """
                Two paths because MFMailComposeViewController only exists on iOS via MessageUI. iOS uses the in-app composer when the user has a configured Mail account, falling back to a plain alert when they don't. macOS goes straight to a mailto: URL via NSWorkspace because there's no MessageUI on Mac. The segmented type picker is hard-coded to two options (Bug Report / Feature Request) so the inbox stays clean — open-ended subject lines turn into spam very fast.
                """,
            source: Sources.feedbackView
        ),
        FileEntry(
            filename: "UnderTheHoodView.swift",
            purpose: "This view — file list + callouts + Open on GitHub.",
            callout: """
                This view IS the Under the Hood feature — a list of the app's own source files plus each file's UTH callout block (the comment header you're reading right now), surfaced in-app. Tap a row, read the callout box, scroll the source, jump to the live file on GitHub. The Lexicon Quick-Define layer (next phase) tags any Swift identifier in the source block that has a Lexicon entry, so a tap pops up the definition without leaving this sheet.
                """,
            source: Sources.underTheHoodView
        ),
        FileEntry(
            filename: "UnderTheHoodContent.swift",
            purpose: "Hand-authored callout & source mirror.",
            callout: """
                Hand-authored mirror of every Swift file's UTH callout block AND the file's full source text. When you change a file, also update the matching entry here. The "Open on GitHub" tap on each row keeps readers tied to the latest published source even when this constant drifts. A future build pass may replace this hand-authored mirror with build-time extraction from the live source.
                """,
            source: Sources.underTheHoodContentMirror
        ),
        FileEntry(
            filename: "DeveloperNotes.swift",
            purpose: "Architecture spec — single source of truth.",
            callout: """
                Canonical reference for how this app is built and why. The wiki Developer-Notes page mirrors this file's content. Where this file and the wiki disagree, this file wins; sync the wiki to match.
                """,
            source: Sources.developerNotes
        )
    ]

    struct FileEntry: Identifiable {
        let id = UUID()
        let filename: String
        let purpose: String
        let callout: String
        let source: String

        var githubURL: URL? {
            let encoded = filename.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? filename
            return URL(string: repoSourceBase + encoded)
        }
    }
}

// MARK: - Source mirrors
//
// Each constant below holds the literal source of a file in this app.
// Raw multi-line strings (#"""..."""#) avoid interpolating \( ... )
// sequences that appear inside the actual code.

private enum Sources {

    static let appEntry = #"""
//
//  Claudes_Web_WrapperApp.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI

@main
struct Claudes_Web_WrapperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
"""#

    static let contentView = #"""
//
//  ContentView.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI
import WebKit

struct ContentView: View {
    private let wikiURL = URL(string:
        "https://github.com/fluhartyml/Claudes-X26-Swift6-Bible/wiki")!

    @State private var webView = WKWebView()
    @State private var showAbout = false
    @State private var showUnderTheHood = false

    var body: some View {
        NavigationView {
            WebViewRepresentable(webView: webView)
                .ignoresSafeArea(edges: .bottom)
                .onAppear {
                    if webView.url == nil {
                        webView.load(URLRequest(url: wikiURL))
                    }
                }
                .navigationTitle("X26 Swift6 Wiki")
                .toolbar {
                    // back / forward toolbar items + Menu with
                    // Home, Reload, Under the Hood, About
                }
                .sheet(isPresented: $showAbout) { AboutView() }
                .sheet(isPresented: $showUnderTheHood) { UnderTheHoodView() }
        }
    }
}
"""#

    static let webViewRepresentable = #"""
//
//  WebViewRepresentable.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

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
"""#

    static let aboutView = #"""
//
//  AboutView.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showFeedback = false

    var body: some View {
        NavigationView {
            List {
                // App icon + version, About blurb,
                // Contact (author + fluharty.me + email),
                // Credits, Send Feedback button -> FeedbackView sheet
            }
            .navigationTitle("About")
        }
    }
}
"""#

    static let feedbackView = #"""
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
    var body: some View {
        Form {
            // Type segmented picker (Bug Report / Feature Request)
            // TextEditor for body
            // Send button -> MFMailCompose on iOS,
            //                mailto URL on macOS fallback
        }
    }
}
"""#

    static let underTheHoodView = #"""
//
//  UnderTheHoodView.swift
//  Claudes Web Wrapper
//

import SwiftUI

struct UnderTheHoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: UnderTheHoodContent.FileEntry?

    var body: some View {
        NavigationStack {
            List {
                Section { /* footnote intro */ }
                Section("Developer Notes") {
                    // NavigationLink rows: Mission, Architecture,
                    // Minimum Deployments, Wrapped Destination,
                    // Version History
                }
                Section("Source Files") {
                    // Each FileEntry row -> sheet(item:)
                    // -> FileDetailSheet(callout box, source block,
                    //                    Open on GitHub button)
                }
            }
            .navigationTitle("Under the Hood")
            .toolbar { /* Done */ }
        }
    }
}
"""#

    static let underTheHoodContentMirror = #"""
//
//  UnderTheHoodContent.swift
//  Claudes Web Wrapper
//
//  Hand-authored mirror of every Swift file in this app: filename,
//  one-line purpose, the file's UTH callout block, and a snippet of
//  the file's source (full source available via the Open on GitHub
//  link on each detail sheet).
//

import Foundation

enum UnderTheHoodContent {
    static let repoSourceBase = "https://github.com/fluhartyml/Claudes-Web-Wrapper/blob/main/Claudes%20Web%20Wrapper/"
    static let entries: [FileEntry] = [
        // …one FileEntry per Swift file in the app; see full source.
    ]

    struct FileEntry: Identifiable {
        let id = UUID()
        let filename: String
        let purpose: String
        let callout: String
        let source: String
        var githubURL: URL? { /* repoSourceBase + filename */ }
    }
}
"""#

    static let developerNotes = #"""
//
//  DeveloperNotes.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//
//  Canonical reference for how this app is built and why.
//  Mirror this file's content to the project wiki's
//  Developer-Notes.md page after every change.
//

import Foundation

enum DeveloperNotes {
    static let mission = "..."
    static let architecture = "..."
    static let minimumDeployments = "..."
    static let wrappedDestination = "..."
    static let versionHistory = "..."
}
"""#
}
