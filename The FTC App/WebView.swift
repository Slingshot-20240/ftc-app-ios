//
//  WebView.swift
//  The FTC App
//
//  Created by Jining Liu on 8/21/25.
//

import SwiftUI
import WebKit

struct WebView: View {
    let url: URL
    @Binding var progress: Double

    init(url: URL, progress: Binding<Double> = .constant(0)) {
        self.url = url
        _progress = progress
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            SwiftUIWebView(url: url, progress: $progress)
        } else {
            WebViewUIViewRepresentable(url: url, progress: $progress)
        }
    }
}

@available(iOS 26.0, *)
struct SwiftUIWebView: View {
    let url: URL
    @Binding var progress: Double
    @State private var webPage: WebPage = .init()

    var body: some View {
        WebKit.WebView(webPage)
            .onAppear {
                webPage.load(url)
            }
            .onChange(of: webPage.estimatedProgress) { _, progress in
                self.progress = progress
            }
    }
}

struct WebViewUIViewRepresentable: UIViewRepresentable {
    let url: URL
    @Binding var progress: Double

    class Coordinator: NSObject {
        var parent: WebViewUIViewRepresentable
        init(parent: WebViewUIViewRepresentable) { self.parent = parent }
        
        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey: Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == "estimatedProgress",
                let webView = object as? WKWebView
            {
                print(webView.estimatedProgress)
                parent.progress = webView.estimatedProgress
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.addObserver(
            context.coordinator,
            forKeyPath: "estimatedProgress",
            options: .new,
            context: nil
        )
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var progress: Double = 0
    WebView(
        url: .init(string: "https://info.firstinspires.org/ftc-05-22-25")!,
        progress: $progress
    )
}
