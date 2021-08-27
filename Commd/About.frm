VERSION 5.00
Begin VB.Form frmAbout 
   BackColor       =   &H00FFE7E6&
   BorderStyle     =   1  '단일 고정
   Caption         =   "GEMIS Commd"
   ClientHeight    =   2640
   ClientLeft      =   2340
   ClientTop       =   1935
   ClientWidth     =   4740
   ClipControls    =   0   'False
   Icon            =   "About.frx":0000
   LinkTopic       =   "Form2"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   Picture         =   "About.frx":08CA
   ScaleHeight     =   1822.175
   ScaleMode       =   0  '사용자
   ScaleWidth      =   4451.104
   Begin VB.Image imgSysinfo 
      Height          =   420
      Left            =   3300
      MousePointer    =   99  '사용자 정의
      ToolTipText     =   "시스템 정보"
      Top             =   1860
      Width           =   555
   End
   Begin VB.Image imgOK 
      Height          =   420
      Left            =   3900
      MousePointer    =   99  '사용자 정의
      ToolTipText     =   "확인"
      Top             =   1860
      Width           =   555
   End
   Begin VB.Label Label1 
      BackColor       =   &H00FFE7E6&
      Caption         =   "Copyright (C) LG-OTIS 2001 All right reserved."
      ForeColor       =   &H00800000&
      Height          =   255
      Left            =   510
      TabIndex        =   3
      Top             =   2340
      Width           =   4125
   End
   Begin VB.Image Image1 
      Height          =   570
      Left            =   150
      Picture         =   "About.frx":1194
      Stretch         =   -1  'True
      Top             =   120
      Width           =   570
   End
   Begin VB.Label lblDescription 
      BackColor       =   &H00FFE7E6&
      Caption         =   "Program description :"
      ForeColor       =   &H00000000&
      Height          =   630
      Left            =   840
      TabIndex        =   0
      Top             =   945
      Width           =   3825
   End
   Begin VB.Label lblTitle 
      BackColor       =   &H00FFE7E6&
      Caption         =   "GEMIS SYSTEM"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   14.25
         Charset         =   129
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00800000&
      Height          =   420
      Left            =   810
      TabIndex        =   1
      Top             =   150
      Width           =   3585
   End
   Begin VB.Label lblVersion 
      BackColor       =   &H00FFE7E6&
      Caption         =   "Version : "
      Height          =   225
      Left            =   840
      TabIndex        =   2
      Top             =   600
      Width           =   3825
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' 레지스터리 보안 옵션.
Const READ_CONTROL = &H20000
Const KEY_QUERY_VALUE = &H1
Const KEY_SET_VALUE = &H2
Const KEY_CREATE_SUB_KEY = &H4
Const KEY_ENUMERATE_SUB_KEYS = &H8
Const KEY_NOTIFY = &H10
Const KEY_CREATE_LINK = &H20
Const KEY_ALL_ACCESS = KEY_QUERY_VALUE + KEY_SET_VALUE + _
                       KEY_CREATE_SUB_KEY + KEY_ENUMERATE_SUB_KEYS + _
                       KEY_NOTIFY + KEY_CREATE_LINK + READ_CONTROL
                     
' 레지스터리 키 ROOT 형식...
Const HKEY_LOCAL_MACHINE = &H80000002
Const ERROR_SUCCESS = 0
Const REG_SZ = 1                         ' Unicode null 종료 문자열
Const REG_DWORD = 4                      ' 32비트 숫자

Const gREGKEYSYSINFOLOC = "SOFTWARE\Microsoft\Shared Tools Location"
Const gREGVALSYSINFOLOC = "MSINFO"
Const gREGKEYSYSINFO = "SOFTWARE\Microsoft\Shared Tools\MSINFO"
Const gREGVALSYSINFO = "PATH"

Private Declare Function RegOpenKeyEx Lib "advapi32" Alias "RegOpenKeyExA" _
    (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, _
    ByVal samDesired As Long, ByRef phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32" Alias "RegQueryValueExA" _
    (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, _
    ByRef lpType As Long, ByVal lpData As String, ByRef lpcbData As Long) As Long
Private Declare Function RegCloseKey Lib "advapi32" (ByVal hKey As Long) As Long

Public Sub StartSysInfo()
    Dim rc As Long
    Dim SysInfoPath As String
    
    On Error GoTo SysInfoErr
    
    ' 시스템 정보 프로그램의 경로와 이름을 레지스터리에서 가져온다.
    If GetKeyValue(HKEY_LOCAL_MACHINE, gREGKEYSYSINFO, _
        gREGVALSYSINFO, SysInfoPath) Then
    '  시스템 정보 프로그램의 경로를 레지스터리에서만 가져온다.
    ElseIf GetKeyValue(HKEY_LOCAL_MACHINE, gREGKEYSYSINFOLOC, _
        gREGVALSYSINFOLOC, SysInfoPath) Then
        ' 알려진 32비트 파일 버전의 존재 여부를 확인한다.
        If (Dir(SysInfoPath & "\MSINFO32.EXE") <> "") Then
            SysInfoPath = SysInfoPath & "\MSINFO32.EXE"
            
        ' 오류 - 파일을 찾을 수 없다.
        Else
            GoTo SysInfoErr
        End If
    ' 오류 - 레지스터리 항목을 찾을 수 없다.
    Else
        GoTo SysInfoErr
    End If
    
    Call Shell(SysInfoPath, vbNormalFocus)
    
    Exit Sub
SysInfoErr:
    MsgBox "You can't use this program.", vbOKOnly
End Sub

Public Function GetKeyValue(KeyRoot As Long, KeyName As String, _
    SubKeyRef As String, ByRef KeyVal As String) As Boolean
    Dim i As Long                            ' 루프 카운터
    Dim rc As Long                          ' 반환 코드
    Dim hKey As Long                      ' 열려 있는 레지스터리 키 처리
    Dim hDepth As Long
    Dim KeyValType As Long            ' 레지스터리 키의 데이터 형식
    Dim tmpVal As String                  ' 레지스터리 키 값을 임시로 저장
    Dim KeyValSize As Long            ' 레지스터리 키 변수의 크기
    '------------------------------------------------------------
    ' Open RegKey Under KeyRoot {HKEY_LOCAL_MACHINE...}
    '------------------------------------------------------------
    ' 레지스터리 키를 엽니다.
    rc = RegOpenKeyEx(KeyRoot, KeyName, 0, KEY_ALL_ACCESS, hKey)
    
    ' 오류를 처리합니다.
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError
    
    tmpVal = String$(1024, 0)                             ' 변수의 크기를 할당한다.
    KeyValSize = 1024                                       ' 변수 크기를 표시한다.
    
    '------------------------------------------------------------
    ' 레지스터리 키 값을 읽어옵니다...
    '------------------------------------------------------------
    rc = RegQueryValueEx(hKey, SubKeyRef, 0, _
                         KeyValType, tmpVal, KeyValSize) ' 키 값을 가져오고 작성한다.
                        
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError
    
    If (Asc(Mid(tmpVal, KeyValSize, 1)) = 0) Then    ' Win95는 Null 종료 문자열을 추가한다.
        tmpVal = Left(tmpVal, KeyValSize - 1)          ' Null을 찾았습니다. 문자열에서 추출한다.
    Else                                                    ' WinNT는 Null 종료 문자열 추가하지 않는다.
        tmpVal = Left(tmpVal, KeyValSize)      ' Null을 찾지 못했습니다. 문자열에서만 추출한다.
    End If
    '------------------------------------------------------------
    ' Determine Key Value Type For Conversion...
    '------------------------------------------------------------
    Select Case KeyValType                                  ' 데이터 형식을 검색한다.
    Case REG_SZ                                             ' 문자열 레지스터리 키 데이터 형식
        KeyVal = tmpVal                                     ' 문자열 값을 복사한다.
    Case REG_DWORD                                          ' 이진 단어 레지스터리 키 데이터 형식
        For i = Len(tmpVal) To 1 Step -1                    ' 각각 비트를 변환한다.
            KeyVal = KeyVal + Hex(Asc(Mid(tmpVal, i, 1)))   ' 값 문자를 문자별로 작성한다.
        Next
        KeyVal = Format$("&h" + KeyVal)                     ' 이진 단어를 문자열로 변환한다.
    End Select
    
    GetKeyValue = True
    rc = RegCloseKey(hKey)                          ' 레지스터리 키를 닫는다.
    Exit Function
    
GetKeyError:      ' 오류가 발생하면 지운다.
    KeyVal = ""                                             ' 반환값을 빈 문자열로 설정한다.
    GetKeyValue = False                                     ' 실패를 반환한다..
    rc = RegCloseKey(hKey)                                  ' 레지스터리 키를 닫는다.
End Function

Private Sub imgOK_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgOK, "Confirm_Down")
End Sub

Private Sub imgOK_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgOK, "Confirm")
End Sub

Private Sub imgSysinfo_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgSysinfo, "SysInfo_Down")
End Sub

Private Sub imgSysinfo_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgSysinfo, "SysInfo")
End Sub

' 시스템 정보
Private Sub imgSysInfo_Click()
    Call StartSysInfo
End Sub

Private Sub imgOK_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    lblVersion.Caption = "Version : " & App.Major & "." & App.Minor & "." & App.Revision
    lblDescription = "This program is LG-OTIS GEMIS Commd " & vbCrLf & _
                     "that is located in the RAS Communication Server "
                
    Call SetImg(imgSysinfo, "SysInfo")
    Call SetImg(imgOK, "Confirm")
End Sub

