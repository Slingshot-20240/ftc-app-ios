//
//  ContentView.swift
//  The FTC App
//
//  Created by Jining Liu on 8/4/25.
//

import SwiFTC
import SwiftUI

struct ContentView: View {
    @Environment(\.isSearching) private var isSearching

    @Binding var search: String

    @AppStorage("user") private var user: User = .init(testing: true)

    @State private var news: [News] = []

    @State private var attending: [FTCAPIV2Data.EventListings.Event] =
        try!
        ({
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        })().decode(
            [FTCAPIV2Data.EventListings.Event].self,
            from:
                "[{\"eventId\":\"0\",\"code\":\"USTXCGM1\",\"divisionCode\":null,\"name\":\"FiT-Central GEMS League Meet 1\",\"remote\":false,\"hybrid\":false,\"fieldCount\":2,\"published\":true,\"type\":\"1\",\"typeName\":\"League Meet\",\"regionCode\":\"USTX\",\"leagueCode\":\"CG\",\"districtCode\":null,\"venue\":null,\"address\":null,\"city\":null,\"stateprov\":null,\"country\":null,\"website\":null,\"liveStreamUrl\":null,\"coordinates\":null,\"webcasts\":null,\"timezone\":null,\"dateStart\":\"2025-11-01T06:00:00Z\",\"dateEnd\":\"2025-11-01T06:00:00Z\"},{\"eventId\":\"1\",\"code\":\"USTXCGM2\",\"divisionCode\":null,\"name\":\"FiT-Central GEMS League Meet 2\",\"remote\":false,\"hybrid\":false,\"fieldCount\":2,\"published\":true,\"type\":\"1\",\"typeName\":\"League Meet\",\"regionCode\":\"USTX\",\"leagueCode\":\"CG\",\"districtCode\":null,\"venue\":null,\"address\":null,\"city\":null,\"stateprov\":null,\"country\":null,\"website\":null,\"liveStreamUrl\":null,\"coordinates\":null,\"webcasts\":null,\"timezone\":null,\"dateStart\":\"2025-11-15T06:00:00Z\",\"dateEnd\":\"2025-11-15T06:00:00Z\"},{\"eventId\":\"2\",\"code\":\"USTXCGM3\",\"divisionCode\":null,\"name\":\"FiT-Central GEMS League Meet 3\",\"remote\":false,\"hybrid\":false,\"fieldCount\":2,\"published\":true,\"type\":\"1\",\"typeName\":\"League Meet\",\"regionCode\":\"USTX\",\"leagueCode\":\"CG\",\"districtCode\":null,\"venue\":null,\"address\":null,\"city\":null,\"stateprov\":null,\"country\":null,\"website\":null,\"liveStreamUrl\":null,\"coordinates\":null,\"webcasts\":null,\"timezone\":null,\"dateStart\":\"2025-12-06T06:00:00Z\",\"dateEnd\":\"2025-12-06T06:00:00Z\"},{\"eventId\":\"3\",\"code\":\"USTXCGLT\",\"divisionCode\":null,\"name\":\"FiT-Central GEMS League Tournament\",\"remote\":false,\"hybrid\":false,\"fieldCount\":2,\"published\":true,\"type\":\"3\",\"typeName\":\"League Tournament\",\"regionCode\":\"USTX\",\"leagueCode\":\"CG\",\"districtCode\":null,\"venue\":null,\"address\":null,\"city\":null,\"stateprov\":null,\"country\":null,\"website\":null,\"liveStreamUrl\":null,\"coordinates\":null,\"webcasts\":null,\"timezone\":null,\"dateStart\":\"2026-01-24T06:00:00Z\",\"dateEnd\":\"2026-01-24T06:00:00Z\"}]"
                .data(using: .utf8)!
        )

    @State private var following: [FTCAPIV2Data.EventListings.Event] =
        try! JSONDecoder().decode(
            [FTCAPIV2Data.EventListings.Event].self,
            from:
                "[{\"type\":\"6\",\"published\":true,\"districtCode\":\"\",\"typeName\":\"FIRST Championship\",\"venue\":\"George R. Brown Convention Center\",\"fieldCount\":1,\"timezone\":\"America\\/Chicago\",\"website\":\"https:\\/\\/www.firstchampionship.org\\/\",\"liveStreamUrl\":\"\",\"coordinates\":{\"coordinates\":[-95.35802,29.7522],\"type\":\"Point\"},\"eventId\":\"08786e70-ca59-9241-ae48-8de7b9e296dc\",\"hybrid\":false,\"address\":\"1001 Avenida De Las Americas\",\"country\":\"USA\",\"stateprov\":\"TX\",\"name\":\"FIRST Championship - FIRST Tech Challenge\",\"city\":\"Houston\",\"dateEnd\":766713600,\"code\":\"FTCCMP1\",\"regionCode\":\"CMPZ2\",\"dateStart\":766368000,\"remote\":false}]"
                .data(using: .utf8)!
        )

    @State private var trendingTeams: [FTCAPIV2Data.TeamListings.Team] =
        try! JSONDecoder().decode(
            [FTCAPIV2Data.TeamListings.Team].self,
            from:
                "[{\"teamNumber\":20240,\"displayTeamNumber\":\"20240\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Slingshot\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2021,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"},{\"teamNumber\":17315,\"displayTeamNumber\":\"17315\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Tomahawk\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2019,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"}]"
                .data(using: .utf8)!
        )

    @State private var trendingEvents: [FTCAPIV2Data.EventListings.Event] =
        try!
        ({
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        })().decode(
            [FTCAPIV2Data.EventListings.Event].self,
            from:
                "[{\"eventId\":\"3\",\"code\":\"USTXCGLT\",\"divisionCode\":null,\"name\":\"FiT-Central GEMS League Tournament\",\"remote\":false,\"hybrid\":false,\"fieldCount\":2,\"published\":true,\"type\":\"3\",\"typeName\":\"League Tournament\",\"regionCode\":\"USTX\",\"leagueCode\":\"CG\",\"districtCode\":null,\"venue\":null,\"address\":null,\"city\":null,\"stateprov\":null,\"country\":null,\"website\":null,\"liveStreamUrl\":null,\"coordinates\":null,\"webcasts\":null,\"timezone\":null,\"dateStart\":\"2026-01-24T06:00:00Z\",\"dateEnd\":\"2026-01-24T06:00:00Z\"},{\"type\":\"6\",\"published\":true,\"districtCode\":\"\",\"typeName\":\"FIRST Championship\",\"venue\":\"George R. Brown Convention Center\",\"fieldCount\":1,\"timezone\":\"America\\/Chicago\",\"website\":\"https:\\/\\/www.firstchampionship.org\\/\",\"liveStreamUrl\":\"\",\"coordinates\":{\"coordinates\":[-95.35802,29.7522],\"type\":\"Point\"},\"eventId\":\"08786e70-ca59-9241-ae48-8de7b9e296dc\",\"hybrid\":false,\"address\":\"1001 Avenida De Las Americas\",\"country\":\"USA\",\"stateprov\":\"TX\",\"name\":\"FIRST Championship - FIRST Tech Challenge\",\"city\":\"Houston\",\"dateEnd\":\"2026-04-19T06:00:00Z\",\"code\":\"FTCCMP1\",\"regionCode\":\"CMPZ2\",\"dateStart\":\"2025-04-15T06:00:00Z\",\"remote\":false}]"
                .data(using: .utf8)!
        )

    var body: some View {
        List {
            if !isSearching {
                welcomeSection

                attendingSection

                followingSection
            }

            trendingSection
                .onChange(of: isSearching) { val in
                    print(val)
                }

            newsSection

            Section {
            } header: {
                VStack(alignment: .leading) {
                    Text("The FTC App")
                    Text("presented by 20240 Slingshot")
                        .font(.subheadline)
                }
            } footer: {
                Text(
                    """
                    Team and event data provided by the [FTC API](https://ftc-events.firstinspires.org/services/API).

                    Trending teams and events are updated hourly, based on in-app search popularity over the last 24 hours.

                    Sources for news and other data can be found on GitHub at [Slingshot-20240/ftc-app-data](https://github.com/Slingshot-20240/ftc-app-data).

                    *FIRST*®, *FIRST*® Tech Challenge, FTC®, *FIRST*® RISE℠, SKYSTONE℠, *FIRST*® GAME CHANGERS℠, ULTIMATE GOAL℠, *FIRST*® FORWARD℠, FREIGHT FRENZY℠, *FIRST*® ENERGIZE℠, POWERPLAY℠, *FIRST*® IN SHOW℠, CENTERSTAGE℠, *FIRST*® DIVE℠, INTO THE DEEP℠, *FIRST*® AGE™, DECODE™, and all accompanying logos as they are created, are trademarks of For Inspiration and Recognition of Science and Technology (*FIRST*®) (www.firstinspires.org). These trademarks are used by special permission of *FIRST* which is not overseeing, involved with, or responsible for this activity, product, or service. © 2025 *FIRST*®. Used by special permission. All rights reserved.

                    © 2025 FTC Team 20240 Slingshot and contributors.
                    Licensed under the MIT License.

                    """
                )
            }
            .headerProminence(.increased)
        }
        .navigationDestination(for: NavigationPage.self) { page in
            switch page {
            case .news:
                NewsView(news: $news, reload: loadNews)
            }
        }
        .navigationDestination(for: News.self) { news in
            NewsArticleView(news: news)
        }
        .onAppear {
            loadNews()
        }
    }

    func loadNews() {
        URLSession.shared.dataTask(
            with: .init(
                url: .init(string: "https://data.theftc.app/news.json")!
            )
        ) { data, response, error in
            guard let data else {
                Logger.count()
                return
            }

            do {
                let news = try JSONDecoder().decode([News].self, from: data)

                withAnimation {
                    self.news = news
                }
            } catch {
                Logger.error("\(error)")
            }
        }
        .resume()
    }

    var welcomeSection: some View {
        Section {
            VStack {
                if let team = user.team {
                    NavigationLink(value: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(
                                    team.displayTeamNumber
                                        ?? String(team.teamNumber)
                                )
                                .font(.title2)
                                .fontWeight(.semibold)
                                .fontDesign(.monospaced)

                                if let region = team.homeRegion {
                                    Tag.custom(
                                        region,
                                        team.displayLocation ?? region
                                    ).label
                                }
                            }

                            if let name = team.nameShort ?? team.nameFull {
                                Text(name)
                                    .font(.title)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                } else {
                    Button("Add My Team", systemImage: "plus.circle.fill") {
                        // TODO: - Add personal team
                    }
                }
            }
        } header: {
            VStack(alignment: .leading) {
                Text("Welcome back,")
                    .font(.title)
                    .fontWeight(.bold)
                Text(user.name + "!")
                    .font(.largeTitle)
            }
            .padding(.vertical)
        }
        .headerProminence(.increased)
    }

    var attendingSection: some View {
        Section {
            ForEach(attending, id: \.eventId) { event in
                NavigationLink(value: event) {
                    VStack(alignment: .leading) {
                        Text(
                            event.dateStart.formatted(
                                date: .long,
                                time: .omitted
                            )
                        )
                        .font(.subheadline)

                        HStack {
                            Text(event.code ?? "???")
                                .font(.headline)

                            if let typeString = event.type,
                                let type = Int(typeString),
                                let typeName = event.typeName
                            {
                                Tag(eventType: type, eventTypeName: typeName)
                                    .label
                            }

                            if let region = event.regionCode {
                                Tag.custom(region, event.address ?? region)
                                    .label
                            }
                        }

                        Text(event.name ?? "???")
                            .font(.subheadline)
                    }
                }
            }
        } header: {
            Label("Attending", systemImage: "figure.walk")
        }
        .headerProminence(.increased)
    }

    var followingSection: some View {
        Section {
            ForEach(following, id: \.eventId) { event in
                NavigationLink(value: 0) {
                    VStack(alignment: .leading) {
                        Text(
                            event.dateStart.formatted(
                                date: .long,
                                time: .omitted
                            )
                        )
                        .font(.subheadline)

                        HStack {
                            Text(event.code ?? "???")
                                .font(.headline)

                            if let typeString = event.type,
                                let type = Int(typeString),
                                let typeName = event.typeName
                            {
                                Tag(eventType: type, eventTypeName: typeName)
                                    .label
                            }

                            if let region = event.regionCode {
                                Tag.custom(region, event.address ?? region)
                                    .label
                            }
                        }

                        Text(event.name ?? "???")
                            .font(.subheadline)
                    }
                }
            }
        } header: {
            Label("Following", systemImage: "calendar.badge.plus")
        }
        .headerProminence(.increased)
    }

    var trendingSection: some View {
        Section {
            ForEach(trendingTeams, id: \.teamNumber) { team in
                NavigationLink(value: team) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(
                                team.displayTeamNumber
                                    ?? String(team.teamNumber)
                            )
                            .fontDesign(.monospaced)

                            if let region = team.homeRegion {
                                Tag.custom(
                                    region,
                                    team.displayLocation ?? region
                                ).label
                            }
                        }

                        Text(team.nameShort ?? team.nameFull ?? "???")
                            .font(.headline)

                        var location: String {
                            if let loc = team.displayLocation {
                                return loc
                            }

                            var loc: [String] = []

                            if let city = team.city {
                                loc.append(city)
                            }

                            if let stateProv = team.stateProv {
                                loc.append(stateProv)
                            }

                            if let country = team.country {
                                loc.append(country)
                            }

                            return loc.joined(separator: ", ")
                        }

                        Text(location)
                            .font(.subheadline)
                    }
                }
            }

            ForEach(trendingEvents, id: \.eventId) { event in
                NavigationLink(value: 0) {
                    VStack(alignment: .leading) {
                        Text(
                            event.dateStart.formatted(
                                date: .long,
                                time: .omitted
                            )
                        )
                        .font(.subheadline)

                        HStack {
                            Text(event.code ?? "???")
                                .font(.headline)

                            if let typeString = event.type,
                                let type = Int(typeString),
                                let typeName = event.typeName
                            {
                                Tag(
                                    eventType: type,
                                    eventTypeName: typeName
                                )
                                .label
                            }

                            if let region = event.regionCode {
                                Tag.custom(region, event.address ?? region)
                                    .label
                            }
                        }

                        Text(event.name ?? "???")
                            .font(.subheadline)
                    }
                }
            }
        } header: {
            Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
        }
        .headerProminence(.increased)
    }

    var newsSection: some View {
        Section {
            ForEach(news[0..<min(news.count, 3)]) { news in
                NavigationLink(value: news) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(
                                news.date.formatted(
                                    date: .long,
                                    time: .omitted
                                )
                            )
                            .font(.subheadline)

                            ForEach(news.tags, id: \.tag) { tag in
                                tag.label
                            }
                        }

                        Text(.init(news.title))
                            .font(.headline)

                        if let description = news.description {
                            Text(
                                .init(
                                    description.replacing(
                                        #/(?:^|\n)- /#,
                                        with: "\n• "
                                    ).replacing(
                                        "\n• ",
                                        with: "• ",
                                        maxReplacements: 1
                                    )
                                )
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        }
                    }
                }
            }

            if news.count > 3 {
                NavigationLink("More News", value: NavigationPage.news)
            }
        } header: {
            Label("News", systemImage: "newspaper")
        }
        .headerProminence(.increased)
    }
}

enum NavigationPage: Hashable {
    case news
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var search: String = ""
    ContentView(search: $search)
}
