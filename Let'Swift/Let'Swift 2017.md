# Let'Swift 2017
> 2017.09.23.Sat.

## 1. Swift4

- `String `멀티라인 가능 추가. ` ''' `로 가능 
- `String`에 바로 `count`를 써서 글자 수 체크 가능.
- `Private` : `extention`에서 같은 소스 파일의 `private 변수`를 접근 가능함.
- `Smart Keypaths` : `\Book.name`처럼 `\`로 Class 또는 Struct를 접근가능하게 함. `💡Rx로 개발시 유용.`
- `Existention` : 프로토콜을 `&`로 추가? 복수로 사용할 수 있게 함.
- `One side range` : `0...` 처럼 한쪽이 완벽하게 정의되지 않아도 사용할 수 있게 됨.🤠
- `@objc` : 자동으로 추론되지 않는다.(=`@objc`가 컴파일 되었던걸 써줘야한다.) `override`, `IBAction`, `IBOutlet` 들은 예외. 
- `Codable`: `dictionary`를 `Struct`로 만들 수 있다. ``CodingKey`로 하면 API....... 알아보기😂`


## 2. Swift vs Kotlin
### Type system
- Swift `let` Kotlin `vel`
- Swift `optional, nil` Kotlin `Nullable, null`

### Mutablility
- Swift `[] 이용해서 ` Kotlin `Library의 함수 이용해서 만듬`
- Swift `var로 선언` Kotlin `Mutable로 선언`

### Extention
   > 가장 큰 차이점.

- Kotlin : Class가 정의되기 전에 Struct를 정의해야한다. 함수를 extention으로 추가 안됨. nullable 추가 가능.

### 메모리 관리.
- Kotlin : `GC` 

## 3. Concurrency in Swift
- Thread, GCD*Operation

## 4. Metal기반 UI/UX 제작
### 최신 유행 UI/UX
- Simple, 사용성 증가, More Simple No Colorful, flat design 유행.
- GlitchLabel(Library)

### MetalKit + MSL(Metal Shader Languge)
- 쉬운 이미지 처리가 가능, shader 코드 분리.

### Post Processing
- 사진 같은 것을 가공해서 화면에 띄우는 것. ex) 빛처리

### 사용법
- MetalKit으로 render 로 받아와서 활옹.
- `commander que` : 명령을 전달하는 역할
- `libarary` : 객체로 사용할 것을 정의
- `pipe line`
- `texture` : metal kit 내에서 사용하는 이미지. 일반 이미지랑 다르다.
- `draw` method
- `command buffer`
- `commander incoder`: 명령을 버퍼에 담을 수 있게 인코더를 하는 것.
- thread 정의를 그룹으로 해야함.

### MSL
- 공식 문서에 잘 나와있음.

### 활용방법
#### - 단일텍스쳐
- 카메라 filter와 비슷하지만 기본 Core Image에서 되지 않는 후처리가 편리하고 가능함.
- 움직이는 애니메이션이 가능. Core Graphic 으로는 퍼포먼스가 안됨.

#### - 텍스쳐+텍스쳐
- 나중에 얹어지는 부분을 layer로 Core Image로 변환해서 buffer로 다시 넘겨줘서 더해서 사용이 가능하다.

#### - View
- 웹뷰나 카메라뷰 위에 그대로 실시간으로 적용이 가능하다.

발표자. 이선협 facebook계정

## 5. iOS11 ARKit
- AR? 현실세계 + 가상환경
- ARKit, iPhone 7부터 사용가능.

### AR Kit 특징
1) Tracking

- AVFoundation + Coremotion Framework
- 광원으로 점들을 찍고 인식해서 사용하게 된다. 

2) Scene Understanding

- 가상의 지형 구성가능. 

3) Rendering


## 6. `toss`의 개발/배포 환경
### 1) 앱 쪼개기
- 서버테스트용, 유저배포용 등등으로 구분해서 사용할 때.
- `target`, `scheme`으로 보통 사용. 
- `반영방식 파악하기` -  combined

### 배포쉽게하기
- `fastlane`


## 7. RXSwift 활용하기
- `observable` 

## 8. ReactorKit으로 단방향 반응형 앱 만들기
- Massive view controller + RxSwift
- `MVC + RxSwift` || `MVVM + RxSwift` = 상태 관리가 어렵다.

### ReactorKit
```
1. 뷰와 로직의 관심사가 분리 가능
2. View Controller가 간결해짐.
3. RxSwift의 기능을 모두 사용 가능.
4. 단방향 데이터 흐름.
5. 중간 상태를  Reduce() 함수로 가능.
6. 특정 기능에 부분적 적용 가능.
7. 테스트를 위한 도구를 자체적으로 지원.
```

- Basic Concept = `View` `Action` `Recactor` `State`
- `View` : 사용자의 입력을 받아 `Action`으로 전달.
- `Reactor` : 뷰에서 받은 액션에 따라 로직을 수행. 대부분의 View는 대응되는 Reactor를 가진다.
- `action이 mutate > reduce를 통해 state를 반환한다.` 비동기처리가 까다롭기 때문 action이 직접적으로 state를 바꾸지 않는다.


## 9. *
- `Enterprise`
- `Education`







