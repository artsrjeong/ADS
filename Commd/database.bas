Attribute VB_Name = "basDatabase"
Option Explicit

Public currDatabase As String           ' 현재 연결하고 싶은 Database
Public xSicPWD As String                   ' SIC password
Public xRemPWD As String                ' REM password
Public connREM As ADODB.Connection      ' 원격감시 Database
Public connSIC As ADODB.Connection      ' 정보센터 Database

Public Function DBInsert49(trb As TTrbInfo) As Integer
    Dim car As Byte     ' car Index
    Dim Index As Byte   ' 고장 Index
    Dim code As Byte    ' 신규 고장코드
    Dim isFlag As Boolean   ' 정보센터에 등록할 고장이 존재하는지 결과
    Dim Result As Integer   ' 함수 실행 결과
    Dim FResult As Integer  ' 이 함수내에서 사용되는 최종 결과
    Dim strCode As String   ' 고장코드 만큼 SQL문을 만듬
    
    On Err GoTo ErrTrap
    
    Result = ConnectREM
    If Result <> True Then      ' REM 연결 실패
        DBInsert49 = Result
        Exit Function
    End If
            
    Result = OK_SUCCESS
    For car = 1 To trb.CarNo
        strCode = ""
        If trb.CarInfo(car).CurrErrNo = 1 Then
            Index = 1
            strCode = "t.code_no = '" & hexFormat(trb.CarInfo(car).CurrError(Index)) & "' "
        End If
        
        If trb.CarInfo(car).CurrErrNo > 1 Then
            strCode = "("
            For Index = 1 To trb.CarInfo(car).CurrErrNo     ' 정보센터 접수
                If Index <> trb.CarInfo(car).CurrErrNo Then
                    strCode = strCode & "t.code_no = '" & hexFormat(trb.CarInfo(car).CurrError(Index)) & "' or "
                Else
                    strCode = strCode & "t.code_no = '" & hexFormat(trb.CarInfo(car).CurrError(Index)) & "')"
                End If
            Next Index
        End If
        
        If strCode <> "" Then
            If NewExistSICTrb(trb.dasId, trb.CarInfo(car), strCode) = True Then  ' 정보센터 접수 고장 존재
                trb.CarInfo(car).SICCheck = True
                trb.CarInfo(car).SICErrNo = 1
                trb.CarInfo(car).SICError(1) = trb.CarInfo(car).CurrError(Index)
                If frmConfig.chkSICInsert.Value <> 1 Then   ' check되면 정보센터에 넣지 않음
                    Result = InsertSICTrb(trb.CarInfo(car))
                End If
            End If
        End If
        If Result <> OK_SUCCESS Then FResult = Result
                
        trb.CarInfo(car).maintNo = GetElevator(trb.dasId, Format(trb.CarInfo(car).carId, "0#"))
        If trb.CarInfo(car).maintNo <> "" Then
            Result = InsertREMTrb(trb.CarInfo(car), trb.fileName, trb.ver)         ' 원격감시 접수
        Else
            
            Result = ERR_REM_NO_MAINT_FAIL
        End If
        If Result <> OK_SUCCESS Then FResult = Result
    Next car
    
    Call DisconnectREM      ' REM 연결 끊기 실패
    DBInsert49 = FResult
    
    Exit Function
ErrTrap:
End Function
Public Sub GetCodeInfo(trb As TCarInfo)
    Dim adoRs As ADODB.Recordset
    Dim Result As Integer
    Dim SQL As String
    On Error GoTo ErrTrap
    

ErrTrap:
End Sub


Public Function GetCustomer(trb As TCarInfo) As Integer
'Ver 59 파일의 로그 저장을 위하여 고객명을 가져온다.
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim adoErr As Object
    Dim SQL As String
    Dim strCustomer As String            ' 신고자 전화번호
    Dim strTeam As String           ' 소속부서
    Dim strCenter As String         ' 접수센타
    Dim strTime As String           ' 접수시간
    Dim Result As Integer           ' SQL 실행결과
    Dim strModelType As String * 1  ' TCD Type = H인 경우는 DI, SIGM을 제외한 전 기종
    On Error GoTo ErrTrap
    
    Result = ConnectSIC
    If Result <> True Then      ' SIC 연결 실패
        WriteUDPLog "SIC Connection", "error"
        Exit Function
    End If
    

    ' 고객명과 호기이름을 가져온다.
    SQL = "select t6.ka6_compname,t5.ka5_itemno from tka50 t5,tka60 t6 where t5.ka5_mainno='" + trb.maintNo + "' and t5.ka5_new_mainno=t6.ka6_new_mainno"
    
    WriteUDPLog "GetCustomer", "고객정보->" + SQL
    Set adoRs = New ADODB.Recordset
    adoRs.Open SQL, connSIC, adOpenStatic, adLockReadOnly, adCmdText
    
    Result = adoRs.RecordCount
    
    Do While Not adoRs.EOF
        trb.Customer = adoRs!ka6_compname & " " & adoRs!ka5_itemno
        adoRs.MoveNext
    Loop
    adoRs.Close
    Set adoRs = Nothing
    GetCustomer = 1
ErrTrap:
End Function
' 도어 고장 관련된 설명을 가져온다.
Public Function GetDoorTrb(code As Byte) As String
    Select Case code
        Case 97
            GetDoorTrb = "ERR_CDS    Car Door 스위치 동작 이상"
        Case 98
            GetDoorTrb = "ERR_R2LD     Landing Door 스위치 동작 이상"
        Case 132
            GetDoorTrb = "ERR_OPEN_LOCK     Door Open Lock 검출"
        Case 133
            GetDoorTrb = "ERR_OPEN_LOCK_3     Open Lock 반복 검출"
        Case 134
            GetDoorTrb = "ERR_CLOSE_LOCK    Door Close Lock 검출"
        Case 135
            GetDoorTrb = "ERR_CLOSE_LOCK_1M     Close Lock 반복 검출"
        Case 139
            GetDoorTrb = "ERR_NUDGING    Nudging 고장"
        Case 145
            GetDoorTrb = "ERR_INV_DM    Inv Door 제어 이상"
        Case 191
            GetDoorTrb = "ERR_DOOR_COMMAND    Door 지령이상"
        Case 192
            GetDoorTrb = "ERR_DOOR_POSI   위치 검출기 고장"
        Case 193
            GetDoorTrb = "ERR_DOOR_VOLTAGE   저/고전압 검출"
        Case 194
            GetDoorTrb = "ERR_DOOR_MOTOR_THERMAL   Motor 과열 Error"
        Case 195
            GetDoorTrb = "ERR_DOOR_IPM    과전류 검출"
    
        Case 223
            GetDoorTrb = "OLS Off 고장    OLS Off 불가"
        Case 224
            GetDoorTrb = "OLS On 고장     OLS On 불가"
        Case 225
            GetDoorTrb = "CDS Off 고장    CDS Off 불가"
        Case 226
            GetDoorTrb = "CDS On 고장     CDS On 불가"
        Case 227
            GetDoorTrb = "CLS Off 고장    CLS Off 불가"
        Case 228
            GetDoorTrb = "CLS On 고장     CLS On 불가"
        Case 229
            GetDoorTrb = "LDS Off 고장    LDS Off 불가"
        Case 230
            GetDoorTrb = "LDS On 고장     LDS On 불가"
        Case 231
            GetDoorTrb = "SES Off 고장    SES Off 불가"
        Case 232
            GetDoorTrb = "PSES Off 고장   PSES Off 불가"
        Case 233
            GetDoorTrb = "Encoder Error   DERR: 001"
        Case 234
            GetDoorTrb = "DLD(Door Load Detect) Error DERR: 010"
        Case 235
            GetDoorTrb = "Motor Thermal Error DERR: 011"
        Case 236
            GetDoorTrb = "Not Used    DERR: 100"
        Case 237
            GetDoorTrb = "Lower Voltage (저전압)  DERR: 101"
        Case 238
            GetDoorTrb = "Command Error (Open, Close 동시지령)    DERR: 110"
        Case 239
            GetDoorTrb = "Over Current (과전류)   DERR: 111"
        End Select
End Function
' Ver 59인 파일을 정보센터와 원격감시 DB에 등록
' 파라미터 - Decoding된 고장
' Return value - 처리 결과
Public Function DBInsert59(trb As TTrbInfo) As Integer
    Dim car As Byte     ' car Index
    Dim Index As Byte   ' 고장 Index
    Dim Result As Integer   ' 함수 실행 결과
    Dim strCode As String   ' 고장코드 만큼 SQL문을 만듬
    Dim bNewExistSicTrb As Boolean
    
    Dim olApp As Outlook.Application
    Set olApp = CreateObject("Outlook.Application")

    Dim olNs As Outlook.NameSpace
    Set olNs = olApp.GetNamespace("MAPI")
    olNs.Logon
   
    Dim olMail As Outlook.MailItem
    
    On Err GoTo ErrTrap
    
    Result = OK_SUCCESS
    For car = 1 To trb.CarNo
        '각 Car 마다 고장 이력을 위하여 고객명을 가져온다.
        
            For Index = 1 To trb.CarInfo(car).NewCodeNo     ' 정보센터 접수
                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "donghok@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "모뎀통신 정상"
                    olMail.Body = "B동 도어 테스트기 하루에 한번씩 전송"
                Else
                    olMail.Subject = Str(car) + "호기 고장"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing
                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "srjeong@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "모뎀통신 정상"
                    olMail.Body = "B동 도어 테스트기 하루에 한번씩 전송"
                Else
                    olMail.Subject = Str(car) + "호기 고장"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing

                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "hjseo@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "모뎀통신 정상"
                    olMail.Body = "B동 도어 테스트기 하루에 한번씩 전송"
                Else
                    olMail.Subject = Str(car) + "호기 고장"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing

                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "taewookk@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "모뎀통신 정상"
                    olMail.Body = "B동 도어 테스트기 하루에 한번씩 전송"
                Else
                    olMail.Subject = Str(car) + "호기 고장"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing

            Next Index
            
    Next car
    Set olNs = Nothing
    Set olApp = Nothing
    
    Exit Function
ErrTrap:
End Function

' 각 호기의 고장코드들 중에서 정보센터에 접수할 고장이 있는지를 검사
' 파라미터 - DAS_ID, 한 호기의 정보, 고장코드 Index
' Return value - 존재하면 TRUE
' 중요) 만약 존재하면 carTrb.MaintNo, carTrb.Content를 갱신한다.
Private Function ExistSICTrb(ByVal dasId As String, ByRef trbCar As TCarInfo, ByVal Index As Byte) As Boolean
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim carId, code As String * 2
    Dim isFlag As Boolean
    
    On Error GoTo ErrTrap
    
    isFlag = False
    carId = Format(Str(trbCar.carId), "0#")
    code = Hex(trbCar.NewCodes(Index))
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_get_code_info"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("DasId", adChar, adParamInput, 9, dasId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("CarId", adChar, adParamInput, 2, carId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("Code", adChar, adParamInput, 2, code)
    
    Set adoCmd.ActiveConnection = connREM
    Set adoRs = New ADODB.Recordset
    Set adoRs = adoCmd.Execute
    Do While Not adoRs.EOF
        trbCar.maintNo = adoRs!maint_no
        trbCar.Content = adoRs!Content
        isFlag = True
        adoRs.MoveNext
    Loop
    
    adoRs.Close
    Set adoRs = Nothing
    Set adoCmd = Nothing
    
    ExistSICTrb = isFlag
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    
    ExistSICTrb = False
End Function

' 각 호기의 고장코드들 중에서 정보센터에 접수할 고장이 있는지를 검사
' 파라미터 - DAS_ID, 한 호기의 정보, 고장코드 Index
' Return value - 존재하면 TRUE
' 중요) 만약 존재하면 carTrb.MaintNo, carTrb.Content를 갱신한다.
Private Function ExistSICTrb49(ByVal dasId As String, trbCar As TCarInfo, ByVal Index As Byte) As Boolean
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim carId, code As String * 2
    Dim isFlag As Boolean
    
    On Error GoTo ErrTrap
    
    isFlag = False
    carId = Format(Str(trbCar.carId), "0#")
    code = Hex(trbCar.CurrError(Index))
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_get_code_info"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("DasId", adChar, adParamInput, 9, dasId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("CarId", adChar, adParamInput, 2, carId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("Code", adChar, adParamInput, 2, code)
    
    Set adoCmd.ActiveConnection = connREM
    Set adoRs = New ADODB.Recordset
    Set adoRs = adoCmd.Execute
    Do While Not adoRs.EOF
        trbCar.maintNo = adoRs!maint_no
        trbCar.Content = adoRs!Content
        isFlag = True
        adoRs.MoveNext
    Loop
    
    adoRs.Close
    Set adoRs = Nothing
    Set adoCmd = Nothing
    
    ExistSICTrb49 = isFlag
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    
    ExistSICTrb49 = False
End Function
'재처리를 위해 GEMIS DB에 전송
Public Function InsertRetry(trb As TCarInfo) As Integer
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim adoErr As Object
    Dim SQL As String
    Dim sp_text$                      ' insert_sic_error sp의 Text를 저장
    Dim strRec_date$
    Dim loXMLHTTP As XMLHTTPRequest
    Dim Request As String
    
    On Error GoTo ErrTrap
        
    strRec_date = "BEA-" & Format(Now, "yymmdd") & "-"
    sp_text = "exec call sp_KA22_isrt03_1UP " + "'" + strRec_date + "'," + "'" + trb.Content + "'," + "'01','ESMI',,,'1','ESMI',,'" + trb.maintNo + "'"
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "insert_sic_error"
    adoCmd.CommandType = adCmdStoredProc

    adoCmd.Parameters.Append adoCmd.CreateParameter("strRec_date", adChar, adParamInput, 50, "BEA-" & Format(Now, "yymmdd") & "-")
    adoCmd.Parameters.Append adoCmd.CreateParameter("maint_no", adChar, adParamInput, 50, trb.maintNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("buildingName", adChar, adParamInput, 50, trb.Customer)
    adoCmd.Parameters.Append adoCmd.CreateParameter("alarm_description", adChar, adParamInput, 100, trb.Content)
    adoCmd.Parameters.Append adoCmd.CreateParameter("sp_text", adChar, adParamInput, 200, sp_text)

    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    InsertRetry = 1
    'Request = "http://otiscs.otis.co.kr/pdajsr/service.asmx/HelloWorld"
    'Set loXMLHTTP = New XMLHTTPRequest
    'loXMLHTTP.Open "GET", Request, False, "", ""
    'loXMLHTTP.send
    'MsgBox loXMLHTTP.responseText
    
    Exit Function
ErrTrap:
    InsertRetry = 0
    Exit Function
End Function

' 정보센터 고장 접수
' 정보센터 DB Connect
' 0) 정보센터에 입력할 TCD의 유형을 구함. H Type = DI, SIGM 기종을 제이한 모든 기종
' 1) 접수위한 사전정보 구함,
' 2) 고장접수,
' 3) T_TROUBLE의 동일한 접수번호 확인,
' 4) ESMI_DAT..T_TROUBLE 접수
' 정보센터 DB Disconnect

Public Function InsertSICTrb(trb As TCarInfo) As Integer
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim adoErr As Object
    Dim SQL As String
    Dim strTel As String            ' 신고자 전화번호
    Dim strTeam As String           ' 소속부서
    Dim strCenter As String         ' 접수센타
    Dim strTime As String           ' 접수시간
    Dim Result As Integer           ' SQL 실행결과
    Dim strModelType As String * 1  ' TCD Type = H인 경우는 DI, SIGM을 제외한 전 기종
    On Error GoTo ErrTrap
    
    Result = ConnectSIC
    If Result <> True Then      ' SIC 연결 실패
        WriteUDPLog "SIC Connection", "error"
        InsertSICTrb = Result
        Exit Function
    End If
    
    ' 0) 정보센터에 입력할 TCD의 유형을 구함. H Type = DI, SIGM 기종을 제이한 모든 기종
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_get_tcd_type"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MAINT_NO", adChar, adParamInput, 15, trb.maintNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TCD_TYPE", adChar, adParamOutput, 1, "N")
        
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    strModelType = adoCmd.Parameters(1).Value
    
    Set adoCmd = Nothing

    ' 1) 고장접수를 위한 사전 정보를 구함 - 관리번호 참조
    'strTime = CStr(Now)
    SQL = "SELECT tka60.ka6_center Center, tka60.ka6_telno TelNo, tka60.ka6_chkteam ChkTeam " & _
          "FROM tka50, tka60 " & _
          "WHERE tka50.ka5_custno = tka60.ka6_custno And tka50.ka5_mainno = '" & trb.maintNo & "'"
    
    WriteUDPLog "InsertSICTrb", "사전정보->" + SQL
    Set adoRs = New ADODB.Recordset
    adoRs.Open SQL, connSIC, adOpenStatic, adLockReadOnly, adCmdText
    
    Result = adoRs.RecordCount
    
    Do While Not adoRs.EOF
        strTel = adoRs!TelNo
        strTeam = adoRs!ChkTeam
        strCenter = adoRs!Center
        adoRs.MoveNext
    Loop
    adoRs.Close
    Set adoRs = Nothing
    
    If Result < 1 Then
        WriteUDPLog "InsertSICTrb", "SIC 정보 없음"
        InsertSICTrb = ERR_SIC_NOT_EXIST
        Exit Function
    End If
        
    ' 2) 고장접수
    Set adoCmd = New ADODB.Command
    adoCmd.CommandText = "SP_REC_ISRT_RECEIPT"     ' 고장 접수
    adoCmd.CommandType = adCmdStoredProc
    adoCmd.Parameters.Append adoCmd.CreateParameter("TMPRECNO", adChar, adParamInput, 11, "BEA-" & Format(Now, "yymmdd") & "-")     ' 제품 코드
    If comm.TestIn = 1 Then     ' Test DB 입력
        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, "/삭제/TEST-" & trb.Content)     ' 접수 내용
    Else
        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, trb.Content)     ' 접수 내용
    End If
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECCD", adChar, adParamInput, 2, "01")     ' 접수 코드
    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLER", adVarChar, adParamInput, 10, "ESMI")     ' 신고자
    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLERTELNO", adChar, adParamInput, 12, "")     ' 신고자 전화번호
    adoCmd.Parameters.Append adoCmd.CreateParameter("RESTIME", adVarChar, adParamInput, 30, "")     ' 예약 시간
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECTRACE", adChar, adParamInput, 1, "1")     ' 상태코드
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECVER", adChar, adParamInput, 7, "ESMI")     ' 접수자
    adoCmd.Parameters.Append adoCmd.CreateParameter("ASDIV", adChar, adParamInput, 7, strTeam)     ' 소속부서
    adoCmd.Parameters.Append adoCmd.CreateParameter("MAINNO", adChar, adParamInput, 15, trb.maintNo)     ' 관리번호
    adoCmd.Parameters.Append adoCmd.CreateParameter("JPCODE", adChar, adParamInput, 3, "")     ' 제품구분코드
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECTIME", adChar, adParamInput, 30, "")     ' 접수시간
    adoCmd.Parameters.Append adoCmd.CreateParameter("DESC", adChar, adParamInput, 100, "")     ' 설명
    adoCmd.Parameters.Append adoCmd.CreateParameter("COMPNAME", adVarChar, adParamInput, 30, "")     ' 설명
    adoCmd.Parameters.Append adoCmd.CreateParameter("ITEM", adVarChar, adParamInput, 30, "")     ' 설명
    adoCmd.Parameters.Append adoCmd.CreateParameter("BUSEONAME", adVarChar, adParamInput, 20, "")     ' 제품구분코드
    
    
'    adoCmd.CommandText = "sp_KA22_isrt03_1"     ' 고장 접수
'    adoCmd.CommandType = adCmdStoredProc
'
'    adoCmd.Parameters.Append adoCmd.CreateParameter("UNITCD", adChar, adParamInput, 1, "E")     ' 제품 코드
'    If comm.TestIn = 1 Then     ' Test DB 입력
'        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, "/삭제/TEST-" & trb.Content)     ' 접수 내용
'    Else
'        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, trb.Content)     ' 접수 내용
'    End If
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RECCD", adChar, adParamInput, 2, "01")     ' 접수 코드
'    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLER", adVarChar, adParamInput, 10, "ESMI")     ' 신고자
'    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLERTELNO", adChar, adParamInput, 12, strTel)     ' 신고자 전화번호
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RESTIME", adVarChar, adParamInput, 30, "")     ' 예약 시간
'    adoCmd.Parameters.Append adoCmd.CreateParameter("STACD", adChar, adParamInput, 1, "1")     ' 상태코드
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RECVER", adChar, adParamInput, 7, "ESMI")     ' 접수자
'    adoCmd.Parameters.Append adoCmd.CreateParameter("ASDIV", adChar, adParamInput, 7, strTeam)     ' 소속부서
'    adoCmd.Parameters.Append adoCmd.CreateParameter("MAINNO", adChar, adParamInput, 15, trb.maintNo)     ' 관리번호
'    adoCmd.Parameters.Append adoCmd.CreateParameter("JPCODE", adChar, adParamInput, 3, "EEL")     ' 제품구분코드
'    adoCmd.Parameters.Append adoCmd.CreateParameter("REGCNTR", adChar, adParamInput, 1, strCenter)     ' 접수센타
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RECTIME", adChar, adParamInput, 30, strTime)     ' 접수시간
'    adoCmd.Parameters.Append adoCmd.CreateParameter("DESC", adChar, adParamInput, 100, "")     ' 설명

    Set adoCmd.ActiveConnection = connSIC
    Set adoRs = New ADODB.Recordset
    WriteUDPLog "InsertSICTrb", "SP_REC_ISRT_RECEIPT 호출"
    Set adoRs = adoCmd.Execute
    WriteUDPLog "InsertSICTrb", "SP 정상 호출"
    trb.SICRecNo = "" '초기화
    
    If Not adoRs.EOF Then
        trb.SICRecNo = adoRs(0)
        WriteUDPLog "처리 결과", adoRs(3)
        If Not adoRs(3) = "신규" Then      ' 독촉이나 지연이면
            WriteUDPLog "InsertSICTrb", "정보센타DB에 ESMI 고장 입력안하고 리턴"
            trb.SICRecNo = "독촉,지연"
            InsertSICTrb = OK_ESMI_REC_EXIST
            adoRs.Close
            Set adoRs = Nothing
            Set adoCmd = Nothing
            Exit Function
        End If
    End If
    
    

    adoRs.Close
    Set adoRs = Nothing
    Set adoCmd = Nothing

    ' 3) T_TROUBLE의 동일한 접수번호 확인
    
    ' 4) ESMI_DAT..T_TROUBLE 접수
    SQL = "INSERT INTO ESMI_DAT..T_TROUBLE(rec_no, main_no, rank, startfl, curfl, dir, safety, " & _
          "door, zone, pload, tcd1, tcd2, tcd3, tcd4, tcd5, tcd6) " & _
          "VALUES (" & "'" & trb.SICRecNo & "', " & _
          "'" & trb.maintNo & "', " & _
          "'FF', " & _
          trb.StartFl & ", " & _
          trb.CurrFl & ", " & _
          "'" & trb.Dir & "', " & _
          "'" & trb.Safety & "', " & _
          "'" & trb.Door & "', " & _
          "'" & trb.Zone & "', " & _
          trb.CarLoad & ", "
    If strModelType = "H" Then
        SQL = SQL & _
          "'" & Hex(trb.SICError(1)) & "', " & _
          "'" & Hex(trb.SICError(2)) & "', " & _
          "'" & Hex(trb.SICError(3)) & "', " & _
          "'" & Hex(trb.SICError(4)) & "', " & _
          "'" & Hex(trb.SICError(5)) & "', " & _
          "'" & Hex(trb.SICError(6)) & "') "
    Else
        SQL = SQL & _
          "'" & trb.SICError(1) & "', " & _
          "'" & trb.SICError(2) & "', " & _
          "'" & trb.SICError(3) & "', " & _
          "'" & trb.SICError(4) & "', " & _
          "'" & trb.SICError(5) & "', " & _
          "'" & trb.SICError(6) & "') "
    End If

    Set adoCmd = New ADODB.Command

    Set adoCmd.ActiveConnection = connSIC
    adoCmd.CommandText = SQL

    adoCmd.Execute

    Set adoCmd = Nothing
    
    Call DisconnectSIC
    
    InsertSICTrb = OK_SUCCESS
    If trb.SICRecNo = "" Then
        WriteUDPLog "Normal", "Blank"
    End If
    Exit Function
    
ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    WriteUDPLog "Error", Err.Description + " ->재처리"
    trb.Comment = trb.Comment + "\n" + "Error" + Err.Description + " ->재처리"
    
    
    reTrbCar = trb
    InsertSICTrb = ERR_SIC_NOT_EXIST_RECNO
    Exit Function
    
'    If connSIC.Errors.Count > 0 Then
'        For Each adoErr In connSIC.Errors
'            MsgBox "Error No: " & adoErr.Number & vbCr & adoErr.Description
'        Next adoErr
'    End If
    
End Function

' 원격감시 DB에 고장을 입력
Private Function InsertREMTrb(ByRef trb As TCarInfo, ByVal xfile As String, ByVal ver As Byte) As Integer
    Dim intResult As Integer
    Dim Index As Integer
    
    trb.REMRecNo = Trbo_Insert(trb.maintNo, trb.SICRecNo, xfile, hexFormat(ver))
    If trb.REMRecNo = "" Then
        InsertREMTrb = ERR_REM_TRBO_FAIL
        Exit Function
    End If
    
    intResult = Trbs_Insert(trb)
    If intResult <> OK_SUCCESS Then
        InsertREMTrb = intResult
        Exit Function
    End If
    
    For Index = 1 To trb.ErrHistNo  ' 고장History 입력
        intResult = Trbh_Insert(trb.REMRecNo, trb.ErrHistory(Index))
        If intResult <> OK_SUCCESS Then
            InsertREMTrb = intResult
            Exit Function
        End If
    Next Index
    
    If ver >= VER_59 Then
        For Index = 1 To trb.NewCodeNo  ' 신규고장입력
            intResult = Trbl_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.NewCodes(Index)), "N", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
        For Index = 1 To trb.RcvCodeNo  ' 복구고장입력
            intResult = Trbl_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.RcvCodes(Index)), "R", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
        For Index = 1 To trb.HoldCodeNo  ' 유지고장입력
            intResult = Trbl_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.HoldCodes(Index)), "H", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
    ElseIf ver = VER_49 Then
        For Index = 1 To trb.CurrErrNo  ' 신규고장입력
            intResult = Trbl_Ver49_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.CurrError(Index)), " ", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
    End If
       
    InsertREMTrb = OK_SUCCESS
End Function

' 고장 Log 입력
Private Function GetElevator(ByVal dasId As String, ByVal carId As String) As String
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    
    On Error GoTo ErrTrap
    
    GetElevator = ""
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_get_maintno"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DAS_ID", adChar, adParamInput, 9, dasId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CAR_ID", adChar, adParamInput, 2, carId)
    
    Set adoCmd.ActiveConnection = connREM
    Set adoRs = New ADODB.Recordset
    Set adoRs = adoCmd.Execute
    Do While Not adoRs.EOF
        GetElevator = adoRs!maint_no
        adoRs.MoveNext
    Loop
    
    adoRs.Close
    Set adoRs = Nothing
    Set adoCmd = Nothing
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    If Not adoRs Is Nothing Then Set adoRs = Nothing
End Function

' 고장접수 입력
Private Function Trbo_Insert(ByVal maintNo As String, ByVal sicNo As String, ByVal xfile As String, ByVal ver As String) As String
    Dim adoCmd As ADODB.Command
    Dim adoRs2 As ADODB.Recordset
    Dim Result As String
    
    On Error GoTo ErrTrap
    
    Result = ""
    
    Set adoCmd = New ADODB.Command

    adoCmd.CommandText = "up_trbo_insert1"
    adoCmd.CommandType = adCmdStoredProc

    adoCmd.Parameters.Append adoCmd.CreateParameter("V_ELEVATOR", adChar, adParamInput, 15, maintNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CS_RCV_ID", adChar, adParamInput, 15, sicNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FILENAME", adChar, adParamInput, 20, xfile)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_VER", adChar, adParamInput, 2, ver)
    If comm.TestIn = 1 Then     ' Test DB 입력
        adoCmd.Parameters.Append adoCmd.CreateParameter("V_FLAG", adVarChar, adParamInput, 1, "Y")
    End If

    Set adoCmd.ActiveConnection = connREM
    Set adoRs2 = New ADODB.Recordset
    Set adoRs2 = adoCmd.Execute

    Do While Not adoRs2.EOF
        Result = adoRs2!RCV_NO
        adoRs2.MoveNext
    Loop
    
    adoRs2.Close
    Set adoRs2 = Nothing
    Set adoCmd = Nothing
    
    Trbo_Insert = Result
    
    Exit Function

ErrTrap:
    WriteUDPLog "Trbo_Insert", Err.Description
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    If Not adoRs2 Is Nothing Then Set adoRs2 = Nothing
End Function

' 고장상태 입력
Private Function Trbs_Insert(ByRef car As TCarInfo) As Integer
    Dim adoCmd As ADODB.Command
    
    On Error GoTo ErrTrap
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_trbs_insert1"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RCV_ID", adChar, adParamInput, 13, car.REMRecNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CURFL", adInteger, adParamInput, 4, car.CurrFl)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STARTFL", adInteger, adParamInput, 4, car.StartFl)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CAR_LOAD", adInteger, adParamInput, 4, car.CarLoad)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DIR", adChar, adParamInput, 1, car.Dir)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_ZONE", adChar, adParamInput, 1, car.Zone)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DOOR", adChar, adParamInput, 1, car.Door)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_ESTOP", adChar, adParamInput, 1, car.EStop)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_SAFETY", adChar, adParamInput, 1, car.Safety)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE1", adChar, adParamInput, 2, Hex(car.EtcState(1)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE2", adChar, adParamInput, 2, Hex(car.EtcState(2)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE3", adChar, adParamInput, 2, Hex(car.EtcState(3)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE4", adChar, adParamInput, 2, Hex(car.EtcState(4)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE5", adChar, adParamInput, 2, Hex(car.EtcState(5)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE6", adChar, adParamInput, 2, Hex(car.EtcState(6)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE7", adChar, adParamInput, 2, Hex(car.EtcState(7)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE8", adChar, adParamInput, 2, Hex(car.EtcState(8)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE9", adChar, adParamInput, 2, Hex(car.EtcState(9)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE10", adChar, adParamInput, 2, Hex(car.EtcState(10)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE11", adChar, adParamInput, 2, Hex(car.EtcState(11)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE12", adChar, adParamInput, 2, Hex(car.EtcState(12)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE13", adChar, adParamInput, 2, Hex(car.EtcState(13)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE14", adChar, adParamInput, 2, Hex(car.EtcState(14)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE15", adChar, adParamInput, 2, Hex(car.EtcState(15)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATE16", adChar, adParamInput, 2, Hex(car.EtcState(16)))
    If comm.TestIn = 1 Then     ' Test DB 입력
        adoCmd.Parameters.Append adoCmd.CreateParameter("V_FLAG", adVarChar, adParamInput, 1, "Y")
    End If
    
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    Set adoCmd = Nothing
    
    Trbs_Insert = OK_SUCCESS
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    
    Trbs_Insert = ERR_REM_TRBS_FAIL
End Function

' 고장 Log 입력
Private Function Trbl_Insert(ByVal rcvId As String, ByVal maintNo As String, ByVal code As String, ByVal status As String, ByVal occurTime As Date) As String
    Dim adoCmd As ADODB.Command
    
    On Error GoTo ErrTrap
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_trbl_insert1"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RCV_ID", adChar, adParamInput, 13, rcvId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MAINTNO", adChar, adParamInput, 15, maintNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CODE", adChar, adParamInput, 2, Format(code, "0#"))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATUS", adChar, adParamInput, 1, status)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_OCCUR", adVarChar, adParamInput, 30, Format(occurTime, "YYYY-MM-DD h:m:s"))
    If comm.TestIn = 1 Then     ' Test DB 입력
        adoCmd.Parameters.Append adoCmd.CreateParameter("V_FLAG", adVarChar, adParamInput, 1, "Y")
    End If
    
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    Set adoCmd = Nothing
    
    Trbl_Insert = OK_SUCCESS
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    
    Trbl_Insert = ERR_REM_TRBl_FAIL
End Function

' 고장 History 입력
Private Function Trbh_Insert(ByVal rcvId As String, ByRef hist As THistInfo) As String
    Dim adoCmd As ADODB.Command
    
    On Error GoTo ErrTrap
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_trbh_insert1"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RCV_ID", adChar, adParamInput, 13, rcvId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MODE", adChar, adParamInput, 2, hexFormat(hist.ErrMode))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CODENO", adChar, adParamInput, 2, hexFormat(hist.ErrCode))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATUS0", adChar, adParamInput, 2, hexFormat(hist.Status0))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATUS1", adChar, adParamInput, 2, hexFormat(hist.Status1))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATUS2", adChar, adParamInput, 2, hexFormat(hist.Status2))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_OCCUR", adVarChar, adParamInput, 30, Format(hist.occurTime, "YYYY-MM-DD h:m:s"))
    If comm.TestIn = 1 Then     ' Test DB 입력
        adoCmd.Parameters.Append adoCmd.CreateParameter("V_FLAG", adVarChar, adParamInput, 1, "Y")
    End If
    
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    Set adoCmd = Nothing
    
    Trbh_Insert = OK_SUCCESS
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    
    Trbh_Insert = ERR_REM_TRBH_FAIL
End Function

' V 파일 입력
Public Function InsertVFile() As Integer
    Dim adoCmd As ADODB.Command
    Dim adoErr As Object
    
    On Error GoTo ErrTrap
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_das_information_update"
    adoCmd.CommandType = adCmdStoredProc
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DAS_ID", adChar, adParamInput, 9, vFile.dasId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RY_CODE", adUnsignedSmallInt, adParamInput, 2, vFile.Dip_sw)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MAX_CAR", adUnsignedSmallInt, adParamInput, 2, vFile.MaxCar)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_BOOT_COUNT", adUnsignedInt, adParamInput, 4, vFile.Boot_Count)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_NORMAL_BOOT", adUnsignedInt, adParamInput, 4, vFile.Normal_BCount)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_BLOCK_MODEM", adUnsignedSmallInt, adParamInput, 2, vFile.Modem_Use)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RESET_TIME", adUnsignedInt, adParamInput, 4, vFile.ETime_Boot)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COLD_TIME", adUnsignedInt, adParamInput, 4, vFile.ETime_ColdBoot)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_POWER_OFF", adUnsignedSmallInt, adParamInput, 2, vFile.Power_State)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_LOCAL_DDD", adVarChar, adParamInput, 8, Trim(vFile.Tel_LocNo))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_HOST_DDD", adVarChar, adParamInput, 8, Trim(vFile.Host_LocNo))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MODEM_COMM", adUnsignedInt, adParamInput, 4, vFile.Comm_Count)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MODEM_SUCC", adUnsignedInt, adParamInput, 4, vFile.Comm_SCount)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DAS_MODE", adChar, adParamInput, 10, Trim(vFile.Das_Mode))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DAS_VERSION", adChar, adParamInput, 32, Trim(vFile.Das_Version))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_SPEC_HOUR", adUnsignedTinyInt, adParamInput, 1, vFile.Spec_Hour)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_SPEC_DAY", adUnsignedTinyInt, adParamInput, 1, vFile.Spec_Day)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_SPEC_MONTH", adUnsignedTinyInt, adParamInput, 1, vFile.Spec_Month)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_SPEC_YEAR", adUnsignedTinyInt, adParamInput, 1, vFile.Spec_Year)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DIP_SW1", adUnsignedTinyInt, adParamInput, 1, vFile.Dip_sw1)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DIP_SW2", adUnsignedTinyInt, adParamInput, 1, vFile.Dip_sw2)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_DIP_SW3", adUnsignedTinyInt, adParamInput, 1, vFile.Dip_sw3)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RTC_YEAR", adUnsignedSmallInt, adParamInput, 2, vFile.Rtc_Year)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RTC_MONTH", adUnsignedTinyInt, adParamInput, 1, vFile.Rtc_Month)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RTC_DAY", adUnsignedTinyInt, adParamInput, 1, vFile.Rtc_Day)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RTC_HOUR", adUnsignedTinyInt, adParamInput, 1, vFile.Rtc_Hour)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RTC_MIN", adUnsignedTinyInt, adParamInput, 1, vFile.Rtc_Min)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RTC_SEC", adUnsignedTinyInt, adParamInput, 1, vFile.Rtc_Sec)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID1", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(1))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID2", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(2))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID3", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(3))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID4", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(4))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID5", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(5))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID6", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(6))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID7", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(7))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_GA_ID8", adUnsignedSmallInt, adParamInput, 2, vFile.Ga_Id(8))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR1", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(1))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR2", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(2))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR3", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(3))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR4", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(4))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR5", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(5))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR6", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(6))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR7", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(7))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_COM_ERR8", adUnsignedSmallInt, adParamInput, 2, vFile.Comm_State(8))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW1", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(1))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW2", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(2))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW3", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(3))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW4", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(4))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW5", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(5))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW6", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(6))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW7", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(7))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_FIX_SW8", adUnsignedSmallInt, adParamInput, 2, vFile.Maint_State(8))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL1", adVarChar, adParamInput, 16, Trim(vFile.Telephone(1)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL2", adVarChar, adParamInput, 16, Trim(vFile.Telephone(2)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL3", adVarChar, adParamInput, 16, Trim(vFile.Telephone(3)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL4", adVarChar, adParamInput, 16, Trim(vFile.Telephone(4)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL5", adVarChar, adParamInput, 16, Trim(vFile.Telephone(5)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL6", adVarChar, adParamInput, 16, Trim(vFile.Telephone(6)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL7", adVarChar, adParamInput, 16, Trim(vFile.Telephone(7)))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TEL8", adVarChar, adParamInput, 16, Trim(vFile.Telephone(8)))
    
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    Set adoCmd = Nothing
    
    InsertVFile = OK_SUCCESS
    
    MDI.lstFile.AddItem "Data was inserted in the database."
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    
    InsertVFile = ERR_REM_VFILE_FAIL
    If connREM.Errors.Count > 0 Then
        For Each adoErr In connREM.Errors
            MsgBox "Error No: " & adoErr.Number & vbCr & adoErr.Description
        Next adoErr
    End If
End Function

' 고장 Log 입력
Private Function Trbl_Ver49_Insert(ByVal rcvId As String, ByVal maintNo As String, ByVal code As String, ByVal status As String, ByVal occurTime As Date) As String
    Dim adoCmd As ADODB.Command
    
    On Error GoTo ErrTrap
    
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_trbl_ver49_insert1"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_RCV_ID", adChar, adParamInput, 13, rcvId)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MAINTNO", adChar, adParamInput, 15, maintNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_CODE", adChar, adParamInput, 2, Format(code, "0#"))
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_STATUS", adChar, adParamInput, 1, status)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_OCCUR", adVarChar, adParamInput, 30, Format(occurTime, "YYYY-MM-DD h:m:s"))
    If comm.TestIn = 1 Then     ' Test DB 입력
        adoCmd.Parameters.Append adoCmd.CreateParameter("V_FLAG", adVarChar, adParamInput, 1, "Y")
    End If
    
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    Set adoCmd = Nothing
    
    Trbl_Ver49_Insert = OK_SUCCESS
    
    Exit Function

ErrTrap:
    If Not adoCmd Is Nothing Then Set adoCmd = Nothing
    
    Trbl_Ver49_Insert = ERR_REM_TRBl_FAIL
End Function
' Delay Table의 아이디와 고장 코드로 DB를 뒤져서 Delay 스트링을 만듬
Public Function GetDelayStr(ByVal DelayIdLow As Byte, ByVal DelayIdHigh As Byte, ByVal CodeNo As Integer) As String
    Dim adoRs As ADODB.Recordset
    Dim DelayTableId%
    Dim SQL As String
    Dim byteBuf() As Byte

    On Error GoTo ErrTrap
    
    DelayTableId = DelayIdLow + DelayIdHigh * 256
    SQL = "SELECT * from rom_delay where ROM_TCD_RANK_NO=" & Str(DelayTableId)
    Set adoRs = New ADODB.Recordset
    adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
    ReDim byteBuf(256)   ' Delay Table 은 256byte
    
    If adoRs.EOF Then
        GetDelayStr = "Delay Table 없음"
    Else
        byteBuf = adoRs!ROM_TCD_DELAY
        GetDelayStr = "(" + Str(byteBuf(CodeNo)) + "초 지속)" ' 1부터 시작하니 1을 추가한다.
    End If
    
    adoRs.Close
    Set adoRs = Nothing
    
    Exit Function
ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    GetDelayStr = "Delay 획득 Error"
End Function
'ESMI가 생성하는 MTC 고장내용을 DB에서 가져온다.
Public Function GetMtc(ByVal MtcIdLow As Byte, ByVal MtcIdHigh As Byte, ByVal CodeNo As Integer) As String
    Dim adoRs As ADODB.Recordset
    Dim MtcId%
    Dim SQL As String

    On Error GoTo ErrTrap
    
    MtcId = MtcIdLow + MtcIdHigh * 256
    SQL = "SELECT * from rom_logic_mtc where MTC_SERIAL_NO=" & Str(MtcId) & " and TCD=0x" & Hex(CodeNo)
    Set adoRs = New ADODB.Recordset
    adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
    
    If adoRs.EOF Then
        GetMtc = "MTC Table 없음"
    Else
        GetMtc = adoRs!mtc_description
    End If
    
    adoRs.Close
    Set adoRs = Nothing
    
    Exit Function
ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    GetMtc = "MTC 설명 획득 Error"
End Function

'ESMI가 생성하는 MTC 고장내용을 DB에서 가져온다.
Public Function GetCtc(ByVal CtcIdLow As Byte, ByVal CtcIdHigh As Byte, ByVal CodeNo As Integer) As String
    Dim adoRs As ADODB.Recordset
    Dim CtcId%
    Dim SQL As String

    On Error GoTo ErrTrap
    
    CtcId = CtcIdLow + CtcIdHigh * 256
    SQL = "SELECT * from rom_logic_ctc where CTC_SERIAL_NO=" & Str(CtcId) & " and TCD=0x" & Hex(CodeNo)
    Set adoRs = New ADODB.Recordset
    adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
    
    If adoRs.EOF Then
        GetCtc = "CTC Table 없음"
    Else
        GetCtc = adoRs!ctc_description
    End If
    
    adoRs.Close
    Set adoRs = Nothing
    
    Exit Function
ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    GetCtc = "CTC 설명 획득 Error"
End Function

' 각 호기의 고장코드들 중에서 정보센터에 접수할 고장이 있는지를 검사
' 파라미터 - DAS_ID, 한 호기의 정보, 고장코드 Index
' Return value - 존재하면 TRUE
' 중요) 만약 존재하면 carTrb.MaintNo, carTrb.Content를 갱신한다.
' 우선순위가 있는 것으로 바뀜
Private Function NewExistSICTrb(ByVal dasId As String, ByRef trbCar As TCarInfo, ByVal code As String) As Boolean
    Dim adoRs As ADODB.Recordset
    Dim carId As String * 2
    Dim isFlag As Boolean
    Dim SQL As String
    On Error GoTo ErrTrap
    
    isFlag = False
    carId = Format(Str(trbCar.carId), "0#")
    
    SQL = "SELECT top 1 e.maint_no maint_no, t.code_no , t.content tcd_content " & _
          "FROM elevator e, model_config m, tcd_config t " & _
          "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
          "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and " & _
          "t.esmi1_flag = 's' and "
    SQL = SQL & code & " ORDER BY priority asc"
    WriteUDPLog "NewExistSICTrb(query)", SQL
    Set adoRs = New ADODB.Recordset
    adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
    If adoRs.EOF Then
        WriteUDPLog "NewExistSICTrb", "Match하는 DASID,CARNO,고장내용이 없읍니다."
    End If
    
    'ESMI1_Flag 이 세트되어있는 고장 내용을 구했으면
    Do While Not adoRs.EOF
        trbCar.maintNo = adoRs!maint_no
        trbCar.Content = adoRs!tcd_content
        
        isFlag = True
        adoRs.MoveNext
    Loop
    
    adoRs.Close
    Set adoRs = Nothing
    
    If isFlag = False Then '보고할 고장이 없으면 그냥 TCD 코드의 설명만 받아서 저장
        SQL = "SELECT top 1 e.maint_no maint_no, t.code_no, t.content tcd_content " & _
              "FROM elevator e, model_config m, tcd_config t " & _
              "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
              "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and "
        SQL = SQL & code & " ORDER BY priority asc"
        WriteUDPLog "NewExistSICTrb(query)", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb", "Match하는 DASID,CARNO,고장내용이 없읍니다."
        End If
        
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!tcd_content
            adoRs.MoveNext
        Loop
        
        adoRs.Close
        Set adoRs = Nothing
    End If
    NewExistSICTrb = isFlag
    
    Exit Function

ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    
    NewExistSICTrb = False
End Function

Private Function NewExistSICTrb69(ByVal dasId As String, ByRef trbCar As TCarInfo) As Boolean
    Dim adoRs As ADODB.Recordset
    Dim carId As String * 2
    Dim isFlag As Boolean
    Dim isMtcFlag As Boolean
    Dim isCtcFlag As Boolean
    Dim SQL As String
    Dim strCode As String
    Dim strMtc As String
    Dim strCtc$
    Dim CodeNo%
    Dim MtcSerial%
    Dim CtcSerial%
    Dim Index As Byte   ' 고장 Index
    On Error GoTo ErrTrap
    
    isFlag = False
    isMtcFlag = False
    isCtcFlag = False
    carId = Format(Str(trbCar.carId), "0#")
    strCode = ""
    strMtc = ""
    strCtc = ""
    For Index = 1 To trbCar.NewCodeNo
        Select Case trbCar.NewCodes(Index)
        Case 1 To &HEF '제어반 고장이면
            If Len(strCode) = 0 Then ' 첫번째 고장이면
                strCode = "(" & "t.code_no = '" & hexFormat(trbCar.NewCodes(Index)) & "' "
            Else
                strCode = " or t.code_no = '" & hexFormat(trbCar.NewCodes(Index)) & "' "
            End If
        Case &HF6 To &HFD
            If Len(strMtc) = 0 Then ' Mtc고장이 하나도 이전에 없으면
                strMtc = "(" & "t.tcd = 0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            Else
                strMtc = " or t.tcd=0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            End If
        Case &HF3 To &HF5
            If Len(strCtc) = 0 Then 'CTC 고장이 하나도 이전에 없으면
                strCtc = "(" & "t.tcd = 0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            Else
                strCtc = " or t.tcd=0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            End If
        End Select
    Next Index
    strCode = strCode & ")"
    strMtc = strMtc & ")"
    strCtc = strCtc & ")"
    
    If Len(strCode) > 3 Then ' 제어반 고장이 없다면 ")" 만 나타날것.
        SQL = "SELECT top 1 e.maint_no maint_no, t.code_no , t.content tcd_content " & _
              "FROM elevator e, model_config m, tcd_config t " & _
              "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
              "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and " & _
              "t.esmi1_flag = 's' and "
        SQL = SQL & strCode & " ORDER BY priority asc"
        
        WriteUDPLog "NewExistSICTrb69(query) 제어반 고장확인", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb69", "Match하는 DASID,CARNO,고장내용이 없읍니다."
        End If
        
        
        'ESMI1_Flag 이 세트되어있는 고장 내용을 구했으면
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!tcd_content
            CodeNo = Val("&H" + adoRs!code_no)
            isFlag = True
            adoRs.MoveNext
        Loop
        adoRs.Close
        Set adoRs = Nothing
        
        If isFlag = False Then '보고할 고장이 없으면 그냥 TCD 코드의 설명만 받아서 저장
            SQL = "SELECT top 1 e.maint_no maint_no, t.code_no, t.content tcd_content " & _
                  "FROM elevator e, model_config m, tcd_config t " & _
                  "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
                  "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and "
            SQL = SQL & strCode & " ORDER BY priority asc"
            WriteUDPLog "NewExistSICTrb(query)", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb", "Match하는 DASID,CARNO,고장내용이 없읍니다."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = adoRs!tcd_content
                CodeNo = Val("&H" + adoRs!code_no)
                adoRs.MoveNext
            Loop
            
            adoRs.Close
            Set adoRs = Nothing
        End If
        trbCar.Content = trbCar.Content & GetDelayStr(trbCar.EtcState(3), trbCar.EtcState(4), CodeNo)
    End If  ' 제어반 고장이 있는 경우
        
    If isFlag = False And Len(strMtc) > 3 Then '제어반에 보고할 고장은 없으나 MTC 고장은 있는 경우
        MtcSerial = trbCar.EtcState(5) + trbCar.EtcState(6) * 256
        SQL = " SELECT top 1 t.tcd , t.mtc_description, e.maint_no  From rom_logic_mtc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' and t.esmi1_flag='s' " & _
              " and t.MTC_SERIAL_NO=" & Str(MtcSerial) & _
              " and " & strMtc & " order by priority asc"
        
        WriteUDPLog "NewExistSICTrb69(query) MTC 고장확인 ", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb69", "MTC Match하는 DASID,CARNO,고장내용이 없읍니다."
        End If
        
        
        'ESMI1_Flag 이 세트되어있는 고장 내용을 구했으면
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!mtc_description
            isMtcFlag = True
            adoRs.MoveNext
        Loop
        adoRs.Close
        Set adoRs = Nothing
        
        If isMtcFlag = False And Len(strCode) < 3 Then '보고할 고장이 없고 제어반 고장도 없으면 MTC 고장코드의 설명만 받아서 저장
        SQL = " SELECT top 1 t.tcd , t.mtc_description, e.maint_no  From rom_logic_mtc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' " & _
              " and t.MTC_SERIAL_NO=" & Str(MtcSerial) & _
              " and " & strMtc & " order by priority asc"
            WriteUDPLog "NewExistSICTrb(query)", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb69 ", "MTC Match하는 DASID,CARNO,고장내용이 없읍니다."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = adoRs!mtc_description
                adoRs.MoveNext
            Loop
            adoRs.Close
            Set adoRs = Nothing
        End If
    End If  ' 제어반 고장이 없고 MTC 고장이 있는 경우
    
    If isFlag = False And isMtcFlag = False And Len(strCtc) > 3 Then '제어반에 보고할 고장도 없고 MTC에 보고할 고장도 없으나 CTC 고장은 있는 경우
        CtcSerial = trbCar.EtcState(7) + trbCar.EtcState(8) * 256
        SQL = " SELECT top 1 t.tcd , t.ctc_description, e.maint_no  From rom_logic_ctc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' and t.esmi1_flag='s' " & _
              " and t.CTC_SERIAL_NO=" & Str(CtcSerial) & _
              " and " & strCtc & " order by priority asc"
        
        WriteUDPLog "NewExistSICTrb69(query) CTC 고장확인 ", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb69", "CTC Match하는 DASID,CARNO,고장내용이 없읍니다."
        End If
        
        
        'ESMI1_Flag 이 세트되어있는 고장 내용을 구했으면
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!ctc_description
            isCtcFlag = True
            adoRs.MoveNext
        Loop
        adoRs.Close
        Set adoRs = Nothing
        
        If isCtcFlag = False And Len(strCode) < 3 And Len(strMtc) < 3 Then '보고할 고장이 없고 제어반 고장도 없고 MTC 고장도 없으면 CTC 설명만 받아서 저장
        SQL = " SELECT top 1 t.tcd , t.ctc_description, e.maint_no  From rom_logic_ctc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' " & _
              " and t.CTC_SERIAL_NO=" & Str(CtcSerial) & _
              " and " & strCtc & " order by priority asc"
            WriteUDPLog "NewExistSICTrb(query)69", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb69 ", "CTC Match하는 DASID,CARNO,고장내용이 없읍니다."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = adoRs!ctc_description
                adoRs.MoveNext
            Loop
            adoRs.Close
            Set adoRs = Nothing
        End If
    End If  ' 제어반 고장이 없고 MTC 고장이 있는 경우
        
    If Len(strCode) < 3 And Len(strMtc) < 3 And Len(strCtc) < 3 Then '제어반고장도 없고 MTC 고장도 없고 CTC 고장도 없으면
        SQL = "SELECT top 1 maint_no from elevator WHERE das='" & dasId & "' and car_no='" & carId & "'"
        WriteUDPLog "NewExistSICTrb(query)69", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb69 ", "CTC Match하는 DASID,CARNO,고장내용이 없읍니다."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = "유효한 고장코드가 아닙니다."
                adoRs.MoveNext
            Loop
            adoRs.Close
            Set adoRs = Nothing
    End If
    
    If isFlag = True Or isMtcFlag = True Or isCtcFlag = True Then
        NewExistSICTrb69 = True
    Else
        NewExistSICTrb69 = False
    End If
    Exit Function

ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    
    NewExistSICTrb69 = False
End Function




' 정보센터 연결
Public Function ConnectSIC() As Integer
    Dim pSVR As String
    Dim pUID As String
    Dim pConnString As String
    
    On Error GoTo ErrTrap

    If MDI.sbrStatus.Panels(3).Text <> Empty Then
        If connSIC.State = adStateOpen Then connSIC.Close
    End If
    
    If xSicPWD = "" Then
        xSicPWD = "svc2001"
    End If
    currDatabase = "SIC"
    pSVR = GetSetting("Commd", "Connection", "SIC_SVR", "otkrseccc01")
    pUID = GetSetting("Commd", "Connection", "SIC_UID", "svc2001")
    'pConnString = "DSN=" & pDSN & ";UID=" & pUID & ";PWD=" & xSicPWD    ODBC 방식
    'SQL Server 2000은 driver={SQL SERVER} 를 안해 줘도 되던데 나중에 문제 생기면 고칠것
    'pConnString = "Provider=SQLOLEDB;Server=" & pSVR & ",4004;User ID=" & pUID & ";" & _
     '     ";Password=svc2001;Initial Catalog=GISSSKA0;"
     pConnString = "driver={SQL SERVER};server=" & pSVR & ",4004;uid=" & pUID & ";" & _
            "pwd=svc2001;database=GISSSKA0;"
    Set connSIC = New ADODB.Connection
    connSIC.Open pConnString
    MDI.sbrStatus.Panels(3).Text = "SIC Connected."
    MDI.Toolbar1.Buttons(1).Enabled = False
    MDI.mnuConnSIC.Enabled = False
    
    ConnectSIC = True
    Exit Function

ErrTrap:
    ConnectSIC = ERR_SIC_CONNECT
End Function
' 정보센터 해제
Public Sub DisconnectSIC()
    On Err GoTo ErrTrap
    
    If MDI.sbrStatus.Panels(3).Text <> Empty Then
        If connSIC.State = adStateOpen Then connSIC.Close
        If Not connSIC Is Nothing Then Set connSIC = Nothing
        MDI.sbrStatus.Panels(3).Text = ""
        MDI.Toolbar1.Buttons(1).Enabled = True
        MDI.mnuConnSIC.Enabled = True
    End If
    
    Exit Sub

ErrTrap:
End Sub

' 원격감시 연결
Public Function ConnectREM() As Integer
    Dim pSVR As String
    Dim pUID As String
    Dim pConnString As String
    
    On Error GoTo ErrTrap

    If MDI.sbrStatus.Panels(2).Text <> Empty Then
        If connREM.State = adStateOpen Then connREM.Close
    End If
    
    If xRemPWD = "" Then
        xRemPWD = "rem2001"
    End If
    currDatabase = "REM"
    pSVR = GetSetting("Commd", "Connection", "REM_SVR", "otkrserem01")
    pUID = GetSetting("Commd", "Connection", "REM_UID", "rem2001")
    pConnString = "driver={SQL SERVER};Server=" & pSVR & ";uid=" & pUID & ";" & _
          ";pwd=rem2001;database=elrms;"
    
    Set connREM = New ADODB.Connection
    connREM.Open pConnString
    MDI.sbrStatus.Panels(2).Text = "REM Connected."
    MDI.Toolbar1.Buttons(1).Enabled = False
    MDI.mnuConnGEMIS.Enabled = False
    
    ConnectREM = True
    Exit Function

ErrTrap:
    ConnectREM = ERR_REM_CONNECT
End Function
' 원격감시 해제
Public Sub DisconnectREM()
    On Err GoTo ErrTrap
    
    If MDI.sbrStatus.Panels(2).Text <> Empty Then
        If connREM.State = adStateOpen Then connREM.Close
        If Not connREM Is Nothing Then Set connREM = Nothing
        MDI.sbrStatus.Panels(2).Text = ""
        MDI.Toolbar1.Buttons(1).Enabled = True
        MDI.mnuConnGEMIS.Enabled = True
    End If
    
    Exit Sub

ErrTrap:
End Sub

