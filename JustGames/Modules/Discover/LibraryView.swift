//
//  AddLibraryButton.swift
//  JustGames
//
//  Created by Ali Dinç on 11/01/2024.
//

import SwiftData
import SwiftUI


enum LibraryViewType: String, CaseIterable, Hashable {
    case addLibrary
    case allLibraries
    
    
    var title: String {
        switch self {
        case .addLibrary:
            return "Add library"
        case .allLibraries:
            return "All libraries"
        }
    }
}

struct LibraryView: View {
    

    @State private var libraryIcon: String?
    @State private var libraryName = ""
    @State private var selectedLibraryView: LibraryViewType = .addLibrary
    
    @State private var showAlertToDeleteLibrary = false
    @State private var showMaxLibraryAlert = false
    
    @AppStorage("appTint") var appTint: Color = .white
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
    
    @State private var libraryToDelete: Library?
    @Query var libraries: [Library]
    
    var body: some View {
        NavigationStack {
            VStack {
                SegmentedView(selectedSegment: $selectedLibraryView, segments: LibraryViewType.allCases) { library in
                    Text(library.title)
                }
                .padding()
                
                switch selectedLibraryView {
                case .addLibrary:
                    AddLibraryView
                case .allLibraries:
                    AllLibrariesView
                }
            }
            .navigationTitle("Libraries")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                        
                }
            })
            .padding(.top)
            .background(.gray.opacity(0.15))
        }
        .alert("You can't have more than 10 libraries.", isPresented: $showMaxLibraryAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
        .alert("Are you sure to delete this library?", isPresented: $showAlertToDeleteLibrary, actions: {
            Button(role: .destructive) {
                if let libraryToDelete {
                    vm.delete(library: libraryToDelete, in: context)
                }
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
        }, message: {
            Text("You won't be able to undo this action.")
        })
    }
    
    private var AddLibraryView: some View {
        Form {
            LibraryNameSection
            LibraryIconSection
            RemainingLibraryCountView
        }
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom, content: {
            AddButton
        })
    }
    
    private var LibraryNameSection: some View {
        Section("Name") {
            TextField("Library name", text: $libraryName)
                .frame(height: 24, alignment: .leading)
                .padding(10)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
                .autocorrectionDisabled()
                .onSubmit {
                    addLibrary()
                }
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowBackground(Color.clear)
    }
    
    private func IconsView(for section: SFSections) -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()], content: {
                ForEach(section.sfModels, id: \.self) { symbol in
                    Button(action: {
                        libraryIcon = symbol
                    }, label: {
                        Image(systemName: symbol)
                            .padding()
                            .imageScale(.medium)
                            .overlay {
                                if symbol == libraryIcon {
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(appTint, lineWidth: 2)
                                }
                            }
                    })
                }
            })
        }
        .frame(height: 150)
    }
    
    private var LibraryIconSection: some View {
        Section("Icon") {
            ScrollView {
                VStack {
                    ForEach(SFSections.allCases, id: \.self) { section in
                        DisclosureGroup {
                            IconsView(for: section)
                        } label: {
                            Text(section.rawValue.capitalized)
                                .font(.subheadline.bold())
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                    }
                }
                
            }
            .frame(height: 200)
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowBackground(Color.clear)
    }
    
    private var RemainingLibraryCountView: some View {
        Text("\(11 - libraries.count)")
            .font(.headline.bold())
        
        +
        
        Text(" remaining slots to create a library.")
            .font(.subheadline)
    }
    
    private var AllLibrariesView: some View {
        List {
            ForEach(libraries.filter({ $0.savingId != Constants.allGamesLibraryID }), id: \.self) { library in
                HStack {
                    if let icon = library.icon {
                        Image(systemName: icon)
                            .imageScale(.medium)
                    }
                    
                    
                    Text(library.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                .padding()
                .hSpacing(.leading)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        libraryToDelete = library
                        showAlertToDeleteLibrary = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var AddButton: some View {
        Button(action: {
            addLibrary()
        }, label: {
            HStack {
                Image(systemName: "plus")
                Text("Add library")
            }
            .hSpacing(.center)
            .foregroundStyle(.white)
            .bold()
            .padding()
            .background(.blue, in: .capsule)
        })
        .padding(.horizontal)
    }
    
    func addLibrary() {
        guard !libraryName.isEmpty else {
            return
        }
        
        guard libraries.count < 11 else {
            showMaxLibraryAlert = true
            return
        }
        
        
        let library = Library(title: libraryName)
        if let libraryIcon {
            library.icon = libraryIcon
        }
        context.insert(library)
        libraryName = ""
        dismiss()
    }
}
