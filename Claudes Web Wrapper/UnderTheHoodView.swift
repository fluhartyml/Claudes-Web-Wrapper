//
//  UnderTheHoodView.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  This view IS the Under the Hood feature — a list of the app's
//  own source files plus each file's UTH callout block (the comment
//  header you're reading right now), surfaced in-app. Tap a row,
//  read the callout, scroll the source, jump to the live file on
//  GitHub. The Lexicon Quick-Define layer (next phase) tags any
//  Swift identifier in the source block that has a Lexicon entry.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct UnderTheHoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected: UnderTheHoodContent.FileEntry?

    var body: some View {
        NavigationStack {
            list
                .navigationTitle("Under the Hood")
                #if os(iOS) || os(visionOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }

    private var list: some View {
        List {
            Section {
                Text("Tap a file to read why the code is written that way, browse the source, and jump to the live file on GitHub.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Developer Notes") {
                NavigationLink("Mission") {
                    DeveloperNotesPage(title: "Mission", text: DeveloperNotes.mission)
                }
                NavigationLink("Architecture") {
                    DeveloperNotesPage(title: "Architecture", text: DeveloperNotes.architecture)
                }
                NavigationLink("Minimum Deployments") {
                    DeveloperNotesPage(title: "Minimum Deployments", text: DeveloperNotes.minimumDeployments)
                }
                NavigationLink("Wrapped Destination") {
                    DeveloperNotesPage(title: "Wrapped Destination", text: DeveloperNotes.wrappedDestination)
                }
                NavigationLink("Version History") {
                    DeveloperNotesPage(title: "Version History", text: DeveloperNotes.versionHistory)
                }
            }

            Section("Source Files") {
                ForEach(UnderTheHoodContent.entries) { entry in
                    Button {
                        selected = entry
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "swift")
                                .foregroundStyle(.tint)
                                .frame(width: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.filename)
                                    .font(.body.monospaced())
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                Text(entry.purpose)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        #if os(iOS) || os(visionOS)
        .listStyle(.insetGrouped)
        #endif
        .sheet(item: $selected) { entry in
            FileDetailSheet(entry: entry)
        }
    }
}

private struct DeveloperNotesPage: View {
    let title: String
    let text: String

    var body: some View {
        ScrollView {
            Text(text)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(title)
        #if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct FileDetailSheet: View {
    let entry: UnderTheHoodContent.FileEntry
    @Environment(\.dismiss) private var dismiss
    @State private var lexiconSelection: LexiconEntry?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.filename)
                            .font(.title3.monospaced())
                        Text(entry.purpose)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Under the Hood", systemImage: "wrench.and.screwdriver")
                            .font(.headline)
                            .foregroundStyle(.tint)
                        Text(entry.callout)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(calloutBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Source — tap any tinted identifier",
                              systemImage: "swift")
                            .font(.headline)
                            .foregroundStyle(.tint)
                        ScrollView(.horizontal, showsIndicators: true) {
                            IdentifierTaggedSourceView(source: entry.source)
                        }
                        .frame(maxHeight: 400)
                        .background(sourceBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    if let url = entry.githubURL {
                        Link(destination: url) {
                            Label("Open on GitHub", systemImage: "arrow.up.right.square")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
                .padding()
            }
            .navigationTitle("Source File")
            #if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .environment(\.openURL, OpenURLAction { url in
                if url.scheme == "lexicon",
                   let host = url.host?.removingPercentEncoding,
                   let lexicon = LexiconContent.entry(for: host) {
                    lexiconSelection = lexicon
                    return .handled
                }
                return .systemAction
            })
            .sheet(item: $lexiconSelection) { lex in
                LexiconSheet(entry: lex)
            }
        }
    }

    private var calloutBackground: Color {
        #if os(iOS) || os(visionOS)
        Color(.secondarySystemBackground)
        #else
        Color.secondary.opacity(0.1)
        #endif
    }

    private var sourceBackground: Color {
        #if os(iOS) || os(visionOS)
        Color(.tertiarySystemBackground)
        #else
        Color.secondary.opacity(0.05)
        #endif
    }
}

#Preview {
    UnderTheHoodView()
}
