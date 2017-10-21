# Graygram study
> [@devxoul](https://github.com/devxoul)님이 GitHub에 올려두신 [Graygram for iOS repository](https://github.com/devxoul/graygram-ios)를 공부하고 정리한 파일입니다.

### 🗂 폴더
- 크게 3가지로 구성.


	#### 🗂 Resources
	- 📋 `Assets.xcassets`, 📋`.storyboard` files
	
	#### 🗂 Supporting Files
	- 📋 `info.plist`
	
	#### 🗂 Sources
	- `Appdelegate.swift`를 포함한 Networking, service, Views ..... 의 폴더들
		- 📋 `Appdelegate.swift`
			- import
				1. `CGFloatLiteral`
				2. `Kingfisher` - server에서 이미지 가져올 때 코드 줄 수를 아주아주 줄여주는 pod.
				3. `ManualLayout` - Layout 잡을 때 편해지는 pod.
				4. `SnapKit` - Autolayout code로 잡을때 간결하게 코드 작성할 수 있게 하는 pod.
				5. `Then` - Storyboard없이 label, button 속성 추가할때 사용하면 매우매우 편리해지는 pod.
			- code
				- `window` setting
				- `TapBarController`, `NavigationController` setting.
				- TabBar, NavigationBar의 `tintColor` setting.

				
		- 🗂 `Networking`
			- ✔️ `Alamofire` 사용시 발생되는 error를 extention으로 정의.
			- 📋 `Response+ErrorInfo.swift` 
				- import : Alamofire
				- Alamofire의 `DataResonse` struct의 extension 생성.
					-  `func errorInfo() -> (message: String?, field: String?)?` 📌
			- 📋 `MappingError.swift` 
				- `MappingError` struct 생성. 📌 어디서 사용되는지 확인해보기.
			- 📋 `DataResponse+MapResult.swift` 
				- import : Alamofire
				- Alamofire의 `DataResonse` struct의 extension 생성.
					- `func mapResult<T>(_ transform: (Value) -> T) -> DataResponse<T>` : login에서 resonse에서 활용.
					- `func flatMapResult<T>(_ transform: (Value) -> Result<T>) -> DataResponse<T>` 📌

					
		- 🗂 `Service`
			- ✔️ App에서 제공되는 서비스
			- 📋 `APIServiceType.swift` 
				- `APIServiceType` struct 정의, extention 생성.
					- `static func url(_ path: String) -> String` : 사용되는 api의 기본 url에 path 입력시, 기본 url뒤에 붙어서 사용할 수 있는 형태로 return. 💡 `Networking` 폴더는 error, response를 신경쓰는 폴더이므로 역할이 다름.
			- 📋 `AuthService.swift` 
				- import : Alamofire
				- `AuthService` struct 정의.
					- `static func login(username: String, password: String, completion: @escaping (DataResponse<Void>) -> Void)`
					- `static func logout()`
			- 📋 `UserService.swift` 
				- import : Alamofire, ObjectMapper(JSON mapping에 사용)
				- user info 가져오기.				
			- 📋 `FeedService.swift` 
				- import : Alamofire
				- blahblah
			- 📋 `PostService.swift` 
				- import : Alamofire
				- blahblah				
								

		- 🗂 `folder`
			- ✔️ !
			- 📋 `.swift` 
				- import : Alamofire
				- blahblah

 		- 🗂 `folder`
			- ✔️ !
			- 📋 `.swift` 
				- import : Alamofire
				- blahblah

		- 🗂 `folder`
			- ✔️ !
			- 📋 `.swift` 
				- import : Alamofire
				- blahblah

		- 🗂 `folder`
			- ✔️ !
			- 📋 `.swift` 
				- import : Alamofire
				- blahblah

		- 🗂 `folder`
			- ✔️ !
			- 📋 `.swift` 
				- import : Alamofire
				- blahblah