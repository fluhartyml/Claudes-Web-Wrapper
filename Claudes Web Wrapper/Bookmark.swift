//
//  Bookmark.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/27/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  SwiftData @Model for a saved web page. Three properties:
//  display title (taken from WKWebView.title at save time), the URL
//  as a String (Codable; URL itself is also Codable in @Model but
//  String round-trips cleanly), and the Date the bookmark was added
//  for sort order.
//  ────────────────────────────────────────────────────────────────
//

import SwiftData
import Foundation

@Model
class Bookmark {
    var title: String
    var urlString: String
    var dateAdded: Date

    init(title: String, urlString: String, dateAdded: Date = .now) {
        self.title = title
        self.urlString = urlString
        self.dateAdded = dateAdded
    }
}
