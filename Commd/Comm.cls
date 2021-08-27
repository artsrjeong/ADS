VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsComm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "���� ó�� ����� ����\r\n��ü �Ǽ�, ���� �Ǽ�, �������� ���� �Ǽ�, ���� �Ǽ�\r\n�ٹ� ����, ������ ����"
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Const TYP_TOTAL = 1
Const TYP_SUCCESS = 2
Const TYP_FAIL = 3
Const TYP_SERVICE = 4
Const TYP_SUBTOTAL = 5

Public Total As Long            ' ��ü �Ǽ�
Attribute Total.VB_VarDescription = "���α׷� ���� �ĺ���\r\n�� ���α׷����κ��� ���Ź��� ���� ���� ����"
Public Success As Long          ' ���� �Ǽ�
Attribute Success.VB_VarDescription = "��ü �Ǽ� �߿��� ���������� ó���� �Ǽ�"
Public Fail As Long             ' ���� �Ǽ�
Attribute Fail.VB_VarDescription = "��ü �� �� �߿��� ���������� ó�� ���� ���� �� ��"
Public Service As Long          ' �������� ���� �Ǽ�
Attribute Service.VB_VarDescription = "�������Ϳ� ������ �� ��"
Public ContinuedFail As String  ' �ٹ� ���� ����
Attribute ContinuedFail.VB_VarDescription = "�ٹ� ���� ����"
Public LastError As String      ' ������ ���� ����
Attribute LastError.VB_VarDescription = "���������� ���� ó������ ���� ���� ����"
Public SubTotal As Long         ' �� ȣ�⺰ ó�� �Ǽ�
Attribute SubTotal.VB_VarDescription = "�� ȣ�⺰ ó���Ǽ�"
Public Multi As Integer         ' �ٹ߰��� ���� �Ǽ�
Attribute Multi.VB_VarDescription = "�ٹ� ���� ���� �Ǽ�"
Public AutoConn As Byte         ' DB �ڵ����� Flag
Attribute AutoConn.VB_VarDescription = "DB �ڵ����� Flag"
Public TestIn As Byte           ' �׽�Ʈ DB �Է�
Public SICInsert As Byte        ' �������� ���������� ����
Attribute SICInsert.VB_VarDescription = "�������Ϳ� ���������� ����"


' ������ �� �� ����
Public Sub IncCount(ByVal ValType As Byte)
Attribute IncCount.VB_Description = "�Ķ���Ϳ� �ش��ϴ� ������ ���� ����"
Attribute IncCount.VB_UserMemId = 0
    Select Case ValType
        Case TYP_TOTAL
            Total = Total + 1
        Case TYP_SUCCESS
            Success = Success + 1
        Case TYP_FAIL
            Fail = Fail + 1
        Case TYP_SERVICE
            Service = Service + 1
        Case TYP_SUBTOTAL
            SubTotal = SubTotal + 1
    End Select
End Sub

' Ŭ���� �ʱ�ȭ
Private Sub Class_Initialize()
    Dim strTmp As String
    
    Total = 0
    Success = 0
    Fail = 0
    Service = 0
    SubTotal = 0
    SICInsert = 0
    ContinuedFail = ""
    LastError = ""
    Multi = GetSetting("Commd", "Etc", "Multi", 10)
    strTmp = GetSetting("Commd", "Etc", "AutoConn", "00")
    If strTmp = "00" Then
        AutoConn = 0
    Else
        AutoConn = 1
    End If
    TestIn = 0
End Sub