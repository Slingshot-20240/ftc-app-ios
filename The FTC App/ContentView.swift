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

    @State private var news: [News] = [
        .init(
            id: 3,
            title: "FTC Team Blast",
            description:
                "Collecting Feedback from the *FIRST* Tech Challenge Community",
            tags: [.firstHq],
            markdown: nil,
            url: .init(string: "https://info.firstinspires.org/ftc-05-22-25"),
            date: ({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            })().date(from: "2025-05-22")!
        ),
        .init(
            id: 2,
            title: "FTC Team Blast",
            description:
                """
                - Waitlist Opportunities for Premier Events!
                - Happy Teacher Appreciation Week
                - Off-season Events
                - AndyMark Game Set Orders
                - Celebrate FIRST Signing Day - May 20
                """,
            tags: [.firstHq],
            markdown: nil,
            url: .init(string: "https://info.firstinspires.org/ftc-05-08-25"),
            date: ({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            })().date(from: "2025-05-08")!
        ),
        .init(
            id: 1,
            title: "FTC Team Blast",
            description:
                """
                - Waitlist Opportunities for Premier Events!
                - Celebrating FIRST Championship
                - Thank You for an Incredible Season
                - National Advocacy Conference 2025
                """,
            tags: [.firstHq],
            markdown: nil,
            url: .init(string: "https://info.firstinspires.org/ftc-05-01-25"),
            date: ({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            })().date(from: "2025-05-01")!
        ),
        .init(
            id: 0,
            title: "FTC Team Blast",
            description:
                """
                - Upcoming FIRST Dashboard Maintenance
                - Team Roster access during Dashboard maintenance
                """,
            tags: [.firstHq],
            markdown: nil,
            url: .init(string: "https://info.firstinspires.org/ftc-04-10-25"),
            date: ({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            })().date(from: "2025-04-10")!
        ),
    ]

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
                "[{\"teamNumber\":20240,\"displayTeamNumber\":\"20240\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Slingshot\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2021,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"},{\"teamNumber\":17315,\"displayTeamNumber\":\"17315\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Tomahawk\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2019,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"},{\"teamNumber\":17113,\"displayTeamNumber\":\"17113\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Hunga Munga\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2019,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"},{\"teamNumber\":18886,\"displayTeamNumber\":\"18886\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Boomerang\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2020,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"}]"
                .data(using: .utf8)!
        )

    var body: some View {
        List {
            if !isSearching {
                welcomeSection

                attendingSection

                followingSection
            }

            trendingTeamsSection
                .onChange(of: isSearching) { val in
                    print(val)
                }

            newsSection
            
            if !isSearching {
                Section {
                } footer: {
                    Text(
                    """
                    Team and event data provided by the [FTC API](https://ftc-events.firstinspires.org/services/API).
                    
                    Sources for news and other data can be found on GitHub at [Slingshot-20240/ftc-app-data](https://github.com/Slingshot-20240/ftc-app-data).
                    
                    """
                    )
                }
            }
        }
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
                                .font(.title)
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
                                    .font(.title2)
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

    var trendingTeamsSection: some View {
        Section {
            ForEach(trendingTeams, id: \.teamNumber) { team in
                NavigationLink(value: 0) {
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
        } header: {
            Label("Trending Teams", systemImage: "chart.line.uptrend.xyaxis")
        }
        .headerProminence(.increased)
    }

    var newsSection: some View {
        Section {
            ForEach(news[0..<min(news.count, 3)]) { news in
                NavigationLink(value: 0) {
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

                        Text(news.title)
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
                NavigationLink("More News", destination: EmptyView())
            }
        } header: {
            Label("News", systemImage: "newspaper")
        }
        .headerProminence(.increased)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var search: String = ""
    ContentView(search: $search)
}
