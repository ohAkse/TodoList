# **Notice**

![Simulator Screenshot - 3 - 2023-09-20 at 21 00 35](https://github.com/ohAkse/TodoList/assets/49290883/b34b3b59-4a1a-4d9b-9a52-17d6f636fe62)
<p align="center">MVVM Todo 화면 이동하기/ 인스타 UI화면으로 이동하기</p>

![Simulator Screenshot - 3 - 2023-09-20 at 21 01 27](https://github.com/ohAkse/TodoList/assets/49290883/594e8965-53dd-4029-b771-350c1d3f7e77)
<p align="center">인스타 화면(프로필 클릭시 간단하게 르탄이 나이?이름? MVVM 바인딩하여 결과를 확인할수 있는 화면이동 가능</p>

*텍스트필드에 입력후 다른 텍스트필드로 Focus 전환시 라벨의 텍스트가 입력되는 단순한 예제(예외처리가 완벽히 되지 않아 키보드가 나온 상태로 입력해주세요)

![Simulator Screenshot - 3 - 2023-09-20 at 21 01 00](https://github.com/ohAkse/TodoList/assets/49290883/9fbf6ad1-353f-4c31-8cbf-8bffe4939677)
<p align="center">CoreData를 이용하여 간단하게 리스트로 확인하는 화면</p>



# 개발언어 및 모듈
개발언어 : 
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white">   
사용 기술 :  <img src="https://img.shields.io/badge/async/await-E60012?style=for-the-badge&logo=asciidoctor&logoColor=white"><img src="https://img.shields.io/badge/URLSession-6332F6?style=for-the-badge&logo=asciidoctor&logoColor=white"><img src="https://img.shields.io/badge/userdefaults-58B7FE?style=for-the-badge&logo=asciidoctor&logoColor=white"><img src="https://img.shields.io/badge/GCD-A9225C?style=for-the-badge&logo=asciidoctor&logoColor=white">  
외부라이브러리 모듈 : <img src="https://img.shields.io/badge/NVActivityIndicatorView-00CEC8?style=for-the-badge&logo=spreadshirt&logoColor=white"><img src="https://img.shields.io/badge/Snapkit-6264A7?style=for-the-badge&logo=snapcraft&logoColor=white">

# **Q&A**
a.UserDefaults와 CoreData의 차이점을 README에 적어주세요.
*UserDefaults의 경우 String, Dictionary, Boolean등 간단한 데이터를 저장하는데 비해 CoreData의 경우 Database와 비슷하게 기능을 하여 보다 복잡한 데이터 구조를 다루어 Local Storage형태로 저장함
*모델링을 만드는부분에서 UserDefault는 모델링을 바로 저장하는 형식이 아닌, 모델링을 Json으로 직렬화하여 Key값으로 저장해야하는등 번거로움이 있지만, CoreData의 경우 DataModel을 만들면 자동으로 Model을 추가가능

b.MVC를 목표로 구현했던 숙련 과제와 MVVM을 구현했던 ProfileViewController를 비교해보세요.
*기존에 구현했던 MVC의 경우 View와 Controller사이에서 상호작용을 하고 로직이나 UI 변경 사항이 많아지면 코드의 양이 많아지는 문제가 있었으나, MVVM으로 구현했을 경우 View쪽에서 데이터 바인딩을 하고 ViewModel에 뭔가 요청을 하게되면 ViewModel에서 처리한 결과를 토대로 자동으로 바인딩된 값을 UI에 반영을 할 수 있어 구조를 보다 세분화시켜 관리하기가 더 용이함을 느꼈습니다.



c.아래 ViewController를 기준으로 구조를 설명해주세요(각 기능별관계는 없어도 됩니다.)
참고 구조)
![스크린샷 2023-09-20 오후 10 18 30](https://github.com/ohAkse/TodoList/assets/49290883/dbf009d6-6bce-4f3c-890c-5d7e693a09e4)

*ProfileViewController : ProfileViewController를 만들면서 해당 뷰컨트롤러의 데이터 흐름을 관리할 viewModel(ProfileViewModel)을 해당 뷰컨트롤러에 주입시켜 viewModel에서 사용될 데이터를 데이터 바인딩시킵니다. 이후 viewModel에 데이터가 변화가 있을 시 해당 View쪽에 변경사항을 알려주어 결과값을 UI에 업데이트 시킵니다. 따라서 ViewModel에 있는 CoreDataManager 및 Observable<Todo> 변수를 이용하여 데이터 흐름을 감지하고 데이터의 추가, 삭제, 수정 등이 있을 시 View쪽에서는 ViewModel로부터 전달받은 값을 UI만 업데이트 시킵니다.


d.자신이 만든 앱의 구조를 파악하는 것은 쉬운 일이 아닙니다. 만든 코드를 되돌아본다고 생각하면서 구조를 그리고 텍스트로 설명해주세요.
*MVVM의 가장큰 핵심적인 기능이 View와 분리 및 Data Binding인데 완벽하게 구현은 하지 못했지만 프로그램의 소스코드가 길어지고 로직이 많아질수록 비즈니스로직과 UI 업데이트를 분리함으로써 유지보수 및 관리적인 측면에서 더 용이할것이라는 생각이 들었습니다.




# **본 프로젝트에서 중점적으로 생각해보고 고민해본 사항**

1)**View와 Control의 분리** : 최대한 중복되는 부분은 함수로 묶고 enum처리나 extension으로 분리하여 처리하도록 노력하였습니다.

2)**UI 구성** : 인스타 UI 구성시 최대한 요구사항에 맞춰 작성하도록 노력하였습니다.



# **보완해야 할 점**

1)**예외 처리** : 특정 기능 작동시 예외처리가 덜되어 오류가 발생할수 았음(ex, 인스타 프로필을 클릭하여 텍스트필드(AgeTextField)에 값을 입력시 에뮬레이터 키보드를 이용하지 않고 수동으로 입력할경우 문제 발생

2)**코드 컨벤션 ** : 급하게 작성하다보니 변수명, 함수이름, 클래스 이름 등 다소 통일성이 부족함

3)**MVVM 패턴 작성 ** : 옵저버 패턴을 이용하여 구현하였는데 효율적인 처리가 있음에도 불구하고 완벽하게 처리 하지못함(ex, tableViewCell databinding)

4)**리팩토링 ** : 개인적 사유로 인한 개발 시간 제약때문에 코드가 난잡함






