//
//  MoreViewSections.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension MoreTab {
    
    var FeedbackSection: some View {
        Section("Feedback") {
            ForEach(Feedback.allCases, id: \.rawValue) { feedback in
                switch feedback {
                case .rate:
                    Button {
                        showAppStore = true
                    } label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                    .buttonStyle(.plain)
                case .tips:
                    Button {
                        showTips = true
                    } label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                    .buttonStyle(.plain)
                case .email:
                    Button {
                        showSendEmail = true
                    } label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                    .buttonStyle(.plain)
                case .share:
                    ShareLink(item: Constants.AppStoreURL) {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                case .about:
                    NavigationLink {
                        AboutView()
                    } label: {
                        MoreRowView(imageName: "info.circle.fill", text: "About")
                    }
                    .buttonStyle(.plain)
                }
            }
            .listRowBackground(Color(.secondarySystemBackground))
        }
    }
    
    var SendEmailButtons: some View {
        Group {
            Button {
                self.email.send(openURL: self.openURL) { didSend in
                    showAlertNoDefaulEmailFound = !didSend
                }
            } label: {
                Text("Default email app")
            }
            
            if MailView.canSendMail {
                Button {
                    self.showMailApp = true
                } label: {
                    Text("iOS email app")
                }
            }
        }
    }
}
