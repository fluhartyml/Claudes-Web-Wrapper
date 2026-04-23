//
//  DeveloperNotes.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//
//  Canonical reference for how this app is built and why.
//  Mirror this file's content to the project wiki's Developer-Notes.md page
//  after every change.
//

import Foundation

enum DeveloperNotes {
    static let mission = """
    Claude's Web Wrapper is the first build-along app in Claude's Xcode 26 Swift Bible.
    It wraps the book's GitHub Wiki so readers can browse all 22 Books, the Lexicon, \
    the Index, and the Bibliography inside a native app instead of a browser tab. \
    The app is deliberately narrow in scope: one destination, one WKWebView, \
    plus an About view and an Under the Hood view. Every design choice in this \
    project is chosen so the reader can copy the pattern into their own first app.
    """

    static let architecture = """
    SwiftUI + WebKit. No SwiftData, no CloudKit, no custom networking.

    • Claudes_Web_WrapperApp.swift — App entry; one WindowGroup hosting ContentView.
    • ContentView.swift — The wrapper. Holds a single WKWebView, loads the wiki on \
      appear, toolbar with back/forward/reload/home plus a menu for About and \
      Under the Hood.
    • WebViewRepresentable.swift — SwiftUI bridge for WKWebView. UIViewRepresentable \
      on iOS/iPadOS/visionOS, NSViewRepresentable on macOS.
    • AboutView.swift — Standard about page: icon, version, credit, feedback button.
    • UnderTheHoodView.swift — Lists every source file and shows its content \
      in a read-only viewer so curious readers can study the implementation.
    • FeedbackView.swift — Mail composer for Bug Report / Feature Request.
    • DeveloperNotes.swift — This file. Mirrors to wiki Developer-Notes.md.
    """

    static let minimumDeployments = """
    iOS 15.6 · iPadOS 15.6 · macOS 12.0 · visionOS 26.4

    The iOS floor is the lowest Xcode 26 allows for a new project. The macOS \
    floor was raised one notch above Xcode's lowest offering (11.5) to 12.0 \
    because several foundational SwiftUI APIs (notably @Environment(\\.dismiss)) \
    require macOS 12. That is the teaching moment of the Minimum Deployment \
    chapter: pick the lowest floor you can, then raise it only when a modern \
    API you actually need demands it.

    v1.x stays at this floor so the app reaches the largest possible user base. \
    v2.0 will raise the floor to the current iOS to adopt modern APIs; users on \
    older devices will automatically receive the final v1.x build via the App \
    Store's last-compatible-version fallback.
    """

    static let wrappedDestination = """
    https://github.com/fluhartyml/Claudes-Xcode-26-Swift-Bible/wiki

    The GitHub-hosted wiki of the book. Loaded at launch. Readers can tap any \
    link inside the wiki to navigate between Books, Chapters, Lexicon entries, \
    and Appendices without leaving the app (one-stop-shop principle).
    """

    static let versionHistory = """
    v1.0 — Ground-up rebuild (2026-04-23). First release of this app. \
    Predecessor "Wraply" remains live at id6762163478 as "Claude's Web Wrapper" \
    and is not modified; this app ships as a new App Store listing with a new \
    bundle ID and store ID.
    """
}
