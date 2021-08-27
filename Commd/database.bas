Attribute VB_Name = "basDatabase"
Option Explicit

Public currDatabase As String           ' ���� �����ϰ� ���� Database
Public xSicPWD As String                   ' SIC password
Public xRemPWD As String                ' REM password
Public connREM As ADODB.Connection      ' ���ݰ��� Database
Public connSIC As ADODB.Connection      ' �������� Database

Public Function DBInsert49(trb As TTrbInfo) As Integer
    Dim car As Byte     ' car Index
    Dim Index As Byte   ' ���� Index
    Dim code As Byte    ' �ű� �����ڵ�
    Dim isFlag As Boolean   ' �������Ϳ� ����� ������ �����ϴ��� ���
    Dim Result As Integer   ' �Լ� ���� ���
    Dim FResult As Integer  ' �� �Լ������� ���Ǵ� ���� ���
    Dim strCode As String   ' �����ڵ� ��ŭ SQL���� ����
    
    On Err GoTo ErrTrap
    
    Result = ConnectREM
    If Result <> True Then      ' REM ���� ����
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
            For Index = 1 To trb.CarInfo(car).CurrErrNo     ' �������� ����
                If Index <> trb.CarInfo(car).CurrErrNo Then
                    strCode = strCode & "t.code_no = '" & hexFormat(trb.CarInfo(car).CurrError(Index)) & "' or "
                Else
                    strCode = strCode & "t.code_no = '" & hexFormat(trb.CarInfo(car).CurrError(Index)) & "')"
                End If
            Next Index
        End If
        
        If strCode <> "" Then
            If NewExistSICTrb(trb.dasId, trb.CarInfo(car), strCode) = True Then  ' �������� ���� ���� ����
                trb.CarInfo(car).SICCheck = True
                trb.CarInfo(car).SICErrNo = 1
                trb.CarInfo(car).SICError(1) = trb.CarInfo(car).CurrError(Index)
                If frmConfig.chkSICInsert.Value <> 1 Then   ' check�Ǹ� �������Ϳ� ���� ����
                    Result = InsertSICTrb(trb.CarInfo(car))
                End If
            End If
        End If
        If Result <> OK_SUCCESS Then FResult = Result
                
        trb.CarInfo(car).maintNo = GetElevator(trb.dasId, Format(trb.CarInfo(car).carId, "0#"))
        If trb.CarInfo(car).maintNo <> "" Then
            Result = InsertREMTrb(trb.CarInfo(car), trb.fileName, trb.ver)         ' ���ݰ��� ����
        Else
            
            Result = ERR_REM_NO_MAINT_FAIL
        End If
        If Result <> OK_SUCCESS Then FResult = Result
    Next car
    
    Call DisconnectREM      ' REM ���� ���� ����
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
'Ver 59 ������ �α� ������ ���Ͽ� ������ �����´�.
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim adoErr As Object
    Dim SQL As String
    Dim strCustomer As String            ' �Ű��� ��ȭ��ȣ
    Dim strTeam As String           ' �ҼӺμ�
    Dim strCenter As String         ' ������Ÿ
    Dim strTime As String           ' �����ð�
    Dim Result As Integer           ' SQL ������
    Dim strModelType As String * 1  ' TCD Type = H�� ���� DI, SIGM�� ������ �� ����
    On Error GoTo ErrTrap
    
    Result = ConnectSIC
    If Result <> True Then      ' SIC ���� ����
        WriteUDPLog "SIC Connection", "error"
        Exit Function
    End If
    

    ' ����� ȣ���̸��� �����´�.
    SQL = "select t6.ka6_compname,t5.ka5_itemno from tka50 t5,tka60 t6 where t5.ka5_mainno='" + trb.maintNo + "' and t5.ka5_new_mainno=t6.ka6_new_mainno"
    
    WriteUDPLog "GetCustomer", "������->" + SQL
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
' ���� ���� ���õ� ������ �����´�.
Public Function GetDoorTrb(code As Byte) As String
    Select Case code
        Case 97
            GetDoorTrb = "ERR_CDS    Car Door ����ġ ���� �̻�"
        Case 98
            GetDoorTrb = "ERR_R2LD     Landing Door ����ġ ���� �̻�"
        Case 132
            GetDoorTrb = "ERR_OPEN_LOCK     Door Open Lock ����"
        Case 133
            GetDoorTrb = "ERR_OPEN_LOCK_3     Open Lock �ݺ� ����"
        Case 134
            GetDoorTrb = "ERR_CLOSE_LOCK    Door Close Lock ����"
        Case 135
            GetDoorTrb = "ERR_CLOSE_LOCK_1M     Close Lock �ݺ� ����"
        Case 139
            GetDoorTrb = "ERR_NUDGING    Nudging ����"
        Case 145
            GetDoorTrb = "ERR_INV_DM    Inv Door ���� �̻�"
        Case 191
            GetDoorTrb = "ERR_DOOR_COMMAND    Door �����̻�"
        Case 192
            GetDoorTrb = "ERR_DOOR_POSI   ��ġ ����� ����"
        Case 193
            GetDoorTrb = "ERR_DOOR_VOLTAGE   ��/������ ����"
        Case 194
            GetDoorTrb = "ERR_DOOR_MOTOR_THERMAL   Motor ���� Error"
        Case 195
            GetDoorTrb = "ERR_DOOR_IPM    ������ ����"
    
        Case 223
            GetDoorTrb = "OLS Off ����    OLS Off �Ұ�"
        Case 224
            GetDoorTrb = "OLS On ����     OLS On �Ұ�"
        Case 225
            GetDoorTrb = "CDS Off ����    CDS Off �Ұ�"
        Case 226
            GetDoorTrb = "CDS On ����     CDS On �Ұ�"
        Case 227
            GetDoorTrb = "CLS Off ����    CLS Off �Ұ�"
        Case 228
            GetDoorTrb = "CLS On ����     CLS On �Ұ�"
        Case 229
            GetDoorTrb = "LDS Off ����    LDS Off �Ұ�"
        Case 230
            GetDoorTrb = "LDS On ����     LDS On �Ұ�"
        Case 231
            GetDoorTrb = "SES Off ����    SES Off �Ұ�"
        Case 232
            GetDoorTrb = "PSES Off ����   PSES Off �Ұ�"
        Case 233
            GetDoorTrb = "Encoder Error   DERR: 001"
        Case 234
            GetDoorTrb = "DLD(Door Load Detect) Error DERR: 010"
        Case 235
            GetDoorTrb = "Motor Thermal Error DERR: 011"
        Case 236
            GetDoorTrb = "Not Used    DERR: 100"
        Case 237
            GetDoorTrb = "Lower Voltage (������)  DERR: 101"
        Case 238
            GetDoorTrb = "Command Error (Open, Close ��������)    DERR: 110"
        Case 239
            GetDoorTrb = "Over Current (������)   DERR: 111"
        End Select
End Function
' Ver 59�� ������ �������Ϳ� ���ݰ��� DB�� ���
' �Ķ���� - Decoding�� ����
' Return value - ó�� ���
Public Function DBInsert59(trb As TTrbInfo) As Integer
    Dim car As Byte     ' car Index
    Dim Index As Byte   ' ���� Index
    Dim Result As Integer   ' �Լ� ���� ���
    Dim strCode As String   ' �����ڵ� ��ŭ SQL���� ����
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
        '�� Car ���� ���� �̷��� ���Ͽ� ������ �����´�.
        
            For Index = 1 To trb.CarInfo(car).NewCodeNo     ' �������� ����
                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "donghok@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "����� ����"
                    olMail.Body = "B�� ���� �׽�Ʈ�� �Ϸ翡 �ѹ��� ����"
                Else
                    olMail.Subject = Str(car) + "ȣ�� ����"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing
                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "srjeong@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "����� ����"
                    olMail.Body = "B�� ���� �׽�Ʈ�� �Ϸ翡 �ѹ��� ����"
                Else
                    olMail.Subject = Str(car) + "ȣ�� ����"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing

                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "hjseo@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "����� ����"
                    olMail.Body = "B�� ���� �׽�Ʈ�� �Ϸ翡 �ѹ��� ����"
                Else
                    olMail.Subject = Str(car) + "ȣ�� ����"
                    olMail.Body = "TCD:" + Str(trb.CarInfo(car).NewCodes(Index)) + " " + GetDoorTrb(trb.CarInfo(car).NewCodes(Index))
                End If
                
                olMail.send
                Set olMail = Nothing

                Set olMail = olApp.CreateItem(olMailItem)
                olMail.To = "taewookk@otis.co.kr"
                If trb.CarInfo(car).NewCodes(Index) = 222 Then
                    olMail.Subject = "����� ����"
                    olMail.Body = "B�� ���� �׽�Ʈ�� �Ϸ翡 �ѹ��� ����"
                Else
                    olMail.Subject = Str(car) + "ȣ�� ����"
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

' �� ȣ���� �����ڵ�� �߿��� �������Ϳ� ������ ������ �ִ����� �˻�
' �Ķ���� - DAS_ID, �� ȣ���� ����, �����ڵ� Index
' Return value - �����ϸ� TRUE
' �߿�) ���� �����ϸ� carTrb.MaintNo, carTrb.Content�� �����Ѵ�.
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

' �� ȣ���� �����ڵ�� �߿��� �������Ϳ� ������ ������ �ִ����� �˻�
' �Ķ���� - DAS_ID, �� ȣ���� ����, �����ڵ� Index
' Return value - �����ϸ� TRUE
' �߿�) ���� �����ϸ� carTrb.MaintNo, carTrb.Content�� �����Ѵ�.
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
'��ó���� ���� GEMIS DB�� ����
Public Function InsertRetry(trb As TCarInfo) As Integer
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim adoErr As Object
    Dim SQL As String
    Dim sp_text$                      ' insert_sic_error sp�� Text�� ����
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

' �������� ���� ����
' �������� DB Connect
' 0) �������Ϳ� �Է��� TCD�� ������ ����. H Type = DI, SIGM ������ ������ ��� ����
' 1) �������� �������� ����,
' 2) ��������,
' 3) T_TROUBLE�� ������ ������ȣ Ȯ��,
' 4) ESMI_DAT..T_TROUBLE ����
' �������� DB Disconnect

Public Function InsertSICTrb(trb As TCarInfo) As Integer
    Dim adoCmd As ADODB.Command
    Dim adoRs As ADODB.Recordset
    Dim adoErr As Object
    Dim SQL As String
    Dim strTel As String            ' �Ű��� ��ȭ��ȣ
    Dim strTeam As String           ' �ҼӺμ�
    Dim strCenter As String         ' ������Ÿ
    Dim strTime As String           ' �����ð�
    Dim Result As Integer           ' SQL ������
    Dim strModelType As String * 1  ' TCD Type = H�� ���� DI, SIGM�� ������ �� ����
    On Error GoTo ErrTrap
    
    Result = ConnectSIC
    If Result <> True Then      ' SIC ���� ����
        WriteUDPLog "SIC Connection", "error"
        InsertSICTrb = Result
        Exit Function
    End If
    
    ' 0) �������Ϳ� �Է��� TCD�� ������ ����. H Type = DI, SIGM ������ ������ ��� ����
    Set adoCmd = New ADODB.Command
    
    adoCmd.CommandText = "up_get_tcd_type"
    adoCmd.CommandType = adCmdStoredProc
    
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_MAINT_NO", adChar, adParamInput, 15, trb.maintNo)
    adoCmd.Parameters.Append adoCmd.CreateParameter("V_TCD_TYPE", adChar, adParamOutput, 1, "N")
        
    Set adoCmd.ActiveConnection = connREM
    adoCmd.Execute
    strModelType = adoCmd.Parameters(1).Value
    
    Set adoCmd = Nothing

    ' 1) ���������� ���� ���� ������ ���� - ������ȣ ����
    'strTime = CStr(Now)
    SQL = "SELECT tka60.ka6_center Center, tka60.ka6_telno TelNo, tka60.ka6_chkteam ChkTeam " & _
          "FROM tka50, tka60 " & _
          "WHERE tka50.ka5_custno = tka60.ka6_custno And tka50.ka5_mainno = '" & trb.maintNo & "'"
    
    WriteUDPLog "InsertSICTrb", "��������->" + SQL
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
        WriteUDPLog "InsertSICTrb", "SIC ���� ����"
        InsertSICTrb = ERR_SIC_NOT_EXIST
        Exit Function
    End If
        
    ' 2) ��������
    Set adoCmd = New ADODB.Command
    adoCmd.CommandText = "SP_REC_ISRT_RECEIPT"     ' ���� ����
    adoCmd.CommandType = adCmdStoredProc
    adoCmd.Parameters.Append adoCmd.CreateParameter("TMPRECNO", adChar, adParamInput, 11, "BEA-" & Format(Now, "yymmdd") & "-")     ' ��ǰ �ڵ�
    If comm.TestIn = 1 Then     ' Test DB �Է�
        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, "/����/TEST-" & trb.Content)     ' ���� ����
    Else
        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, trb.Content)     ' ���� ����
    End If
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECCD", adChar, adParamInput, 2, "01")     ' ���� �ڵ�
    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLER", adVarChar, adParamInput, 10, "ESMI")     ' �Ű���
    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLERTELNO", adChar, adParamInput, 12, "")     ' �Ű��� ��ȭ��ȣ
    adoCmd.Parameters.Append adoCmd.CreateParameter("RESTIME", adVarChar, adParamInput, 30, "")     ' ���� �ð�
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECTRACE", adChar, adParamInput, 1, "1")     ' �����ڵ�
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECVER", adChar, adParamInput, 7, "ESMI")     ' ������
    adoCmd.Parameters.Append adoCmd.CreateParameter("ASDIV", adChar, adParamInput, 7, strTeam)     ' �ҼӺμ�
    adoCmd.Parameters.Append adoCmd.CreateParameter("MAINNO", adChar, adParamInput, 15, trb.maintNo)     ' ������ȣ
    adoCmd.Parameters.Append adoCmd.CreateParameter("JPCODE", adChar, adParamInput, 3, "")     ' ��ǰ�����ڵ�
    adoCmd.Parameters.Append adoCmd.CreateParameter("RECTIME", adChar, adParamInput, 30, "")     ' �����ð�
    adoCmd.Parameters.Append adoCmd.CreateParameter("DESC", adChar, adParamInput, 100, "")     ' ����
    adoCmd.Parameters.Append adoCmd.CreateParameter("COMPNAME", adVarChar, adParamInput, 30, "")     ' ����
    adoCmd.Parameters.Append adoCmd.CreateParameter("ITEM", adVarChar, adParamInput, 30, "")     ' ����
    adoCmd.Parameters.Append adoCmd.CreateParameter("BUSEONAME", adVarChar, adParamInput, 20, "")     ' ��ǰ�����ڵ�
    
    
'    adoCmd.CommandText = "sp_KA22_isrt03_1"     ' ���� ����
'    adoCmd.CommandType = adCmdStoredProc
'
'    adoCmd.Parameters.Append adoCmd.CreateParameter("UNITCD", adChar, adParamInput, 1, "E")     ' ��ǰ �ڵ�
'    If comm.TestIn = 1 Then     ' Test DB �Է�
'        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, "/����/TEST-" & trb.Content)     ' ���� ����
'    Else
'        adoCmd.Parameters.Append adoCmd.CreateParameter("RECCONT", adVarChar, adParamInput, 100, trb.Content)     ' ���� ����
'    End If
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RECCD", adChar, adParamInput, 2, "01")     ' ���� �ڵ�
'    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLER", adVarChar, adParamInput, 10, "ESMI")     ' �Ű���
'    adoCmd.Parameters.Append adoCmd.CreateParameter("CALLERTELNO", adChar, adParamInput, 12, strTel)     ' �Ű��� ��ȭ��ȣ
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RESTIME", adVarChar, adParamInput, 30, "")     ' ���� �ð�
'    adoCmd.Parameters.Append adoCmd.CreateParameter("STACD", adChar, adParamInput, 1, "1")     ' �����ڵ�
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RECVER", adChar, adParamInput, 7, "ESMI")     ' ������
'    adoCmd.Parameters.Append adoCmd.CreateParameter("ASDIV", adChar, adParamInput, 7, strTeam)     ' �ҼӺμ�
'    adoCmd.Parameters.Append adoCmd.CreateParameter("MAINNO", adChar, adParamInput, 15, trb.maintNo)     ' ������ȣ
'    adoCmd.Parameters.Append adoCmd.CreateParameter("JPCODE", adChar, adParamInput, 3, "EEL")     ' ��ǰ�����ڵ�
'    adoCmd.Parameters.Append adoCmd.CreateParameter("REGCNTR", adChar, adParamInput, 1, strCenter)     ' ������Ÿ
'    adoCmd.Parameters.Append adoCmd.CreateParameter("RECTIME", adChar, adParamInput, 30, strTime)     ' �����ð�
'    adoCmd.Parameters.Append adoCmd.CreateParameter("DESC", adChar, adParamInput, 100, "")     ' ����

    Set adoCmd.ActiveConnection = connSIC
    Set adoRs = New ADODB.Recordset
    WriteUDPLog "InsertSICTrb", "SP_REC_ISRT_RECEIPT ȣ��"
    Set adoRs = adoCmd.Execute
    WriteUDPLog "InsertSICTrb", "SP ���� ȣ��"
    trb.SICRecNo = "" '�ʱ�ȭ
    
    If Not adoRs.EOF Then
        trb.SICRecNo = adoRs(0)
        WriteUDPLog "ó�� ���", adoRs(3)
        If Not adoRs(3) = "�ű�" Then      ' �����̳� �����̸�
            WriteUDPLog "InsertSICTrb", "������ŸDB�� ESMI ���� �Է¾��ϰ� ����"
            trb.SICRecNo = "����,����"
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

    ' 3) T_TROUBLE�� ������ ������ȣ Ȯ��
    
    ' 4) ESMI_DAT..T_TROUBLE ����
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
    WriteUDPLog "Error", Err.Description + " ->��ó��"
    trb.Comment = trb.Comment + "\n" + "Error" + Err.Description + " ->��ó��"
    
    
    reTrbCar = trb
    InsertSICTrb = ERR_SIC_NOT_EXIST_RECNO
    Exit Function
    
'    If connSIC.Errors.Count > 0 Then
'        For Each adoErr In connSIC.Errors
'            MsgBox "Error No: " & adoErr.Number & vbCr & adoErr.Description
'        Next adoErr
'    End If
    
End Function

' ���ݰ��� DB�� ������ �Է�
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
    
    For Index = 1 To trb.ErrHistNo  ' ����History �Է�
        intResult = Trbh_Insert(trb.REMRecNo, trb.ErrHistory(Index))
        If intResult <> OK_SUCCESS Then
            InsertREMTrb = intResult
            Exit Function
        End If
    Next Index
    
    If ver >= VER_59 Then
        For Index = 1 To trb.NewCodeNo  ' �ű԰����Է�
            intResult = Trbl_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.NewCodes(Index)), "N", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
        For Index = 1 To trb.RcvCodeNo  ' ���������Է�
            intResult = Trbl_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.RcvCodes(Index)), "R", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
        For Index = 1 To trb.HoldCodeNo  ' ���������Է�
            intResult = Trbl_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.HoldCodes(Index)), "H", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
    ElseIf ver = VER_49 Then
        For Index = 1 To trb.CurrErrNo  ' �ű԰����Է�
            intResult = Trbl_Ver49_Insert(trb.REMRecNo, trb.maintNo, Hex(trb.CurrError(Index)), " ", trb.FinalTime)
            If intResult <> OK_SUCCESS Then
                InsertREMTrb = intResult
                Exit Function
            End If
        Next Index
    End If
       
    InsertREMTrb = OK_SUCCESS
End Function

' ���� Log �Է�
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

' �������� �Է�
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
    If comm.TestIn = 1 Then     ' Test DB �Է�
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

' ������� �Է�
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
    If comm.TestIn = 1 Then     ' Test DB �Է�
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

' ���� Log �Է�
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
    If comm.TestIn = 1 Then     ' Test DB �Է�
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

' ���� History �Է�
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
    If comm.TestIn = 1 Then     ' Test DB �Է�
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

' V ���� �Է�
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

' ���� Log �Է�
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
    If comm.TestIn = 1 Then     ' Test DB �Է�
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
' Delay Table�� ���̵�� ���� �ڵ�� DB�� ������ Delay ��Ʈ���� ����
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
    ReDim byteBuf(256)   ' Delay Table �� 256byte
    
    If adoRs.EOF Then
        GetDelayStr = "Delay Table ����"
    Else
        byteBuf = adoRs!ROM_TCD_DELAY
        GetDelayStr = "(" + Str(byteBuf(CodeNo)) + "�� ����)" ' 1���� �����ϴ� 1�� �߰��Ѵ�.
    End If
    
    adoRs.Close
    Set adoRs = Nothing
    
    Exit Function
ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    GetDelayStr = "Delay ȹ�� Error"
End Function
'ESMI�� �����ϴ� MTC ���峻���� DB���� �����´�.
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
        GetMtc = "MTC Table ����"
    Else
        GetMtc = adoRs!mtc_description
    End If
    
    adoRs.Close
    Set adoRs = Nothing
    
    Exit Function
ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    GetMtc = "MTC ���� ȹ�� Error"
End Function

'ESMI�� �����ϴ� MTC ���峻���� DB���� �����´�.
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
        GetCtc = "CTC Table ����"
    Else
        GetCtc = adoRs!ctc_description
    End If
    
    adoRs.Close
    Set adoRs = Nothing
    
    Exit Function
ErrTrap:
    If Not adoRs Is Nothing Then Set adoRs = Nothing
    GetCtc = "CTC ���� ȹ�� Error"
End Function

' �� ȣ���� �����ڵ�� �߿��� �������Ϳ� ������ ������ �ִ����� �˻�
' �Ķ���� - DAS_ID, �� ȣ���� ����, �����ڵ� Index
' Return value - �����ϸ� TRUE
' �߿�) ���� �����ϸ� carTrb.MaintNo, carTrb.Content�� �����Ѵ�.
' �켱������ �ִ� ������ �ٲ�
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
        WriteUDPLog "NewExistSICTrb", "Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
    End If
    
    'ESMI1_Flag �� ��Ʈ�Ǿ��ִ� ���� ������ ��������
    Do While Not adoRs.EOF
        trbCar.maintNo = adoRs!maint_no
        trbCar.Content = adoRs!tcd_content
        
        isFlag = True
        adoRs.MoveNext
    Loop
    
    adoRs.Close
    Set adoRs = Nothing
    
    If isFlag = False Then '������ ������ ������ �׳� TCD �ڵ��� ���� �޾Ƽ� ����
        SQL = "SELECT top 1 e.maint_no maint_no, t.code_no, t.content tcd_content " & _
              "FROM elevator e, model_config m, tcd_config t " & _
              "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
              "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and "
        SQL = SQL & code & " ORDER BY priority asc"
        WriteUDPLog "NewExistSICTrb(query)", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb", "Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
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
    Dim Index As Byte   ' ���� Index
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
        Case 1 To &HEF '����� �����̸�
            If Len(strCode) = 0 Then ' ù��° �����̸�
                strCode = "(" & "t.code_no = '" & hexFormat(trbCar.NewCodes(Index)) & "' "
            Else
                strCode = " or t.code_no = '" & hexFormat(trbCar.NewCodes(Index)) & "' "
            End If
        Case &HF6 To &HFD
            If Len(strMtc) = 0 Then ' Mtc������ �ϳ��� ������ ������
                strMtc = "(" & "t.tcd = 0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            Else
                strMtc = " or t.tcd=0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            End If
        Case &HF3 To &HF5
            If Len(strCtc) = 0 Then 'CTC ������ �ϳ��� ������ ������
                strCtc = "(" & "t.tcd = 0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            Else
                strCtc = " or t.tcd=0x" & hexFormat(trbCar.NewCodes(Index)) & " "
            End If
        End Select
    Next Index
    strCode = strCode & ")"
    strMtc = strMtc & ")"
    strCtc = strCtc & ")"
    
    If Len(strCode) > 3 Then ' ����� ������ ���ٸ� ")" �� ��Ÿ����.
        SQL = "SELECT top 1 e.maint_no maint_no, t.code_no , t.content tcd_content " & _
              "FROM elevator e, model_config m, tcd_config t " & _
              "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
              "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and " & _
              "t.esmi1_flag = 's' and "
        SQL = SQL & strCode & " ORDER BY priority asc"
        
        WriteUDPLog "NewExistSICTrb69(query) ����� ����Ȯ��", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb69", "Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
        End If
        
        
        'ESMI1_Flag �� ��Ʈ�Ǿ��ִ� ���� ������ ��������
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!tcd_content
            CodeNo = Val("&H" + adoRs!code_no)
            isFlag = True
            adoRs.MoveNext
        Loop
        adoRs.Close
        Set adoRs = Nothing
        
        If isFlag = False Then '������ ������ ������ �׳� TCD �ڵ��� ���� �޾Ƽ� ����
            SQL = "SELECT top 1 e.maint_no maint_no, t.code_no, t.content tcd_content " & _
                  "FROM elevator e, model_config m, tcd_config t " & _
                  "WHERE e.model = m.model and e.das = '" & dasId & "' and " & _
                  "e.car_no = '" & carId & "' and t.model_gp = m.model_gp and "
            SQL = SQL & strCode & " ORDER BY priority asc"
            WriteUDPLog "NewExistSICTrb(query)", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb", "Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
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
    End If  ' ����� ������ �ִ� ���
        
    If isFlag = False And Len(strMtc) > 3 Then '����ݿ� ������ ������ ������ MTC ������ �ִ� ���
        MtcSerial = trbCar.EtcState(5) + trbCar.EtcState(6) * 256
        SQL = " SELECT top 1 t.tcd , t.mtc_description, e.maint_no  From rom_logic_mtc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' and t.esmi1_flag='s' " & _
              " and t.MTC_SERIAL_NO=" & Str(MtcSerial) & _
              " and " & strMtc & " order by priority asc"
        
        WriteUDPLog "NewExistSICTrb69(query) MTC ����Ȯ�� ", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb69", "MTC Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
        End If
        
        
        'ESMI1_Flag �� ��Ʈ�Ǿ��ִ� ���� ������ ��������
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!mtc_description
            isMtcFlag = True
            adoRs.MoveNext
        Loop
        adoRs.Close
        Set adoRs = Nothing
        
        If isMtcFlag = False And Len(strCode) < 3 Then '������ ������ ���� ����� ���嵵 ������ MTC �����ڵ��� ���� �޾Ƽ� ����
        SQL = " SELECT top 1 t.tcd , t.mtc_description, e.maint_no  From rom_logic_mtc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' " & _
              " and t.MTC_SERIAL_NO=" & Str(MtcSerial) & _
              " and " & strMtc & " order by priority asc"
            WriteUDPLog "NewExistSICTrb(query)", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb69 ", "MTC Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = adoRs!mtc_description
                adoRs.MoveNext
            Loop
            adoRs.Close
            Set adoRs = Nothing
        End If
    End If  ' ����� ������ ���� MTC ������ �ִ� ���
    
    If isFlag = False And isMtcFlag = False And Len(strCtc) > 3 Then '����ݿ� ������ ���嵵 ���� MTC�� ������ ���嵵 ������ CTC ������ �ִ� ���
        CtcSerial = trbCar.EtcState(7) + trbCar.EtcState(8) * 256
        SQL = " SELECT top 1 t.tcd , t.ctc_description, e.maint_no  From rom_logic_ctc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' and t.esmi1_flag='s' " & _
              " and t.CTC_SERIAL_NO=" & Str(CtcSerial) & _
              " and " & strCtc & " order by priority asc"
        
        WriteUDPLog "NewExistSICTrb69(query) CTC ����Ȯ�� ", SQL
        Set adoRs = New ADODB.Recordset
        adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
        If adoRs.EOF Then
            WriteUDPLog "NewExistSICTrb69", "CTC Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
        End If
        
        
        'ESMI1_Flag �� ��Ʈ�Ǿ��ִ� ���� ������ ��������
        Do While Not adoRs.EOF
            trbCar.maintNo = adoRs!maint_no
            trbCar.Content = adoRs!ctc_description
            isCtcFlag = True
            adoRs.MoveNext
        Loop
        adoRs.Close
        Set adoRs = Nothing
        
        If isCtcFlag = False And Len(strCode) < 3 And Len(strMtc) < 3 Then '������ ������ ���� ����� ���嵵 ���� MTC ���嵵 ������ CTC ���� �޾Ƽ� ����
        SQL = " SELECT top 1 t.tcd , t.ctc_description, e.maint_no  From rom_logic_ctc t,elevator e " & _
              " WHERE e.das='" & dasId & "' and e.car_no='" & carId & "' " & _
              " and t.CTC_SERIAL_NO=" & Str(CtcSerial) & _
              " and " & strCtc & " order by priority asc"
            WriteUDPLog "NewExistSICTrb(query)69", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb69 ", "CTC Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = adoRs!ctc_description
                adoRs.MoveNext
            Loop
            adoRs.Close
            Set adoRs = Nothing
        End If
    End If  ' ����� ������ ���� MTC ������ �ִ� ���
        
    If Len(strCode) < 3 And Len(strMtc) < 3 And Len(strCtc) < 3 Then '����ݰ��嵵 ���� MTC ���嵵 ���� CTC ���嵵 ������
        SQL = "SELECT top 1 maint_no from elevator WHERE das='" & dasId & "' and car_no='" & carId & "'"
        WriteUDPLog "NewExistSICTrb(query)69", SQL
            Set adoRs = New ADODB.Recordset
            adoRs.Open SQL, connREM, adOpenStatic, adLockReadOnly, adCmdText
            If adoRs.EOF Then
                WriteUDPLog "NewExistSICTrb69 ", "CTC Match�ϴ� DASID,CARNO,���峻���� �����ϴ�."
            End If
            
            Do While Not adoRs.EOF
                trbCar.maintNo = adoRs!maint_no
                trbCar.Content = "��ȿ�� �����ڵ尡 �ƴմϴ�."
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




' �������� ����
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
    'pConnString = "DSN=" & pDSN & ";UID=" & pUID & ";PWD=" & xSicPWD    ODBC ���
    'SQL Server 2000�� driver={SQL SERVER} �� ���� �൵ �Ǵ��� ���߿� ���� ����� ��ĥ��
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
' �������� ����
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

' ���ݰ��� ����
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
' ���ݰ��� ����
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

