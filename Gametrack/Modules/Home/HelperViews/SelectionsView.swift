//
//  CustomSegmentedView.swift
//  Cards
//
//  Created by Ali Dinç on 20/12/2023.
//

import SwiftUI

struct SelectionsView:  View {
    
    var vm: HomeViewModel
    @Binding var selectedSegment: SegmentType
    @Namespace private var animation
    @Environment(\.dismiss) private var dismiss
    @AppStorage("appTint") var appTint: Color = .purple
    @State private var showClear = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack {
                    Text("Select your \(selectedSegment.rawValue)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .hSpacing(.leading)
                    
                    if selectedSegment == .platform || selectedSegment == .genre {
                        Text("You can select multiple options.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .hSpacing(.leading)
                    } else {
                        Text("You can select a category from the title too.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .hSpacing(.leading)
                    }
                }
                
                HStack(spacing: 16) {
                    RefreshButton
                    CloseButton()
                }
            }
            .padding(20)
            
            SegmentedView
            OptionsView
                
        }
        .onChange(of: vm.fetchTaskToken.platforms, { oldValue, newValue in
            Task {
                if vm.fetchTaskToken.platforms.isEmpty {
                    vm.fetchTaskToken.platforms = [.database]
                } else {
                    vm.fetchTaskToken.platforms = newValue
                }
                await vm.refreshTask()
            }
        })
        .onChange(of: vm.fetchTaskToken.genres, { oldValue, newValue in
            Task {
                if vm.fetchTaskToken.genres.isEmpty {
                    vm.fetchTaskToken.genres = [.allGenres]
                } else {
                    vm.fetchTaskToken.genres = newValue
                }
                await vm.refreshTask()
            }
        })
    }
    
    private var RefreshButton: some View {
        Button {
            vm.fetchTaskToken.platforms = [.database]
            vm.fetchTaskToken.genres = [.allGenres]
            dismiss()
           
            Task {
                await vm.refreshTask()
            }
        } label: {
            Text("Clear filters")
                .font(.subheadline)
        }
        .opacity(showClear ? 1 : 0)
        .onChange(of: vm.fetchTaskToken.platforms) { oldValue, newValue in
            if newValue.count >= 1 {
                showClear = true
            }
        }
        .onChange(of: vm.fetchTaskToken.genres) { oldValue, newValue in
            if newValue.count >= 1 {
                showClear = true
            }
        }
    }
    
    private var SegmentedView: some View {
        HStack(spacing: 0) {
            ForEach(SegmentType.allCases, id: \.rawValue) { segment in
                SegmentItem(segment: segment)
            }
        }
        .background(appTint.opacity(0.15), in: .capsule)
        .padding(.horizontal, 20)
    }
    
    private func SegmentItem(segment: SegmentType) -> some View {
        Text(segment.rawValue.capitalized)
            .hSpacing()
            .tag(segment.id)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(selectedSegment == segment ? .black : .secondary)
            .padding(.vertical, 10)
            .background {
                if selectedSegment == segment {
                    Capsule()
                        .fill(appTint)
                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                }
            }
            .contentShape(.capsule)
            .onTapGesture {
                withAnimation(.snappy) {
                    selectedSegment = segment
                }
            }
            .onChange(of: segment) { oldValue, newValue in
                selectedSegment = newValue
            }
    }
    
    @ViewBuilder
    private var OptionsView: some View {
        switch selectedSegment {
        case .platform:
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                   
                                   ]) {
                    ForEach(PopularPlatform.allCases.filter{ $0.id != PopularPlatform.database.id }.sorted(by: { $0.title < $1.title })) { platform in
                        Button {
                            if vm.fetchTaskToken.platforms.contains(platform) {
                                if let index = vm.fetchTaskToken.platforms.firstIndex(of: platform) {
                                    vm.fetchTaskToken.platforms.remove(at: index)
                                }
                            } else {
                                vm.fetchTaskToken.platforms.removeAll(where: { $0.id == PopularPlatform.database.id })
                                vm.fetchTaskToken.platforms.append(platform)
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Image(platform.assetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(.top, 4)
                                    .padding(.horizontal)
                                
                                Text(platform.title)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.bottom, 4)
                            }
                            .frame(width: 85, height: 85)
                            .background(
                                Color.black.opacity(0.5), in: .rect(cornerRadius: 20)
                            )
                            .overlay {
                                if vm.fetchTaskToken.platforms.contains(platform) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(appTint, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        case .genre:
            ScrollView {
                LazyVGrid(columns: [ GridItem(.flexible()),
                                      GridItem(.flexible()),
                                      GridItem(.flexible()),
                                      GridItem(.flexible()),
                                   ]) {
                    ForEach(PopularGenre.allCases.filter { $0.id != PopularGenre.allGenres.id }.sorted(by: { $0.title < $1.title })) { genre in
                        Button {
                            if vm.fetchTaskToken.genres.contains(genre) {
                                if let index = vm.fetchTaskToken.genres.firstIndex(of: genre) {
                                    vm.fetchTaskToken.genres.remove(at: index)
                                }
                            } else {
                                vm.fetchTaskToken.genres.removeAll(where: { $0.id == PopularGenre.allGenres.id })
                                vm.fetchTaskToken.genres.append(genre)
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Image(genre.assetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(.top, 4)
                                    .padding(.horizontal)
                                
                                Text(genre.title)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .padding(.bottom, 4)
                            }
                            .frame(width: 85, height: 85)
                            .background(
                                Color.black.opacity(0.5), in: .rect(cornerRadius: 20)
                            )
                            .overlay {
                                if vm.fetchTaskToken.genres.contains(genre) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(appTint, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        case .category:
            ScrollView {
                LazyVStack {
                    ForEach([Category.topRated, Category.newReleases, Category.upcoming, Category.upcomingThisWeek, Category.upcomingThisMonth]) { category in
                        
                        Button {
                            if vm.fetchTaskToken.category == category {
                                vm.fetchTaskToken.category = .database
                            } else {
                                vm.fetchTaskToken.category = category
                            }
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Image(systemName: category.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 20, height: 20)
                                
                                Text(category.title)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .foregroundStyle(.primary)
                            .hSpacing(.leading)
                            .background(
                                Color.black.opacity(0.5), in: .rect(cornerRadius: 20)
                            )
                            .overlay {
                                if vm.fetchTaskToken.category == category {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(appTint, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
