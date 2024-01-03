//
//  SettingsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI


struct MoreView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    @AppStorage("collectionViewType") private var viewType: ViewType = .list
    
    @Environment(\.openURL) var openURL
    @State private var email = SupportEmail(toAddress: "alidinc.uk@outlook.com",
                                            subject: "Support Email",
                                            messageHeader: "Please describe your issue below.")
    
    @State private var showMailApp = false
    @State private var showAbout = false
    @State private var showIcons = false
    @State private var showSendEmail = false
    @State private var showAppStore = false
    @State private var showAlertNoDefaulEmailFound = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Header
                
                Form {
                    Section("Appearance") {
                        HStack {
                            MoreMainRowView(imageName: "swatchpalette.fill", text: "App Tint")
                            ColorPicker("", selection: $appTint, supportsOpacity: false)
                        }
                        
                        Button {
                            self.showIcons.toggle()
                        } label: {
                            HStack {
                                MoreMainRowView(imageName: "apps.iphone", text: "App Icon")
                                Spacer()
                                Image(selectedAppIcon.title.lowercased())
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFit()
                            }
                        }
                    }
                    
                    Section("Feedback") {
                        ForEach(Feedback.allCases, id: \.id) { feedback in
                            switch feedback {
                            case .rate:
                                Button(action: {
                                    showAppStore = true
                                }, label: {
                                   MoreMainRowView(imageName: feedback.imageName, text: feedback.title)
                                })
                            case .email:
                                Button(action: {
                                    showSendEmail = true
                                }, label: {
                                    MoreMainRowView(imageName: feedback.imageName, text: feedback.title)
                                })
                            case .share:
                                ShareLink(item: Constants.AppStoreURL) {
                                    MoreMainRowView(imageName: feedback.imageName, text: feedback.title)
                                }
                            }
                        }
                    }
                    
                    Section("About") {
                        Button {
                            self.showAbout.toggle()
                        } label: {
                            MoreMainRowView(imageName: "info.circle.fill", text: "About")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.gray.opacity(0.15))
            .confirmationDialog("Rate us", isPresented: $showAppStore, titleVisibility: .visible, actions: {
                Button {
                    self.rateApp()
                } label: {
                    Text("Go to AppStore")
                }

            })
            .confirmationDialog("Send an email", isPresented: $showSendEmail, titleVisibility: .visible, actions: {
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
            })
            .alert("No default email app found", isPresented: $showAlertNoDefaulEmailFound, actions: {
                Button {
                    addToClipboardWithHaptics(with: "brendan.koeleman@outlook.com")
                } label: {
                    Text("Copy our support email here.")
                }
            
                Button {} label: {
                    Text("OK")
                }
            })
            .sheet(isPresented: $showIcons, content: {
                IconSelectionView()
                    .presentationDetents([.medium])
            })
            .sheet(isPresented: $showMailApp, content: {
                MailView(supportEmail: $email) { result in
                    switch result {
                    case .success:
                        print("Email sent")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            .sheet(isPresented: $showAbout, content: {
                AboutView()
                    .presentationDetents([.medium])
            })
        }
    }
    
    private var Header: some View {
        HStack(spacing: 8) {
          //  SFImage(name: "ellipsis.circle.fill", opacity: 0, radius: 0, padding: 0, color: appTint)
            
            Text("More")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(.primary)
                .shadow(radius: 10)
                .hSpacing(.leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    @MainActor
    func rateApp() {
        let urlStr = "\(Constants.AppStoreURL)?action=write-review"
        
        guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

#Preview {
    MoreView()
}

import SwiftUI

struct MoreMainRowView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    
    @State var imageName: String
    @State var text: String
    @State var subtitle: String?
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: self.imageName)
                .foregroundStyle(appTint)
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text(self.text)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                
                if let subtitle {
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .frame(height: 40)
    }
}
