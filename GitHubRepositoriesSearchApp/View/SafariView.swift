//
//  SafariView.swift
//  GitHubRepositoriesSearchApp
//
//  Created by 金山義成 on 2024/02/02.
//

//import SwiftUI
//import SafariServices
//
//struct SafariView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = SFSafariViewController
//    let url: URL
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//
//    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
//}

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @Binding var url: URL
    typealias UIViewControllerType = SFSafariViewController

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
