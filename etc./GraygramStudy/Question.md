# Question 
> `Graygram`을 공부하고 난 뒤 생긴 질문들을 정리한 파일입니다.

- ❓ `closure` `@escaping` `mapping`
- ❓ `let storage = HTTPCookieStorage.shared`에 쿠키저장.
- ❓ 접근제한자 구분하고 활용하기! - `filePrivate`, `private`, `first`
	- ❗️[접근제한자 정리 잘 되어있는 블로그](https://blog.asamaru.net/2017/01/04/swift-3-access-controls/)
	- `open` ▶️ `public` ▶️ `internal` ▶️ `filePrivate` ▶️ `private` 의 순으로 제한적이다.
	- `open` - defalut 값.
	- `first` - 다른 곳에서 접근은 가능하지만, 상속은 못받게 할 때 사용한다.
	- `private`, `filePrivate` - 둘 다 해당 class 내에서만 사용이 가능하고 가장 큰 차이점은 `filePrivate`는 extension에서도 접근이 가능하다.
- ❓ `extension`의 기능 확실히 짚고 넘어가기.
	- ❗️
	- type(class, struct, protocoo ....)에 새로운 기능을 추가할 순 있지만, **기존에 존재하는 기능을 재정의 할 수는 없다.*
	- 특히 외부 라이브러리를 사용할 때, **내가 원하는 기능을 추가**하고자 할 때 extension을 사용한다.
	- 상속과의 차이점 : 상속은 `class`에서만 가능하고 특정 타입을 물려받아 하나의 새로운 타입을 정의하고 추가 기능을 구현하는 수직 확장. extension은 기존의 타입에 기능(`func`, `closure`)을 추가하는 수평 확장이며 재정의할 수 없다.
- ❓`override` (재정의)
	- ❗️
	- 자식클래스는 부모로부터 물려받은 특성을 그대로 사용하지 않고 **자신만의 기능으로 변경하여 사용**할 수 있다. 이것이 `override`!
	- 자식클래스에서 부모클래스의 `method`를 `override`하여 **재정의 했지만 부모클래스의 재정의하지 않는 기능을 사용**하고 싶으면 `super` 프로퍼티를 사용하면 된다. `ex) super.someMethod()`
	- method나 property앞에 재정의를 못하게 하려면 `final`을 붙여서 정의해주면 된다. `ex) final var koreanAge :Int = 23 `
	- method뿐만아니라 property도 가능하당. property를 override할 때는 자체를 재정의하는 것이 아니라 `getter`, `setter`, `property observer`를 재정의하는 것을 의미한다.

		```swift
		override var koreanAge:Int {
			get {
					return super.koreanAge
			}
			
			set {
					self.age = newValue - 1
			}
		}
		```
		
- ❓ `struct`, `class`
	- ❗️ reference로 공유, 사용될 가능성(?)이 있는 경우에는 절대적으로 class 사용.
	- height, width, 2d, 3d같은 수치?를 포함할 때 struct를 사용하면 좋다좋다😀!
	- `struct`는 값 타입, `class`는 참조 타입.
		- **값 타입** : 상수나 변수에 할당되거나, 함수가 넘겨질 때 *복사*가 됨.
		- **참조 타입** : 복사하지 않고 인스턴스에 참조가 사용 됨.
		- 💡 즉, 사용하고 있는 변수가 바뀔 경우, 값타입에서는 다른곳에서 사용되는 곳에 영향이 없지만, 참조타입일 경우 전체적으로 바뀜.