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
    Claude's Web Wrapper is the first build-along app in Claude's X26 Swift6 book.
    It wraps the book's GitHub Wiki so readers can browse all 22 Books, the Lexicon, \
    the Index, and the Bibliography inside a native app instead of a browser tab. \
    The app is deliberately narrow in scope: one destination, one WKWebView, \
    plus an About view and an Under the Hood view. Every design choice in this \
    project is chosen so the reader can copy the pattern into their own first app.
    """

    static let architecture = """
    SwiftUI + WebKit + SwiftData. No CloudKit, no custom networking.

    • Claudes_Web_WrapperApp.swift — App entry; one WindowGroup hosting \
      ContentView, plus a SwiftData modelContainer for the Bookmark store.
    • ContentView.swift — The wrapper. Holds a single WKWebView, loads the \
      wiki on appear, toolbar with back/forward + star (save bookmark) + book \
      (open bookmarks list) + menu for Home, Reload, About, Under the Hood.
    • WebViewRepresentable.swift — SwiftUI bridge for WKWebView. \
      UIViewRepresentable on iOS / iPadOS / visionOS, NSViewRepresentable on macOS.
    • AboutView.swift — Standard about page: icon, version, credit, feedback button.
    • Bookmark.swift — SwiftData @Model — title, urlString, dateAdded.
    • BookmarksView.swift — @Query list with swipe-to-delete + tap-to-open \
      callback that loads the URL in the same WKWebView.
    • UnderTheHoodView.swift — File list + per-file callout sheet with \
      embedded source, Lexicon Quick-Define on tappable Swift identifiers, \
      and Open-on-GitHub button. Modeled after Audio Universe.
    • UnderTheHoodContent.swift — Hand-authored mirror of every file's UTH \
      callout block plus its full source. Sync rule: when a file changes, \
      update the matching entry here.
    • LexiconContent.swift — Starter corpus of Swift-identifier definitions; \
      tappable highlight in the Under the Hood source block fires only on \
      headwords present here. Grows as the wiki Lexicon page collection is \
      authored.
    • LexiconSheet.swift — NavigationStack-wrapped entry view; related-link \
      taps push the next entry onto the same stack.
    • IdentifierTaggedSourceView.swift — AttributedString tagger that wraps \
      every Lexicon-headword match with a lexicon:// URL link; the parent's \
      OpenURLAction interceptor presents LexiconSheet on tap.
    • FeedbackView.swift — Mail composer for Bug Report / Feature Request.
    • DeveloperNotes.swift — This file. Mirrors to wiki Developer-Notes.md.
    """

    static let minimumDeployments = """
    iOS 17.0 · iPadOS 17.0 · macOS 14.0 · visionOS 26.4

    The original v1.0 floor was iOS 15.6 / macOS 12.0 — the lowest the build \
    tools allowed. This update raised the floor to iOS 17 / macOS 14 because \
    NavigationStack (iOS 16+) and AttributedString-with-link tap-routing \
    (iOS 17+ in the form used here) are both load-bearing for the Under the \
    Hood retool and the Lexicon Quick-Define feature. That is the teaching \
    moment: pick the lowest floor you can, then raise it only when a modern \
    API you actually need demands it. Users on iOS 15 / iOS 16 devices \
    receive the final v1.0 build via the App Store's last-compatible-version \
    fallback.
    """

    static let wrappedDestination = """
    https://github.com/fluhartyml/Claudes-X26-Swift6-Bible/wiki/Claudes-X26-Swift6-Bible

    The book wiki's table-of-contents page — loaded at launch. Readers land \
    on the menu of every Book, Lexicon section, Build-Along, and Appendix, \
    and tap into whichever chapter they want to read. The wiki Home page \
    (intro / orientation) remains one tap away via the wiki's own sidebar. \
    Every link inside the wiki navigates within the same WKWebView \
    (one-stop-shop principle).
    """

    static let versionHistory = """
    v1.1 — Under the Hood retool + Lexicon Quick-Define + Bookmarks (2026-04-27). \
    UTH adopts the per-file callout + Open-on-GitHub pattern from Audio Universe. \
    Lexicon Quick-Define adds tappable Swift-identifier definitions inside the \
    source viewer (starter corpus, grows as the wiki Lexicon is authored). \
    Bookmarks restored from the original Wraply codebase: star to save, book to \
    open list, swipe to delete. Floor raised to iOS 17 / macOS 14 (NavigationStack \
    + AttributedString link tap routing).

    v1.0 — Ground-up rebuild (2026-04-23). First release of this app. \
    Predecessor "Wraply" remains live at id6762163478 as "Claude's Web Wrapper" \
    and is not modified; this app ships as a new App Store listing with a new \
    bundle ID and store ID.
    """
}
