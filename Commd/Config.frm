VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmConfig 
   BorderStyle     =   1  '단일 고정
   Caption         =   "Commd Config"
   ClientHeight    =   3615
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3615
   ScaleWidth      =   4680
   Begin TabDlg.SSTab SSTab1 
      Height          =   2745
      Left            =   150
      TabIndex        =   2
      Top             =   180
      Width           =   4365
      _ExtentX        =   7699
      _ExtentY        =   4842
      _Version        =   393216
      Style           =   1
      Tab             =   1
      TabHeight       =   520
      TabCaption(0)   =   "Gen"
      TabPicture(0)   =   "Config.frx":0000
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "chkEscalator"
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "Conn"
      TabPicture(1)   =   "Config.frx":001C
      Tab(1).ControlEnabled=   -1  'True
      Tab(1).Control(0)=   "Frame1"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "Frame2"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).ControlCount=   2
      TabCaption(2)   =   "Etc"
      TabPicture(2)   =   "Config.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Frame3"
      Tab(2).Control(1)=   "chkAutoConnection"
      Tab(2).Control(2)=   "chkTestInsert"
      Tab(2).Control(3)=   "chkSICInsert"
      Tab(2).ControlCount=   4
      Begin VB.CheckBox chkEscalator 
         Caption         =   "Using this program to Escalator"
         Height          =   345
         Left            =   -74640
         TabIndex        =   16
         Top             =   720
         Width           =   3285
      End
      Begin VB.CheckBox chkSICInsert 
         Caption         =   "Alarm is &not inserted into SIC database (Not saved in registry)"
         Height          =   465
         Left            =   -74760
         TabIndex        =   15
         Top             =   2160
         Width           =   3765
      End
      Begin VB.CheckBox chkTestInsert 
         Caption         =   "Test DB Insert(Not saved in registry)"
         Height          =   345
         Left            =   -74760
         TabIndex        =   14
         Top             =   1800
         Width           =   3765
      End
      Begin VB.CheckBox chkAutoConnection 
         Caption         =   "Auto DB Connection (Using Registry)"
         Enabled         =   0   'False
         Height          =   345
         Left            =   -74760
         TabIndex        =   13
         Top             =   1560
         Value           =   1  '확인
         Width           =   3765
      End
      Begin VB.Frame Frame3 
         Caption         =   "Multi TCD"
         Height          =   885
         Left            =   -74760
         TabIndex        =   9
         Top             =   570
         Width           =   3825
         Begin VB.TextBox txtMulti 
            Alignment       =   1  '오른쪽 맞춤
            Appearance      =   0  '평면
            Height          =   285
            Left            =   2340
            TabIndex        =   10
            Top             =   360
            Width           =   705
         End
         Begin VB.Label Label5 
            AutoSize        =   -1  'True
            Height          =   180
            Left            =   3210
            TabIndex        =   12
            Top             =   420
            Width           =   60
         End
         Begin VB.Label Label6 
            AutoSize        =   -1  'True
            Caption         =   "No of Multiple occured"
            Height          =   180
            Left            =   240
            TabIndex        =   11
            Top             =   420
            Width           =   1920
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "SIC"
         Height          =   975
         Left            =   240
         TabIndex        =   6
         Top             =   1560
         Width           =   3825
         Begin VB.TextBox txtSIC_SVR 
            Appearance      =   0  '평면
            Height          =   285
            Left            =   1770
            TabIndex        =   7
            Text            =   "otkrseccc01"
            Top             =   420
            Width           =   1755
         End
         Begin VB.Label Label4 
            AutoSize        =   -1  'True
            Caption         =   "서버 Name:"
            Height          =   180
            Left            =   360
            TabIndex        =   8
            Top             =   480
            Width           =   990
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "REM"
         Height          =   975
         Left            =   240
         TabIndex        =   3
         Top             =   510
         Width           =   3825
         Begin VB.TextBox txtREM_SVR 
            Appearance      =   0  '평면
            Height          =   285
            Left            =   1770
            TabIndex        =   5
            Text            =   "otkrserem01"
            Top             =   420
            Width           =   1755
         End
         Begin VB.Label Label1 
            AutoSize        =   -1  'True
            Caption         =   "서버 Name :"
            Height          =   180
            Left            =   360
            TabIndex        =   4
            Top             =   480
            Width           =   1050
         End
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   3540
      TabIndex        =   1
      Top             =   3120
      Width           =   975
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   375
      Left            =   2340
      TabIndex        =   0
      Top             =   3120
      Width           =   975
   End
End
Attribute VB_Name = "frmConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public iEscalator As Byte

Private Sub chkEscalator_Click()
    iEscalator = chkEscalator.Value
End Sub

' [닫기] 버튼 클릭
Private Sub cmdClose_Click()
    Unload Me
End Sub
' [저장] 버튼 클릭
Private Sub cmdSave_Click()
    Dim xMulti As Integer
    Dim xDSN As String
    
    ' 연결 - 원격감시
    xDSN = Trim(txtREM_SVR.Text)
    If xDSN <> "" Then
        SaveSetting "Commd", "Connection", "REM_SVR", xDSN
    End If
    
    ' 연결 - 정보센터
    xDSN = Trim(txtSIC_SVR.Text)
    If xDSN <> "" Then
        SaveSetting "Commd", "Connection", "SIC_SVR", xDSN
    End If
    
    ' 기타 - 다발고장
    If txtMulti.Text <> "" Then
        xMulti = CInt(Trim(txtMulti.Text))
    Else
        xMulti = 10
    End If
    SaveSetting "Commd", "Etc", "Multi", xMulti
    comm.Multi = CInt(xMulti)
    
    ' 기타 - DB 자동 연결
    If chkAutoConnection.Value = 1 Then
        SaveSetting "Commd", "Etc", "AutoConn", "FF"
    Else
        SaveSetting "Commd", "Etc", "AutoConn", "00"
    End If
    comm.AutoConn = chkAutoConnection.Value
    
    ' 기타 - TEST DB Insert
    comm.TestIn = chkTestInsert.Value
    
    ' 기타 -정보센터 넣을것인지
    comm.SICInsert = chkSICInsert.Value
End Sub

Private Sub Form_Load()
    Dim strTmp As String
    
    txtREM_SVR.Text = GetSetting("Commd", "Connection", "REM_SVR", "otkrserem01")
    txtSIC_SVR.Text = GetSetting("Commd", "Connection", "SIC_SVR", "otkrseccc01")
    txtMulti.Text = GetSetting("Commd", "Etc", "Multi", "10")
    strTmp = GetSetting("Commd", "Etc", "Autoconn", "00")
    If strTmp = "00" Then
        chkAutoConnection.Value = 0
    Else
        chkAutoConnection.Value = 1
    End If
    
    chkTestInsert.Value = comm.TestIn
    chkSICInsert.Value = comm.SICInsert
End Sub

Private Sub txtMulti_GotFocus()
    txtMulti.SelStart = 0        '텍스트 박스에 포커스가 오면 텍스트를 반전(선택)
    txtMulti.SelLength = Len(txtMulti.Text)
End Sub
