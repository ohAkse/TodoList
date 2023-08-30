# **Notice**
1)기존에 작업했던 브랜치의 경우 프로젝트가 열리지 않는 문제가 있어 새롭게 브랜치 만들어 작성했습니다. **이전 커밋내역은 우측 링크에서 확인**하실수있습니다.(https://github.com/ohAkse/Memo2)

2)MVVM 패턴을 적용한 다른 코드는(https://github.com/ohAkse/TodoList/tree/release_mvvm)여기서 확인하실 수 있습니다.(RxSwift/Combine 적용 X)
  
3)UISheetPresentationController를 사용함으로 인해 최소 **IOS 15버전 이상이여야 정상적으로 확인**하실수 있으며, 추가과제 기능 구현 중 이미지를 불러오는 부분에서 16버전이상일 경우와 아닌 경우에 따라 이미지를 받아오는 로직을 다르게 처리하는 부분이 있어 OS 버전별로 기능 확인하실 수 있습니다.(15-15.5 -> 비동기 콜백함수로 처리, 16버전 이상 -> Async await 비동기 함수 처리)  
* **async/await처리를 담당하는 함수는 두개의 작업이 끝났을때 UI에 동시에 보여지며, 비동기 콜백 함수처리의 경우 작업단위를 구분짓고 처리가 완료되는대로 UI에 표시되게 기능을 구현**하였습니다.

4)에뮬레이터로 Userdefauls 변경사항이 생긴후 바로 빌드 및 재실행시 저장되는 userdefaults 내용을 관리하는 파일에 Write하는 속도가 매우 느림으로 인해 정상적으로 저장 안될수도 있습니다.  

![userdefaults](https://github.com/ohAkse/TodoList/assets/49290883/c5f72d62-70a3-423b-bf28-6aff83b8eca0)  
**-디스크에 UserDefault로 저장한 내용이 늦게 저장되는 화면**

5)추가과제 기능 구현 중 thedog(cat)api를 사용하였는데 받아오는 사진 형식이 간혈적으로 gif인 경우가 있어 못받아오는 경우가 있습니다. gif로 받아왔을때 처리나,이미지 로드 실패했을 때 retry하는 로직 추가, Fail Image 변경 등은 추가하지 않았으며 **로딩바가 계속 나올 시 뒤로가기 했다가 다시 들어갈 경우 정상적으로 이미지 로드 되는것을 확인**하실 수 있습니다.


# 개발언어 및 모듈
개발언어 : 
<img src="https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white">   
사용 기술 :  <img src="https://img.shields.io/badge/async/await-E60012?style=for-the-badge&logo=asciidoctor&logoColor=white"><img src="https://img.shields.io/badge/URLSession-6332F6?style=for-the-badge&logo=asciidoctor&logoColor=white"><img src="https://img.shields.io/badge/userdefaults-58B7FE?style=for-the-badge&logo=asciidoctor&logoColor=white"><img src="https://img.shields.io/badge/GCD-A9225C?style=for-the-badge&logo=asciidoctor&logoColor=white">  
외부라이브러리 모듈 : <img src="https://img.shields.io/badge/NVActivityIndicatorView-00CEC8?style=for-the-badge&logo=spreadshirt&logoColor=white"><img src="https://img.shields.io/badge/Snapkit-6264A7?style=for-the-badge&logo=snapcraft&logoColor=white">

# **프로젝트 간단 소개**

**Model**: 프로젝트에서 데이터를 다루는 모델은 TodoList와 관련된 데이터를 다루는 Memo구조체를 관리하여 userdefault로 변경사항을 추가, 삭제, 저장 등을 다루는 LocalDBManager와 thedogapi를 다루는 animal 구조체를 이용 및 네트워크 통신을 관리하는 NetworkManager로 이루어져 있습니다.

**View**: 총 6가지의 화면이 있습니다. 

![스크린샷 2023-08-27 오후 4 25 19](https://github.com/ohAkse/TodoList/assets/49290883/3fc174e0-717e-475e-bf13-4de42fc3bd27)


MemoHomeViewController : 처음 앱을 실행했을 때 보여지는 View이며, TodoList로 이동하기, 완료 목록 이동하기, 동물 구경하러 이동하기 등 버튼을 터치하여 이동하는 기능을 담당합니다.

MemoListViewController : TodoList를 관리하는 View이며, 이 화면이 담당하는 기능은 다음과 같습니다. 
1)할일 추가 : 우측 상단의 네비게이션 바의 + 버튼을 터치하여 카테고리와 내용을 입력하면 테이블뷰에 카테고리에 해당되는 내용을 추가합니다.
2)할일 완료 처리 : 스위치 버튼을 on/off를 함에 따라 항목을 완료처리 할수 있으며, 완료처리가 된 항목은 해당 Text의 밑줄이 그어지고, 완료페이지에서 내용을 따로 확인하실수 있습니다.
3)할일 수정 : 텍스트 내용을 수정하려면 셀안에 있는 텍스트를 터치하거나, 셀을 우측에서 슬라이딩하여 pencil 아이콘을 터치후 내용을 수정합니다.
4)할일 삭제 :  셀을 우측에서 슬라이딩하여 trash 아이콘을 터치후 내용을 삭제합니다.
각 카테고리 별 항목에 따라 완료되지 않은 항목을 확인할 수 있으며, 모든 카테고리의 항목들이 완료가 되었다면, "All Plans have been executed!"라는 문구가 테이블뷰 하단에 나오게 됩니다.

MemocategoryViewController : 할일을 추가할 때 카테고리를 선택하는 화면입니다.

MemoWriteViewController : 할일을 수정하거나 추가할때 내용을 담당하는 화면입니다.

MemoCompleteViewController : 완료된 항목만을 나타내는 항목이며, 네비게이션바 좌측의 카테고리를 선택하여 내용을 확인할수있고 우측의 오름차순/내림차순을 통해 내용을 재정렬하여 확인할수있습니다.

PetViewController : 추가과제를 보여주기 위한 화면으로써, API를 통해 얻은 이미지(강아지,고양이)를 확인 할 수 있는 화면입니다.

**Controller**
사용자의 User Action을 통해 받은 이벤트를 토대로 데이터를 처리하고 UI를 Update하는 부분으로써 
본 프로젝트에서는 addtarget이나 closure를 통해 받은 UI 이벤트를 처리하고 userdefaults로 저장후 UI를 다시 update하는 로직으로 구성하였습니다.(주로 extension으로 처리하는 부분이 Controller로 사용되었습니다.)


# **본 프로젝트에서 중점적으로 생각해보고 고민해본 사항**

1)**코드 가독성** : 최대한 중복되는 부분은 함수로 묶고 enum처리나 extension으로 분리하여 처리하도록 노력하였습니다.

2)**강한 참조 처리** : 모든 페이지를 소멸자 부분에 print를 하여 정상적으로 메모리 해제가 되는지 확인하여, 누수가 없는지 확인하였습니다.

3)**사용가능 버전 분기 처리 및 비동기/동시성 처리** : OS 사용 가능 버전 분기 처리에 익숙해지기 위해 간단한 기능 추가(url 이미지 처리)를 처리하는데 분기처리했습니다.(15~15.5버전 비동기 콜백, 16버전이상은 Async/await)
단, UI의 경우 실행되는 디바이스의 OS 버전이 15보다 낮을 경우 UISheetPresentationController(15버전 이상)로 인해 리스트의 추가/삭제가 안될수 있습니다.

4)**HttpresponseStatus** : 추가기능 구현중 API 통신 중 예외처리 추가 기능 구현이 있어 시도를 해보았지만, 웹쪽 도메인 지식이 많지 않아 최대한 의미에 맞게 분기처리를하여 로그를 남기도록 하였지만 불명확한 부분이 있을 수 있습니다. 

