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
			- 📋 `APIServiceType.swift` : Alamofire를 이용해 서버에 요청할 url를 정의하는 함수를 요청한다.
				- `APIServiceType` struct 정의, extention 생성.
					- `static func url(_ path: String) -> String` : 사용되는 api의 기본 url에 path 입력시, 기본 url뒤에 붙어서 사용할 수 있는 형태로 return. 💡 `Networking` 폴더는 error, response를 신경쓰는 폴더이므로 역할이 다름.
			- 📋 `AuthService.swift` 
				- import : Alamofire
				- `AuthService` struct 정의. * *APIService struct를 상속.*
					- `static func login(username: String, password: String, completion: @escaping (DataResponse<Void>) -> Void)`
					- `static func logout()`
			- 📋 `UserService.swift` : user 정보 가져온다. 
				- import : Alamofire, ObjectMapper(JSON mapping에 사용)
				- `UserService` struct 정의. * *APIService struct를 상속.*
					- `static func me(_ completion: @escaping (DataResponse<User>) -> Void)`
			- 📋 `FeedService.swift` 
				- import : Alamofire, ObjectMapper
				- `FeedService` struct * *APIService struct를 상속.*
					- `static func feed(paging: Paging, completion: @escaping (DataResponse<Feed>) -> Void)`
			- 📋 `PostService.swift` 
				- import : Alamofire, ObjectMapper
				- `PostService` struct 	* *APIService struct를 상속.*
					- `static func create(image: UIImage, message: String?, progress: @escaping (Progress) -> Void, completion: @escaping (DataResponse<Post>) -> Void)` : PostEditorViewController에서 글 작성하는 networking에서 사용.	
					- `static func post(id: Int, completion: @escaping (DataResponse<Post>) -> Void)` : POST view controller에서 networking에서 사용.
					- `static func like(postID: Int, completion: ((DataResponse<Void>) -> Void)? = nil)`
					- `static func unlike(postID: Int, completion: ((DataResponse<Void>) -> Void)? = nil)`

		- 🗂 `types`
			- ✔️ enum으로 선택할 수 있는 것들을 정리.
			- 📋 `PhotoSize.swift` 
				- enum `PhotoSize` : hd, large, medium, thumbnail, small, tiny
				- var `point` : 개발에 사용되는 포인트 크기. ???????🐞
				- var `pixel` : 렌더링에 사용되는 픽셀 크기.
			- 📋 `Paging.swift` 
				- enum `Paging` : refresh, next(string)
			- 📋 `FeedViewMode.swift` 
				- enum `FeedViewMode` : card, tile

 		- 🗂 `Models`
			- ✔️ ObjectMapper를 사용하여 받아오는 모델을 정의해 줌.
			- 폴더안에 모든 파일이 ObjectMapper 오픈소스를 사용한다. ObjectMapper를 이용하여 모델을 정의할 때에는 Mappable을 상속받는다.
			- 📋 `User.swift` 
				- import : ObjectMapper
				- struct `User`
					- `Mappable` 상속받았다.
					- 💡 struct이므로 변수를 바꿀 method를 사용하기 위해서는 mutating을 func앞에 붙여줘야한다. (class와 struct의 가장 큰 차이)
			- 📋 `Post.swift` 
				- import : ObjectMapper
				- struct `Post`
			- 📋 `Feed.swift` 
				- import : ObjectMapper
				- struct `Feed`		

		- 🗂 `ViewControllers`
			- ✔️ !
			- 📋 `SplashViewController.swift` 
				- import : UIKit
				- `final class SplashViewController: UIViewController` : 프로필 정보 받아오기.
				- 💡 다른 곳에서 상속받지 못하게 할 때 class앞에 final!!!! - 접근제한자
			- 📋 `MainTabBarController.swift` 
				- import : UIKit
				- `final class MainTabBarController: UITabBarController`	
					- `FeedViewController`, `SettingViewController` 두 가지를 가져와서 상수로 set.
					- 💡 `filePrivate`, `private` - 접근제한자
					- extention으로 `TapBarController`를 set.
			- 📋 `LoginViewController.swift` 
				- import : UIKit
				- `final class LoginViewController:UIViewController`
					- UI들을 fileprivate, 코드로 생성했다.
					- `#selector`로 설정할 `func`들 정의.
			- 📋 `FeedViewController.swift` 
				- import : UIKit
				- `final class FeedViewController:UIViewController`	
					- class안에 `file private struct Metric` 정의.
					- view 모드를 button 클릭시 view mode를 미리 switch closure로 정의된 변수로.
					- `collectionView`는 class안에서 정의해주고 delegate로 상속받아서 설정 해주는 것들은 다 extension으로 설정.
			- 📋 `PostViewController.swift` 
				- import : UIKit
			- 📋 `ImageCropViewController.swift` 
				- import : UIKit
			- 📋 `PostEditorViewController.swift` 
				- import : UIKit
			- 📋 `SettingViewController.swift` 
				- import : UIKit, SafariServices

		- 🗂 `Views`
			- ✔️ tableView, collectionView의 cell들을 정의.
			- 📋 `PostCardCell.swift` 
				- import : UIKit
				- Metic, Constant, Font처럼 한가지를 크기, 색과 같이 여러가지 프로퍼티를 정의해줘야 하는 겅우, struct로 정의해서 하나로 묶어주었다.
				- ㅑ
			- 📋 `PostTileCell.swift` 
				- import : UIKit
				- blahblah				
			- 📋 `CollectionActivityIndicatorView.swift` 
				- import : UIKit
				- blahblah				
			- 📋 `PostEditorImageCell.swift` 
				- import : UIKit
				- blahblah	
			- 📋 `PostEditorMessageCell.swift` 
				- import : UIKit
				- blahblah				
			- 📋 `SettingsCell.swift` 
				- import : UIKit
				- blahblah

				
		- 🗂 `Utils`
			- ✔️ !
			- 📋 `String+BoundingRect.swift` : string의 extension
			- 📋 `UIImageView+Photo.swift` : UIimageView의 extension
			- 📋 `UIImage+Grayscaled.swift` : UIImage의 extension
				
				
				
				
				
				