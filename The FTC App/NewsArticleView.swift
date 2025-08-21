//
//  NewsArticleView.swift
//  The FTC App
//
//  Created by Jining Liu on 8/21/25.
//

import SwiftUI

struct NewsArticleView: View {
    let news: News
    @State private var loadingProgress: Double = 0

    @State private var showInfo: Bool = false

    var body: some View {
        WebView(url: news.url, progress: $loadingProgress)
            .overlay {
                if loadingProgress < 2 {
                    ProgressView(value: loadingProgress)
                        .transition(
                            .opacity.animation(.snappy)
                        )
                        .animation(
                            .snappy(duration: 0.01),
                            value: loadingProgress
                        )
                        .frame(maxHeight: .infinity, alignment: .top)
                        .onChange(of: loadingProgress) { progress in
                            if progress >= 1 && progress < 2 {
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 0.5
                                ) {
                                    loadingProgress = 2
                                }
                            }
                        }
                }
            }
            .navigationTitle(.init(news.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "info.circle") {
                        showInfo = true
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .sheet(isPresented: $showInfo) {
                info
                    .presentationDetents([.medium])
            }
    }

    var info: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("Published Date")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(
                            news.date.formatted(date: .complete, time: .omitted)
                        )
                    }

                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(
                            .init(
                                (news.description ?? "None").replacing(
                                    #/(?:^|\n)- /#,
                                    with: "\n• "
                                ).replacing(
                                    "\n• ",
                                    with: "• ",
                                    maxReplacements: 1
                                )
                            )
                        )
                    }

                    VStack(alignment: .leading) {
                        Text("Markdown Available")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(news.markdown != nil ? "Yes" : "No")
                    }

                    VStack(alignment: .leading) {
                        Text("Tags")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(
                            .init(
                                news.tags.map(\.description).joined(
                                    separator: ", "
                                )
                            )
                        )
                    }

                    VStack(alignment: .leading) {
                        Text("URL")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Link(news.url.absoluteString, destination: news.url)
                    }
                    .contextMenu {
                        Button("Copy", systemImage: "document.on.clipboard") {
                            UIPasteboard.general.string =
                                news.url.absoluteString
                        }
                    }
                } header: {
                    Text("Metadata")
                }
            }
            .navigationTitle(.init(news.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showInfo = false
                    } label: {
                        if #available(iOS 26.0, *) {
                            Image(systemName: "xmark")
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var news: News = try! JSONDecoder().decode(
        News.self,
        from:
            "{\"url\":\"https:\\/\\/info.firstinspires.org\\/ftc-05-22-25\",\"id\":3,\"description\":\"Collecting Feedback from the *FIRST* Tech Challenge Community\",\"date\":769582800,\"title\":\"FTC Team Blast\",\"tags\":[{\"firstHq\":{}}]}"
            .data(using: .utf8)!
    )

    NavigationStack {
        NewsArticleView(news: news)
    }
}
