//
//  GifImage.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 17/04/2024.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.clear
        webView.allowsLinkPreview = true
        webView.isOpaque = false

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }

}


struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(){
            Text("Test")
            GifImage("winningAnimation").background(Color.clear).zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
    }
    }
}
