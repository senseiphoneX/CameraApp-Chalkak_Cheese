# @unnnyong Swift Style Guide

![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)

앞으로 개인 앱 코드를 깃헙에 올리면서 코드 작성의 통일성을 위하여 Swift Stydle Guide를 작성합니다.

## 코드 레이아웃

### 들여쓰기 및 띄어쓰기

- 들여쓰기에는 탭(tab)을 사용합니다.
- 콜론(`:`)을 쓸 때에는 콜론의 오른쪽에만 공백을 둡니다.

    ```swift
    let names: [String: String]?
    ```

- 연산자 오버로딩 함수 정의에서는 연산자와 괄호 사이에 한 칸 띄어씁니다.

    ```swift
    func ** (lhs: Int, rhs: Int)
    ```

### 줄바꿈

- 함수 정의가 최대 길이를 초과하는 경우에는 윗 줄의 괄호가 끝나는 부분의 들여쓰기에 맞추어 줄을 바꿉니다.

    ```swift
    func collectionView(
    	_ collectionView: UICollectionView,
    	cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
    	// doSomething()
    }

    func animationController(
    	forPresented presented: UIViewController,
    	presenting: UIViewController,
    	source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
    	// doSomething()
    }
    ```

- 함수를 호출하는 코드가 최대 길이를 초과하는 경우에는 파라미터 이름을 기준으로 줄바꿈합니다.

    ```swift
    let actionSheet = UIActionSheet(
    	title: "정말 계정을 삭제하실 건가요?",
    	delegate: self,
    	cancelButtonTitle: "취소",
    	destructiveButtonTitle: "삭제해주세요"
    )
    ```

    단, 파라미터에 클로저가 2개 이상 존재하는 경우에는 무조건 내려쓰기합니다.

    ```swift
    UIView.animate(
    	withDuration: 0.25,
    	animations: {
      	// doSomething()
    	},
    	completion: { finished in
      	// doSomething()
    	}
    )
    ```

- `if let` 구문이 길거나 상수 정의가 두 개 이상의 경우에는 줄바꿈하고 한 칸 들여씁니다.

    ```swift
    if let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
    	let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
    	user.gender == .female {
    	// ...
    }
    ```
    
- `guard let` 구문이 길거나 상수 정의가 두개 이상의 경우에는 줄바꿈하고 한 칸 들여씁니다. `else`는 `guard`와 같은 들여쓰기를 적용합니다.

    ```swift
    guard let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
      let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
      user.gender == .female
    else {
      return
    }
    ```

### 최대 줄 길이

- 한 줄은 최대 99자를 넘지 않아야 합니다.

### 빈 줄

- 빈 줄에는 공백이 포함되지 않도록 합니다.
- 모든 파일은 빈 줄로 끝나도록 합니다.
- MARK 구문은 위, 아래에 빈 줄이 필요합니다.

    ```swift
    // MARK: Layout

    override func layoutSubviews() {
      // doSomething()
    }

    // MARK: Actions

    override func menuButtonDidTap() {
      // doSomething()
    }
    ```
    
### 임포트

모듈 임포트는 알파벳 순으로 정렬합니다. 내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분하여 서드파티 프레임워크를 임포트합니다.

```swift
import UIKit

import Alamofire
import SwiftyJSON
import URLNavigator
```

## 네이밍

### 클래스

- 클래스 이름에는 UpperCamelCase를 사용합니다.
- 클래스 이름에는 접두사<sup>Prefix</sup>를 붙이지 않습니다.

### 함수

- 함수 이름에는 lowerCamelCase를 사용합니다.
- 함수 이름 앞에는 되도록이면 `get`을 붙이지 않습니다.

    **좋은 예:**

    ```swift
    func name(for user: User) -> String?
    ```

    **나쁜 예:**

    ```swift
    func getName(for user: User) -> String?
    ```

- Action 함수의 네이밍은 '주어 + 동사 + 목적어' 형태를 사용합니다.

    - *Tap(눌렀다 뗌)*은 `UIControlEvents`의 `.touchUpInside`에 대응하고, *Press(누름)*는 `.touchDown`에 대응합니다.
    - *will~*은 특정 행위가 일어나기 직전이고, *did~*는 특정 행위가 일어난 직후입니다.
    - *should~*는 일반적으로 `Bool`을 반환하는 함수에 사용됩니다.

    **좋은 예:**

    ```swift
    func backButtonDidTap() {
    	// ...
    }
    ```

    **나쁜 예:**

    ```swift
    func back() {
    	// ...
    }

    func pressBack() {
    	// ...
    }
    ```

### 변수

- 변수 이름에는 lowerCamelCase를 사용합니다.

### 상수

- 상수 이름에는 lowerCamelCase를 사용합니다.

    **좋은 예:**

    ```swift
    let maximumNumberOfLines = 3
    ```

    **나쁜 예:**

    ```swift
    let kMaximumNumberOfLines = 3
    let MAX_LINES = 3
    ```
    
### 열거형

- enum의 각 case에는 lowerCamelCase를 사용합니다.

    **좋은 예:**

    ```swift
    enum Result {
      case .success
      case .failure
    }
    ```
    
    **나쁜 예:**

    ```swift
    enum Result {
      case .Success
      case .Failure
    }
    ```

### 약어

- 약어로 시작하는 경우 소문자로 표기하고, 그 외의 경우에는 항상 대문자로 표기합니다.

    **좋은 예:**

    <pre>
    let user<strong>ID</strong>: Int?
    let <strong>html</strong>: String?
    let website<strong>URL</strong>: URL?
    let <strong>url</strong>String: String?
    </pre>

    **나쁜 예:**

    <pre>
    let user<strong>Id</strong>: Int?
    let <strong>HTML</strong>: String?
    let website<strong>Url</strong>: NSURL?
    let <strong>URL</strong>String: String?
    </pre>

### Delegate

- Delegate 메서드는 프로토콜명으로 네임스페이스를 구분합니다.

    **좋은 예:**

    ```swift
    protocol UserCellDelegate {
      func userCellDidSetProfileImage(_ cell: UserCell)
      func userCell(_ cell: UserCell, didTapFollowButtonWith user: User)
    }
    ```

    **나쁜 예:**

    ```swift
    protocol UserCellDelegate {
      func didSetProfileImage()
      func followPressed(user: User)

      // `UserCell`이라는 클래스가 존재할 경우 컴파일 에러 발생
      func UserCell(_ cell: UserCell, didTapFollowButtonWith user: User)
    }
    ```

## 클로저

- 파라미터와 리턴 타입이 없는 Closure 정의시에는 `() -> Void`를 사용합니다.

    **좋은 예:**

    ```swift
    let completionBlock: (() -> Void)?
    ```

    **나쁜 예:**

    ```swift
    let completionBlock: (() -> ())?
    let completionBlock: ((Void) -> (Void))?
    ```

- Closure 정의시 파라미터에는 괄호를 사용하지 않습니다.

    **좋은 예:**

    ```swift
    { operaion, responseObject in
      // doSomething()
    }
    ```

    **나쁜 예:**

    ```swift
    { (operaion, responseObject) in
      // doSomething()
    }
    ```

- Closure 정의시 가능한 경우 타입 정의를 생략합니다.

    **좋은 예:**

    ```swift
    ...,
    completion: { finished in
      // doSomething()
    }
    ```

    **나쁜 예:**

    ```swift
    ...,
    completion: { (finished: Bool) -> Void in
      // doSomething()
    }
    ```

- Closure 호출시 또다른 유일한 Closure를 마지막 파라미터로 받는 경우, 파라미터 이름을 생략합니다.

    **좋은 예:**

    ```swift
    UIView.animate(withDuration: 0.5) {
      // doSomething()
    }
    ```

    **나쁜 예:**

    ```swift
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
      // doSomething()
    })
    ```

## 클래스와 구조체

- 클래스와 구조체 내부에서는 `self`를 명시적으로 사용합니다.
- 구조체를 생성할 때에는 Swift 구조체 생성자를 사용합니다.

    **좋은 예:**

    ```swift
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    ```

    **나쁜 예:**

    ```swift
    let frame = CGRectMake(0, 0, 100, 100)
    ```

## 타입

- `Array<T>`와 `Dictionary<T: U>` 보다는 `[T]`, `[T: U]`를 사용합니다.

    **좋은 예:**

    ```swift
    var messages: [String]?
    var names: [Int: String]?
    ```

    **나쁜 예:**

    ```swift
    var messages: Array<String>?
    var names: Dictionary<Int, String>?
    ```

## 주석

- `///`를 사용해서 문서화에 사용되는 주석을 남깁니다.

    ```swift
    /// 사용자 프로필을 그려주는 뷰
    class ProfileView: UIView {

        /// 사용자 닉네임을 그려주는 라벨
        var nameLabel: UILabel!
    }
    ```


- `// MARK:`를 사용해서 연관된 코드를 구분짓습니다.

    Objective-C에서 제공하는 `#pragma mark`와 같은 기능으로, 연관된 코드와 그렇지 않은 코드를 구분할 때 사용합니다.

    ```swift
    // MARK: Init

    override init(frame: CGRect) {
      // doSomething()
    }

    deinit {
      // doSomething()
    }


    // MARK: Layout

    override func layoutSubviews() {
      // doSomething()
    }


    // MARK: Actions

    override func menuButtonDidTap() {
      // doSomething()
    }
    ```

## 프로그래밍 권장사항

- 상수를 정의할 때에는 `enum`를 만들어 비슷한 상수끼리 모아둡니다. 재사용성과 유지보수 측면에서 큰 향상을 가져옵니다. `struct` 대신 `enum`을 사용하는 이유는, 생성자가 제공되지 않는 자료형을 사용하기 위해서입니다. [CGFloatLiteral](https://github.com/devxoul/CGFloatLiteral)과 [SwiftyColor](https://github.com/devxoul/SwiftyColor)를 사용해서 코드를 단순화시킵니다.

    ```swift
    final class ProfileViewController: UIViewController {

      enum Metric {
        static let profileImageViewLeft = 10.f
        static let profileImageViewRight = 10.f
        static let nameLabelTopBottom = 8.f
        static let bioLabelTop = 6.f
      }

      enum Font {
        static let nameLabel = UIFont.boldSystemFont(ofSize: 14)
        static let bioLabel = UIFont.boldSystemFont(ofSize: 12)
      }

      enum Color {
        static let nameLabelText = 0x000000.color
        static let bioLabelText = 0x333333.color ~ 70%
      }

    }
    ```

    이렇게 선언된 상수들은 다음과 같이 사용될 수 있습니다.

    ```swift
    self.profileImageView.frame.origin.x = Metric.profileImageViewLeft
    self.nameLabel.font = Font.nameLabel
    self.nameLabel.textColor = Color.nameLabelText
    ```

- 더이상 상속이 발생하지 않는 클래스는 항상 `final` 키워드로 선언합니다.

- 프로토콜을 적용할 때에는 extension을 만들어서 관련된 메서드를 모아둡니다.

    **좋은 예**:

    ```swift
    final class MyViewController: UIViewController {
      // ...
    }

    // MARK: - UITableViewDataSource

    extension MyViewController: UITableViewDataSource {
      // ...
    }

    // MARK: - UITableViewDelegate

    extension MyViewController: UITableViewDelegate {
      // ...
    }
    ```

    **나쁜 예**:

    ```swift
    final class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
      // ...
    }
    ```


### 라이센스

본 문서는 [StyleShare Swift Style Gude](https://github.com/StyleShare/swift-style-guide)를 참고하여 작성하였습니다.