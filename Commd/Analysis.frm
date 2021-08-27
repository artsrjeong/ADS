VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmAnalysis 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  '단일 고정
   Caption         =   "View process result"
   ClientHeight    =   5760
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9090
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5760
   ScaleWidth      =   9090
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   6
      Left            =   3210
      Locked          =   -1  'True
      TabIndex        =   32
      Top             =   4356
      Width           =   675
   End
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   5
      Left            =   1440
      Locked          =   -1  'True
      TabIndex        =   31
      Top             =   5160
      Width           =   675
   End
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   4
      Left            =   1440
      Locked          =   -1  'True
      TabIndex        =   30
      Top             =   4896
      Width           =   675
   End
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   3
      Left            =   1440
      Locked          =   -1  'True
      TabIndex        =   29
      Top             =   4620
      Width           =   675
   End
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   2
      Left            =   1440
      Locked          =   -1  'True
      TabIndex        =   28
      Top             =   4356
      Width           =   675
   End
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   1
      Left            =   3210
      Locked          =   -1  'True
      TabIndex        =   27
      Top             =   4080
      Width           =   675
   End
   Begin VB.TextBox txtStatus 
      Alignment       =   2  '가운데 맞춤
      Appearance      =   0  '평면
      Height          =   285
      Index           =   0
      Left            =   1440
      Locked          =   -1  'True
      TabIndex        =   26
      Top             =   4080
      Width           =   675
   End
   Begin VB.CommandButton cmdSelect 
      Caption         =   "Search"
      Height          =   375
      Left            =   7470
      TabIndex        =   22
      Top             =   1380
      Width           =   1305
   End
   Begin VB.CommandButton cmdSearch 
      Caption         =   "Find"
      Height          =   345
      Left            =   3810
      TabIndex        =   21
      Top             =   1410
      Width           =   1305
   End
   Begin VB.TextBox txtSearch 
      Height          =   315
      Left            =   1320
      TabIndex        =   20
      Top             =   1410
      Width           =   2475
   End
   Begin VB.ListBox lstHist 
      Appearance      =   0  '평면
      Height          =   1464
      Left            =   4530
      TabIndex        =   10
      Top             =   4080
      Width           =   4275
   End
   Begin MSFlexGridLib.MSFlexGrid Grid1 
      Height          =   2076
      Left            =   276
      TabIndex        =   9
      Top             =   1776
      Width           =   8508
      _ExtentX        =   15028
      _ExtentY        =   3678
      _Version        =   393216
      FocusRect       =   0
      HighLight       =   2
      GridLines       =   0
      GridLinesFixed  =   1
      SelectionMode   =   1
      Appearance      =   0
   End
   Begin VB.Frame Frame1 
      Caption         =   "Summary"
      Height          =   1095
      Left            =   270
      TabIndex        =   0
      Top             =   180
      Width           =   8505
      Begin VB.TextBox txtSumm 
         Alignment       =   2  '가운데 맞춤
         Appearance      =   0  '평면
         BackColor       =   &H00FFFFFF&
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   285
         Index           =   5
         Left            =   6660
         Locked          =   -1  'True
         TabIndex        =   35
         Top             =   720
         Width           =   1620
      End
      Begin VB.TextBox txtSumm 
         Alignment       =   2  '가운데 맞춤
         Appearance      =   0  '평면
         BackColor       =   &H00FFFFFF&
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   285
         Index           =   4
         Left            =   3630
         Locked          =   -1  'True
         TabIndex        =   18
         Top             =   720
         Width           =   745
      End
      Begin VB.TextBox txtSumm 
         Alignment       =   2  '가운데 맞춤
         Appearance      =   0  '평면
         BackColor       =   &H00FFFFFF&
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   285
         Index           =   3
         Left            =   6660
         Locked          =   -1  'True
         TabIndex        =   8
         Top             =   300
         Width           =   745
      End
      Begin VB.TextBox txtSumm 
         Alignment       =   2  '가운데 맞춤
         Appearance      =   0  '평면
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   285
         Index           =   2
         Left            =   3630
         Locked          =   -1  'True
         TabIndex        =   7
         Top             =   270
         Width           =   745
      End
      Begin VB.TextBox txtSumm 
         Alignment       =   2  '가운데 맞춤
         Appearance      =   0  '평면
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   285
         Index           =   1
         Left            =   1770
         Locked          =   -1  'True
         TabIndex        =   6
         Top             =   720
         Width           =   745
      End
      Begin VB.TextBox txtSumm 
         Alignment       =   2  '가운데 맞춤
         Appearance      =   0  '평면
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   1770
         Locked          =   -1  'True
         TabIndex        =   2
         Top             =   270
         Width           =   745
      End
      Begin VB.Label lblSumm 
         Alignment       =   1  '오른쪽 맞춤
         AutoSize        =   -1  'True
         Caption         =   "Multi"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF00FF&
         Height          =   195
         Index           =   5
         Left            =   6015
         TabIndex        =   34
         Top             =   750
         Width           =   510
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "+"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   12
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   240
         Index           =   1
         Left            =   3210
         TabIndex        =   25
         Top             =   510
         Width           =   150
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "="
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   14.25
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Index           =   0
         Left            =   2730
         TabIndex        =   24
         Top             =   270
         Width           =   165
      End
      Begin VB.Label lblSumm 
         AutoSize        =   -1  'True
         Caption         =   "Fail"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   195
         Index           =   4
         Left            =   3090
         TabIndex        =   19
         Top             =   750
         Width           =   390
      End
      Begin VB.Label lblSumm 
         AutoSize        =   -1  'True
         Caption         =   "SIC Insert"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   195
         Index           =   3
         Left            =   5220
         TabIndex        =   5
         Top             =   330
         Width           =   1065
      End
      Begin VB.Label lblSumm 
         AutoSize        =   -1  'True
         Caption         =   "Succ"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   195
         Index           =   2
         Left            =   3090
         TabIndex        =   4
         Top             =   330
         Width           =   570
      End
      Begin VB.Label lblSumm 
         AutoSize        =   -1  'True
         Caption         =   "# of Process"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00404040&
         Height          =   195
         Index           =   1
         Left            =   300
         TabIndex        =   3
         Top             =   750
         Width           =   1410
      End
      Begin VB.Label lblSumm 
         AutoSize        =   -1  'True
         Caption         =   "# of XFile"
         BeginProperty Font 
            Name            =   "굴림"
            Size            =   9.75
            Charset         =   129
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   0
         Left            =   330
         TabIndex        =   1
         Top             =   330
         Width           =   1005
      End
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Filename"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   12
         Charset         =   129
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   270
      TabIndex        =   33
      Top             =   1470
      Width           =   1095
   End
   Begin VB.Label lblResult 
      AutoSize        =   -1  'True
      Caption         =   "result :"
      Height          =   180
      Left            =   4536
      TabIndex        =   23
      Top             =   3876
      Width           =   588
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "DIR :"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   6
      Left            =   2376
      TabIndex        =   17
      Top             =   4380
      Width           =   492
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "DOOR :"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   5
      Left            =   300
      TabIndex        =   16
      Top             =   5196
      Width           =   816
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "ZONE "
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   4
      Left            =   300
      TabIndex        =   15
      Top             =   4920
      Width           =   660
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "CAR LOAD "
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   3
      Left            =   300
      TabIndex        =   14
      Top             =   4656
      Width           =   1176
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "SAFETY :"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   2
      Left            =   300
      TabIndex        =   13
      Top             =   4380
      Width           =   936
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "Stop Fl :"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   1
      Left            =   2376
      TabIndex        =   12
      Top             =   4116
      Width           =   852
   End
   Begin VB.Label lblStatus 
      AutoSize        =   -1  'True
      Caption         =   "Start Floor:"
      BeginProperty Font 
         Name            =   "굴림"
         Size            =   11.25
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   228
      Index           =   0
      Left            =   300
      TabIndex        =   11
      Top             =   4116
      Width           =   1092
   End
End
Attribute VB_Name = "frmAnalysis"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' txtSumm Index
Const SUM_TOTAL = 0
Const SUM_SUBTOTAL = 1
Const SUM_SUCC = 2
Const SUM_SIC = 3
Const SUM_FAIL = 4
Const SUM_MULTI = 5

' Grid1 - Column Index
Const C_NO = 0
Const C_TIME = 1        ' 처리시간
Const C_NAME = 2        ' 파일이름
Const C_VER = 3         ' DAS Version
Const C_ID = 4          ' 호기 ID
Const C_RESULT = 5      ' 처리결과
Const C_NEW = 6         ' 신규고장
Const C_RCV = 7         ' 복구고장
Const C_HOLD = 8        ' 유지고장
Const C_MAINNO = 9      ' 관리번호
Const C_REMID = 10      ' 원격감시 접수번호
Const C_RECNO = 11      ' 정보센터 접수번호
Const C_CONT = 12       ' 정보센터 접수내용

' txtStatus Index
Const START_FL = 0
Const STOP_FL = 1
Const Safety = 2
Const LOAD = 3
Const Zone = 4
Const Door = 5
Const Dir = 6

' [검색] 버튼 클릭
Private Sub cmdSearch_Click()
    Dim i As Integer
  
    For i = 1 To Grid1.Rows - 1
        If Trim(Grid1.TextMatrix(i, C_NAME)) = Trim(txtSearch.Text) Then
            Grid1.TopRow = i
            Exit For
        End If
    Next i
End Sub

' [조회] 버튼 클릭
Private Sub cmdSelect_Click()
    Call Form_Activate
End Sub

Private Sub Form_Activate()
    Dim Count%
    Dim Index%, X%
    Dim codes$, s$
    
    lblSumm(SUM_MULTI).Caption = "Above Multi(" & comm.Multi & ")items"
    txtSumm(SUM_TOTAL).Text = Str(comm.Total)           ' 전체 수신 건수
    txtSumm(SUM_SUBTOTAL).Text = Str(comm.SubTotal)     ' 호기별 처리 건수
    txtSumm(SUM_SUCC).Text = Str(comm.Success)          ' 성공 건수
    txtSumm(SUM_SIC).Text = Str(comm.Service)           ' 정보센터 접수 건수
    txtSumm(SUM_FAIL).Text = Str(comm.Fail)             ' 실패 건수
    txtSumm(SUM_MULTI).Text = comm.ContinuedFail        ' 다발고장 DAS
    
    With Grid1
        If comm.SubTotal > MAX_TRB_HISTORY Then
            .Rows = MAX_TRB_HISTORY
            Count = MAX_TRB_HISTORY
        Else
            .Rows = histId + 1
            Count = histId
        End If
        .Cols = 13
        
        s$ = "^No|<P Time|<File|^VER|^ID|^Result|<New|<Rcv|<Hold|<MaintNO|<REM|<SIC|<Content"
        .FormatString = s$
        
        For Index = 1 To .Rows - 1
            .TextMatrix(Index, C_NO) = Index
            .TextMatrix(Index, C_TIME) = trbHist(Index).FileTime
            .TextMatrix(Index, C_NAME) = trbHist(Index).fileName
            .TextMatrix(Index, C_VER) = Hex(trbHist(Index).ver)
            .TextMatrix(Index, C_ID) = trbHist(Index).CarInfo.carId
            .TextMatrix(Index, C_RESULT) = CStr(trbHist(Index).Result)
            codes = ""
            For X = 1 To trbHist(Index).CarInfo.NewCodeNo
                codes = codes + hexFormat(trbHist(Index).CarInfo.NewCodes(X)) + " "
            Next X
            .TextMatrix(Index, C_NEW) = codes
            If trbHist(Index).ver = VER_49 Then
                codes = ""
                For X = 1 To trbHist(Index).CarInfo.CurrErrNo
                    codes = codes + hexFormat(trbHist(Index).CarInfo.CurrError(X)) + " "
                Next X
                .TextMatrix(Index, C_NEW) = codes
            End If
            codes = ""
            For X = 1 To trbHist(Index).CarInfo.RcvCodeNo
                codes = codes + hexFormat(trbHist(Index).CarInfo.RcvCodes(X)) + " "
            Next X
            .TextMatrix(Index, C_RCV) = codes
            codes = ""
            For X = 1 To trbHist(Index).CarInfo.HoldCodeNo
                codes = codes + hexFormat(trbHist(Index).CarInfo.HoldCodes(X)) + " "
            Next X
            .TextMatrix(Index, C_HOLD) = codes
            .TextMatrix(Index, C_MAINNO) = trbHist(Index).CarInfo.maintNo
'            If trbHist(index).CarInfo.SICCheck = True Then
'                .TextMatrix(index, C_SIC) = "Y"
'            Else
'                .TextMatrix(index, C_SIC) = ""
'            End If
            .TextMatrix(Index, C_REMID) = trbHist(Index).CarInfo.REMRecNo
            .TextMatrix(Index, C_RECNO) = trbHist(Index).CarInfo.SICRecNo
            .TextMatrix(Index, C_CONT) = trbHist(Index).CarInfo.Content
        Next Index
    End With
    
    AutosizeGridColumns Grid1
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Unload Me
End Sub

' [Grid1] 클릭하면
Private Sub Grid1_Click()
    Dim Index%, code%
    Dim Msg$
    
    ' 0번째를 클릭하면 Sorting - 1, 2 번째 Column만 가능
    If (Grid1.MouseRow = 0) And ((Grid1.MouseCol = 1) Or (Grid1.MouseCol = 2)) Then
        SortFlex Grid1, Grid1.MouseCol, False, True, True
        Exit Sub
    End If

    If Grid1.Rows = 1 Then Exit Sub
    ' 1번째 이상을 클릭하면 선택
    Index = Grid1.Row
    lblResult.Caption = ">> " & trbHist(Index).fileName & " - " & _
                        trbHist(Index).CarInfo.carId & _
                        "(" & trbHist(Index).CarInfo.ErrHistNo & "건)"
    lstHist.Clear
    For code = 1 To trbHist(Index).CarInfo.ErrHistNo
        If trbHist(Index).ver >= VER_59 Then
            Msg = CStr(trbHist(Index).CarInfo.ErrHistory(code).occurTime) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrMode) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrCode) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).Status0) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).Status1) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).Status2)
        ElseIf trbHist(Index).ver = VER_49 Then
            Msg = CStr(trbHist(Index).CarInfo.ErrHistory(code).occurTime) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrMode) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrCode)
        End If
        lstHist.AddItem Msg
        lstHist.Refresh
    Next code
    txtStatus(START_FL).Text = CStr(trbHist(Index).CarInfo.StartFl)
    txtStatus(STOP_FL).Text = CStr(trbHist(Index).CarInfo.CurrFl)
    txtStatus(Safety).Text = trbHist(Index).CarInfo.Safety
    txtStatus(LOAD).Text = CStr(trbHist(Index).CarInfo.CarLoad)
    txtStatus(Zone).Text = trbHist(Index).CarInfo.Zone
    txtStatus(Door).Text = trbHist(Index).CarInfo.Door
    txtStatus(Dir).Text = trbHist(Index).CarInfo.Dir
End Sub

' 플렉스 그리스 칼럼 자동 조정하는 방법
Public Sub AutosizeGridColumns(msFG As MSFlexGrid)
  Dim i, J As Integer
  Dim txtString As String
  Dim intTempWidth, intBiggestWidth As Integer
  Dim intRows As Integer
  Const intPadding = 150

  With msFG
      For i = 0 To .Cols - 1
          .Col = i
          intRows = .Rows
          intBiggestWidth = 0
          For J = 0 To intRows - 1
              .Row = J
              txtString = .Text
              intTempWidth = TextWidth(txtString) + intPadding
              If intTempWidth > intBiggestWidth Then intBiggestWidth = intTempWidth
          Next J
          .ColWidth(i) = intBiggestWidth
      Next i
      intTempWidth = 0
      For i = 0 To .Cols - 1
          intTempWidth = intTempWidth + .ColWidth(i)
      Next i
      If intTempWidth < msFG.Width Then
          intTempWidth = Fix((msFG.Width - intTempWidth) / .Cols)
          For i = 0 To .Cols - 1
              .ColWidth(i) = .ColWidth(i) + intTempWidth
          Next i
      End If
  End With
End Sub

' Sort
' 주의) IsString의 값을 Column의 Index - 0, 1, 2로 주면 된다. 만약 모든 컬럼을 sorting하고자 하면 갯수만큼 준다.
Public Sub SortFlex(FlexGrid As MSFlexGrid, ByVal TheCol As Integer, ParamArray IsString() As Variant)
    Dim i%
    Dim Headline$
    Dim Ascend As Boolean
    Dim Decend As Boolean
    
    FlexGrid.Col = TheCol

    For i = 0 To FlexGrid.Cols - 1
        Headline = FlexGrid.TextMatrix(0, i)
        Ascend = Right$(Headline, 1) = "+"
        Decend = Right$(Headline, 1) = "-"
        If Ascend Or Decend Then Headline = Left$(Headline, Len(Headline) - 1)

        If i = TheCol Then
            If Ascend Then
                FlexGrid.TextMatrix(0, i) = Headline & "-"
                If IsMissing(IsString(i)) Then
                    FlexGrid.Sort = flexSortGenericDescending
                Else
                    If IsString(i) Then
                        FlexGrid.Sort = flexSortStringDescending
                    Else
                        FlexGrid.Sort = flexSortNumericDescending
                    End If
                End If
            Else
                FlexGrid.TextMatrix(0, i) = Headline & "+"
                If IsMissing(IsString(i)) Then
                    FlexGrid.Sort = flexSortGenericAscending
                Else
                    If IsString(i) Then
                        FlexGrid.Sort = flexSortStringAscending
                    Else
                        FlexGrid.Sort = flexSortNumericAscending
                    End If
                End If
            End If
        Else
            FlexGrid.TextMatrix(0, i) = Headline
        End If
   Next i
End Sub

Private Sub Grid1_SelChange()
    Dim Index, code As Integer
    Dim Msg As String
    
    If Grid1.Rows = 1 Then Exit Sub
    ' 1번째 이상을 클릭하면 선택
    Index = Grid1.Row
    lblResult.Caption = ">> " & trbHist(Index).fileName & " - " & _
                        trbHist(Index).CarInfo.carId & _
                        "(" & trbHist(Index).CarInfo.ErrHistNo & "건)"
    lstHist.Clear
    For code = 1 To trbHist(Index).CarInfo.ErrHistNo
        If trbHist(Index).ver >= VER_59 Then
            Msg = CStr(trbHist(Index).CarInfo.ErrHistory(code).occurTime) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrMode) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrCode) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).Status0) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).Status1) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).Status2)
        ElseIf trbHist(Index).ver = VER_49 Then
            Msg = CStr(trbHist(Index).CarInfo.ErrHistory(code).occurTime) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrMode) & " " & _
                hexFormat(trbHist(Index).CarInfo.ErrHistory(code).ErrCode)
        End If
        lstHist.AddItem Msg
        lstHist.Refresh
    Next code
    txtStatus(START_FL).Text = CStr(trbHist(Index).CarInfo.StartFl)
    txtStatus(STOP_FL).Text = CStr(trbHist(Index).CarInfo.CurrFl)
    txtStatus(Safety).Text = trbHist(Index).CarInfo.Safety
    txtStatus(LOAD).Text = CStr(trbHist(Index).CarInfo.CarLoad)
    txtStatus(Zone).Text = trbHist(Index).CarInfo.Zone
    txtStatus(Door).Text = trbHist(Index).CarInfo.Door
    txtStatus(Dir).Text = trbHist(Index).CarInfo.Dir
End Sub

