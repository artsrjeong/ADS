VERSION 5.00
Begin VB.Form frmLogon 
   BackColor       =   &H00FFE7E6&
   BorderStyle     =   1  '단일 고정
   ClientHeight    =   2640
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   3585
   ControlBox      =   0   'False
   Icon            =   "Login.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   2640
   ScaleWidth      =   3585
   Begin VB.TextBox txtPWD 
      Height          =   315
      IMEMode         =   3  '사용 못함
      Left            =   1560
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   1680
      Width           =   1905
   End
   Begin VB.TextBox txtUID 
      Height          =   315
      Left            =   1560
      TabIndex        =   0
      Top             =   1320
      Width           =   1905
   End
   Begin VB.Label lblDSN 
      BackColor       =   &H00FFE7E6&
      Caption         =   "DSN Name :"
      Height          =   312
      Left            =   720
      TabIndex        =   6
      Top             =   996
      Width           =   2532
   End
   Begin VB.Image imgOK 
      Height          =   420
      Left            =   2910
      MousePointer    =   99  '사용자 정의
      Picture         =   "Login.frx":08CA
      ToolTipText     =   "확인"
      Top             =   2040
      Width           =   555
   End
   Begin VB.Image imgCancel 
      Height          =   420
      Left            =   2310
      MousePointer    =   99  '사용자 정의
      Picture         =   "Login.frx":154E
      ToolTipText     =   "취소"
      Top             =   2040
      Width           =   555
   End
   Begin VB.Label lblVersion 
      BackColor       =   &H00FFE7E6&
      Caption         =   "Version"
      Height          =   225
      Left            =   1110
      TabIndex        =   5
      Top             =   630
      Width           =   2295
   End
   Begin VB.Label Label2 
      BackColor       =   &H00FFE7E6&
      Caption         =   "Password"
      Height          =   255
      Left            =   690
      TabIndex        =   4
      Top             =   1710
      Width           =   885
   End
   Begin VB.Label Label1 
      BackColor       =   &H00FFE7E6&
      Caption         =   "USER ID"
      Height          =   255
      Left            =   690
      TabIndex        =   3
      Top             =   1380
      Width           =   765
   End
   Begin VB.Label lblTitle 
      BackColor       =   &H00FFE7E6&
      Caption         =   "GEMIS LOGON"
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
      Left            =   990
      TabIndex        =   2
      Top             =   210
      Width           =   3885
   End
   Begin VB.Image Image1 
      Height          =   570
      Left            =   270
      Picture         =   "Login.frx":21D2
      Stretch         =   -1  'True
      Top             =   210
      Width           =   570
   End
End
Attribute VB_Name = "frmLogon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' 레지스트리에서 읽어온 Connection String 정보를 저장하는 지역 변수
Private xConnString As String

Private Sub Form_Activate()
    txtPWD.SetFocus
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    Select Case KeyCode
        Case vbKeyReturn            ' <Enter> 키
            Call imgOK_Click
        Case vbKeyEscape            ' <Esc> 키
            Call imgCancel_Click
    End Select
End Sub

Private Sub imgCancel_Click()
    Unload Me
End Sub

Private Sub imgCancel_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgCancel, "Cancel_Down")
End Sub

Private Sub imgCancel_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgCancel, "Cancel")
End Sub

Private Sub imgOK_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgOK, "Confirm_Down")
End Sub

Private Sub imgOK_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call SetImg(imgOK, "Confirm")
End Sub

' [확인] 버튼 클릭
Private Sub imgOK_Click()
    Dim Index As Integer
    Dim xSVR As String
    
    On Error GoTo ErrTrap
    
    If txtUID.Text = "" Then Exit Sub
    
    If currDatabase = "REM" Then
        xRemPWD = Trim(txtPWD.Text)    ' 원격감시 PWD는 기억할 필요가 있다.
        xSVR = GetSetting("Commd", "Connection", "REM_SVR", "otkrserem01")
        xConnString = "driver={SQL SERVER};server=" & xSVR & ";uid=" & Trim(txtUID.Text) & ";" & _
          "pwd=" & xRemPWD & ";database=elrms;"
        Index = 2
        SaveSetting "Commd", "Connection", "REM_UID", Trim(txtUID.Text)
        Set connREM = New ADODB.Connection
        connREM.Open xConnString
        If connREM.State = adStateOpen Then
            MDI.sbrStatus.Panels(Index).Text = currDatabase & " Connected."
            MDI.Toolbar1.Buttons(2).Enabled = False
            MDI.mnuConnGEMIS.Enabled = False
        End If
    ElseIf currDatabase = "SIC" Then
        xSicPWD = Trim(txtPWD.Text)    ' 정보센터 PWD는 기억할 필요가 있다.
        xSVR = GetSetting("Commd", "Connection", "SIC_SVR", "otkrseccc01")
        xConnString = "driver={SQL SERVER};Server=" & xSVR & ",4004;uid=" & Trim(txtUID.Text) & ";" & _
          "pwd=" & xSicPWD & ";database=GISSSKA0;"
        Index = 3
        SaveSetting "Commd", "Connection", "SIC_UID", Trim(txtUID.Text)
        Set connSIC = New ADODB.Connection
        connSIC.Open xConnString
        If connSIC.State = adStateOpen Then
            MDI.sbrStatus.Panels(Index).Text = currDatabase & " Connected."
            MDI.Toolbar1.Buttons(1).Enabled = False
            MDI.mnuConnSIC.Enabled = False
        End If
    End If
    
    Unload Me
    Exit Sub
    
ErrTrap:
    MDI.sbrStatus.Panels(Index).Text = currDatabase & " Disconnected."
    'Err.Raise Err.Number, Err.Source, Err.Description
End Sub

Private Sub Form_Load()
    Dim xSVR As String
    
    If currDatabase = "REM" Then
        lblTitle.Caption = "GEMIS LOGON"
        xSVR = GetSetting("Commd", "Connection", "REM_SVR", "otkrserem01")
        txtUID.Text = GetSetting("Commd", "Connection", "REM_UID", "rem2001")
    ElseIf currDatabase = "SIC" Then
        lblTitle.Caption = "SIC LOGON"
        xSVR = GetSetting("Commd", "Connection", "SIC_SVR", "otkrseccc01")
        txtUID.Text = GetSetting("Commd", "Connection", "SIC_UID", "svc2001")
    End If
    
    lblVersion.Caption = "Version : " & App.Major & "." & App.Minor & "." & App.Revision
    lblDSN = "서버 Name : " & xSVR
    
'    Me.Top = (Screen.Height - Me.Height) / 2
'    Me.Left = (Screen.Width - Me.Width) / 2
    
    Call SetImg(imgCancel, "Cancel_None")
    Call SetImg(imgOK, "Confirm_None")
    
End Sub

Private Sub txtPWD_GotFocus()
    txtPWD.SelStart = 0        '텍스트 박스에 포커스가 오면 텍스트를 반전(선택)
    txtPWD.SelLength = Len(txtPWD.Text)
End Sub

Private Sub txtUID_GotFocus()
    txtUID.SelStart = 0        '텍스트 박스에 포커스가 오면 텍스트를 반전(선택)
    txtUID.SelLength = Len(txtUID.Text)
End Sub

