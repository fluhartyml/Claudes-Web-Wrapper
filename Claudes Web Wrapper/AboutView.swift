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
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "safari")
                            .resizable()
                            .frame(width: 72, height: 72)
                            .foregroundStyle(.tint)
                        Text("Claude's Web Wrapper")
                            .font(.title2).bold()
                            .multilineTextAlignment(.center)
                        Text("v\(appVersion)")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                Section("About This App") {
                    Text("A single-destination wrapper for Claude's X26 Swift6 GitHub Wiki. Built as the first build-along app in the book.")
                        .font(.body)
                }

                Section("Contact") {
                    HStack {
                        Text("Author")
                        Spacer()
                        Text("Michael Lee Fluharty")
                            .foregroundStyle(.secondary)
                    }
                    .font(.body)
                    Link("fluharty.me", destination: URL(string: "https://fluharty.me")!)
                        .font(.body)
                    Link("michael.fluharty@mac.com", destination: URL(string: "mailto:michael.fluharty@mac.com")!)
                        .font(.body)
                }

                Section("Credits") {
                    Text("Engineered with Claude by Anthropic")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button {
                        showFeedback = true
                    } label: {
                        Label("Send Feedback", systemImage: "envelope")
                            .font(.body)
                    }
                }
            }
            .navigationTitle("About")
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
            .sheet(isPresented: $showFeedback) {
                FeedbackView()
            }
        }
        #if os(iOS) || os(visionOS)
        .navigationViewStyle(.stack)
        #endif
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }
}

#Preview {
    AboutView()
}
