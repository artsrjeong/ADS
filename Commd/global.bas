Attribute VB_Name = "basGlobal"
'+++++++++++++++++++++++++++++++++
' 이 프로그램에서 정의하고 있는
' Error를 정의하고 있다
'+++++++++++++++++++++++++++++++++

Option Explicit
Option Base 1


Public Const OK_SUCCESS = 1
Public Const OK_ESMI_REC_EXIST = 2  ' ESMI_DAT..T_TROUBLE에 동일한 접수번호 존재 - 독촉인 경우
Public Const OK_THRETHOULD = 10     ' 성공으로 판단하는 기준값

' DB 연결 관련 고장
Public Const ERR_SIC_CONNECT = 51   ' 정보센터 연결 고장
Public Const ERR_REM_CONNECT = 52   ' 원격감시 연결 고장

' 파일 관련 고장
Public Const ERR_NOT_EXIST = 101    ' 파일이 존재하지 않음
Public Const ERR_VERSION = 102      ' 현재 Version 처리 불가
Public Const ERR_CODE_CARID = 103   ' CODE_CARID 존재 안함
Public Const ERR_CODE_CURR = 104    ' CODE_CURR 존재 안함
Public Const ERR_CODE_LAST = 105    ' CODE_LAST 존재 안함
Public Const ERR_CODE_TRHT = 106    ' CODE_TRHT 존재 안함
Public Const ERR_CODE_FNST = 107    ' CODE_FNST 존재 안함
Public Const ERR_CODE_ERST = 108    ' CODE_ERST 존재 안함
Public Const ERR_TIME_CONV = 110    ' 시간정보(고장발생 또는 고장이력)가 깨짐

' 정보센터
Public Const ERR_SIC_NOT_EXIST = 301        ' 고장이 발생한 관리번호에 대해 정보센터 DB에 고객정보가 존재하지 않음
Public Const ERR_SIC_NOT_EXIST_RECNO = 302  ' 접수번호가 안따짐
Public Const ERR_SIC_SP_KA22_ISRT03_1 = 303 ' Stored Procedure Execption Error

' 원격감시
Public Const ERR_REM_TRBO_FAIL = 401        ' 고장 접수번호 생성 실패
Public Const ERR_REM_TRBS_FAIL = 402        ' 고장상태 입력 실패
Public Const ERR_REM_TRBl_FAIL = 403        ' 고장 Log 입력 실패
Public Const ERR_REM_TRBH_FAIL = 404        ' 고장 HISTORY 입력 실패
Public Const ERR_REM_NO_MAINT_FAIL = 405        ' 고장 HISTORY 입력 실패

Public Const ERR_REM_VFILE_FAIL = 501       ' VFile 고장입력 실패

Type COPYDATASTRUCT
    dwData As Long
    cbData As Long
    lpData As Long
End Type

Public Const GWL_WNDPROC = (-4)
Public Const WM_COPYDATA = &H4A
Public Const WM_WINDOWPOSCHANGED = &H47
Public lpPrevWndProc As Long
Public gHW As Long

'Copies a block of memory from one location to another.
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
(hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)

Declare Function CallWindowProc Lib "user32" Alias _
"CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As _
Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As _
Long) As Long

Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" _
(ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As _
Long) As Long

Public Sub Hook()
    lpPrevWndProc = SetWindowLong(gHW, GWL_WNDPROC, AddressOf WindowProc)
    'Debug.Print lpPrevWndProc
End Sub

Public Sub Unhook()
    Dim temp As Long
    
    temp = SetWindowLong(gHW, GWL_WNDPROC, lpPrevWndProc)
End Sub

Function WindowProc(ByVal hw As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    If uMsg = WM_COPYDATA Then
        Call mySub(lParam)
    End If
    WindowProc = CallWindowProc(lpPrevWndProc, hw, uMsg, wParam, lParam)
End Function

Sub mySub(lParam As Long)
    Dim cds As COPYDATASTRUCT
    Dim buf(1 To 255) As Byte
    Dim a As String
    
    Call CopyMemory(cds, ByVal lParam, Len(cds))
    
    Select Case cds.dwData
        Case 1
            Debug.Print "got a 1"
        Case 2
            Debug.Print "got a 2"
        Case 3
            Call CopyMemory(buf(1), ByVal cds.lpData, cds.cbData)
            a = StrConv(buf, vbUnicode)
            a = Left$(a, InStr(1, a, Chr$(0)) - 1)
            
            With MDI
                .lstXFile.AddItem a
                .lstXFile.Refresh
                    
                .shpStatus(0).FillColor = vbRed
                .shpStatus(1).FillColor = vbRed
                .shpStatus(0).Refresh
                .shpStatus(1).Refresh
    
                .tmrCheck.Enabled = True
            End With
    End Select
End Sub

Public Sub SetImg(ByRef imgControl As Object, ByVal strImgName As String)
    imgControl.Picture = LoadResPicture(strImgName, vbResBitmap)
    imgControl.MouseIcon = LoadResPicture("Point", vbResCursor)
End Sub

Public Function GetUDPMsg() As TTrbMsg
    Dim msgData As TTrbMsg
    Dim Index As Integer
    Dim code As Integer
    Dim codes As String
    Dim Msg As String
    
    Index = histId
    
    msgData.ErrHistNo = trbHist(Index).CarInfo.ErrHistNo
    For code = 1 To trbHist(Index).CarInfo.ErrHistNo
        msgData.ErrHistory(code) = trbHist(Index).CarInfo.ErrHistory(code)
    Next code
    msgData.g_time = trbHist(Index).FileTime
    msgData.g_name = trbHist(Index).fileName
    msgData.g_ver = Hex(trbHist(Index).ver)
    msgData.g_id = trbHist(Index).CarInfo.carId
    msgData.g_result = CStr(trbHist(Index).Result)
    codes = ""
    For code = 1 To trbHist(Index).CarInfo.NewCodeNo
        codes = codes + hexFormat(trbHist(Index).CarInfo.NewCodes(code)) + " "
    Next code
    msgData.g_new = codes
    If trbHist(Index).ver = VER_49 Then
        codes = ""
        For code = 1 To trbHist(Index).CarInfo.CurrErrNo
            codes = codes + hexFormat(trbHist(Index).CarInfo.CurrError(code)) + " "
        Next code
        msgData.g_new = codes
    End If
    codes = ""
    For code = 1 To trbHist(Index).CarInfo.RcvCodeNo
        codes = codes + hexFormat(trbHist(Index).CarInfo.RcvCodes(code)) + " "
    Next code
    msgData.g_rcv = codes
    codes = ""
    For code = 1 To trbHist(Index).CarInfo.HoldCodeNo
        codes = codes + hexFormat(trbHist(Index).CarInfo.HoldCodes(code)) + " "
    Next code
    msgData.g_hold = codes
    msgData.g_maintno = trbHist(Index).CarInfo.maintNo
'    If trbHist(index).CarInfo.maintNo = True Then
'        msgData.g_siccheck = "Y"
'    Else
'        msgData.g_siccheck = ""
'    End If
    msgData.g_remid = trbHist(Index).CarInfo.REMRecNo
    msgData.g_recno = trbHist(Index).CarInfo.SICRecNo
    msgData.g_content = trbHist(Index).CarInfo.Content
    
    
    msgData.l_start = CStr(trbHist(Index).CarInfo.StartFl)
    msgData.l_stop = CStr(trbHist(Index).CarInfo.CurrFl)
    msgData.l_safety = trbHist(Index).CarInfo.Safety
    msgData.l_load = CStr(trbHist(Index).CarInfo.CarLoad)
    msgData.l_zone = trbHist(Index).CarInfo.Zone
    msgData.l_door = trbHist(Index).CarInfo.Door
    msgData.l_dir = trbHist(Index).CarInfo.Dir
    
    msgData.s_total = Str(comm.Total)           ' 전체 수신 건수
    msgData.s_subtotal = Str(comm.SubTotal)     ' 호기별 처리 건수
    msgData.s_succ = Str(comm.Success)          ' 성공 건수
    msgData.s_sic = Str(comm.Service)           ' 정보센터 접수 건수
    msgData.s_fail = Str(comm.Fail)             ' 실패 건수
    msgData.s_multi = Str(comm.Multi)           ' 기준 건수
    msgData.s_das = comm.ContinuedFail          ' 다발고장 DAS
    
    GetUDPMsg = msgData
End Function


Public Function GetStr(ByVal strData As String, ByVal inx As Long) As String
    Dim i%
    Dim subStr$
    Dim subInx%
    subInx = 0
    subStr = ""
    For i = 1 To Len(strData)
        If Mid$(strData, i, 1) = " " And inx = subInx Then
            GetStr = subStr
            Exit Function
        ElseIf Mid$(strData, i, 1) = " " And inx <> subInx Then
            subStr = ""
            subInx = subInx + 1
        End If
        subStr = subStr + Mid$(strData, i, 1)
    Next
    GetStr = subStr
End Function
