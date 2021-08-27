VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmFind 
   Appearance      =   0  '평면
   BackColor       =   &H8000000B&
   BorderStyle     =   1  '단일 고정
   Caption         =   "File Find "
   ClientHeight    =   4635
   ClientLeft      =   1710
   ClientTop       =   1635
   ClientWidth     =   7380
   ForeColor       =   &H80000008&
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4635
   ScaleWidth      =   7380
   Begin VB.CommandButton cmdFind 
      Appearance      =   0  '평면
      Caption         =   "&Process"
      Height          =   495
      Index           =   1
      Left            =   5880
      TabIndex        =   7
      Top             =   1050
      Width           =   1215
   End
   Begin VB.CheckBox chkFileInfo 
      Appearance      =   0  '평면
      Caption         =   "Including property"
      BeginProperty Font 
         Name            =   "굴림체"
         Size            =   9.75
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   375
      Left            =   2880
      TabIndex        =   5
      Top             =   840
      Width           =   2655
   End
   Begin VB.DirListBox dirFind 
      Appearance      =   0  '평면
      BeginProperty Font 
         Name            =   "굴림체"
         Size            =   9.75
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1890
      Left            =   240
      TabIndex        =   4
      Top             =   600
      Width           =   2175
   End
   Begin VB.DriveListBox drvFind 
      Appearance      =   0  '평면
      BeginProperty Font 
         Name            =   "굴림체"
         Size            =   9.75
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   240
      TabIndex        =   3
      Top             =   120
      Width           =   2175
   End
   Begin VB.CommandButton cmdFind 
      Appearance      =   0  '평면
      Caption         =   "E&xit"
      Height          =   495
      Index           =   2
      Left            =   5880
      TabIndex        =   2
      Top             =   1800
      Width           =   1215
   End
   Begin VB.CommandButton cmdFind 
      Appearance      =   0  '평면
      Caption         =   "&Start"
      Height          =   495
      Index           =   0
      Left            =   5880
      TabIndex        =   1
      Top             =   360
      Width           =   1215
   End
   Begin VB.TextBox txtFileType 
      Appearance      =   0  '평면
      BeginProperty Font 
         Name            =   "굴림체"
         Size            =   9.75
         Charset         =   129
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   2880
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   360
      Width           =   2535
   End
   Begin MSFlexGridLib.MSFlexGrid gdFiles 
      Height          =   1725
      Left            =   240
      TabIndex        =   8
      Top             =   2760
      Width           =   6855
      _ExtentX        =   12091
      _ExtentY        =   3043
      _Version        =   393216
      Cols            =   3
      FixedCols       =   0
      FocusRect       =   0
      HighLight       =   2
      GridLines       =   0
      GridLinesFixed  =   1
      SelectionMode   =   1
      Appearance      =   0
      FormatString    =   "<File Name|>File Time|^Size"
   End
   Begin VB.Label lblResult 
      AutoSize        =   -1  'True
      Caption         =   "result :"
      Height          =   180
      Left            =   240
      TabIndex        =   6
      Top             =   2550
      Width           =   585
   End
End
Attribute VB_Name = "frmFind"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Activate()
'    Dim s$
'
'    s = "<파일이름|>파일시간|^크기"
'    gdFiles.FormatString = s
'    gdFiles.Rows = 1
End Sub

Private Sub Form_Load()
    Dim s$
    
    txtFileType.Text = "x*.*"  ' 초기 파일타입을 x*.* 로 설정
    dirFind.path = "C:\DAS_DUMP\data"
    
    s = "<File Name|>File Time|^Size"
    gdFiles.FormatString = s
    gdFiles.Rows = 1
End Sub

' Start/Stop/Exit 버튼 클릭
Private Sub cmdFind_Click(Index As Integer)
    Select Case Index
        Case 0: Call StartSearch    ' [Start] 버튼 클릭
        Case 1: Call StartProcess   ' [Process] 버튼 클릭
        Case 2: Unload Me           ' [Exit] 버튼 클릭
    End Select
End Sub

' Drive 변경
Private Sub drvFind_Change()
    dirFind.path = drvFind.Drive
End Sub

' [Start] 버튼 클릭 - Directory 검색
Private Sub StartSearch()
    Dim s$
    Screen.MousePointer = vbHourglass

    'lstFiles.Clear  '리스트박스의 내용을 비운다.
    gdFiles.Clear
    s = "<File Name|>File Time|^Size"
    gdFiles.FormatString = s
    gdFiles.Rows = 1

    ' 검색 전 다른 모든 조작 금지
    cmdFind(0).Enabled = False
    cmdFind(2).Enabled = False
    drvFind.Enabled = False
    dirFind.Enabled = False
    txtFileType.Enabled = False
    
    Call GetFiles

    ' 검색 후 다른 모든 조작 허용
    cmdFind(0).Enabled = True
    cmdFind(2).Enabled = True
    drvFind.Enabled = True
    dirFind.Enabled = True
    txtFileType.Enabled = True
    
    Screen.MousePointer = vbDefault
End Sub

' 선택된 Directory에서 검색조건에 맞는 파일들을 모두 찾아냄
Private Sub GetFiles()
    Dim path$, path1$
    Dim fileName$, fileName1$
    Dim entry$
    Dim dirAdded As Integer
    Dim Index%
    Dim s$

    path = dirFind.path
    If Right$(path, 1) <> "\" Then
        path = path & "\"
    End If
    path1 = path & txtFileType.Text
    fileName = Dir$(path1)

    Index = 1
    Do Until fileName = ""
        gdFiles.Rows = gdFiles.Rows + 1
        gdFiles.TextMatrix(Index, 0) = Trim(fileName)
        If chkFileInfo.Value Then
            fileName1 = path & fileName
            gdFiles.TextMatrix(Index, 1) = Trim(CStr(FileDateTime(fileName1)))
            gdFiles.TextMatrix(Index, 2) = Trim(CStr(FileLen(fileName1)))
        End If
        'lstFiles.AddItem entry
        'gdFiles.AddItem entry
        gdFiles.Refresh
        Index = Index + 1
        fileName = Dir$     ' 다음 항목을 읽어온다
    Loop
    
    AutosizeGridColumns gdFiles
    lblResult.Caption = ">> " & dirFind.path & "(" & CStr(gdFiles.Rows - 1) & " items)"

End Sub

' [Process] 버튼 클릭 - 검색된 파일 처리
Private Sub StartProcess()
    Dim X As Integer
    Dim Result As Integer
    Dim strName As String
    Dim path As String
    Dim path1 As String
    Dim absPath As String
    
    If gdFiles.Rows = 1 Then Exit Sub   ' 처리할 항목이 0인 경우
    
    Screen.MousePointer = vbHourglass
    
    absPath = dirFind.path              '찾고자 하는 Directory
    If Right$(path, 1) <> "\" Then
        absPath = absPath & "\"
    End If
    
    gdFiles.Rows = gdFiles.Rows + 1     ' 이유는 마지막 하나를 지울수 없기 때문
    Do While gdFiles.Rows > 2
        strName = Trim(gdFiles.TextMatrix(1, 0))
        If strName <> "" Then
            MDI.sbrStatus.Panels(1).Text = strName
            path = absPath & strName            ' strName = only filename
            Result = ProcessTrb(path)           ' path = full path filename
            WriteLog (Result)
            
            If Result < OK_THRETHOULD Then
                path1 = "C:\DAS_DUMP\Checked"
            Else
                path1 = "C:\DAS_DUMP\Err"
            End If
            path1 = AddPath(path1, strName)     ' path1 = full path filename - destinatio
            Result = MoveFile(path, path1)      ' path = full path filename - source
            gdFiles.RemoveItem 1
            gdFiles.Refresh
            lblResult.Caption = ">> " & dirFind.path & "(" & Str(gdFiles.Rows - 2) & " items)"
            lblResult.Refresh
        End If
    Loop
    gdFiles.Rows = gdFiles.Rows - 1     ' 원위치
    
    MDI.sbrStatus.Panels(1).Text = "Completed."
    Screen.MousePointer = vbDefault
End Sub

' [gdFiles] 그리드 클릭
Private Sub gdFiles_Click()
    If gdFiles.MouseRow <> 0 Then Exit Sub
    
    SortFlex gdFiles, gdFiles.MouseCol, True, True, True
End Sub

' 한개의 레코드를 처리
Private Sub gdFiles_DblClick()
    Dim X As Integer
    Dim Result As Integer
    Dim strName As String
    Dim path As String
    Dim path1 As String
    Dim absPath As String
    Dim Index As Integer    ' 클릭한 레코드
    
    If gdFiles.Rows = 1 Then Exit Sub       ' 처리할 항목이 0인 경우
    If gdFiles.MouseRow = 0 Then Exit Sub  ' 제목을 클릭한 경우
    
    Index = gdFiles.MouseRow
    Screen.MousePointer = vbHourglass
    
    absPath = dirFind.path              '찾고자 하는 Directory
    If Right$(path, 1) <> "\" Then
        absPath = absPath & "\"
    End If
    
    gdFiles.Rows = gdFiles.Rows + 1     ' 이유는 마지막 하나를 지울수 없기 때문

    strName = Trim(gdFiles.TextMatrix(Index, 0))
    If strName <> "" Then
        MDI.sbrStatus.Panels(1).Text = strName
        path = absPath & strName            ' strName = only filename
        Result = ProcessTrb(path)           ' path = full path filename
        WriteLog (Result)
        
        If Result < OK_THRETHOULD Then
            path1 = "C:\DAS_DUMP\Checked"
        Else
            path1 = "C:\DAS_DUMP\Err"
        End If
        path1 = AddPath(path1, strName)     ' path1 = full path filename - destinatio
        Result = MoveFile(path, path1)      ' path = full path filename - source
        gdFiles.RemoveItem Index
        gdFiles.Refresh
        lblResult.Caption = ">> " & dirFind.path & "(" & Str(gdFiles.Rows - 2) & " items)"
        lblResult.Refresh
    End If

    gdFiles.Rows = gdFiles.Rows - 1     ' 원위치
    
    MDI.sbrStatus.Panels(1).Text = "Completed."
    Screen.MousePointer = vbDefault
End Sub

' 검색하고자 하는 타입
Private Sub txtFileType_GotFocus()
    txtFileType.SelStart = 0        '텍스트 박스에 포커스가 오면 텍스트를 반전(선택)
    txtFileType.SelLength = Len(txtFileType.Text)
End Sub

' 플렉스 그리스 칼럼 자동 조정하는 방법
Private Sub AutosizeGridColumns(msFG As MSFlexGrid)
  Dim i, J As Integer
  Dim txtString As String
  Dim intTempWidth, intBiggestWidth As Integer
  Dim intRows As Integer
  Const intPadding = 150

  If msFG.Rows = 0 Then Exit Sub
  With msFG
      For i = 0 To .Cols - 1
          .Col = i
          intRows = .Rows
          intBiggestWidth = 0
          For J = 0 To intRows - 1      ' 해당 컬럼의 모든 행에서 가장 긴 행의 컬럼 크기를 구한다.
              .Row = J
              txtString = .Text
              intTempWidth = TextWidth(txtString) + intPadding
              If intTempWidth > intBiggestWidth Then intBiggestWidth = intTempWidth
          Next J
          .ColWidth(i) = intBiggestWidth
      Next i
      intTempWidth = 0
      For i = 0 To .Cols - 1            ' 모든 컬럼의 전체 크기를 구한다.
          intTempWidth = intTempWidth + .ColWidth(i)
      Next i
      If intTempWidth < msFG.Width Then ' 계산된 컬럼의 크기가 그리드의 크기보다 적은 경우
          intTempWidth = Fix((msFG.Width - intTempWidth) / .Cols)
          For i = 0 To .Cols - 1
              .ColWidth(i) = .ColWidth(i) + intTempWidth
          Next i
      End If
  End With
End Sub

' Sort
' 주의) IsString의 값을 Column의 Index - 0, 1, 2로 주면 된다. 만약 모든 컬럼을 sorting하고자 하면 갯수만큼 준다.
Private Sub SortFlex(FlexGrid As MSFlexGrid, ByVal TheCol As Integer, ParamArray IsString() As Variant)
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

