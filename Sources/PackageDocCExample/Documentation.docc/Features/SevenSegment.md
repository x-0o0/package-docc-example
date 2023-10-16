#  7 세그먼트 데이터 모델

SevenSegment 데이터 모델에 대한 문서.

## Overview

``SevenSegment/switch1``, ``SevenSegment/switch2``, ``SevenSegment/switch3``, ``SevenSegment/switch4`` 는 각각 차례대로 이진법 숫자의 2^0의 자리, 2^1의 자리, 2^2의 자리, 2^3의 자리 숫자를 의미 합니다.

즉 ``SevenSegment/switch1`` 과 ``SevenSegment/switch3`` 이 `true` 이고 나머지가 `false` 이면 이진법 숫자 **0101**(2) 을 의미 합니다

```swift
let sevenSegment = SevenSegment()
sevenSegment.switch1 = true
sevenSegment.switch3 = true
```

스위치들이 가리키는 값에 대한 십진법 숫자는 ``SevenSegment/decimalNumber`` 값을 읽어 알아낼 수 있습니다.

위 예시의 경우 ``SevenSegment/decimalNumber`` 를 출력해보면 `5` 가 출력됩니다.

```swift
print(sevenSegment.decimalNumber) // 5
```

### 뷰에서의 사용

이 데이터 모델을 `@StateObject` 키워드로 인스턴스를 생성한 후 `BinarySwitchView` 와 `SevenSegmentView` 에 주입하여 사용할 수 있습니다.

```swift
struct ContentView: View {
    @StateObject private var sevenSegment = SevenSegment()

    var body: some View {
        VStack {
            BinarySwitchView(modelData: sevenSegment)

            SevenSegmentView(modelData: sevenSegment)
        }
    }
}
```
