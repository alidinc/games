//
//  MoreViewSections.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension MoreTab {
    var SettingsSection: some View {
        Section("Settings") {
            SelectAppIconRow
            ViewTypeRow
            HapticsRow
            ColorSchemeRow
            ColorPicker(selection: $appTint, supportsOpacity: false, label: {
                MoreRowView(imageName: "swatchpalette.fill", text: "Tint Color")
            })
        }
        .listRowBackground(Color(.secondarySystemBackground))
    }
    
    var FeedbackSection: some View {
        Section("Feedback") {
            ForEach(Feedback.allCases, id: \.id) { feedback in
                switch feedback {
                case .rate:
                    Button {
                        showAppStore = true
                    } label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                case .tips:
                    Button {
                        showTips = true
                    } label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                case .email:
                    Button {
                        showSendEmail = true
                    } label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                case .share:
                    ShareLink(item: Constants.AppStoreURL) {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                }
            }
        }
        .listRowBackground(Color(.secondarySystemBackground))
    }
    
    var AboutSection: some View {
        Section("About") {
            Button {
                showAbout.toggle()
            } label: {
                MoreRowView(imageName: "info.circle.fill", text: "About")
            }
        }
        .listRowBackground(Color(.secondarySystemBackground))
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
