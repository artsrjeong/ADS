VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmFind 
   Appearance      =   0  '���
   BackColor       =   &H8000000B&
   BorderStyle     =   1  '���� ����
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
      Appearance      =   0  '���
      Caption         =   "&Process"
      Height          =   495
      Index           =   1
      Left            =   5880
      TabIndex        =   7
      Top             =   1050
      Width           =   1215
   End
   Begin VB.CheckBox chkFileInfo 
      Appearance      =   0  '���
      Caption         =   "Including property"
      BeginProperty Font 
         Name            =   "����ü"
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
      Appearance      =   0  '���
      BeginProperty Font 
         Name            =   "����ü"
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
      Appearance      =   0  '���
      BeginProperty Font 
         Name            =   "����ü"
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
      Appearance      =   0  '���
      Caption         =   "E&xit"
      Height          =   495
      Index           =   2
      Left            =   5880
      TabIndex        =   2
      Top             =   1800
      Width           =   1215
   End
   Begin VB.CommandButton cmdFind 
      Appearance      =   0  '���
      Caption         =   "&Start"
      Height          =   495
      Index           =   0
      Left            =   5880
      TabIndex        =   1
      Top             =   360
      Width           =   1215
   End
   Begin VB.TextBox txtFileType 
      Appearance      =   0  '���
      BeginProperty Font 
         Name            =   "����ü"
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
'    s = "<�����̸�|>���Ͻð�|^ũ��"
'    gdFiles.FormatString = s
'    gdFiles.Rows = 1
End Sub

Private Sub Form_Load()
    Dim s$
    
    txtFileType.Text = "x*.*"  ' �ʱ� ����Ÿ���� x*.* �� ����
    dirFind.path = "C:\DAS_DUMP\data"
    
    s = "<File Name|>File Time|^Size"
    gdFiles.FormatString = s
    gdFiles.Rows = 1
End Sub

' Start/Stop/Exit ��ư Ŭ��
Private Sub cmdFind_Click(Index As Integer)
    Select Case Index
        Case 0: Call StartSearch    ' [Start] ��ư Ŭ��
        Case 1: Call StartProcess   ' [Process] ��ư Ŭ��
        Case 2: Unload Me           ' [Exit] ��ư Ŭ��
    End Select
End Sub

' Drive ����
Private Sub drvFind_Change()
    dirFind.path = drvFind.Drive
End Sub

' [Start] ��ư Ŭ�� - Directory �˻�
Private Sub StartSearch()
    Dim s$
    Screen.MousePointer = vbHourglass

    'lstFiles.Clear  '����Ʈ�ڽ��� ������ ����.
    gdFiles.Clear
    s = "<File Name|>File Time|^Size"
    gdFiles.FormatString = s
    gdFiles.Rows = 1

    ' �˻� �� �ٸ� ��� ���� ����
    cmdFind(0).Enabled = False
    cmdFind(2).Enabled = False
    drvFind.Enabled = False
    dirFind.Enabled = False
    txtFileType.Enabled = False
    
    Call GetFiles

    ' �˻� �� �ٸ� ��� ���� ���
    cmdFind(0).Enabled = True
    cmdFind(2).Enabled = True
    drvFind.Enabled = True
    dirFind.Enabled = True
    txtFileType.Enabled = True
    
    Screen.MousePointer = vbDefault
End Sub

' ���õ� Directory���� �˻����ǿ� �´� ���ϵ��� ��� ã�Ƴ�
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
        fileName = Dir$     ' ���� �׸��� �о�´�
    Loop
    
    AutosizeGridColumns gdFiles
    lblResult.Caption = ">> " & dirFind.path & "(" & CStr(gdFiles.Rows - 1) & " items)"

End Sub

' [Process] ��ư Ŭ�� - �˻��� ���� ó��
Private Sub StartProcess()
    Dim X As Integer
    Dim Result As Integer
    Dim strName As String
    Dim path As String
    Dim path1 As String
    Dim absPath As String
    
    If gdFiles.Rows = 1 Then Exit Sub   ' ó���� �׸��� 0�� ���
    
    Screen.MousePointer = vbHourglass
    
    absPath = dirFind.path              'ã���� �ϴ� Directory
    If Right$(path, 1) <> "\" Then
        absPath = absPath & "\"
    End If
    
    gdFiles.Rows = gdFiles.Rows + 1     ' ������ ������ �ϳ��� ����� ���� ����
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
    gdFiles.Rows = gdFiles.Rows - 1     ' ����ġ
    
    MDI.sbrStatus.Panels(1).Text = "Completed."
    Screen.MousePointer = vbDefault
End Sub

' [gdFiles] �׸��� Ŭ��
Private Sub gdFiles_Click()
    If gdFiles.MouseRow <> 0 Then Exit Sub
    
    SortFlex gdFiles, gdFiles.MouseCol, True, True, True
End Sub

' �Ѱ��� ���ڵ带 ó��
Private Sub gdFiles_DblClick()
    Dim X As Integer
    Dim Result As Integer
    Dim strName As String
    Dim path As String
    Dim path1 As String
    Dim absPath As String
    Dim Index As Integer    ' Ŭ���� ���ڵ�
    
    If gdFiles.Rows = 1 Then Exit Sub       ' ó���� �׸��� 0�� ���
    If gdFiles.MouseRow = 0 Then Exit Sub  ' ������ Ŭ���� ���
    
    Index = gdFiles.MouseRow
    Screen.MousePointer = vbHourglass
    
    absPath = dirFind.path              'ã���� �ϴ� Directory
    If Right$(path, 1) <> "\" Then
        absPath = absPath & "\"
    End If
    
    gdFiles.Rows = gdFiles.Rows + 1     ' ������ ������ �ϳ��� ����� ���� ����

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

    gdFiles.Rows = gdFiles.Rows - 1     ' ����ġ
    
    MDI.sbrStatus.Panels(1).Text = "Completed."
    Screen.MousePointer = vbDefault
End Sub

' �˻��ϰ��� �ϴ� Ÿ��
Private Sub txtFileType_GotFocus()
    txtFileType.SelStart = 0        '�ؽ�Ʈ �ڽ��� ��Ŀ���� ���� �ؽ�Ʈ�� ����(����)
    txtFileType.SelLength = Len(txtFileType.Text)
End Sub

' �÷��� �׸��� Į�� �ڵ� �����ϴ� ���
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
          For J = 0 To intRows - 1      ' �ش� �÷��� ��� �࿡�� ���� �� ���� �÷� ũ�⸦ ���Ѵ�.
              .Row = J
              txtString = .Text
              intTempWidth = TextWidth(txtString) + intPadding
              If intTempWidth > intBiggestWidth Then intBiggestWidth = intTempWidth
          Next J
          .ColWidth(i) = intBiggestWidth
      Next i
      intTempWidth = 0
      For i = 0 To .Cols - 1            ' ��� �÷��� ��ü ũ�⸦ ���Ѵ�.
          intTempWidth = intTempWidth + .ColWidth(i)
      Next i
      If intTempWidth < msFG.Width Then ' ���� �÷��� ũ�Ⱑ �׸����� ũ�⺸�� ���� ���
          intTempWidth = Fix((msFG.Width - intTempWidth) / .Cols)
          For i = 0 To .Cols - 1
              .ColWidth(i) = .ColWidth(i) + intTempWidth
          Next i
      End If
  End With
End Sub

' Sort
' ����) IsString�� ���� Column�� Index - 0, 1, 2�� �ָ� �ȴ�. ���� ��� �÷��� sorting�ϰ��� �ϸ� ������ŭ �ش�.
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

