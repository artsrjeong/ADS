LG-OTIS GEMIS Commd Readme

	Program version : 2.00.0013

개요
	이 프로그램은 RAS 통신서버에 설치되는 프로그램이다.
	주요 기능은 모뎀접수 프로그램으로부터 고장을 받아 원격감시, 정보센터에 접수한다.

설치
	설치 사양 : NT server 4.0 (including Service Pack 4 NT server 4.0)
	1) ODBC 설치
	2) MDAC2.5SP1-English 설치
		Commd에는 Microsoft Data Access Components (MDAC) 2.5가 필요합니다. 
		MDAC 2.5 Service Pack 1 버전이 설치되어 있지 않다면, Commd를 설치하기 이전에 
		반드시 이를 설치하여야 합니다.
	3) MDAC version 확인
		C:\Program Files\Common Files\System\ado\Msado15.dll
		The version should be 2.51.5303.0
	4) ODBC Setup
		System DSN - REM_DB
		Server : OTKRSEREM01
		System DSN - SIC_DB
		Server : OTKRSECCC01
		주의) 아래 내용은 공통사항으로 반드시 지켜야 한다.
		SQL 서버 인증 사용
		Uncheck ANSI 널, 채움 문자 및 경고 사용
		Uncheck 문자 데이터에 대한 변환 실행
	5) GEMIS Commd 프로그램 Setup
	6) Commd 프로그램 버젼 확인
		Program version : 2.00.0013

프로그램 실행 후 초기 설정
	1) Config 화면 설정
		Conn Tab에서 REM DSN Name, SIC DSN Name이 ODBC System DSN과 동일하게 설정 후 Save 버튼 클릭
	2) SIC Logon - 정상적으로 연결되었는지 상태바 확인
	3) REM Logon - 정상적으로 연결되었는지 상태바 확인

수정사항 이력
2001-05-17	현재) 정보센터 DB 연결 방식은 고장을 접수할때 Connect - 접수 - Disconnect 한다.
		이유) 중간에 서버를 잠시 Shutdown했을때 프로그램을 재실행해야 하는 일을 하지 않아도 된다.

2001-07-05	(1) V file 처리 기능 추가 - 이상현씨 요구
(ver 2.0.4)	(2) Directory 관리 - 정상->checked, file format error->err, 나머지->data
		(3) 건물정전(F0)의 우선순위를 제일 높게해서 처리

2001-08-28	(1) REM DB 연결-고장입력-연결 끊기 방식으로 처리
(ver 2.0.8)	(2) 정보센터에 넣을것인지 여부를 Spec화 - default는 넣음. 
		    예외 상황이 발생한 경우 원격감시만 입력하고 정보센터는 무시할 경우 대비.

2001-08-30	(1) 프로그램 버그 발견 - 정보센터 접수 안됨
(ver 2.0.11)	    원인) 정전 처리 코드 추가후 문제 발생 & 원인 제거

2001-10-23	(1) V File 처리 Routine 무시
(ver 2.0.13)

200-11-14	(1) 프로그램 버그 발견 - 고장중에서 3A -> 00 으로 등록
(ver 2.0.15)	    hexFormat()으로 수정하였음.
		(2) 기능 추가 - Escalator에서 DB없이 사용하는 경우에는 Log 파일만 남김
		    사용방법은 Config -> Gen 탭에서 체크박스 "Using this program to Escalator" Check한다.