Attribute VB_Name = "basFile"
'+++++++++++++++++++++++++++++++++
' �������Ͽ� ���� �ڷᱸ����
' ���������� Decoding�ϴ� �Լ���
' �����ϰ� �ִ�
'+++++++++++++++++++++++++++++++++

Option Explicit
Option Base 1


' DAS Version
Public Const VER_59 = &H59
Public Const VER_69 = &H69
Public Const VER_49 = &H49

' DAS SPEC
Public Const MAX_TRB_HISTORY = 100  ' �����̷� ������ ���Ǵ� �����̷� ����
Private Const MAX_CAR = 8           ' �� Das�� ����Ǵ� �ִ� ȣ�� ���
Private Const MAX_ERROR = 256       ' �� ȣ�⿡ �߻��Ǵ� �ִ� ���� ���
Private Const MAX_HISTORY = 100     ' �� ȣ�⿡ ����Ǵ� �ִ� �����̷� ����
Private Const MAX_FILENO = 128      ' DAS <-> EL ����������� File No �� ����
Private Const MAX_ETC_59 = 23       ' ��Ÿ ���� - Ver = 0x59
Private Const MAX_ETC_49 = 16       ' ��Ÿ ���� - Ver = 0x49
Private Const MAX_SORT = 255

' ���� ó�� ����
Private Const TYP_TOTAL = 1
Private Const TYP_SUCCESS = 2
Private Const TYP_FAIL = 3
Private Const TYP_SERVICE = 4
Private Const TYP_SUBTOTAL = 5

' ����� ���� ����
Private Const START_FLOOR = 1   ' �����
Private Const FN_Z61LP = 1      ' UP �����
Private Const FN_Z62LP = 1      ' DOWN �����
Private Const FN_ZX40G = 1      ' DOOR CLOSE Ȯ��
Private Const FN_N900 = 4       ' ������
Private Const FN_Z65RG = 6      ' CAR LOAD(%)
Private Const FN_XCUT = 39      ' EMERGENCY STOP
Private Const FN_XOLS = 40      ' OPEN LIMIT SWITCH
Private Const FN_X50BC = 41     ' ���� ȸ�� Ȯ��
Private Const FN_XFML = 41      ' FML �Է�

' HEADER Offset
Private Const OFS_VER = 1
Private Const OFS_LOCH = 2
Private Const OFS_LOCL = 3
Private Const OFS_DASH = 4
Private Const OFS_DASL = 5

Public Type THistInfo  ' ����-ȣ��-�����̷�
    occurTime As Date                           ' �����̷� �߻��ð�
    ErrMode As Byte                             ' ���� ���
    ErrCode As Byte                             ' ���� �ڵ�
    Status0 As Byte                             ' Ver &H59�ΰ��
    Status1 As Byte                             ' Ver &H59�ΰ��
    Status2 As Byte                             ' Ver &H59�ΰ��
End Type

Public Type TCarInfo   ' ����-ȣ��
    src As String                               ' ���Ͽ��� ������ ������ ������ ������ ������ ��ó������
    carId As Byte                               ' ȣ�� Id   [CODE_CARID], DAS = 0���� ���� ����
    CurrErrNo As Byte                           ' ���� �߻��� ���� ���� [CODE_CURR]
    CurrError(1 To MAX_ERROR) As Byte           ' ���� �����ڵ�
    LastErrNo As Byte                           ' ���� �߻��� ���� ���� [CODE_LAST]
    LastError(1 To MAX_ERROR) As Byte           ' ���� �����ڵ�
    ErrHistNo As Byte                           ' �����̷� ���� [CODE_TRHT]
    ErrHistory(1 To MAX_HISTORY) As THistInfo   ' �����̷�
    FinalTime As Date                           ' ���� �߻��ð� [CODE_FNST]
    EtcState(1 To MAX_ETC_59) As Byte           ' ��Ÿ ���� [CODE_ERST] - &H49 = 16byte, &H59 = 23byte
    CurrFl As Byte                              ' ������
    StartFl As Byte                             ' �����
    Dir As String * 1                           ' ����
    Zone As String * 1                          ' ���� ��
    Door As String * 1                          ' ���� ����
    EStop As String * 1                         ' ESTOP
    Safety As String * 1                        ' ����ȸ��
    CarLoad As Byte                             ' CAR ����
    NewCodeNo As Byte                           ' �ű� �����ڵ� ����
    RcvCodeNo As Byte                           ' ���� �����ڵ� ����
    HoldCodeNo As Byte                          ' ���� �����ڵ� ����
    NewCodes(1 To MAX_ERROR) As Byte            ' �ű� �����ڵ��
    RcvCodes(1 To MAX_ERROR) As Byte            ' ���� �����ڵ��
    HoldCodes(1 To MAX_ERROR) As Byte           ' ���� �����ڵ��
    SICErrNo As Byte                            ' �����̷��� ���� ErrMode�� F1�� ��. �� ����
    SICError(1 To 6) As Byte                    ' 1 = ���������ڵ�, 2~6 = History �߿��� F1
    SICCheck As Boolean                         ' �������Ϳ� ������ ������ �����ϴ��� ����
    maintNo As String                           ' ������ȣ
    Customer As String                          ' ����
    REMRecNo As String                          ' ���ݰ��� ������ȣ
    SICRecNo As String                          ' �������� ������ȣ
    Content As String                           ' �������� ���� ����
    REMRcvError As String                          ' ���ݰ��� ����Error ����
    SICRcvError As String                          ' ������Ÿ ����Error ����
    Comment As String                           ' ��Ÿ ��� ����(�α׸� ���� ���Ͽ�)
End Type

Public Type TTrbInfo   ' ����
    ver As Byte                                 ' Version ����
    dasId As String * 9                         ' 'LocNo'-'DasNo'
    fileName As String                          ' File �̸�
    FileTime As String                          ' file�� ó���ð�
    Result As Integer                           ' ���� ó�����
    CarNo As Byte                               ' ȣ�� ����
    CarInfo(1 To MAX_CAR) As TCarInfo           ' ����-ȣ�� ����
    Comment As String                           ' ��Ÿ Error ����
End Type

Public Type TTrbHist   ' �����̷�
    ver As Byte                                 ' Version ����
    dasId As String * 9                         ' 'LocNo'-'DasNo'
    fileName As String                          ' File �̸�
    FileTime As String                          ' file�� ó���ð�
    Result As Integer                           ' ���� ó�����
    CarInfo As TCarInfo                         ' ����-ȣ�� ����
End Type

Public Type TTrbMsg   ' UDP ��Ŷ
    ErrHistNo As Byte                           ' �����̷� ���� [CODE_TRHT]
    s_total As String * 5
    s_subtotal As String * 5
    s_succ As String * 5
    s_sic As String * 5
    s_fail As String * 5
    s_multi As String * 5
    s_das As String * 10
    g_time As String * 20
    g_name As String * 30
    g_ver As String * 5
    g_id As String * 5
    g_result As String * 5
    g_new As String * 20
    g_rcv As String * 20
    g_hold As String * 20
    g_maintno As String * 20
    g_remid As String * 20
    g_recno As String * 20
    g_content As String * 50
    l_start As String * 3
    l_stop As String * 3
    l_safety As String * 3
    l_load As String * 3
    l_zone As String * 3
    l_door As String * 3
    l_dir As String * 3
    ErrHistory(1 To 100) As THistInfo ' �����̷�
End Type

Public Type TVFile
    ver As Byte                                 ' Version ����
    dasId As String * 9                         ' 'LocNo'-'DasNo'
    fileName As String                          ' File �̸�
    FileTime As String                          ' file�� ó���ð�
    Result As Integer                           ' ���� ó�����
    Dip_sw As Byte                              ' ȣ�� �������(DIP S/W)
    Dip_sw1 As Byte                             ' Dip s/w 1 value
    Dip_sw2 As Byte                             ' Dip s/w 2 value
    Dip_sw3 As Byte                             ' Dip s/w 3 value
    MaxCar As Byte                              ' Max Car
    Ga_Id(1 To MAX_CAR) As Byte                 ' G/A ID
    Comm_State(1 To MAX_CAR) As Byte            ' ���Error����
    Maint_State(1 To MAX_CAR) As Byte           ' ���˸�� ����
    Boot_Count As Integer                       ' Boot count
    Normal_BCount As Integer                    ' ���� bootȽ��
    Modem_Use As Byte                           ' Modem ��� ����
    ETime_Boot As Long                          ' Boot�� ���� ���  �ð� (��)
    ETime_ColdBoot As Long                      ' Cold boot�� �� ���� �ð� (��)
    Power_State As Byte                         ' ���� ����
    Tel_LocNo As String * 8                     ' ��ȭ ������ȣ
    Host_LocNo As String * 8                    ' ȣ��Ʈ ������ȣ
    Telephone(1 To MAX_CAR) As String * 16      ' ��ȭ��ȣ
    Spec_Hour As Byte                           ' Spec serial no - ��
    Spec_Day As Byte                            ' Spec serial no - ��
    Spec_Month As Byte                          ' Spec serial no - ��
    Spec_Year As Byte                           ' Spec serial no - ��
    Comm_Count As Long                          ' ����� Ƚ��
    Comm_SCount As Long                         ' ����� ����Ƚ��
    Rtc_Year As Integer                         ' Rtc_Year
    Rtc_Month As Byte                           ' Rtc_Month
    Rtc_Day As Byte                             ' Rtc_Day
    Rtc_Hour As Byte                            ' Rtc_Hour
    Rtc_Min As Byte                             ' Rtc_Min
    Rtc_Sec As Byte                             ' Rtc_Sec
    Das_Mode As String * 10                     ' Das_Mode
    Das_Version As String * 32                  ' Das_Version
End Type


Public histId As Integer                        ' �����̷� ���� index
Private trbbuf As TTrbInfo                      ' 1���� ���������� �����ϴ� ���
Public trbHist(1 To MAX_TRB_HISTORY) As TTrbHist ' �����̷� ���� - ��������:ȣ�⺰
Public comm As clsComm                          ' ������� Class
Public vFile As TVFile
Public jsrSrc As String
Public jsrDes As String
Public reTrbCar As TCarInfo
Public procSrc As String
Public logCnt As Integer                        ' writeHist �Լ��� �� ������ 1�� �����Ѵ�.
Public prevDay As String
Public curDay As String

' ������ ó���ϴ� �����Լ��δ�.
' �Ķ���� - Full path & filename
' Return value - ���� : 1, ���� : �� ������ �ڵ�
Public Function ProcessTrb(ByVal strFile As String) As Integer
    Dim byteBuf() As Byte   ' ���� �迭�� ��� Index = 0���� ����
    Dim Result As Integer
    Dim Index As Integer
    
    MDI.lstFile.Clear
    
    Call InitTrbBuf
    
    trbbuf.FileTime = CStr(Now)             ' ó���ð�
    trbbuf.fileName = StripPath(strFile)    ' full path file���� path�� ���� ��
    
    WriteUDPLog "ProcessTrb", "------------" + trbbuf.fileName + "-------------------------------"
    WriteUDPLog "ProcessTrb", " XFile ó��"
    
    If Dir(strFile) = Empty Then
        MDI.lstFile.AddItem "can't find " & strFile
        MDI.lstFile.Refresh
        Result = ERR_NOT_EXIST
        trbbuf.Result = Result
        WriteHist trbbuf
    Else
        byteBuf() = ReadData(strFile)           ' �ش� ���Ͽ��� -> byte array()�� ����
        trbbuf.ver = byteBuf(OFS_VER)
        MDI.lstFile.AddItem trbbuf.fileName & " - " & Hex(trbbuf.ver)
        MDI.lstFile.Refresh
        
        Select Case trbbuf.ver  ' Check das version
            Case VER_59, VER_69
                WriteUDPLog "ProcessTrb", "VerSion 59->Go to Decode59"
                Result = Decode59(byteBuf(), strFile)
                If Result = OK_SUCCESS And frmConfig.iEscalator = 0 Then
                    WriteUDPLog "ProcessTrb", "Decode OK-> Go to DBInsert59"
                    Result = DBInsert59(trbbuf)
                Else
                    trbbuf.Comment = "XFile Decode Error"
                End If
                trbbuf.Result = Result
                WriteHist trbbuf
            Case VER_49
                WriteUDPLog "ProcessTrb", "Version 49"
                Result = Decode49(byteBuf(), strFile)
                If Result = OK_SUCCESS And frmConfig.iEscalator = 0 Then
                    Result = DBInsert49(trbbuf)
                End If
                trbbuf.Result = Result
                WriteHist trbbuf
            Case Else
                Result = ERR_VERSION
        End Select
    End If
    comm.ContinuedFail = GetMultiOccur(trbbuf.dasId)  ' �ٹ� ���� Check
    comm.IncCount TYP_TOTAL             ' ��ü ���� �Ǽ� ����
    If Result < OK_THRETHOULD Then
        comm.IncCount (TYP_SUCCESS)     ' ���� �Ǽ� ����
    Else
        comm.IncCount (TYP_FAIL)        ' ���� �Ǽ� ����
    End If
    For Index = 1 To trbbuf.CarNo
        comm.IncCount TYP_SUBTOTAL      ' �� ȣ�⺰ ó�� �Ǽ�
        If trbbuf.CarInfo(Index).SICRecNo <> "" Then
            comm.IncCount TYP_SERVICE   ' �������� �����Ǽ� ����
        End If
    Next Index
    ProcessTrb = Result
    
End Function

' V File�� ó���ϴ� �����Լ��δ�.
' �Ķ���� - Full path & filename
' Return value - ���� : 1, ���� : �� ������ �ڵ�
Public Function ProcessVFile(ByVal strFile As String) As Integer
    Dim byteBuf() As Byte   ' ���� �迭�� ��� Index = 0���� ����
    Dim Result As Integer
    
    MDI.lstFile.Clear
    
    Call InitVFileBuf
    
    vFile.fileName = StripPath(strFile)     ' full path file���� path�� ���� ��
    vFile.FileTime = CStr(Now)              ' ó���ð�

    If Dir(strFile) = Empty Then
        Result = ERR_NOT_EXIST
    Else
        byteBuf() = ReadData(strFile)           ' �ش� ���Ͽ��� -> byte array()�� ����
        vFile.ver = byteBuf(OFS_VER)
        MDI.lstFile.AddItem vFile.fileName & " - " & Hex(vFile.ver)
        MDI.lstFile.Refresh
    
        Select Case vFile.ver  ' Check das version
            Case &H62
                Result = DecodeVFile(byteBuf())
                If Result = OK_SUCCESS Then
                    Result = InsertVFile()
                End If
            Case Else
                Result = ERR_VERSION
        End Select
    End If
    
    vFile.Result = Result
    ProcessVFile = Result
End Function

' �Ѱ��� ���������� �޾Ƽ� �����̷� ������ ����
Private Sub WriteHist(trb As TTrbInfo)
    Dim Index As Integer
    Dim f As Integer
    Dim i As Integer
    Dim J As Integer
    Dim strMsg As String
    Dim strSrc As String
    Dim strDes As String
    Dim wFlag As Boolean
    Dim docTrb As MSXML.DOMDocument
    Dim trbElement As MSXML.IXMLDOMElement
    Dim trbNodeList As MSXML.IXMLDOMNodeList
    Dim newTrb As MSXML.IXMLDOMElement
    Dim newVer As MSXML.IXMLDOMElement
    Dim newSrc As MSXML.IXMLDOMElement
    Dim newFileTime As MSXML.IXMLDOMElement
    Dim newFileName As MSXML.IXMLDOMElement
    Dim newMaintNo As MSXML.IXMLDOMElement
    Dim newDasId As MSXML.IXMLDOMElement
    Dim newCarId As MSXML.IXMLDOMElement
    Dim newCustomer As MSXML.IXMLDOMElement
    Dim newNewCodes As MSXML.IXMLDOMElement
    Dim newRcvCodes As MSXML.IXMLDOMElement
    Dim newHoldCodes As MSXML.IXMLDOMElement
    Dim newTrbHist As MSXML.IXMLDOMElement
    Dim newTrbHists As MSXML.IXMLDOMElement
    Dim newTrbHistTime As MSXML.IXMLDOMElement
    Dim newTrbHistContent As MSXML.IXMLDOMElement
    
    Dim newCurrFl As MSXML.IXMLDOMElement                     ' ������
    Dim newStartFl As MSXML.IXMLDOMElement                       ' �����
    Dim newDir As MSXML.IXMLDOMElement                           ' ����
    Dim newZone As MSXML.IXMLDOMElement                          ' ���� ��
    Dim newDoor As MSXML.IXMLDOMElement                          ' ���� ����
    Dim newEStop As MSXML.IXMLDOMElement                         ' ESTOP
    Dim newSafety As MSXML.IXMLDOMElement                        ' ����ȸ��
    Dim newCarLoad As MSXML.IXMLDOMElement                       ' CAR ����

    Dim newContent As MSXML.IXMLDOMElement
    Dim newSicCheck As MSXML.IXMLDOMElement
    Dim newRemRecNo As MSXML.IXMLDOMElement
    Dim newSicRecNo As MSXML.IXMLDOMElement
    Dim newRemRcvError As MSXML.IXMLDOMElement
    Dim newSicRcvError As MSXML.IXMLDOMElement
    Dim newComment As MSXML.IXMLDOMElement
    Dim newResult   As MSXML.IXMLDOMElement
    
    
    logCnt = logCnt + 1
    Set docTrb = New MSXML.DOMDocument
    docTrb.async = False
    If docTrb.LOAD("c:\inetpub\wwwroot\" & Format(Now, "yymmdd") & ".xml") Then
    Else
        docTrb.loadXML "<?xml version='1.0'?><TRBLIST></TRBLIST>"
    End If
    Set trbElement = docTrb.documentElement
    
    'element ����
    
    'If intVal < 1 Then Exit Sub '�ƹ��͵� ó�� ����
    
    strSrc = AddPath("C:\inetpub\wwwroot\", Format(Now, "yymmdd"))
    
    f = FreeFile                            ' Write contents to file
    Open strSrc For Append As f
    
    For Index = 1 To trb.CarNo
        strMsg = ""
        histId = histId + 1
        If histId > MAX_TRB_HISTORY Then
            histId = 1
        End If
        trb.CarInfo(Index).src = procSrc
        'XML DOM �� �߰��Ѵ�.
        Set newVer = docTrb.createElement("VER")
        Set newTrb = docTrb.createElement("TRB")
        Set newSrc = docTrb.createElement("SRC")
        Set newFileTime = docTrb.createElement("FILETIME")
        Set newFileName = docTrb.createElement("FILENAME")
        Set newMaintNo = docTrb.createElement("MAINTNO")
        Set newDasId = docTrb.createElement("DASID")
        Set newCarId = docTrb.createElement("CARID")
        Set newCustomer = docTrb.createElement("CUSTOMER")
        
        Set newCurrFl = docTrb.createElement("CurrFl")                     ' ������
        Set newStartFl = docTrb.createElement("StartFl")                   ' �����
        Set newDir = docTrb.createElement("Dir")                           ' ����
        Set newZone = docTrb.createElement("Zone")                         ' ���� ��
        Set newDoor = docTrb.createElement("Door")                         ' ���� ����
        Set newEStop = docTrb.createElement("EStop")                       ' ESTOP
        Set newSafety = docTrb.createElement("Safety")                     ' ����ȸ��
        Set newCarLoad = docTrb.createElement("CarLoad")                   ' CAR ����
        
        Set newNewCodes = docTrb.createElement("NEWCODES")
        Set newRcvCodes = docTrb.createElement("RCVCODES")
        Set newHoldCodes = docTrb.createElement("HOLDCODES")
        Set newTrbHists = docTrb.createElement("TRBHISTS")
        Set newContent = docTrb.createElement("CONTENT")
        Set newSicCheck = docTrb.createElement("SICCHECK")
        Set newRemRecNo = docTrb.createElement("REMRECNO")
        Set newSicRecNo = docTrb.createElement("SICRECNO")
        Set newRemRcvError = docTrb.createElement("REMRCVERROR")
        Set newSicRcvError = docTrb.createElement("SICRCVERROR")
        Set newComment = docTrb.createElement("COMMENT")
        Set newResult = docTrb.createElement("RESULT")
        
        newVer.Text = hexFormat(trb.ver)
        newSrc.Text = trb.CarInfo(Index).src
        newFileTime.Text = trb.FileTime
        newFileName.Text = trb.fileName
        newMaintNo.Text = trb.CarInfo(Index).maintNo
        newDasId.Text = trb.dasId
        newCarId.Text = Format(trb.CarInfo(Index).carId, "0#")
        newCustomer.Text = trb.CarInfo(Index).Customer
        newCurrFl.Text = CStr(trb.CarInfo(Index).CurrFl)
        newStartFl.Text = CStr(trb.CarInfo(Index).StartFl)
        newDir.Text = trb.CarInfo(Index).Dir
        newZone.Text = trb.CarInfo(Index).Zone
        newDoor.Text = trb.CarInfo(Index).Door
        newEStop.Text = trb.CarInfo(Index).EStop
        newSafety.Text = trb.CarInfo(Index).Safety
        newCarLoad.Text = CStr(trb.CarInfo(Index).CarLoad)
        
        strMsg = ""
        For i = 1 To trb.CarInfo(Index).NewCodeNo     '�ű� ���� �ڵ�
            strMsg = strMsg + hexFormat(trb.CarInfo(Index).NewCodes(i)) + " "
        Next i
        newNewCodes.Text = strMsg
        
        
        '�� �и��� �ٴ� ��ĭ�� �ϳ��� ����� �д�.
        strMsg = ""
        For i = 1 To trb.CarInfo(Index).RcvCodeNo     '���� ���� �ڵ�
            strMsg = strMsg + hexFormat(trb.CarInfo(Index).RcvCodes(i)) + " "
        Next i
        newRcvCodes.Text = strMsg
        
        strMsg = ""
        For i = 1 To trb.CarInfo(Index).HoldCodeNo     '���� ���� �ڵ�
            strMsg = strMsg + hexFormat(trb.CarInfo(Index).HoldCodes(i)) + " "
        Next i
        newHoldCodes.Text = strMsg
        '���� �����丮
        For i = 1 To trb.CarInfo(Index).ErrHistNo
            Set newTrbHist = docTrb.createElement("TRBHIST")
            Set newTrbHistTime = docTrb.createElement("TRBTIME")
            Set newTrbHistContent = docTrb.createElement("TRBCONTENT")
            newTrbHistTime.Text = Format(trb.CarInfo(Index).ErrHistory(i).occurTime, "YY-MM-DD hh:mm:ss")
            If trbbuf.ver >= VER_59 Then
                newTrbHistContent.Text = "" & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).ErrMode) & " " & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).ErrCode) & " " & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).Status0) & " " & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).Status1) & " " & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).Status2)
            ElseIf trbbuf.ver = VER_49 Then
                newTrbHistContent = "" & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).ErrMode) & " " & _
                    hexFormat(trb.CarInfo(Index).ErrHistory(i).ErrCode)
            End If
            newTrbHist.appendChild newTrbHistTime
            newTrbHist.appendChild newTrbHistContent
            newTrbHists.appendChild newTrbHist
            Set newTrbHistTime = Nothing
            Set newTrbHistContent = Nothing
            Set newTrbHist = Nothing
        Next i
        
        '���� ����
        newContent.Text = trb.CarInfo(Index).Content
        '������Ÿ ���� ����
        If trb.CarInfo(Index).SICCheck = True Then
            newSicCheck.Text = "Y"
        Else
            newSicCheck.Text = "N"
        End If
        'REM ���� ��ȣ
        newRemRecNo.Text = trb.CarInfo(Index).REMRecNo
        '������Ÿ ���� ��ȣ
        newSicRecNo.Text = trb.CarInfo(Index).SICRecNo
        newRemRcvError.Text = trb.CarInfo(Index).REMRcvError
        newSicRcvError.Text = trb.CarInfo(Index).SICRcvError
        newComment.Text = trb.Comment + trb.CarInfo(Index).Comment
        newResult.Text = trb.Result
        
        newTrb.appendChild newVer
        newTrb.appendChild newSrc
        newTrb.appendChild newFileTime
        newTrb.appendChild newFileName
        newTrb.appendChild newMaintNo
        newTrb.appendChild newDasId
        newTrb.appendChild newCarId
        newTrb.appendChild newCustomer
        
        newTrb.appendChild newCurrFl
        newTrb.appendChild newStartFl
        newTrb.appendChild newDir
        newTrb.appendChild newZone
        newTrb.appendChild newDoor
        newTrb.appendChild newEStop
        newTrb.appendChild newSafety
        newTrb.appendChild newCarLoad
        
        newTrb.appendChild newNewCodes
        newTrb.appendChild newRcvCodes
        newTrb.appendChild newHoldCodes
        newTrb.appendChild newTrbHists
        newTrb.appendChild newContent
        newTrb.appendChild newSicCheck
        newTrb.appendChild newRemRecNo
        newTrb.appendChild newSicRecNo
        newTrb.appendChild newRemRcvError
        newTrb.appendChild newSicRcvError
        newTrb.appendChild newComment
        newTrb.appendChild newResult
        trbElement.appendChild newTrb
        
        Set newTrb = Nothing
        Set newVer = Nothing
        Set newSrc = Nothing
        Set newFileTime = Nothing
        Set newFileName = Nothing
        Set newMaintNo = Nothing
        Set newDasId = Nothing
        Set newCarId = Nothing
        Set newCustomer = Nothing
        
        Set newCurrFl = Nothing
        Set newStartFl = Nothing
        Set newDir = Nothing
        Set newZone = Nothing
        Set newDoor = Nothing
        Set newEStop = Nothing
        Set newSafety = Nothing
        Set newCarLoad = Nothing
        
        Set newNewCodes = Nothing
        Set newRcvCodes = Nothing
        Set newHoldCodes = Nothing
        Set newContent = Nothing
        Set newTrbHists = Nothing
        Set newSicCheck = Nothing
        Set newRemRecNo = Nothing
        Set newSicRecNo = Nothing
        Set newRemRcvError = Nothing
        Set newSicRcvError = Nothing
        Set newComment = Nothing
        Set newResult = Nothing
        
        
        trbHist(histId).dasId = trb.dasId
        trbHist(histId).fileName = trb.fileName
        trbHist(histId).FileTime = Format(trb.FileTime, "YY-MM-DD h:m:s")
        'trbHist(histId).FileTime = trb.FileTime
        trbHist(histId).Result = trb.Result
        trbHist(histId).ver = trb.ver
        trbHist(histId).CarInfo = trb.CarInfo(Index)
        Print #f, strMsg
    Next Index
    
    docTrb.Save "c:\inetpub\wwwroot\" & Format(Now, "yymmdd") & ".xml"
    Set docTrb = Nothing
    
    curDay = Format(Now, "yymmdd")
    If prevDay <> curDay Then
        prevDay = curDay
        logCnt = 1
    End If
    
    If trb.Result = ERR_NOT_EXIST Then      ' ������ �������� �ʴ� ���
        histId = histId + 1
        If histId > MAX_TRB_HISTORY Then
            histId = 1
        End If
        trbHist(histId).fileName = trb.fileName
        trbHist(histId).Result = trb.Result
    End If
    Close f
End Sub

Public Sub WriteVFIleLog(ByVal intVal As Integer)
    Dim f As Integer
    Dim strSrc As String
    Dim strDes As String
    Dim strMsg As String
    
    strSrc = AddPath("", "Messages.log")
    strDes = AddPath("", "Messages0.log")
    
    strMsg = "[" + vFile.FileTime + "]" + vFile.fileName + " V]" + Hex(vFile.ver) + _
             " - " + Format(intVal, "00#")
             
    If Dir(strSrc) <> Empty Then            ' ������ �ִ� ��츸 ũ�⸦ �˻�
        If FileLen(strSrc) > 64000 Then     ' 64KB�� �ʰ��ϸ� copy
            FileCopy strSrc, strDes
            Kill strSrc
        End If
    End If
    
    f = FreeFile                            ' Write contents to file
    Open strSrc For Append As f
    Print #f, strMsg
    Close f
End Sub
' ���� ó�� ����� log ���Ͽ� Append
' �Ķ���� - ����ó�� ���
' ����) log ������ ũ��� 64KB�� �ʰ��� �� ����. ����,
'       default = Messages.log �� �����ϰ� �ʰ��ϸ� Messages0.log�� copy�Ѵ�.
Public Sub WriteLog(ByVal intVal As Integer)
    Dim f As Integer
    Dim i As Integer
    Dim J As Integer
    Dim strMsg As String
    Dim strSrc As String
    Dim strDes As String
    Dim wFlag As Boolean
    
    'If intVal < 1 Then Exit Sub '�ƹ��͵� ó�� ����
    
    strSrc = AddPath("C:\inetpub\wwwroot\", "Messages.txt")
    strDes = AddPath("C:\inetpub\wwwroot\", "Messages0.txt")
    
    For i = 1 To trbbuf.CarNo
        strMsg = "[" + trbbuf.FileTime + "]" + _
                 trbbuf.fileName + " V]" + Hex(trbbuf.ver) + " ID]" + Hex(trbbuf.CarInfo(i).carId) + _
                 " - " + Format(intVal, "00#") + " : "
        
        If trbbuf.ver = VER_49 And trbbuf.CarInfo(i).CurrErrNo > 0 Then
            strMsg = strMsg + "C-"
            For J = 1 To trbbuf.CarInfo(i).CurrErrNo
                strMsg = strMsg + hexFormat(trbbuf.CarInfo(i).CurrError(J)) + " "
            Next J
        End If
        
        If trbbuf.ver >= VER_59 Then         ' Version�� 59�� ��츸 ����
'            If trbbuf.CarInfo(i).LastErrNo > 0 Then
'                strMsg = strMsg + "L-"
'            End If
'            For j = 1 To trbbuf.CarInfo(i).LastErrNo
'                strMsg = strMsg + hexFormat(trbbuf.CarInfo(i).LastError(j)) + " "
'            Next j
        
            If trbbuf.CarInfo(i).NewCodeNo > 0 Then
                strMsg = strMsg + "N-"
            End If
            For J = 1 To trbbuf.CarInfo(i).NewCodeNo
                strMsg = strMsg + hexFormat(trbbuf.CarInfo(i).NewCodes(J)) + " "
            Next J
            
            If trbbuf.CarInfo(i).RcvCodeNo > 0 Then
                strMsg = strMsg + "R-"
            End If
            For J = 1 To trbbuf.CarInfo(i).RcvCodeNo
                strMsg = strMsg + hexFormat(trbbuf.CarInfo(i).RcvCodes(J)) + " "
            Next J
            
            If trbbuf.CarInfo(i).HoldCodeNo > 0 Then
                strMsg = strMsg + "H-"
            End If
            For J = 1 To trbbuf.CarInfo(i).HoldCodeNo
                strMsg = strMsg + hexFormat(trbbuf.CarInfo(i).HoldCodes(J)) + " "
            Next J
        End If
        
'        If trbbuf.Ver = VER_59 And trbbuf.CarInfo(i).NewCodeNo > 0 Then   ' �ű԰����� ���
'            wFlag = True
'        ElseIf trbbuf.Ver = VER_49 And trbbuf.CarInfo(i).CurrErrNo > 1 Then
'            wFlag = True
'        ElseIf trbbuf.Ver = VER_49 And trbbuf.CarInfo(i).CurrErrNo = 1 And _
'            trbbuf.CarInfo(i).CurrError(1) <> 0 Then          ' ������ �ƴ� ���
'            wFlag = True
'        Else
'            wFlag = False
'        End If
'
'        If wFlag = True Then
'            strMsg = strMsg + Str(trbbuf.CarInfo(i).StartFl) + _
'                     "->" + Str(trbbuf.CarInfo(i).CurrFl) + _
'                     "(" + Str(trbbuf.CarInfo(i).CarLoad) + _
'                     ") [S-" + trbbuf.CarInfo(i).Safety + _
'                     "] [Z-" + trbbuf.CarInfo(i).Zone + _
'                     "] [D-" + trbbuf.CarInfo(i).Door + _
'                     "] [I-" + trbbuf.CarInfo(i).Dir + "]"
'        End If
      
        strMsg = strMsg + trbbuf.CarInfo(i).maintNo + " " + trbbuf.CarInfo(i).REMRecNo + " "
        If trbbuf.CarInfo(i).SICCheck = True Then
                strMsg = strMsg + " S:" + trbbuf.CarInfo(i).SICRecNo + " T-" + _
                         Hex(trbbuf.CarInfo(i).SICError(1)) + " " + _
                         Hex(trbbuf.CarInfo(i).SICError(2)) + " " + _
                         Hex(trbbuf.CarInfo(i).SICError(3)) + " " + _
                         Hex(trbbuf.CarInfo(i).SICError(4)) + " " + _
                         Hex(trbbuf.CarInfo(i).SICError(5)) + " " + _
                         Hex(trbbuf.CarInfo(i).SICError(6))
        End If
        
        If Dir(strSrc) <> Empty Then            ' ������ �ִ� ��츸 ũ�⸦ �˻�
            If FileLen(strSrc) > 64000 Then     ' 64KB�� �ʰ��ϸ� copy
                FileCopy strSrc, strDes
                Kill strSrc
            End If
        End If
        
        f = FreeFile                            ' Write contents to file
        Open strSrc For Append As f
        Print #f, strMsg
        Close f
    Next i
    
    If intVal = ERR_NOT_EXIST Then      ' ������ �������� �ʴ� ���
        strMsg = "[" + trbbuf.FileTime + "]" + _
                 trbbuf.fileName + " V]" + Hex(trbbuf.ver) + " ID]" + Hex(trbbuf.CarInfo(i).carId) + _
                 " - " + Format(intVal, "00#")
        If Dir(strSrc) <> Empty Then            ' ������ �ִ� ��츸 ũ�⸦ �˻�
            If FileLen(strSrc) > 640000 Then     ' 640KB�� �ʰ��ϸ� copy
                FileCopy strSrc, strDes
                Kill strSrc
            End If
        End If
        
        f = FreeFile                            ' Write contents to file
        Open strSrc For Append As f
        Print #f, strMsg
        Close f
    End If
End Sub

' trbBuf �ڷᱸ���� Clear
' ����) ���� ������ ���� �� ������ �����Ƿ� �ݵ�� Clear ���
Private Sub InitTrbBuf()
    Dim X As Integer
    Dim Y As Integer
    
    trbbuf.CarNo = 0
    trbbuf.fileName = ""
    trbbuf.dasId = ""
    trbbuf.ver = 0
    trbbuf.Result = 0
    
    For X = 1 To MAX_CAR
        trbbuf.CarInfo(X).CurrErrNo = 0
        trbbuf.CarInfo(X).ErrHistNo = 0
        trbbuf.CarInfo(X).LastErrNo = 0
        trbbuf.CarInfo(X).NewCodeNo = 0
        trbbuf.CarInfo(X).RcvCodeNo = 0
        trbbuf.CarInfo(X).SICErrNo = 0
        trbbuf.CarInfo(X).HoldCodeNo = 0
        trbbuf.CarInfo(X).maintNo = ""
        trbbuf.CarInfo(X).Content = ""
        trbbuf.CarInfo(X).SICRecNo = ""
        trbbuf.CarInfo(X).SICCheck = False
        
        For Y = 1 To MAX_ETC_59
            trbbuf.CarInfo(X).EtcState(Y) = 0
        Next Y
        
        For Y = 1 To MAX_ERROR
            trbbuf.CarInfo(X).CurrError(Y) = 0
            trbbuf.CarInfo(X).LastError(Y) = 0
            trbbuf.CarInfo(X).NewCodes(Y) = 0
            trbbuf.CarInfo(X).HoldCodes(Y) = 0
            trbbuf.CarInfo(X).RcvCodes(Y) = 0
        Next Y
        
        For Y = 1 To 6
            trbbuf.CarInfo(X).SICError(Y) = 0
        Next Y
    Next X
End Sub

Private Sub InitVFileBuf()
    Dim i As Integer
    
    vFile.Boot_Count = 0
    vFile.Comm_Count = 0
    For i = 1 To MAX_CAR
        vFile.Comm_State(i) = 0
    Next i
    vFile.Comm_SCount = 0
    vFile.Das_Mode = ""
    vFile.Das_Version = ""
    vFile.dasId = ""
    vFile.Dip_sw = 0
    vFile.Dip_sw1 = 0
    vFile.Dip_sw2 = 0
    vFile.Dip_sw3 = 0
    vFile.ETime_Boot = 0
    vFile.ETime_ColdBoot = 0
    vFile.fileName = ""
    vFile.FileTime = ""
    For i = 1 To MAX_CAR
        vFile.Ga_Id(i) = 0
    Next i
    vFile.Host_LocNo = ""
    For i = 1 To MAX_CAR
        vFile.Maint_State(i) = 0
    Next i
    vFile.MaxCar = 0
    vFile.Modem_Use = 0
    vFile.Normal_BCount = 0
    vFile.Power_State = 0
    vFile.Result = 0
    vFile.Rtc_Day = 0
    vFile.Rtc_Hour = 0
    vFile.Rtc_Min = 0
    vFile.Rtc_Month = 0
    vFile.Rtc_Sec = 0
    vFile.Rtc_Year = 0
    vFile.Rtc_Year = 0
    vFile.Spec_Day = 0
    vFile.Spec_Hour = 0
    vFile.Spec_Month = 0
    vFile.Spec_Year = 0
    vFile.Tel_LocNo = ""
    For i = 1 To MAX_CAR
        vFile.Telephone(i) = ""
    Next i
    vFile.ver = 0
End Sub

Private Function DecodeVFile(byteVFile() As Byte) As Integer
    Dim bufPtr As Integer
    Dim Index As Integer
    Dim strTemp As String
    
    bufPtr = 2      ' DAS Id
    vFile.dasId = hexFormat(byteVFile(bufPtr)) + hexFormat(byteVFile(bufPtr + 1)) + "-" + _
                   hexFormat(byteVFile(bufPtr + 2)) + hexFormat(byteVFile(bufPtr + 3))
    
    bufPtr = bufPtr + 4  ' ȣ�� �������
    vFile.Dip_sw = byteVFile(bufPtr)
    
    bufPtr = bufPtr + 1  ' Max Car
    vFile.MaxCar = byteVFile(bufPtr)
    
    For Index = 1 To vFile.MaxCar
        vFile.Ga_Id(Index) = byteVFile(bufPtr + Index)          ' G/A ID(Max Car ������ŭ)
        vFile.Comm_State(Index) = byteVFile(bufPtr + vFile.MaxCar + Index)     ' ��� Error ����
        vFile.Maint_State(Index) = byteVFile(bufPtr + (vFile.MaxCar * 2) + Index)  ' ���˸�� ����
    Next Index
    
    bufPtr = bufPtr + (vFile.MaxCar * 3) + 1    ' Boot count
    vFile.Boot_Count = byteVFile(bufPtr) + byteVFile(bufPtr + 1) * &H100
    
    bufPtr = bufPtr + 2     ' ���� Boot Ƚ��
    vFile.Normal_BCount = byteVFile(bufPtr) + byteVFile(bufPtr + 1) * &H100
    
    bufPtr = bufPtr + 2     ' Modem ��� ����
    vFile.Modem_Use = byteVFile(bufPtr)
    
    bufPtr = bufPtr + 1     ' Boot�� ���� ���  �ð� (��)
    vFile.ETime_Boot = byteVFile(bufPtr) + byteVFile(bufPtr + 1) * &H100 + _
        byteVFile(bufPtr + 2) * &H10000 + byteVFile(bufPtr + 3) * &H1000000
    
    bufPtr = bufPtr + 4     ' Cold Boot�� �� ���� �ð� (��)
    vFile.ETime_ColdBoot = byteVFile(bufPtr) + byteVFile(bufPtr + 1) * &H100 + _
        byteVFile(bufPtr + 2) * &H10000 + byteVFile(bufPtr + 3) * &H1000000
    
    bufPtr = bufPtr + 4     ' ���� ����
    vFile.Power_State = byteVFile(bufPtr)
    
    bufPtr = bufPtr + 1     ' ��ȭ ������ȣ
    vFile.Tel_LocNo = GetStr(byteVFile(), bufPtr, 8)
    
    bufPtr = bufPtr + 8     ' ȣ��Ʈ ������ȣ
    vFile.Host_LocNo = GetStr(byteVFile(), bufPtr, 8)
    
    bufPtr = bufPtr + 8     ' ��ȭ��ȣ
    For Index = 1 To 8
        vFile.Telephone(Index) = GetStr(byteVFile(), bufPtr, 16)
        bufPtr = bufPtr + 16
    Next Index
    
    vFile.Spec_Hour = byteVFile(bufPtr)
    vFile.Spec_Day = byteVFile(bufPtr + 1)
    vFile.Spec_Month = byteVFile(bufPtr + 2)
    vFile.Spec_Year = byteVFile(bufPtr + 3)
    
    bufPtr = bufPtr + 4     ' Dip s/w 1
    vFile.Dip_sw1 = byteVFile(bufPtr)
    vFile.Dip_sw2 = byteVFile(bufPtr + 1)
    vFile.Dip_sw3 = byteVFile(bufPtr + 2)
    
    bufPtr = bufPtr + 3     ' ����� Ƚ��
    vFile.Comm_Count = byteVFile(bufPtr) + byteVFile(bufPtr + 1) * &H100 + _
        byteVFile(bufPtr + 2) * &H10000 + byteVFile(bufPtr + 3) * &H1000000
    
    bufPtr = bufPtr + 4     ' ����� ����Ƚ��
    vFile.Comm_SCount = byteVFile(bufPtr) + byteVFile(bufPtr + 1) * &H100 + _
        byteVFile(bufPtr + 2) * &H10000 + byteVFile(bufPtr + 3) * &H1000000
    
    bufPtr = bufPtr + 4     ' RTC year
    vFile.Rtc_Year = byteVFile(bufPtr) + (byteVFile(bufPtr + 1) * &H100)
    bufPtr = bufPtr + 2
    vFile.Rtc_Month = byteVFile(bufPtr) ' RTC month
    vFile.Rtc_Day = byteVFile(bufPtr + 1) ' RTC day
    vFile.Rtc_Hour = byteVFile(bufPtr + 2) ' RTC hour
    vFile.Rtc_Min = byteVFile(bufPtr + 3) ' RTC min
    vFile.Rtc_Sec = byteVFile(bufPtr + 4) ' RTC sec
    
    bufPtr = bufPtr + 5     ' DAS mode
    vFile.Das_Mode = GetStr(byteVFile(), bufPtr, 10)
    
    bufPtr = bufPtr + 10     ' DAS version
    vFile.Das_Version = GetStr(byteVFile(), bufPtr, 32)
    
    MDI.lstFile.AddItem "DAS Mode : " & vFile.Das_Mode
    MDI.lstFile.AddItem "DAS Version : " & vFile.Das_Version
    MDI.lstFile.AddItem "Decoding completed."
    MDI.lstFile.Refresh
    DecodeVFile = OK_SUCCESS
End Function
Private Function isDateOk(byteTrb() As Byte, ByVal Index%) As Boolean
    Dim yy$
    Dim mm$
    Dim dd$
    Dim hh$
    Dim mi$
    Dim ss$
    Dim strTime$
    Dim curDay As Date
    On Error GoTo ErrTrap
    yy = Format(byteTrb(Index + 0), "200#")
    mm = Format(byteTrb(Index + 1), "0#")
    dd = Format(byteTrb(Index + 2), "0#")
    hh = Format(byteTrb(Index + 3), "0#")
    mi = Format(byteTrb(Index + 4), "0#")
    ss = Format(byteTrb(Index + 5), "0#")
    strTime = mm + "/" + dd + "/" + yy + " " + hh + ":" + mi + ":" + ss
    curDay = CDate(strTime)
    isDateOk = True
    Exit Function
ErrTrap:
    isDateOk = False
End Function

' ���� �迭 byteTrb() -> trbBuf ������ ��� �Լ��δ�.
' �Ķ���� - ����迭, ���������̸�
' Return value - ���� : 1, ���� : �� ������ �ڵ�
Private Function Decode59(byteTrb() As Byte, ByVal strName$) As Integer
    Dim strTrb As String    ' ���� �迭 byteTrb() -> String ������ ��ȯ : Position�� ã�� ����
    Dim byteCarId As Byte   ' ȣ�� Index
    Dim intPtr As Integer   ' Position of searched string
    Dim offset As Integer   ' Offset
    Dim Index As Integer    ' ���� ��ġ ��, index = intPtr + offset
    Dim yy As String * 4    ' �ð�
    Dim mm As String * 2
    Dim dd As String * 2
    Dim hh As String * 2
    Dim mi As String * 2
    Dim ss As String * 2
    Dim strTime As String
    Dim strTmp As String
    Dim byteFinalState(0 To MAX_FILENO * 2 - 1) As Byte ' ����� EL ���� ���� = fileNo + mask
    Dim X As Integer
    Dim dateOk As Boolean
    
    ' TTrbInfo �� ��� ����
    strTrb = GetString(byteTrb(), FileLen(strName))     ' byteTrb() -> String ��ȯ
    trbbuf.CarNo = GetCarNo(strTrb)
    
    trbbuf.dasId = hexFormat(byteTrb(OFS_LOCH)) + hexFormat(byteTrb(OFS_LOCL)) + "-" + _
                   hexFormat(byteTrb(OFS_DASH)) + hexFormat(byteTrb(OFS_DASL))
    'Comment �ʱ�ȭ
    trbbuf.Comment = ""
    ' TCarInfo�� ��� ����
    For byteCarId = 1 To trbbuf.CarNo
        'Comment �ʱ�ȭ
        trbbuf.CarInfo(byteCarId).Comment = ""
        trbbuf.CarInfo(byteCarId).Customer = "����"    ' ���� �ʱ�ȭ
        trbbuf.CarInfo(byteCarId).REMRecNo = ""        'REM ������ȣ �ʱ�ȭ
        trbbuf.CarInfo(byteCarId).SICRecNo = ""        'SIC ������ȣ �ʱ�ȭ
        
        intPtr = GetPos(strTrb, "CODE_CARID", byteCarId)    ' CODE_CARID position�� ����
        If intPtr = 0 Then
            Decode59 = ERR_CODE_CARID
            Exit Function
        End If
        trbbuf.CarInfo(byteCarId).carId = byteTrb(intPtr)
        strTmp = "(C_ID) " & Str(trbbuf.CarInfo(byteCarId).carId)
        
        strTmp = strTmp & " (CURR) "
        intPtr = GetPos(strTrb, "CODE_CURR", byteCarId)     ' CODE_CURR position�� ����
        If intPtr = 0 Then
            Decode59 = ERR_CODE_CURR
            Exit Function
        End If
        trbbuf.CarInfo(byteCarId).CurrErrNo = byteTrb(intPtr)
        For offset = 1 To trbbuf.CarInfo(byteCarId).CurrErrNo
            trbbuf.CarInfo(byteCarId).CurrError(offset) = byteTrb(intPtr + offset)
            strTmp = strTmp & hexFormat(trbbuf.CarInfo(byteCarId).CurrError(offset)) & " "
        Next offset
        
        strTmp = strTmp & " (LAST) "
        intPtr = GetPos(strTrb, "CODE_LAST", byteCarId)     ' CODE_LAST position�� ����
        If intPtr = 0 Then
            Decode59 = ERR_CODE_LAST
            Exit Function
        End If
        trbbuf.CarInfo(byteCarId).LastErrNo = byteTrb(intPtr)
        For offset = 1 To trbbuf.CarInfo(byteCarId).LastErrNo
            trbbuf.CarInfo(byteCarId).LastError(offset) = byteTrb(intPtr + offset)
            strTmp = strTmp & hexFormat(trbbuf.CarInfo(byteCarId).LastError(offset)) & " "
        Next offset
        MDI.lstFile.AddItem strTmp
        MDI.lstFile.Refresh
        
        GetNewCodes byteCarId   ' �� �Լ��� �ݵ�� CODE_CURR, CODE_LAST�� ���� �� ���
        DataSort trbbuf.CarInfo(byteCarId).NewCodeNo, trbbuf.CarInfo(byteCarId).NewCodes()
        GetRcvCodes byteCarId
        MDI.lstFile.AddItem "(NEW #) " & Str(trbbuf.CarInfo(byteCarId).NewCodeNo) & _
                            " (RCV #) " & Str(trbbuf.CarInfo(byteCarId).RcvCodeNo) & _
                            " (HOLD #) " & Str(trbbuf.CarInfo(byteCarId).HoldCodeNo)

        intPtr = GetPos(strTrb, "CODE_FNST", byteCarId)     ' CODE_FNST position�� ����
        If intPtr = 0 Then
            Decode59 = ERR_CODE_FNST
            Exit Function
        End If
        yy = Format(byteTrb(intPtr + 0), "200#")
        mm = Format(byteTrb(intPtr + 1), "0#")
        dd = Format(byteTrb(intPtr + 2), "0#")
        hh = Format(byteTrb(intPtr + 3), "0#")
        mi = Format(byteTrb(intPtr + 4), "0#")
        ss = Format(byteTrb(intPtr + 5), "0#")
        strTime = mm + "/" + dd + "/" + yy + " " + hh + ":" + mi + ":" + ss
        
        dateOk = isDateOk(byteTrb, intPtr)
        
        On Error GoTo ErrTrap
        If trbbuf.CarInfo(byteCarId).CurrErrNo > 0 Then             ' ������ 0 �̸� �̷¸� ������ ���
            If dateOk Then
                trbbuf.CarInfo(byteCarId).FinalTime = CDate(strTime)
            Else
                trbbuf.CarInfo(byteCarId).Comment = "��¥ ������ ���� �ð����� �ٲ�"
                trbbuf.CarInfo(byteCarId).FinalTime = Now
            End If
        End If
        
        Index = intPtr + 5
        For offset = 0 To MAX_FILENO * 2 - 1                ' �߿�) FileNo ���� + Mask ���� ��� ����
            byteFinalState(offset) = byteTrb(Index + offset + 1)
        Next offset
        
        intPtr = GetPos(strTrb, "CODE_ERST", byteCarId)
        If intPtr = 0 Then
            Decode59 = ERR_CODE_ERST
            Exit Function
        End If
        For offset = 1 To MAX_ETC_59
            trbbuf.CarInfo(byteCarId).EtcState(offset) = byteTrb(intPtr + offset - 1)
        Next offset
        
        GetElStatus byteCarId, byteFinalState()     ' FNST, ERST�� ������ ����
        
        intPtr = GetPos(strTrb, "CODE_TRHT", byteCarId)
        If intPtr = 0 Then
            Decode59 = ERR_CODE_TRHT
            Exit Function
        End If
        trbbuf.CarInfo(byteCarId).ErrHistNo = byteTrb(intPtr)
        MDI.lstFile.AddItem "(HISTORY #) " & Str(trbbuf.CarInfo(byteCarId).ErrHistNo)
        For offset = 1 To trbbuf.CarInfo(byteCarId).ErrHistNo
            Index = intPtr + ((offset - 1) * 11)
            yy = Format(byteTrb(Index + 1), "200#")
            mm = Format(byteTrb(Index + 2), "0#")
            dd = Format(byteTrb(Index + 3), "0#")
            hh = Format(byteTrb(Index + 4), "0#")
            mi = Format(byteTrb(Index + 5), "0#")
            ss = Format(byteTrb(Index + 6), "0#")
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrMode = byteTrb(Index + 7)
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrCode = byteTrb(Index + 8)
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).Status0 = byteTrb(Index + 9)
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).Status1 = byteTrb(Index + 10)
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).Status2 = byteTrb(Index + 11)
            strTime = mm + "/" + dd + "/" + yy + " " + hh + ":" + mi + ":" + ss
            
            If isDateOk(byteTrb, Index + 1) Then
                trbbuf.CarInfo(byteCarId).ErrHistory(offset).occurTime = CDate(strTime)
            Else
                trbbuf.CarInfo(byteCarId).Comment = "��¥ ������ ���� �ð����� ����"
                trbbuf.CarInfo(byteCarId).ErrHistory(offset).occurTime = Now
            End If
            
            If trbbuf.ver >= VER_59 Then
                strTmp = strTime & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrMode) & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrCode) & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).Status0) & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).Status1) & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).Status2)
            ElseIf trbbuf.ver = VER_49 Then
                strTmp = strTime & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrMode) & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrCode)
            End If
            MDI.lstFile.AddItem strTmp
            MDI.lstFile.Refresh
        Next offset
        
        If (trbbuf.CarInfo(byteCarId).NewCodeNo > 0) And _
            (trbbuf.CarInfo(byteCarId).ErrHistNo > 0) Then
            GetSICCodes trbbuf.CarInfo(byteCarId)
        End If
    Next byteCarId
    
    Decode59 = OK_SUCCESS
    
    Exit Function
    
ErrTrap:
    Decode59 = ERR_TIME_CONV
End Function

' String���� "CODE_CARID" ���� ����
Private Function GetCarNo(ByVal strData$) As Byte
    Dim byteCar As Integer
    Dim myPos, startPos As Integer
    
    byteCar = 0
    startPos = 1
    Do
        myPos = InStr(startPos, strData, "CODE_CARID")
        If myPos = 0 Then
            Exit Do
        Else
            byteCar = byteCar + 1
            startPos = myPos + 1
        End If
    Loop
    
    GetCarNo = byteCar
End Function

' String���� ã�����ϴ� ���ڿ��� �ٷ� ���� position�� ����
' �� ����� ���ڿ����� ������ ����
' Example - ù��° ���ڿ��� �ٷ� ���� Position
' "xxxCODE_CARIDyy", "CODE_CARID", 1 -> 14
' Return value - ���� ã�� ���ϸ� 0
Private Function GetPos(ByVal strData, ByVal strSearch, ByVal byteSeq) As Integer
    Dim byteCur, startPos, myPos As Integer
    Dim boolResult As Boolean
    
    startPos = 1
    byteCur = 0
    Do
        myPos = InStr(startPos, strData, strSearch, vbBinaryCompare)
        If myPos > 0 Then
            byteCur = byteCur + 1
            If byteCur = byteSeq Then
                boolResult = True
                Exit Do
            Else
                startPos = myPos + 1
            End If
        Else
            boolResult = False
            Exit Do
        End If
    Loop
    
    If boolResult = True Then
        GetPos = myPos + Len(strSearch)
    Else
        GetPos = 0
    End If
End Function

' byte() -> String �� ����
Private Function GetString(byteData() As Byte, ByVal fSize As Integer) As String
    Dim strData$
    Dim i As Integer

    For i = 1 To fSize
        strData = strData + Chr(byteData(i))
    Next i
    GetString = strData
End Function

' byte() -> String �� ����
' �� ���Լ��� ������ġ�� ũ�⸦ ���� �� ����
Private Function GetStr(byteData() As Byte, sPoint As Integer, ByVal fSize As Integer) As String
    Dim strData As String
    Dim i As Integer

    For i = sPoint To sPoint + fSize
        If byteData(i) = 0 Then Exit For
        strData = strData + Chr(byteData(i))
    Next i
    GetStr = strData
End Function
' ���� �迭 byteTrb() -> trbBuf ������ ��� �Լ��δ�.
' Return value - ���� : 1, ���� : �� ������ �ڵ�
Private Function Decode49(byteTrb() As Byte, ByVal strName$) As Integer
    Dim strTrb As String    ' ���������� String ������ ����
    Dim byteCarId As Byte   ' ȣ�� Index
    Dim intPtr As Integer   ' Position of searched string
    Dim offset As Integer   ' Offset
    Dim Index As Integer    ' ���� ��ġ ��, index = intPtr + offset
    Dim yy As String * 4
    Dim mm As String * 2
    Dim dd As String * 2
    Dim hh As String * 2
    Dim mi As String * 2
    Dim ss As String * 2
    Dim strTime As String
    Dim strTmp As String
    Dim byteFinalState(0 To MAX_FILENO * 2 - 1) As Byte
    
    
    ' TTrbInfo �� ��� ����
    trbbuf.FileTime = CStr(Now)                         ' ó���ð�
    strTrb = GetString(byteTrb(), FileLen(strName))
    trbbuf.CarNo = GetCarNo(strTrb)
    
    trbbuf.dasId = hexFormat(byteTrb(OFS_LOCH)) + hexFormat(byteTrb(OFS_LOCL)) + "-" + _
                   hexFormat(byteTrb(OFS_DASH)) + hexFormat(byteTrb(OFS_DASL))
                   
    ' TCarInfo�� ��� ����
    For byteCarId = 1 To trbbuf.CarNo
        intPtr = GetPos(strTrb, "CODE_CARID", byteCarId)
        If intPtr = 0 Then
            Decode49 = ERR_CODE_CARID
            Exit Function
        End If
        trbbuf.CarInfo(byteCarId).carId = byteTrb(intPtr)
        strTmp = "(C_ID) " & Str(trbbuf.CarInfo(byteCarId).carId) & " (CURR) "
        
        trbbuf.CarInfo(byteCarId).CurrErrNo = byteTrb(intPtr + 1)
        For offset = 1 To trbbuf.CarInfo(byteCarId).CurrErrNo
            Index = intPtr + 1 + offset
            trbbuf.CarInfo(byteCarId).CurrError(offset) = byteTrb(Index)
            strTmp = strTmp & hexFormat(trbbuf.CarInfo(byteCarId).CurrError(offset)) & " "
        Next offset
        MDI.lstFile.AddItem strTmp
        MDI.lstFile.Refresh
        
        intPtr = GetPos(strTrb, "CODE_FNST", byteCarId)
        If intPtr = 0 Then
            Decode49 = ERR_CODE_FNST
            Exit Function
        End If
        yy = Format(byteTrb(intPtr + 0), "200#")
        mm = Format(byteTrb(intPtr + 1), "0#")
        dd = Format(byteTrb(intPtr + 2), "0#")
        hh = Format(byteTrb(intPtr + 3), "0#")
        mi = Format(byteTrb(intPtr + 4), "0#")
        ss = Format(byteTrb(intPtr + 5), "0#")
        strTime = mm + "/" + dd + "/" + yy + " " + hh + ":" + mi + ":" + ss
        
        On Error GoTo ErrTrap
        If trbbuf.CarInfo(byteCarId).CurrErrNo > 0 Then             ' ������ 0 �̸� �̷¸� ������ ���
            trbbuf.CarInfo(byteCarId).FinalTime = CDate(strTime)    ' �̶� �ð��� 0���� �´�.
        End If
        
        Index = intPtr + 5
        For offset = 0 To MAX_FILENO * 2 - 1
            byteFinalState(offset) = byteTrb(Index + offset + 1)
        Next offset
        
        intPtr = GetPos(strTrb, "CODE_ERST", byteCarId)
        If intPtr = 0 Then
            Decode49 = ERR_CODE_ERST
            Exit Function
        End If
        For offset = 1 To MAX_ETC_49
            trbbuf.CarInfo(byteCarId).EtcState(offset) = byteTrb(intPtr + offset - 1)
        Next offset
        
        GetElStatus byteCarId, byteFinalState()     ' FNST, ERST�� ������ ����
        
        intPtr = GetPos(strTrb, "CODE_TRHT", byteCarId)
        If intPtr = 0 Then
            Decode49 = ERR_CODE_TRHT
            Exit Function
        End If
        trbbuf.CarInfo(byteCarId).ErrHistNo = byteTrb(intPtr)
        MDI.lstFile.AddItem "(HISTORY #) " & Str(trbbuf.CarInfo(byteCarId).ErrHistNo)
        For offset = 1 To trbbuf.CarInfo(byteCarId).ErrHistNo
            Index = intPtr + ((offset - 1) * 8)
            yy = Format(byteTrb(Index + 1), "200#")
            mm = Format(byteTrb(Index + 2), "0#")
            dd = Format(byteTrb(Index + 3), "0#")
            hh = Format(byteTrb(Index + 4), "0#")
            mi = Format(byteTrb(Index + 5), "0#")
            ss = Format(byteTrb(Index + 6), "0#")
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrMode = byteTrb(Index + 7)
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrCode = byteTrb(Index + 8)
            strTime = mm + "/" + dd + "/" + yy + " " + hh + ":" + mi + ":" + ss
            trbbuf.CarInfo(byteCarId).ErrHistory(offset).occurTime = CDate(strTime)
            MDI.lstFile.AddItem strTime & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrMode) & " " & _
                    hexFormat(trbbuf.CarInfo(byteCarId).ErrHistory(offset).ErrCode)
            MDI.lstFile.Refresh
        Next offset
        
        If trbbuf.CarInfo(byteCarId).ErrHistNo > 0 Then
            GetSICCodes trbbuf.CarInfo(byteCarId)
        End If
    Next byteCarId
    
    Decode49 = OK_SUCCESS
    
    Exit Function
    
ErrTrap:
    Decode49 = ERR_TIME_CONV
End Function

' �� �Լ��� �������¿� Mask ���·κ��� ����� EL ���� ���¸� ���Ѵ�.
' �Ķ���� - index 1 ~ 8, �������� : 0x00 ~ 0xff (MASK ���� ���� ����)
' ����) DAS�κ��� �ö���� FileNo�� 0x00 ~ 0x7f, Mask�� 0x00 ~ 0x7f
'       �׷���, ���������� FilNo 1���� ���� ����
Private Sub GetElStatus(ByVal byteCar As Byte, byteFinal() As Byte)
    Dim display As Boolean
    Dim strTmp As String

    ' �����
    trbbuf.CarInfo(byteCar).StartFl = trbbuf.CarInfo(byteCar).EtcState(START_FLOOR)
    
    ' ������
    trbbuf.CarInfo(byteCar).CurrFl = byteFinal(FN_N900)
    
    ' ���� ȸ�� Ȯ�� - [S], [R], [ ]
    
    If (byteFinal(MAX_FILENO + FN_X50BC) And &H8) = &H8 Then    ' Masked
        trbbuf.CarInfo(byteCar).Safety = " "
    Else
        If (byteFinal(FN_X50BC) And &H8) = &H8 Then
            trbbuf.CarInfo(byteCar).Safety = "S"
        Else
            trbbuf.CarInfo(byteCar).Safety = "R"
        End If
    End If
    
    ' EMERGENCY STOP - [S], [R], [ ]
    If (byteFinal(MAX_FILENO + FN_XCUT) And &H1) = &H1 Then     'Masked
        trbbuf.CarInfo(byteCar).EStop = " "
    Else
        If (byteFinal(FN_XCUT) And &H1) = &H1 Then
            trbbuf.CarInfo(byteCar).EStop = "S"
        Else
            trbbuf.CarInfo(byteCar).EStop = "R"
        End If
    End If
    
    ' CAR LOAD(%)
    trbbuf.CarInfo(byteCar).CarLoad = byteFinal(FN_Z65RG)
    
    ' FML �Է� - [I], [O], [ ]
    If (byteFinal(MAX_FILENO + FN_XFML) And &H20) = &H20 Then
        trbbuf.CarInfo(byteCar).Zone = " "
    Else
        If (byteFinal(FN_XFML) And &H20) = &H20 Then
            trbbuf.CarInfo(byteCar).Zone = "I"
        Else
            trbbuf.CarInfo(byteCar).Zone = "O"
        End If
    End If
    
    ' DOOR OPNE/CLOSE Ȯ��  - [O], [C], [N], [ ]
    If (byteFinal(FN_XOLS) And &H20) = &H20 Then
        trbbuf.CarInfo(byteCar).Door = "O"
    Else
        trbbuf.CarInfo(byteCar).Door = "N"
    End If
    If (byteFinal(FN_ZX40G) And &H40) = &H40 Then
        trbbuf.CarInfo(byteCar).Door = "C"
    Else
        trbbuf.CarInfo(byteCar).Door = "N"
    End If
    If ((byteFinal(MAX_FILENO + FN_XOLS) And &H20) = &H20) And _
       ((byteFinal(MAX_FILENO + FN_ZX40G) And &H40) = &H40) Then
        trbbuf.CarInfo(byteCar).Door = " "
    End If
    
    ' UP/DOWN ����� - [U], [D], [N], [ ]
    If (byteFinal(FN_Z61LP) And &H4) = &H4 Then
        trbbuf.CarInfo(byteCar).Dir = "U"
    Else
        trbbuf.CarInfo(byteCar).Dir = "N"
    End If
    If (byteFinal(FN_Z62LP) And &H8) = &H8 Then
        trbbuf.CarInfo(byteCar).Dir = "D"
    Else
        trbbuf.CarInfo(byteCar).Dir = "N"
    End If
    If ((byteFinal(MAX_FILENO + FN_Z61LP) And &H4) = &H4) And _
       ((byteFinal(MAX_FILENO + FN_Z62LP) And &H8) = &H8) Then  ' �� �� Masked
        trbbuf.CarInfo(byteCar).Dir = " "
    End If
    
    If trbbuf.ver >= VER_59 And trbbuf.CarInfo(byteCar).NewCodeNo > 0 Then   ' �ű԰����� ���
        display = True
    ElseIf trbbuf.ver = VER_49 And trbbuf.CarInfo(byteCar).CurrErrNo > 1 Then
        display = True
    ElseIf trbbuf.ver = VER_49 And trbbuf.CarInfo(byteCar).CurrErrNo = 1 And _
        trbbuf.CarInfo(byteCar).CurrError(1) <> 0 Then          ' ������ �ƴ� ���
        display = True
    Else
        display = False
    End If
    
    If display = True Then
        strTmp = Str(trbbuf.CarInfo(byteCar).StartFl) & " -> "
        strTmp = strTmp + Str(trbbuf.CarInfo(byteCar).CurrFl)
        strTmp = strTmp + " (S)" & trbbuf.CarInfo(byteCar).Safety
        strTmp = strTmp + " (C)" & Str(trbbuf.CarInfo(byteCar).CarLoad) & "%"
        strTmp = strTmp + " (Z)" & trbbuf.CarInfo(byteCar).Zone
        strTmp = strTmp + " (D) " & trbbuf.CarInfo(byteCar).Door
        strTmp = strTmp + " (L) " & trbbuf.CarInfo(byteCar).Dir
        MDI.lstFile.AddItem strTmp
    End If
End Sub

' �� �Լ��� �ű԰���, ���������� ����
' CODE_CURR�� ������ CODE_LAST �����ڵ� ����Ʈ�� ������ �ű�
' ����) Ver 49���� ������ �� ����
Private Sub GetNewCodes(ByVal byteCar As Byte)
    Dim X As Integer
    Dim Y As Integer
    Dim curErr As Byte
    Dim lastErr As Byte
    Dim Index As Integer
    Dim bolFlag As Boolean
           
    For X = 1 To trbbuf.CarInfo(byteCar).CurrErrNo
        curErr = trbbuf.CarInfo(byteCar).CurrError(X)           ' CODE_CURR���� �� ������ ����
        If curErr <> 0 Then     ' �����ڵ� 0�� ��� ����
            bolFlag = False
            For Y = 1 To trbbuf.CarInfo(byteCar).LastErrNo      ' CODE_LAST ���� ����Ʈ�� Search
                lastErr = trbbuf.CarInfo(byteCar).LastError(Y)
                If curErr = lastErr Then
                    bolFlag = True
                    Exit For
                End If
            Next Y
            If bolFlag = False Then     ' �� ��� ������ �ű԰��� ����Ʈ�� �߰�
                trbbuf.CarInfo(byteCar).NewCodeNo = trbbuf.CarInfo(byteCar).NewCodeNo + 1
                Index = trbbuf.CarInfo(byteCar).NewCodeNo
                trbbuf.CarInfo(byteCar).NewCodes(Index) = curErr
            Else                        ' �� ��� ������ �������� ����Ʈ�� �߰�
                trbbuf.CarInfo(byteCar).HoldCodeNo = trbbuf.CarInfo(byteCar).HoldCodeNo + 1
                Index = trbbuf.CarInfo(byteCar).HoldCodeNo
                trbbuf.CarInfo(byteCar).HoldCodes(Index) = curErr
            End If
        End If
    Next X
End Sub

' �������, ���Ű��� -> �����ڵ带 ����
' CODE_LAST�� ������ CODE_CURR �����ڵ� ����Ʈ�� ������ ����
' ����) Ver 49���� ������ �� ����
Private Sub GetRcvCodes(ByVal byteCar As Byte)
    Dim X As Integer
    Dim Y As Integer
    Dim curErr As Byte
    Dim lastErr As Byte
    Dim Index As Integer
    Dim bolFlag As Boolean
    
    For X = 1 To trbbuf.CarInfo(byteCar).LastErrNo
        lastErr = trbbuf.CarInfo(byteCar).LastError(X)      ' CODE_LAST���� �� ������ ����
        If lastErr <> 0 Then    ' �����ڵ� 0�� ��� ����
            bolFlag = False
            For Y = 1 To trbbuf.CarInfo(byteCar).CurrErrNo      ' CODE_CURR ���� ����Ʈ�� Search
                curErr = trbbuf.CarInfo(byteCar).CurrError(Y)
                If lastErr = curErr Then
                    bolFlag = True
                    Exit For
                End If
            Next Y
            If bolFlag = False Then         ' �� ��� ������ �������� ����Ʈ�� �߰�
                trbbuf.CarInfo(byteCar).RcvCodeNo = trbbuf.CarInfo(byteCar).RcvCodeNo + 1
                Index = trbbuf.CarInfo(byteCar).RcvCodeNo
                trbbuf.CarInfo(byteCar).RcvCodes(Index) = lastErr
            End If
        End If
    Next X
End Sub

' Sort
Private Sub DataSort(ByVal CodeNo As Byte, ByRef codes() As Byte)
    Dim i As Integer
    Dim J As Integer
    Dim imsi As Byte
    
    If CodeNo <= 1 Then Exit Sub
    
    codes(CodeNo + 1) = MAX_SORT
    For J = 1 To CodeNo
      For i = J + 1 To CodeNo + 1
          If codes(J) > codes(i) Then
               imsi = codes(J)
               codes(J) = codes(i)
               codes(i) = imsi
          End If
      Next i
    Next J
End Sub

' �������Ϳ� ������ �ֱ� 5���� ������ ����
Private Sub GetSICCodes(ByRef car As TCarInfo)
    Dim Index As Integer
    Dim mode As String * 2  ' ������
    Dim code As String * 2  ' �����ڵ�
    
    car.SICErrNo = 2
    For Index = car.ErrHistNo To 1 Step -1
        mode = Hex(car.ErrHistory(Index).ErrMode)
        code = Hex(car.ErrHistory(Index).ErrCode)
        If (mode = "F1") And (Trim(code) <> "0") Then
            car.SICError(car.SICErrNo) = car.ErrHistory(Index).ErrCode
            car.SICErrNo = car.SICErrNo + 1
        End If
        If car.SICErrNo > 6 Then Exit For
    Next Index
End Sub

' �ٹ� ���� Check
Private Function GetMultiOccur(ByVal dasId As String) As String
    Dim Index As Integer
    Dim Count As Integer
    
    If dasId = "" Then
        GetMultiOccur = ""
        Exit Function
    End If
    
    For Index = 1 To MAX_TRB_HISTORY
        If (dasId = trbHist(Index).dasId) Then
            Count = Count + 1
        End If
    Next Index
    
    If Count > comm.Multi Then  ' �ٹ� ����
        GetMultiOccur = dasId
    Else
        GetMultiOccur = ""
    End If
End Function

'+++++++++++++++++++++++++++++++++
' ���Ͽ� ���� �⺻���� ó���Լ���
' �����ϰ� �ִ�
'+++++++++++++++++++++++++++++++++

' String -> Hex String ��ȯ
Public Function HexString(X$) As String
   Dim i As Integer
   Dim Y As String
   
   Y = ""
   For i = 1 To Len(X)
       Y = Y & Right("00" & Hex(Asc(Mid(X, i, 1))), 2) & " "
   Next i
   HexString = Y
End Function

' �� �Լ��� ������ �о� Byte() ����
' �Ķ���� - ���� �̸�
' Return value - byte()
Public Function ReadData(ByVal strName$) As Byte()
    Dim byteBuf() As Byte
    Dim f As Integer        ' File pointer
    Dim bufPtr As Integer   ' Buffer Pointer
    
    On Error GoTo ErrTrap
    
    f = FreeFile()          ' ������� �ʴ� ���Ϲ�ȣ�� ��´�.
    Open strName For Binary As f
    
    ReDim byteBuf(LOF(f))   ' ���� ũ�⸦ �о� �����迭 �缱��
    
    bufPtr = 1
    Do
        Get f, , byteBuf(bufPtr)
        If bufPtr = LOF(f) Then Exit Do
        bufPtr = bufPtr + 1
    Loop
    Close f
    
    ReadData = byteBuf      ' �����迭 return ���
    
    Exit Function

ErrTrap:
    
End Function

' Full path -> Fle name ����
' StripPath("c:\windows\hello.txt") -> hello.txt
Public Function StripPath(T$) As String
    Dim X%, ct%
    
    StripPath$ = T$
    X% = InStr(T$, "\")
    Do While X%
        ct% = X%
        X% = InStr(ct% + 1, T$, "\")
    Loop
    If ct% > 0 Then StripPath$ = Mid$(T$, ct% + 1)
End Function

Public Function GetPath(T$) As String
    Dim X%, ct%
    GetPath$ = T$
    X% = InStr(T$, "\")
    Do While X%
        ct% = X%
        X% = InStr(ct% + 1, T$, "\")
    Loop
    If ct% > 0 Then GetPath$ = Mid$(T$, 1, ct% - 1)
End Function

' Path + File name ���̱�
' ����, Path�� ""�̸� Default�� ���� �������α׷��� path
Public Function AddPath(path, file) As String
   Dim xPath As String
   
   If path = "" Then
       xPath = App.path
   Else
       xPath = path
   End If
       
   If Right(xPath, 1) <> "\" Then
       AddPath = xPath & "\" & file
   Else
       AddPath = xPath & file
   End If
End Function

' File move
' �Ķ���� - source, destination
' Retuen value - ���� : True, ���� : False
Public Function MoveFile(Source As String, Destination As String) As Boolean
   On Error GoTo MoveError
   Dim DestPath$
   DestPath = GetPath(Destination)
   If Dir(DestPath, vbDirectory) = "" Then
        MkDir (DestPath)
   End If
   FileCopy Source, Destination
   Kill Source
   MoveFile = True
   Exit Function

MoveError:
   WriteUDPLog "Move Fail->", Err.Description
'   jsrSrc = Source
'   jsrDes = Destination
'   MDI.jsrTimer.Enabled = True
   MoveFile = False
End Function

' byte -> 2�ڸ� Hex String ����
Public Function hexFormat(ByVal byteData As Byte) As String
    Dim i As Byte
    Dim strTemp As String
    
    strTemp = Hex(byteData)
    For i = Len(strTemp) To 1
        strTemp = "0" & strTemp
    Next i
    hexFormat = strTemp
End Function

' UDP data �� �޾����� ����� IP�� �޽����� ����
Public Sub WriteUDPLog(ByVal RemoteIP As String, ByVal Msg As String)
    Dim f As Integer
    Dim i As Integer
    Dim J As Integer
    Dim strMsg As String
    Dim strSrc As String
    Dim strDes As String
    Dim wFlag As Boolean
    
    'If intVal < 1 Then Exit Sub '�ƹ��͵� ó�� ����
    
    strSrc = AddPath("C:\inetpub\wwwroot\", "Messages.txt")
    strDes = AddPath("C:\inetpub\wwwroot\", "Messages0.txt")
    
    strMsg = RemoteIP & " : " & Msg
    
    If Dir(strSrc) <> Empty Then            ' ������ �ִ� ��츸 ũ�⸦ �˻�
        If FileLen(strSrc) > 64000 Then     ' 64KB�� �ʰ��ϸ� copy
            FileCopy strSrc, strDes
            Kill strSrc
        End If
    End If
    f = FreeFile                            ' Write contents to file
    Open strSrc For Append As f
    Print #f, strMsg
    Close f
End Sub
