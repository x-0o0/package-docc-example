//
//  SevenSegmentView.swift
//
//
//  Created by 이재성 on 10/17/23.
//

import SwiftUI

public struct SevenSegmentView: View {
    @ObservedObject public var modelData: SevenSegment
    
    public var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 200, height: 20)
                .foregroundStyle(modelData.isAOn ? Color.accentColor : Color.clear)
                .border(.tint, width: 1)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 20, height: 200)
                    .foregroundStyle(modelData.isFOn ? Color.accentColor : Color.clear)
                    .border(.tint, width: 1)
                
                Spacer()
                    .frame(width: 200, height: 200)
                
                Rectangle()
                    .frame(width: 20, height: 200)
                    .foregroundStyle(modelData.isBOn ? Color.accentColor : Color.clear)
                    .border(.tint, width: 1)
            }
            
            Rectangle()
                .frame(width: 200, height: 20)
                .foregroundStyle(modelData.isGOn ? Color.accentColor : Color.clear)
                .border(.tint, width: 1)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 20, height: 200)
                    .foregroundStyle(modelData.isEOn ? Color.accentColor : Color.clear)
                    .border(.tint, width: 1)
                
                Spacer()
                    .frame(width: 200, height: 200)
                
                Rectangle()
                    .frame(width: 20, height: 200)
                    .foregroundStyle(modelData.isCOn ? Color.accentColor : Color.clear)
                    .border(.tint, width: 1)
            }
            
            Rectangle()
                .frame(width: 200, height: 20)
                .foregroundStyle(modelData.isDOn ? Color.accentColor : Color.clear)
                .border(.tint, width: 1)
        }
    }
}

#Preview {
    SevenSegmentView(
        modelData: SevenSegment()
    )
}
