//
//  FTCApp.swift
//  The FTC App
//
//  Created by Jining Liu on 8/4/25.
//

import SwiFTC
import SwiftUI

@main
struct FTCApp: App {
    @State private var search: String = ""

    @AppStorage("selectedFtcSeason") private var selectedFtcSeason: FTCSeason =
        .decode

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(search: $search)
                    .searchable(
                        text: $search,
                        prompt: "Search events, teams, and news"
                    )
                    .navigationTitle(selectedFtcSeason.nameWithTrademark)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("", systemImage: "gear") {
                                // TODO: - Settings
                            }
                            .labelStyle(.iconOnly)
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            Button("", systemImage: "wrench.and.screwdriver") {
                                // TODO: - Tools
                            }
                            .labelStyle(.iconOnly)
                        }
                    }
            }
        }
    }
}
