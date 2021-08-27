VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.MDIForm MDI 
   BackColor       =   &H8000000C&
   Caption         =   "GEMIS-Commd"
   ClientHeight    =   5325
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   9555
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows 기본값
   Begin VB.PictureBox Picture1 
      Align           =   1  '위 맞춤
      AutoSize        =   -1  'True
      Height          =   1365
      Left            =   0
      ScaleHeight     =   1305
      ScaleWidth      =   9495
      TabIndex        =   2
      Top             =   660
      Width           =   9555
      Begin VB.Timer tmrReInsert 
         Enabled         =   0   'False
         Interval        =   60000
         Left            =   4440
         Top             =   120
      End
      Begin VB.Timer jsrTimer 
         Interval        =   2000
         Left            =   4320
         Top             =   600
      End
      Begin MSWinsockLib.Winsock wskFile 
         Left            =   0
         Top             =   720
         _ExtentX        =   741
         _ExtentY        =   741
         _Version        =   393216
         Protocol        =   1
      End
      Begin VB.Timer tmrCheck 
         Enabled         =   0   'False
         Interval        =   3000
         Left            =   0
         Top             =   360
      End
      Begin VB.ListBox lstXFile 
         Appearance      =   0  '평면
         Height          =   744
         Left            =   300
         TabIndex        =   5
         Top             =   390
         Width           =   4092
      End
      Begin MSWinsockLib.Winsock Winsock1 
         Left            =   0
         Top             =   0
         _ExtentX        =   741
         _ExtentY        =   741
         _Version        =   393216
         Protocol        =   1
      End
      Begin VB.ListBox lstFile 
         Appearance      =   0  '평면
         Height          =   1284
         Left            =   4680
         TabIndex        =   4
         Top             =   10
         Width           =   4848
      End
      Begin VB.Label lblStatus 
         AutoSize        =   -1  'True
         Caption         =   "Message received from Modems..."
         Height          =   180
         Index           =   0
         Left            =   720
         TabIndex        =   3
         Top             =   180
         Width           =   2748
      End
      Begin VB.Shape shpStatus 
         FillColor       =   &H0000FF00&
         FillStyle       =   0  '단색
         Height          =   192
         Index           =   1
         Left            =   3600
         Shape           =   3  '원형
         Top             =   156
         Width           =   228
      End
      Begin VB.Shape shpStatus 
         FillColor       =   &H0000FF00&
         FillStyle       =   0  '단색
         Height          =   192
         Index           =   0
         Left            =   480
         Shape           =   3  '원형
         Top             =   156
         Width           =   228
      End
   End
   Begin MSComDlg.CommonDialog dlgCom 
      Left            =   690
      Top             =   810
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.StatusBar sbrStatus 
      Align           =   2  '아래 맞춤
      Height          =   435
      Left            =   0
      TabIndex        =   1
      Top             =   4890
      Width           =   9555
      _ExtentX        =   16854
      _ExtentY        =   767
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   5
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   2
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   4313
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   4313
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   6
            Alignment       =   1
            TextSave        =   "2004-10-23"
         EndProperty
         BeginProperty Panel5 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   5
            Alignment       =   1
            TextSave        =   "오후 5:48"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   120
      Top             =   810
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   24
      ImageHeight     =   23
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   8
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":0000
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":0454
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":08A8
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":0CFC
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":1018
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":146C
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":18C0
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "Commd.frx":1D14
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar Toolbar1 
      Align           =   1  '위 맞춤
      Height          =   660
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9555
      _ExtentX        =   16854
      _ExtentY        =   1164
      ButtonWidth     =   1244
      ButtonHeight    =   1111
      Appearance      =   1
      Style           =   1
      ImageList       =   "ImageList1"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   11
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "SIC"
            Key             =   "정보센터"
            ImageIndex      =   5
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "REM"
            Key             =   "원격감시"
            ImageIndex      =   5
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Open"
            Key             =   "불러오기"
            ImageIndex      =   2
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Search"
            Key             =   "전체찾기"
            ImageIndex      =   8
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Save"
            Key             =   "저장"
            ImageIndex      =   1
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "View"
            Key             =   "분석"
            ImageIndex      =   3
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Config"
            Key             =   "환경설정"
            ImageIndex      =   7
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "Exit"
            Key             =   "종료"
            ImageIndex      =   4
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
      Begin VB.Menu mnuFileOpen 
         Caption         =   "Open"
      End
      Begin VB.Menu mnuFindAll 
         Caption         =   "Search"
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "Save"
      End
      Begin VB.Menu mnuFileSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExit 
         Caption         =   "Exit"
      End
   End
   Begin VB.Menu mnuConn 
      Caption         =   "Conn"
      Begin VB.Menu mnuConnSIC 
         Caption         =   "SIC Connect"
      End
      Begin VB.Menu mnuConnGEMIS 
         Caption         =   "REM Connect"
      End
      Begin VB.Menu mnuConnSpe1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuDiscSIC 
         Caption         =   "SIC Disconnect"
      End
      Begin VB.Menu mnuDiscGEMIS 
         Caption         =   "REM Disconnect"
      End
   End
   Begin VB.Menu mnuTool 
      Caption         =   "Tool"
      Begin VB.Menu mnuAnalysis 
         Caption         =   "View"
      End
      Begin VB.Menu mnuConf 
         Caption         =   "Config"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuVersion 
         Caption         =   "About"
      End
   End
End
Attribute VB_Name = "MDI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub jsrTimer_Timer()
    Dim f As Integer
    Dim i As Integer
    Dim J As Integer
    Dim strMsg As String
    Dim strSrc As String
    Dim strDes As String
    Dim wFlag As Boolean
    Dim docWatchDog As MSXML.DOMDocument
    Dim eleWatchDog As MSXML.IXMLDOMElement
    Dim newWatchDog As MSXML.IXMLDOMElement
    Dim newTime As MSXML.IXMLDOMElement
    Dim newCnt As MSXML.IXMLDOMElement
    'If intVal < 1 Then Exit Sub '아무것도 처리 안함
    
    Set docWatchDog = New MSXML.DOMDocument
    docWatchDog.async = False
    docWatchDog.loadXML "<?xml version='1.0'?><WATCHDOGS></WATCHDOGS>"
    Set eleWatchDog = docWatchDog.documentElement
    Set newWatchDog = docWatchDog.createElement("WATCHDOG")
    Set newTime = docWatchDog.createElement("TIME")
    Set newCnt = docWatchDog.createElement("COUNT")
    newTime.Text = CStr(Now)
    newCnt.Text = Str(logCnt)
    newWatchDog.appendChild newTime
    newWatchDog.appendChild newCnt
    eleWatchDog.appendChild newWatchDog
    Set newTime = Nothing
    Set newCnt = Nothing
    Set newWatchDog = Nothing
    Set eleWatchDog = Nothing
    
    docWatchDog.Save "c:\inetpub\wwwroot\watchdog.xml"
    Set docWatchDog = Nothing
        
End Sub

Private Sub MDIForm_Load()
   
'   If App.PrevInstance Then
'       MsgBox "이 프로그램은 두번 실행될 수 없습니다."
'       End
'   End If
    
    ' This gives you visibility that the target app is running
    ' and you are pointing to the correct hWnd
    ' Me.Caption = Hex$(FindWindow(vbNullString, "Target"))
    
    gHW = Me.hwnd
    Hook
    Me.Caption = "GEMIS-Commd"
    Me.Show
    logCnt = 0
    prevDay = ""
    Set comm = New clsComm  ' 관리 Class를 생성하면서 초기값을 알 수 있다.
    
    histId = 0  ' 고장이력 관리 번호 : 1 ~ 100
    
    With Winsock1
        .RemoteHost = "172.28.74.125"
        .RemotePort = 8818
        .LocalPort = 8817
        .Bind 8817
    End With
    
    With wskFile
        .LocalPort = 8816
        .Bind 8816
    End With
    
'    On Error GoTo err_hnd
'    Dim i
'    For i = 1 To 12
'        If Dir("C:\das_dump\Checked\" & Str(i), vbDirectory) = "" Then
'            MkDir "C:\das_dump\Checked\" & Str(i)
'        End If
'        If Dir("C:\das_dump\Err\" & Str(i), vbDirectory) = "" Then
'            MkDir "C:\das_dump\Err\" & Str(i)
'        End If
'    Next
    Exit Sub
err_hnd:
    MsgBox "Dir Create Err"
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    On Err GoTo ErrTrap
    Unhook
    
    Set comm = Nothing
    
    If sbrStatus.Panels(2).Text <> Empty Then
        If connREM.State = adStateOpen Then connREM.Close
        If Not connREM Is Nothing Then Set connREM = Nothing
    End If
    
    If sbrStatus.Panels(3).Text <> Empty Then
        If connSIC.State = adStateOpen Then connSIC.Close
        If Not connSIC Is Nothing Then Set connSIC = Nothing
    End If
    
    Exit Sub

ErrTrap:

End Sub

Private Sub mnuDiscGEMIS_Click()
    On Err GoTo ErrTrap
    
    If sbrStatus.Panels(2).Text <> Empty Then
        If connREM.State = adStateOpen Then connREM.Close
        If Not connREM Is Nothing Then Set connREM = Nothing
        sbrStatus.Panels(2).Text = ""
        MDI.Toolbar1.Buttons(2).Enabled = True
        MDI.mnuConnGEMIS.Enabled = True
    End If
    
    Exit Sub

ErrTrap:
End Sub

Private Sub mnuDiscSIC_Click()
    On Err GoTo ErrTrap
    
    If sbrStatus.Panels(3).Text <> Empty Then
        If connSIC.State = adStateOpen Then connSIC.Close
        If Not connSIC Is Nothing Then Set connSIC = Nothing
        sbrStatus.Panels(3).Text = ""
        MDI.Toolbar1.Buttons(1).Enabled = True
        MDI.mnuConnSIC.Enabled = True
    End If
    
    Exit Sub

ErrTrap:
End Sub

Private Sub mnuVersion_Click()
    frmAbout.Show
End Sub

' Modem으로부터 받은 고장파일 처리
Private Sub tmrCheck_Timer()
    Dim Result As Integer
    Dim path As String
    Dim strFileName As String
    Dim strType As String * 1     ' File의 Type : XFile, VFile, AFile
    Dim bFlag As Boolean        ' 파일을 옮길것인지 check
    
    If lstXFile.ListCount > 0 Then
        strFileName = Trim(lstXFile.List(0))
        strType = Mid(StripPath(strFileName), 1, 1)
        
        Select Case strType
            Case "X"    ' XFile인 경우
                bFlag = True
                procSrc = "모뎀"
                Result = ProcessTrb(strFileName)
                WriteLog (Result)
                WriteUDPLog "tmrCheck_Timer", "-------------------------------------------------"
            Case "V"    ' VFile인 경우
                bFlag = True
'                Result = ProcessVFile(strFileName)
'                WriteVFIleLog (Result)
                WriteVFIleLog (OK_SUCCESS)
            Case Else
                bFlag = False
                Result = OK_SUCCESS
        End Select
        
        If bFlag = True Then
            Dim yymm$
            yymm = Mid(Right(strFileName, 10), 1, 4)
            If Result < OK_THRETHOULD Then
                path = "C:\DAS_DUMP\Checked\" & yymm
            Else
                path = "C:\DAS_DUMP\Err\" & yymm
            End If
            path = AddPath(path, StripPath(strFileName))
            Result = MoveFile(strFileName, path)
        End If
        
        lstXFile.RemoveItem 0
        lstXFile.Refresh
        
        If lstXFile.ListCount = 0 Then
            shpStatus(0).FillColor = vbGreen
            shpStatus(1).FillColor = vbGreen
            shpStatus(0).Refresh
            shpStatus(1).Refresh
        End If
    Else
        tmrCheck.Enabled = False
    End If
End Sub

Private Sub tmrReInsert_Timer()
    Dim Result As Integer           ' SQL 실행결과
    WriteUDPLog "ReInsert", "from DeadLock"
    tmrReInsert.Enabled = False
    reTrbCar.src = "재처리"
    Result = InsertSICTrb(reTrbCar)
    If Result = ERR_SIC_NOT_EXIST_RECNO Then
        tmrReInsert.Enabled = True
    End If
End Sub

' [툴바] 클릭
Private Sub Toolbar1_ButtonClick(ByVal Button As MSComctlLib.Button)
    Select Case Button.Key
        Case "정보센터"
            mnuConnSIC_Click
        Case "원격감시"
            mnuConnGEMIS_Click
        Case "불러오기"
            mnuFileOpen_Click
        Case "전체찾기"
            mnuFindAll_Click
        Case "분석"
            mnuAnalysis_Click
        Case "환경설정"
            mnuConf_Click
        Case "종료"
            mnuExit_Click
    End Select
End Sub

' [정보센터] 버튼 클릭
Private Sub mnuConnSIC_Click()
    currDatabase = "SIC"
    frmLogon.Show
End Sub

' [원격감시] 버튼 클릭
Private Sub mnuConnGEMIS_Click()
    currDatabase = "REM"
    frmLogon.Show
End Sub

' [불러오기] 버튼 클릭
Private Sub mnuFileOpen_Click()
    Dim Result As Integer
    Dim path As String
    
    dlgCom.InitDir = "C:\DAS_DUMP\data"
    dlgCom.Filter = "XFile (x*.*)|*.*"
    dlgCom.FilterIndex = 1
    dlgCom.ShowOpen
    If Err.Number = cdlCancel Then Exit Sub
    
    If dlgCom.fileName <> "" Then
        Dim yymm$
        yymm = Mid(Right(dlgCom.fileName, 10), 1, 4)
        procSrc = "화일"
        Result = ProcessTrb(dlgCom.fileName)
        WriteLog (Result)
        WriteUDPLog "mnuFileOpen_Click", "-------------------------------------------------"
        If Result < OK_THRETHOULD Then
            path = "C:\DAS_DUMP\Checked\" & yymm
        Else
            path = "C:\DAS_DUMP\Err\" & yymm
        End If
        path = AddPath(path, StripPath(dlgCom.fileName))
        Result = MoveFile(dlgCom.fileName, path)
    End If
End Sub

' [전체찾기] 버튼 클릭
Private Sub mnuFindAll_Click()
    frmFind.Show
End Sub

' [분석] 버튼 클릭
Private Sub mnuAnalysis_Click()
    frmAnalysis.Show
End Sub

' [환경설정] 버튼 클릭
Private Sub mnuConf_Click()
    frmConfig.Show
End Sub

' [종료] 버튼 클릭
Private Sub mnuExit_Click()
    Dim Result As Integer
    
    Result = MsgBox("Are you sure exit program ?", vbYesNo + vbQuestion, "Confirm")
    If Result = vbYes Then
        Unload Me
    End If
End Sub

' UDP 수신
Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim arrBuf() As Byte
    Dim strData As TTrbMsg
    Dim strRcv As String
    Dim strTmp As String
    
    On Err GoTo ErrTrap
    
    Winsock1.GetData arrBuf
    
    strRcv = Chr(arrBuf(0)) + Chr(arrBuf(1)) + Chr(arrBuf(2))
    If strRcv = "@@@" Then
        strTmp = Winsock1.LocalIP   '주의) 꼭 지우지 말것 - .EXE Runtime문제 해결
        If comm.Success > 0 Then
            strData = GetUDPMsg
            ReDim arrBuf(Len(strData) - 1) As Byte
            CopyMemory arrBuf(0), strData, Len(strData)
            Winsock1.SendData arrBuf
            sbrStatus.Panels(1).Text = "Responsed (" & Len(strData) & ") to " & Winsock1.RemoteHostIP
            sbrStatus.Refresh
        Else
            Winsock1.SendData "@@@"
            sbrStatus.Panels(1).Text = "Responsed @@@ to " & Winsock1.RemoteHostIP
            sbrStatus.Refresh
        End If
    End If

    Exit Sub
ErrTrap:
End Sub

Private Sub mnuFileSave_Click()
    lstXFile.AddItem "C:\DAS_DUMP\DATA\V01210002-010703.000"
    lstXFile.Refresh
    shpStatus(0).FillColor = vbRed
    shpStatus(1).FillColor = vbRed
    shpStatus(0).Refresh
    shpStatus(1).Refresh
    tmrCheck.Enabled = True
End Sub

Private Sub wskFile_DataArrival(ByVal bytesTotal As Long)
    Dim data$, path$, packet$, f%
    Dim Result%
    wskFile.GetData packet
    WriteUDPLog wskFile.RemoteHostIP, packet
    data = Trim(GetStr(packet, 1)) '파일 이름만 뽑아냄
    If data <> "" Then
        'MsgBox data
        f = FreeFile()          ' 사용하지 않는 파일번호를 얻는다.
        Open GetStr(packet, 0) For Binary As f
        If LOF(f) = Val(GetStr(packet, 2)) Then
            wskFile.RemoteHost = wskFile.RemoteHostIP
            wskFile.RemotePort = 8816
            wskFile.SendData packet
            WriteUDPLog wskFile.LocalIP, "send- " & packet
            Result = ProcessTrb(AddPath("c:\das_dump\data\", data))
            WriteLog (Result)
            Dim yymm$
            yymm = Mid(Right(AddPath("c:\das_dump\data\", data), 10), 1, 4)

            If Result < OK_THRETHOULD Then
                path = "c:\DAS_DUMP\Checked\" & yymm
            Else
                path = "c:\DAS_DUMP\Err\" & yymm
            End If
            path = AddPath(path, data)
            Result = MoveFile("c:\das_dump\data\" & data, path)
            If Result = False Then
                WriteUDPLog wskFile.LocalIP, "Move Fail"
            End If
        Else
            WriteUDPLog wskFile.LocalIP, "Packet Length failure"
        End If
        
    Else
        lstFile.AddItem "Specify File name"
        WriteUDPLog wskFile.LocalIP, "There is no File name in Packet"
    End If
End Sub

