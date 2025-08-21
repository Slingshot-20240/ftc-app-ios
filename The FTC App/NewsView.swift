//
//  NewsView.swift
//  The FTC App
//
//  Created by Jining Liu on 8/21/25.
//

import SwiftUI

struct NewsView: View {
    @Binding var news: [News]

    let reload: () -> Void

    @State private var search: String = ""

    var body: some View {
        List {
            Section {
                ForEach(news) { news in
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
                                .lineLimit(3)
                            }
                        }
                    }
                }
            }

            Section {
            } footer: {
                Text(
                    """
                    JSON data for compiled news sources can be found at [data.theftc.app/news.json](https://data.theftc.app/news.json).

                    See [Slingshot-20240/ftc-app-data](https://github.com/Slingshot-20240/ftc-app-data) on GitHub for source history and additional information.

                    """
                )
            }
        }
        .refreshable {
            Task {
                reload()
            }
        }
        .searchable(text: $search)
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    // TODO: - filters
                } label: {
                    if #available(iOS 26.0, *) {
                        Image(systemName: "line.3.horizontal.decrease")
                    } else {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
        }
        .navigationDestination(for: News.self) { news in
            NewsArticleView(news: news)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var news: [News] = try! JSONDecoder().decode(
        [News].self,
        from:
            "[{\"url\":\"https:\\/\\/info.firstinspires.org\\/ftc-05-22-25\",\"id\":3,\"description\":\"Collecting Feedback from the *FIRST* Tech Challenge Community\",\"date\":769582800,\"title\":\"FTC Team Blast\",\"tags\":[{\"firstHq\":{}}]},{\"url\":\"https:\\/\\/info.firstinspires.org\\/ftc-05-08-25\",\"id\":2,\"description\":\"- Waitlist Opportunities for Premier Events!\\n- Happy Teacher Appreciation Week\\n- Off-season Events\\n- AndyMark Game Set Orders\\n- Celebrate *FIRST* Signing Day - May 20\",\"date\":768373200,\"title\":\"FTC Team Blast\",\"tags\":[{\"firstHq\":{}}]},{\"url\":\"https:\\/\\/info.firstinspires.org\\/ftc-05-01-25\",\"id\":1,\"description\":\"- Waitlist Opportunities for Premier Events!\\n- Celebrating *FIRST* Championship\\n- Thank You for an Incredible Season\\n- National Advocacy Conference 2025\",\"date\":767768400,\"title\":\"FTC Team Blast\",\"tags\":[{\"firstHq\":{}}]},{\"url\":\"https:\\/\\/info.firstinspires.org\\/ftc-04-10-25\",\"id\":0,\"description\":\"- Upcoming *FIRST* Dashboard Maintenance\\n- Team Roster access during Dashboard maintenance\",\"date\":765954000,\"title\":\"FTC Team Blast\",\"tags\":[{\"firstHq\":{}}]}]"
            .data(using: .utf8)!
    )

    NavigationStack {
        NewsView(news: $news) {}
    }
}
