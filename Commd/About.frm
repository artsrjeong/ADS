VERSION 5.00
Begin VB.Form frmAbout 
   BackColor       =   &H00FFE7E6&
   BorderStyle     =   1  '���� ����
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
   ScaleMode       =   0  '�����
   ScaleWidth      =   4451.104
   Begin VB.Image imgSysinfo 
      Height          =   420
      Left            =   3300
      MousePointer    =   99  '����� ����
      ToolTipText     =   "�ý��� ����"
      Top             =   1860
      Width           =   555
   End
   Begin VB.Image imgOK 
      Height          =   420
      Left            =   3900
      MousePointer    =   99  '����� ����
      ToolTipText     =   "Ȯ��"
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
         Name            =   "����"
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

' �������͸� ���� �ɼ�.
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
                     
' �������͸� Ű ROOT ����...
Const HKEY_LOCAL_MACHINE = &H80000002
Const ERROR_SUCCESS = 0
Const REG_SZ = 1                         ' Unicode null ���� ���ڿ�
Const REG_DWORD = 4                      ' 32��Ʈ ����

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
    
    ' �ý��� ���� ���α׷��� ��ο� �̸��� �������͸����� �����´�.
    If GetKeyValue(HKEY_LOCAL_MACHINE, gREGKEYSYSINFO, _
        gREGVALSYSINFO, SysInfoPath) Then
    '  �ý��� ���� ���α׷��� ��θ� �������͸������� �����´�.
    ElseIf GetKeyValue(HKEY_LOCAL_MACHINE, gREGKEYSYSINFOLOC, _
        gREGVALSYSINFOLOC, SysInfoPath) Then
        ' �˷��� 32��Ʈ ���� ������ ���� ���θ� Ȯ���Ѵ�.
        If (Dir(SysInfoPath & "\MSINFO32.EXE") <> "") Then
            SysInfoPath = SysInfoPath & "\MSINFO32.EXE"
            
        ' ���� - ������ ã�� �� ����.
        Else
            GoTo SysInfoErr
        End If
    ' ���� - �������͸� �׸��� ã�� �� ����.
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
    Dim i As Long                            ' ���� ī����
    Dim rc As Long                          ' ��ȯ �ڵ�
    Dim hKey As Long                      ' ���� �ִ� �������͸� Ű ó��
    Dim hDepth As Long
    Dim KeyValType As Long            ' �������͸� Ű�� ������ ����
    Dim tmpVal As String                  ' �������͸� Ű ���� �ӽ÷� ����
    Dim KeyValSize As Long            ' �������͸� Ű ������ ũ��
    '------------------------------------------------------------
    ' Open RegKey Under KeyRoot {HKEY_LOCAL_MACHINE...}
    '------------------------------------------------------------
    ' �������͸� Ű�� ���ϴ�.
    rc = RegOpenKeyEx(KeyRoot, KeyName, 0, KEY_ALL_ACCESS, hKey)
    
    ' ������ ó���մϴ�.
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError
    
    tmpVal = String$(1024, 0)                             ' ������ ũ�⸦ �Ҵ��Ѵ�.
    KeyValSize = 1024                                       ' ���� ũ�⸦ ǥ���Ѵ�.
    
    '------------------------------------------------------------
    ' �������͸� Ű ���� �о�ɴϴ�...
    '------------------------------------------------------------
    rc = RegQueryValueEx(hKey, SubKeyRef, 0, _
                         KeyValType, tmpVal, KeyValSize) ' Ű ���� �������� �ۼ��Ѵ�.
                        
    If (rc <> ERROR_SUCCESS) Then GoTo GetKeyError
    
    If (Asc(Mid(tmpVal, KeyValSize, 1)) = 0) Then    ' Win95�� Null ���� ���ڿ��� �߰��Ѵ�.
        tmpVal = Left(tmpVal, KeyValSize - 1)          ' Null�� ã�ҽ��ϴ�. ���ڿ����� �����Ѵ�.
    Else                                                    ' WinNT�� Null ���� ���ڿ� �߰����� �ʴ´�.
        tmpVal = Left(tmpVal, KeyValSize)      ' Null�� ã�� ���߽��ϴ�. ���ڿ������� �����Ѵ�.
    End If
    '------------------------------------------------------------
    ' Determine Key Value Type For Conversion...
    '------------------------------------------------------------
    Select Case KeyValType                                  ' ������ ������ �˻��Ѵ�.
    Case REG_SZ                                             ' ���ڿ� �������͸� Ű ������ ����
        KeyVal = tmpVal                                     ' ���ڿ� ���� �����Ѵ�.
    Case REG_DWORD                                          ' ���� �ܾ� �������͸� Ű ������ ����
        For i = Len(tmpVal) To 1 Step -1                    ' ���� ��Ʈ�� ��ȯ�Ѵ�.
            KeyVal = KeyVal + Hex(Asc(Mid(tmpVal, i, 1)))   ' �� ���ڸ� ���ں��� �ۼ��Ѵ�.
        Next
        KeyVal = Format$("&h" + KeyVal)                     ' ���� �ܾ ���ڿ��� ��ȯ�Ѵ�.
    End Select
    
    GetKeyValue = True
    rc = RegCloseKey(hKey)                          ' �������͸� Ű�� �ݴ´�.
    Exit Function
    
GetKeyError:      ' ������ �߻��ϸ� �����.
    KeyVal = ""                                             ' ��ȯ���� �� ���ڿ��� �����Ѵ�.
    GetKeyValue = False                                     ' ���и� ��ȯ�Ѵ�..
    rc = RegCloseKey(hKey)                                  ' �������͸� Ű�� �ݴ´�.
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

' �ý��� ����
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

