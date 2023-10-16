// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct SampleView: View {
    @StateObject private var sevenSegment = SevenSegment()
    
    var body: some View {
        VStack {
            BinarySwitchView(modelData: sevenSegment)
            
            SevenSegmentView(modelData: sevenSegment)
        }
    }
}

#Preview {
    SampleView()
}
