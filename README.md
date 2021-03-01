# GitSearch


#### Introduction  
Github API와 RxSwift, RxCocoa, MVVM 패턴을 기반으로 간단한 검색 앱을 구현하였습니다. 

#### Demo
![Feb-28-2021 07-06-41](https://user-images.githubusercontent.com/60660894/109401721-9280cc80-7993-11eb-9168-2ebb199e425b.gif)

#### Requirement 
- SearchBar에 텍스트를 입력할때마다 User를 검색한다. 
- Debounce는 0.3초로 구현한다. 
- User에는 프로필 이미지, 이름, Public Repo의 갯수를 표시한다.
- 최초에 보여지는 리스트의 수는 20명이며 스크롤에 따라서 추가로 로딩한다. 

#### Skill
URLSession, Codable, Storyboard, UIKit, RxSwift, RxCocoa, Driver, Bind

#### Architecture
- MVVM 

#### API 
- https://developer.github.com/v3/search/#search-users
- https://developer.github.com/v3/users/#get-a-single-user

