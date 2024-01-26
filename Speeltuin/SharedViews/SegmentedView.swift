//
//  SegmentedView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 09/01/2024.
//

import SwiftUI

import SwiftUI

struct SegmentedView<SegmentItem: Hashable, SegmentContent: View>: View {
    
    var fillColor: Color
    @Binding var selectedSegment: SegmentItem
    var segments: [SegmentItem]
    var segmentContent: (SegmentItem) -> SegmentContent
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                SegmentItemView(
                    fillColor: fillColor,
                    segment: segment,
                    selectedSegment: $selectedSegment,
                    animation: animation
                ) {
                    segmentContent(segment)
                }
            }
        }
        .background(Color.gray.opacity(0.15), in: .capsule)
        .padding(.horizontal, 20)
    }
}

private struct SegmentItemView<SegmentItem: Hashable, SegmentContent: View>: View {
    
    var fillColor: Color
    let segment: SegmentItem
    @Binding var selectedSegment: SegmentItem
    let animation: Namespace.ID
    let content: () -> SegmentContent

    var body: some View {
        content()
            .hSpacing()
            .tag(segment)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(selectedSegment == segment ? .black : .secondary)
            .padding(.vertical, 10)
            .background {
                if selectedSegment == segment {
                    Capsule()
                        .fill(fillColor)
                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                }
            }
            .contentShape(.capsule)
            .onTapGesture {
                withAnimation(.snappy) {
                    selectedSegment = segment
                }
            }
    }
}
