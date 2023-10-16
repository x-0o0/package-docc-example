//
//  BinarySwitchView.swift
//
//
//  Created by 이재성 on 10/17/23.
//

import SwiftUI

/// 바이너리 스위치에 대한 뷰
public struct BinarySwitchView: View {
    @ObservedObject public var modelData: SevenSegment
    
    public var body: some View {
        VStack {
            Text("\(modelData.decimalNumber)")
                .font(.largeTitle.bold())
            
            HStack {
                Toggle(modelData.switch4 ? "1️⃣" : "0️⃣", isOn: $modelData.switch4)
                    .toggleStyle(.button)
                    .clipShape(.circle)
                    .background {
                        Circle()
                            .stroke(.tint, lineWidth: 1)
                    }
                
                Toggle(modelData.switch3 ? "1️⃣" : "0️⃣", isOn: $modelData.switch3)
                    .toggleStyle(.button)
                    .clipShape(.circle)
                    .background {
                        Circle()
                            .stroke(.tint, lineWidth: 1)
                    }
                    .disabled(modelData.switch4)
                
                Toggle(modelData.switch2 ? "1️⃣" : "0️⃣", isOn: $modelData.switch2)
                    .toggleStyle(.button)
                    .clipShape(.circle)
                    .background {
                        Circle()
                            .stroke(.tint, lineWidth: 1)
                    }
                    .disabled(modelData.switch4)
                
                Toggle(modelData.switch1 ? "1️⃣" : "0️⃣", isOn: $modelData.switch1)
                    .toggleStyle(.button)
                    .clipShape(.circle)
                    .background {
                        Circle()
                            .stroke(.tint, lineWidth: 1)
                    }
                    .disabled(modelData.switch4)
            }
        }
        .onChange(of: modelData.switch4) { newValue in
            if newValue {
                modelData.switch1 = false
                modelData.switch2 = false
                modelData.switch3 = false
            }
        }
    }
}

#Preview {
    BinarySwitchView(modelData: SevenSegment())
}
