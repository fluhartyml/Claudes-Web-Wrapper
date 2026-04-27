//
//  ContentView.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI
import SwiftData
import WebKit

struct ContentView: View {
    private let wikiURL = URL(string:
        "https://github.com/fluhartyml/Claudes-X26-Swift6-Bible/wiki/Claudes-X26-Swift6-Bible")!

    @Environment(\.modelContext) private var modelContext
    @State private var webView = WKWebView()
    @State private var showAbout = false
    @State private var showUnderTheHood = false
    @State private var showBookmarks = false
    @State private var showBookmarkSaved = false

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
                #if os(iOS) || os(visionOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    #if os(iOS) || os(visionOS)
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            webView.goBack()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(!webView.canGoBack)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            webView.goForward()
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(!webView.canGoForward)
                    }

                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            saveBookmark()
                        } label: {
                            Label("Save", systemImage: "star")
                        }
                        Spacer()
                        Button {
                            showBookmarks = true
                        } label: {
                            Label("Bookmarks", systemImage: "book")
                        }
                        Spacer()
                        Button {
                            webView.load(URLRequest(url: wikiURL))
                        } label: {
                            Label("Contents", systemImage: "list.bullet")
                        }
                        Spacer()
                        Button {
                            webView.reload()
                        } label: {
                            Label("Reload", systemImage: "arrow.clockwise")
                        }
                        Spacer()
                        Button {
                            showUnderTheHood = true
                        } label: {
                            Label("Under the Hood", systemImage: "car.fill")
                        }
                        Spacer()
                        Button {
                            showAbout = true
                        } label: {
                            Label("About", systemImage: "info.circle")
                        }
                    }
                    #else
                    ToolbarItem(placement: .navigation) {
                        Button {
                            webView.goBack()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(!webView.canGoBack)
                    }
                    ToolbarItem(placement: .navigation) {
                        Button {
                            webView.goForward()
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(!webView.canGoForward)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            saveBookmark()
                        } label: {
                            Label("Save Bookmark", systemImage: "star")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showBookmarks = true
                        } label: {
                            Label("Bookmarks", systemImage: "book")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            webView.load(URLRequest(url: wikiURL))
                        } label: {
                            Label("Contents", systemImage: "list.bullet")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            webView.reload()
                        } label: {
                            Label("Reload", systemImage: "arrow.clockwise")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showUnderTheHood = true
                        } label: {
                            Label("Under the Hood", systemImage: "car.fill")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showAbout = true
                        } label: {
                            Label("About", systemImage: "info.circle")
                        }
                    }
                    #endif
                }
                .sheet(isPresented: $showAbout) {
                    AboutView()
                }
                .sheet(isPresented: $showUnderTheHood) {
                    UnderTheHoodView()
                }
                .sheet(isPresented: $showBookmarks) {
                    BookmarksView { urlString in
                        if let url = URL(string: urlString) {
                            webView.load(URLRequest(url: url))
                        }
                    }
                }
                .alert("Bookmark Saved", isPresented: $showBookmarkSaved) {
                    Button("OK") {}
                }
        }
        #if os(iOS) || os(visionOS)
        .navigationViewStyle(.stack)
        #endif
    }

    private func saveBookmark() {
        let title = webView.title?.isEmpty == false ? webView.title! : "Untitled"
        let urlString = webView.url?.absoluteString ?? wikiURL.absoluteString
        let bookmark = Bookmark(title: title, urlString: urlString)
        modelContext.insert(bookmark)
        showBookmarkSaved = true
    }
}

#Preview {
    ContentView()
}
