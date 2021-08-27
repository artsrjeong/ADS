; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CPC_LDRView
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "PC_LDR.h"
LastPage=0

ClassCount=7
Class1=CPC_LDRApp
Class2=CPC_LDRDoc
Class3=CPC_LDRView
Class4=CMainFrame

ResourceCount=5
Resource1=IDR_MAINFRAME
Resource2=IDD_ABOUTBOX
Class5=CAboutDlg
Class6=CMyListCtrl
Resource3=IDD_PC_LDR_FORM
Class7=CDataInDlg
Resource4=IDR_LIST_MENU
Resource5=IDD_DATAIN_DLG

[CLS:CPC_LDRApp]
Type=0
HeaderFile=PC_LDR.h
ImplementationFile=PC_LDR.cpp
Filter=N
LastObject=CPC_LDRApp
BaseClass=CWinApp
VirtualFilter=AC

[CLS:CPC_LDRDoc]
Type=0
HeaderFile=PC_LDRDoc.h
ImplementationFile=PC_LDRDoc.cpp
Filter=N
LastObject=CPC_LDRDoc

[CLS:CPC_LDRView]
Type=0
HeaderFile=PC_LDRView.h
ImplementationFile=PC_LDRView.cpp
Filter=D
LastObject=IDC_DATA_SET
BaseClass=CFormView
VirtualFilter=VWC


[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T
LastObject=ID_EDIT_COPY
BaseClass=CFrameWnd
VirtualFilter=fWC




[CLS:CAboutDlg]
Type=0
HeaderFile=PC_LDR.cpp
ImplementationFile=PC_LDR.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_OPEN
Command2=ID_FILE_SAVE
Command3=ID_FILE_MRU_FILE1
Command4=ID_APP_EXIT
Command5=IDM_COM1
Command6=IDM_COM2
Command7=ID_VIEW_TOOLBAR
Command8=ID_VIEW_STATUS_BAR
Command9=ID_APP_ABOUT
CommandCount=9

[ACL:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_FILE_PRINT
Command5=ID_EDIT_UNDO
Command6=ID_EDIT_CUT
Command7=ID_EDIT_COPY
Command8=ID_EDIT_PASTE
Command9=ID_EDIT_UNDO
Command10=ID_EDIT_CUT
Command11=ID_EDIT_COPY
Command12=ID_EDIT_PASTE
Command13=ID_NEXT_PANE
Command14=ID_PREV_PANE
CommandCount=14

[DLG:IDD_PC_LDR_FORM]
Type=1
Class=CPC_LDRView
ControlCount=55
Control1=IDC_VAR_LIST,SysListView32,1350631425
Control2=IDC_COMM_EN,button,1342242819
Control3=IDC_DISP,edit,1350631552
Control4=IDC_MAPFILE_NAME,static,1342308864
Control5=IDC_GROUP,combobox,1342242819
Control6=IDC_IDX,edit,1350639618
Control7=IDC_DATA,edit,1350633602
Control8=IDC_DATA_SET,edit,1350631554
Control9=IDC_FWD_RUN,button,1342242816
Control10=IDC_STOP,button,1342242816
Control11=IDC_REV_RUN,button,1342242816
Control12=IDC_SET,button,1342242816
Control13=IDC_STATIC,static,1342308864
Control14=IDC_STATIC,static,1342308864
Control15=IDC_STATIC,static,1342308864
Control16=IDC_STATIC,static,1342308864
Control17=IDC_STATIC,static,1342308864
Control18=IDC_STATIC,static,1342308864
Control19=IDC_OutFreq,static,1342308866
Control20=IDC_RefFreq,static,1342308866
Control21=IDC_OutCur,static,1342308866
Control22=IDC_OutV,static,1342308866
Control23=IDC_DCV,static,1342308866
Control24=IDC_TRIP,static,1342308866
Control25=IDC_STATIC,static,1342308864
Control26=IDC_STATIC,static,1342308864
Control27=IDC_STATIC,static,1342308864
Control28=IDC_STATIC,static,1342308864
Control29=IDC_STATIC,static,1342308864
Control30=IDC_STATIC,static,1342308864
Control31=IDC_VER,static,1342308866
Control32=IDC_COMM,static,1342308865
Control33=IDC_PROGRESS,msctls_progress32,1350565888
Control34=IDC_PARA_SAVE,button,1342242816
Control35=IDC_PARA_INIT,button,1342242816
Control36=IDC_STATIC,static,1342308865
Control37=IDC_STATIC,static,1342308865
Control38=IDC_STATIC,static,1342308865
Control39=IDC_STATIC,static,1342308865
Control40=IDC_STATIC,static,1342308864
Control41=IDC_PORT_IN,static,1342308866
Control42=IDC_LED_CLOSE,static,1342177288
Control43=IDC_LED_OPEN,static,1342177288
Control44=IDC_LED_NUDGE,static,1342177288
Control45=IDC_LED_HCL,static,1342177288
Control46=IDC_DO2,button,1342242816
Control47=IDC_DO3,button,1342242816
Control48=IDC_DO4,button,1342242816
Control49=IDC_DO5,button,1342242816
Control50=IDC_CLEAR,button,1342242816
Control51=IDC_DO12,button,1342242816
Control52=IDC_DO13,button,1342242816
Control53=IDC_DO15,button,1342242816
Control54=IDC_CLEAR2,button,1342242816
Control55=IDC_DO_READY,button,1342242816

[TB:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_OPEN
Command2=ID_FILE_SAVE
Command3=ID_FILE_PRINT
Command4=ID_APP_ABOUT
Command5=ID_RELOAD
CommandCount=5

[CLS:CMyListCtrl]
Type=0
HeaderFile=MyListCtrl.h
ImplementationFile=MyListCtrl.cpp
BaseClass=CListCtrl
Filter=W
LastObject=CMyListCtrl
VirtualFilter=FWC

[DLG:IDD_DATAIN_DLG]
Type=1
Class=CDataInDlg
ControlCount=4
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308864
Control4=IDC_DATA2,edit,1350631554

[CLS:CDataInDlg]
Type=0
HeaderFile=DataInDlg.h
ImplementationFile=DataInDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=ID_APP_ABOUT
VirtualFilter=dWC

[MNU:IDR_LIST_MENU]
Type=1
Class=CPC_LDRView
Command1=IDM_SET_DATA
Command2=IMD_UP
Command3=IDM_DOWN
Command4=IDM_DEL
Command5=IDM_DEL_ALL
Command6=IDM_SET_INT
Command7=IDM_SET_UINT
Command8=IDM_SET_BIN
Command9=IDM_SET_HEX
CommandCount=9

