VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsComm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "고장 처리 결과를 관리\r\n전체 건수, 성공 건수, 정보센터 접수 건수, 실패 건수\r\n다발 고장, 실패한 상태"
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Const TYP_TOTAL = 1
Const TYP_SUCCESS = 2
Const TYP_FAIL = 3
Const TYP_SERVICE = 4
Const TYP_SUBTOTAL = 5

Public Total As Long            ' 전체 건수
Attribute Total.VB_VarDescription = "프로그램 시작 후부터\r\n모뎀 프로그램으로부터 수신받은 고장 파일 갯수"
Public Success As Long          ' 성공 건수
Attribute Success.VB_VarDescription = "전체 건수 중에서 정상적으로 처리된 건수"
Public Fail As Long             ' 실패 건수
Attribute Fail.VB_VarDescription = "전체 건 수 중에서 정상적으로 처리 된지 않은 건 수"
Public Service As Long          ' 정보센터 접수 건수
Attribute Service.VB_VarDescription = "정보센터에 접수한 건 수"
Public ContinuedFail As String  ' 다발 고장 정보
Attribute ContinuedFail.VB_VarDescription = "다발 고장 정보"
Public LastError As String      ' 마지막 실패 정보
Attribute LastError.VB_VarDescription = "마지막으로 정상 처리되지 않은 고장 상태"
Public SubTotal As Long         ' 각 호기별 처리 건수
Attribute SubTotal.VB_VarDescription = "각 호기별 처리건수"
Public Multi As Integer         ' 다발고장 기준 건수
Attribute Multi.VB_VarDescription = "다발 고장 기준 건수"
Public AutoConn As Byte         ' DB 자동연결 Flag
Attribute AutoConn.VB_VarDescription = "DB 자동연결 Flag"
Public TestIn As Byte           ' 테스트 DB 입력
Public SICInsert As Byte        ' 정보센터 넣을것인지 여부
Attribute SICInsert.VB_VarDescription = "정보센터에 넣을것인지 여부"


' 종류별 건 수 증가
Public Sub IncCount(ByVal ValType As Byte)
Attribute IncCount.VB_Description = "파라미터에 해당하는 변수의 값을 증가"
Attribute IncCount.VB_UserMemId = 0
    Select Case ValType
        Case TYP_TOTAL
            Total = Total + 1
        Case TYP_SUCCESS
            Success = Success + 1
        Case TYP_FAIL
            Fail = Fail + 1
        Case TYP_SERVICE
            Service = Service + 1
        Case TYP_SUBTOTAL
            SubTotal = SubTotal + 1
    End Select
End Sub

' 클래스 초기화
Private Sub Class_Initialize()
    Dim strTmp As String
    
    Total = 0
    Success = 0
    Fail = 0
    Service = 0
    SubTotal = 0
    SICInsert = 0
    ContinuedFail = ""
    LastError = ""
    Multi = GetSetting("Commd", "Etc", "Multi", 10)
    strTmp = GetSetting("Commd", "Etc", "AutoConn", "00")
    If strTmp = "00" Then
        AutoConn = 0
    Else
        AutoConn = 1
    End If
    TestIn = 0
End Sub
