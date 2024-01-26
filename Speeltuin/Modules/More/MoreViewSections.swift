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
                MoreRowView(imageName: "swatchpalette.fill", text: "Tint color")
            })
        }
    }
    
    var FeedbackSection: some View {
        Section("Feedback") {
            ForEach(Feedback.allCases, id: \.id) { feedback in
                switch feedback {
                case .rate:
                    Button(action: {
                        showAppStore = true
                    }, label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    })
                case .email:
                    Button(action: {
                        showSendEmail = true
                    }, label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    })
                case .share:
                    ShareLink(item: Constants.AppStoreURL) {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                }
            }
        }
    }
    
    var AboutSection: some View {
        Section("About") {
            Button {
                self.showAbout.toggle()
            } label: {
                MoreRowView(imageName: "info.circle.fill", text: "About")
            }
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
            } else {
                
            }
        }
    }
}
