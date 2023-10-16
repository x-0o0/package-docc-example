//
//  SevenSegment.swift
//
//
//  Created by 이재성 on 10/17/23.
//

import SwiftUI

public class SevenSegment: ObservableObject {
    /// 1의 자리 숫자
    @Published public var switch1: Bool = false
    /// 2의 자리 숫자
    @Published public var switch2: Bool = false
    /// 4의 자리 숫자
    @Published public var switch3: Bool = false
    /// 8의 자리 숫자
    @Published public var switch4: Bool = false
    
    /// 십진법으로 변환한 값
    public var decimalNumber: Int {
        var number = 0
        if switch1 { number += 1 }
        if switch2 { number += 2 }
        if switch3 { number += 4 }
        if switch4 { number += 8 }
        return number
    }
    
    /// 최상단 세그먼트
    public var isAOn: Bool {
        switch1 && switch3 ||
        !switch1 && !switch3 ||
        switch2 && !switch3 ||
        switch4
    }
    
    /// 우측 상단 세그먼트
    public var isBOn: Bool {
        switch1 && switch2 ||
        !switch1 && !switch2 ||
        !switch3
    }
    
    /// 우측 하단 세그먼트
    public var isCOn: Bool {
        switch1 ||
        !switch2 ||
        switch3
    }
    
    /// 최하단 세그먼트
    public var isDOn: Bool {
        switch1 && !switch2 && switch3 ||
        !switch1 && switch2 ||
        !switch1 && !switch3 ||
        switch2 && !switch3
    }
    
    /// 좌측 하단 세그먼트
    public var isEOn: Bool {
        !switch1 && switch2 ||
        !switch1 && !switch3
        
    }
    
    /// 좌측 상단 세그먼트
    public var isFOn: Bool {
        !switch1 && !switch2 ||
        !switch1 && switch3 ||
        !switch2 && switch3 ||
        switch4
    }
    
    /// 중앙 세그먼트
    public var isGOn: Bool {
        !switch1 && switch3 ||
        switch2 && !switch3 ||
        !switch2 && switch3 ||
        switch4
    }
}
