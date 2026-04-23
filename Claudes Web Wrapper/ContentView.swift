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
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                webView.load(URLRequest(url: wikiURL))
                            } label: {
                                Label("Home (Wiki)", systemImage: "house")
                            }
                            Button {
                                webView.reload()
                            } label: {
                                Label("Reload", systemImage: "arrow.clockwise")
                            }
                            Divider()
                            Button {
                                showUnderTheHood = true
                            } label: {
                                Label("Under the Hood",
                                      systemImage: "wrench.and.screwdriver")
                            }
                            Button {
                                showAbout = true
                            } label: {
                                Label("About", systemImage: "info.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
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
                            webView.load(URLRequest(url: wikiURL))
                        } label: {
                            Label("Home", systemImage: "house")
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
                            Label("Under the Hood",
                                  systemImage: "wrench.and.screwdriver")
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
        }
        #if os(iOS) || os(visionOS)
        .navigationViewStyle(.stack)
        #endif
    }
}

#Preview {
    ContentView()
}
