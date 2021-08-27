// PC_LDRView.cpp : implementation of the CPC_LDRView class
//

#include "stdafx.h"
#include "PC_LDR.h"

#include "PC_LDRDoc.h"
#include "PC_LDRView.h"

#include "DataInDlg.h"
#include "led.h"

#include "Mintr.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#include "direct.h"

#include "MainFrm.h"
/////////////////////////////////////////////////////////////////////////////
// CPC_LDRView

IMPLEMENT_DYNCREATE(CPC_LDRView, CFormView)

BEGIN_MESSAGE_MAP(CPC_LDRView, CFormView)
	//{{AFX_MSG_MAP(CPC_LDRView)
	ON_COMMAND(IDM_COM1, OnCom1)
	ON_COMMAND(IDM_COM2, OnCom2)
	ON_BN_CLICKED(IDC_COMM_EN, OnCommEn)
	ON_WM_TIMER()
	ON_COMMAND(IDM_DEL, OnDel)
	ON_COMMAND(IDM_DOWN, OnDown)
	ON_COMMAND(IDM_SET_DATA, OnSetData)
	ON_COMMAND(IDM_SET_INT, OnSetInt)
	ON_COMMAND(IDM_SET_UINT, OnSetUint)
	ON_COMMAND(IMD_UP, OnUp)
	ON_COMMAND(IDM_SET_BIN, OnSetBin)
	ON_COMMAND(IDM_SET_HEX, OnSetHex)
	ON_COMMAND(ID_FILE_NEW, OnFileNew)
	ON_UPDATE_COMMAND_UI(IDM_COM1, OnUpdateCom1)
	ON_UPDATE_COMMAND_UI(IDM_COM2, OnUpdateCom2)
	ON_WM_DESTROY()
	ON_COMMAND(IDM_DEL_ALL, OnDelAll)
	ON_COMMAND(ID_RELOAD, OnReload)
	ON_CBN_SELCHANGE(IDC_GROUP, OnSelchangeGroup)
	ON_BN_CLICKED(IDC_SET, OnSet)
	ON_BN_CLICKED(IDC_STOP, OnStop)
	ON_BN_CLICKED(IDC_FWD_RUN, OnFwdRun)
	ON_BN_CLICKED(IDC_REV_RUN, OnRevRun)
	ON_COMMAND(ID_FILE_OPEN, OnFileOpen)
	ON_COMMAND(ID_FILE_SAVE, OnFileSave)
	ON_COMMAND(ID_APP_EXIT, OnAppExit)
	ON_BN_CLICKED(IDC_PARA_SAVE, OnParaSave)
	ON_BN_CLICKED(IDC_PARA_INIT, OnParaInit)
	ON_BN_CLICKED(IDC_DO2, OnDo2)
	ON_BN_CLICKED(IDC_DO3, OnDo3)
	ON_BN_CLICKED(IDC_DO4, OnDo4)
	ON_BN_CLICKED(IDC_DO5, OnDo5)
	ON_BN_CLICKED(IDC_CLEAR, OnClear)
	ON_BN_CLICKED(IDC_DO12, OnDo12)
	ON_BN_CLICKED(IDC_DO13, OnDo13)
	ON_BN_CLICKED(IDC_DO15, OnDo15)
	ON_BN_CLICKED(IDC_CLEAR2, OnClear2)
	ON_BN_CLICKED(IDC_DO_READY, OnDoReady)
	//}}AFX_MSG_MAP
	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, CFormView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CFormView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CFormView::OnFilePrintPreview)
	ON_MESSAGE(WM_RECEIVEDATA, OnReceiveData)

END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRView construction/destruction

CPC_LDRView::CPC_LDRView()
	: CFormView(CPC_LDRView::IDD)
{
	//{{AFX_DATA_INIT(CPC_LDRView)
	m_bCommEn = FALSE;
	m_disp = _T("");
	m_sSelVari = _T("");
	m_iDataSet = _T("0");
	m_wData = _T("");
	m_wIndexSet = _T("0");
	//}}AFX_DATA_INIT
	// TODO: add construction code here

}


CPC_LDRView::~CPC_LDRView()
{
/*	FILE *fp;
	fp = fopen(m_init_path,"wt");

	fprintf(fp,"%d\r\n",m_iPort);
	fprintf(fp,"%s\r\n",m_sFileDir);
	fprintf(fp,"%s\r\n",m_sMapFileName);
	CMyListCtrl *listTmp;
	listTmp = &m_listCtrl;

	for(int i=0;i<listCnt;i++){
		CString sTmp;
		sTmp = m_listCtrl.GetItemText(i,0);
		fprintf(fp,"%s\r\n",sTmp);
		sTmp = m_listCtrl.GetItemText(i,1);
		fprintf(fp,"%s\r\n",sTmp);
		sTmp = m_listCtrl.GetItemText(i,3);
		fprintf(fp,"%s\r\n",sTmp);
	}

	fclose(fp);	
*/
}

void CPC_LDRView::DoDataExchange(CDataExchange* pDX)
{
	CFormView::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPC_LDRView)
	DDX_Control(pDX, IDC_LED_OPEN, m_led_open);
	DDX_Control(pDX, IDC_LED_NUDGE, m_led_nudge);
	DDX_Control(pDX, IDC_LED_HCL, m_led_hcl);
	DDX_Control(pDX, IDC_LED_CLOSE, m_led_close);
	DDX_Control(pDX, IDC_PROGRESS, m_Progress);
	DDX_Control(pDX, IDC_GROUP, m_GroupSet);
	DDX_Control(pDX, IDC_VAR_LIST, m_listCtrl);
	DDX_Check(pDX, IDC_COMM_EN, m_bCommEn);
	DDX_Text(pDX, IDC_DISP, m_disp);
	DDX_Text(pDX, IDC_DATA_SET, m_iDataSet);
	DDX_Text(pDX, IDC_DATA, m_wData);
	DDX_Text(pDX, IDC_IDX, m_wIndexSet);
	//}}AFX_DATA_MAP
}

BOOL CPC_LDRView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CFormView::PreCreateWindow(cs);
}


void CPC_LDRView::OnInitialUpdate()
{
	CFormView::OnInitialUpdate();
	GetParentFrame()->RecalcLayout();
	ResizeParentToFit();

 	m_listCtrl.SetExtendedStyle(LVS_EX_GRIDLINES | LVS_EX_FULLROWSELECT ); 
//	MinTrace("OK!!!\n");

	LV_COLUMN lvcolumn;
	char *listcolumn[5] = {"Var. Name", "Addr", "Data","Unit","Data@File"};

	int width[5] = {120, 0, 80,80,80};

	lvcolumn.mask = LVCF_FMT | LVCF_SUBITEM | LVCF_TEXT | LVCF_WIDTH ;
	lvcolumn.fmt = LVCFMT_CENTER;

	Dec10[0] = 1;
	Dec10[1] = 10;
	Dec10[2] = 100;
	Dec10[3] = 1000;

//	DgrAddr[0] = 0x1019;
//	DgrAddr[1] = 0x101a;
//	DgrAddr[2] = 0x101b;
	DgrAddr[0] = 0x1204;
	DgrAddr[1] = 0x1203;
	DgrAddr[2] = 0x1209;
	DgrAddr[3] = 0x1202;
	DgrAddr[4] = 0x1201;
	DgrAddr[5] = 0x120a;
	DgrAddr[6] = 0x120d;
	DgrAddr[7] = 0x1119;

	FName[0] = _T("wPCBTest");				DotPos[0] = 0;	FUnit[0] = _T("");	
//	FName[0] = _T("Freq. Cmd");				DotPos[0] = 1;	FUnit[0] = _T("Hz");	
	FName[1] = _T("wDOImage");				DotPos[1] = 0;	FUnit[1] = _T("");	
//	FName[1] = _T("JOG Cmd");				DotPos[1] = 1;	FUnit[1] = _T("Hz");	
	FName[2] = _T("Acc Time");				DotPos[2] = 1;	FUnit[2] = _T("sec");	
	FName[3] = _T("Dec Time");				DotPos[3] = 1;	FUnit[3] = _T("sec");
	FName[4] = _T("Dir Cmd");				DotPos[4] = 0;	FUnit[4] = _T("");
	FName[5] = _T("Freq. CmdSrc");			DotPos[5] = 0;	FUnit[5] = _T("");
	FName[6] = _T("Run CmdSrc");			DotPos[6] = 0;	FUnit[6] = _T("");
	FName[7] = _T("Stop Mode");				DotPos[7] = 0;	FUnit[7] = _T("");

	FName[8] = _T("Ctrl Mode");				DotPos[8] = 0;	FUnit[8] = _T("");
	FName[9] = _T("Start Freq.");			DotPos[9] = 1;	FUnit[9] = _T("Hz");
	FName[10] = _T("Max Freq.");			DotPos[10] = 1;	FUnit[10] = _T("Hz");
	FName[11] = _T("Base Freq.");			DotPos[11] = 1;	FUnit[11] = _T("Hz");
	FName[12] = _T("Base Volt");			DotPos[12] = 0;	FUnit[12] = _T("V");
	FName[13] = _T("V Out Gain");			DotPos[13] = 1;	FUnit[13] = _T("%");
	FName[14] = _T("Trq Boost Qty.");		DotPos[14] = 1;	FUnit[14] = _T("%");
	FName[15] = _T("Trq Boost Freq.");		DotPos[15] = 1;	FUnit[15] = _T("%");
	FName[16] = _T("ETH Level");			DotPos[16] = 1;	FUnit[16] = _T("%");
	FName[17] = _T("Over Load Level");		DotPos[17] = 1;	FUnit[17] = _T("%");
	FName[18] = _T("PWM Freq.");			DotPos[18] = 1;	FUnit[18] = _T("kHz");
	FName[19] = _T("Motor Rated Amps");		DotPos[19] = 2; FUnit[19] = _T("A");
	FName[20] = _T("Motor Pole");			DotPos[20] = 0;	FUnit[20] = _T("Pole");
	FName[21] = _T("Motor Rated Slip");		DotPos[21] = 1;	FUnit[21] = _T("Hz");
	FName[22] = _T("Motor Flux Current");	DotPos[22] = 2;	FUnit[22] = _T("A");
	FName[23] = _T("Motor R1");				DotPos[23] = 1;	FUnit[23] = _T("%");
	FName[24] = _T("Motor R2");				DotPos[24] = 1;	FUnit[24] = _T("%");
	FName[25] = _T("Motor L");				DotPos[25] = 2;	FUnit[25] = _T("%");
	FName[26] = _T("Motor Lsigma");			DotPos[26] = 1;	FUnit[26] = _T("%");

	FName[27] = _T("Di1 Def.");				DotPos[27] = 0;	FUnit[27] = _T("");
	FName[28] = _T("Di2 Def.");				DotPos[28] = 0;	FUnit[28] = _T("");
	FName[29] = _T("Di3 Def.");				DotPos[29] = 0;	FUnit[29] = _T("");
	FName[30] = _T("Di1 Type");				DotPos[30] = 0;	FUnit[30] = _T("");
	FName[31] = _T("Di2 Type");				DotPos[31] = 0;	FUnit[31] = _T("");
	FName[32] = _T("Di3 Type");				DotPos[32] = 0;	FUnit[32] = _T("");
	FName[33] = _T("Do1 Def.");				DotPos[33] = 0;	FUnit[33] = _T("");
	FName[34] = _T("Do1 Type");				DotPos[34] = 0;	FUnit[34] = _T("");


	FName[35] = _T("Ain Offset");			DotPos[35] = 1;	FUnit[35] = _T("%");
	FName[36] = _T("Ain Gain");				DotPos[36] = 1;	FUnit[36] = _T("%");
	FName[37] = _T("Ain LPF");				DotPos[37] = 1;	FUnit[37] = _T("");
	FName[38] = _T("Drive Type");			DotPos[38] = 0;	FUnit[38] = _T("");

	FAddr[0] = _T("0x1103");
	FAddr[1] = _T("0x111b");	
	FAddr[2] = _T("0x1302");	
	FAddr[3] = _T("0x1303");
	FAddr[4] = _T("0x1304");
	FAddr[5] = _T("0x1305");
	FAddr[6] = _T("0x1306");
	FAddr[7] = _T("0x1307");
	FAddr[8] = _T("0x1308");
	FAddr[9] = _T("0x130b");
	FAddr[10] = _T("0x130c");
	FAddr[11] = _T("0x130d");
	FAddr[12] = _T("0x130e");
	FAddr[13] = _T("0x130f");	//F15
	FAddr[14] = _T("0x1313");
	FAddr[15] = _T("0x1314");
	FAddr[16] = _T("0x131d");
	FAddr[17] = _T("0x131f");
	FAddr[18] = _T("0x1323");
	FAddr[19] = _T("0x1324");
	FAddr[20] = _T("0x1325");
	FAddr[21] = _T("0x1326");
	FAddr[22] = _T("0x1328");
	FAddr[23] = _T("0x1329");
	FAddr[24] = _T("0x132a");
	FAddr[25] = _T("0x132b");
	FAddr[26] = _T("0x132c");
	FAddr[27] = _T("0x1401");
	FAddr[28] = _T("0x1402");
	FAddr[29] = _T("0x1403");
	FAddr[30] = _T("0x1404");
	FAddr[31] = _T("0x1405");
	FAddr[32] = _T("0x1406");
	FAddr[33] = _T("0x1407");
	FAddr[34] = _T("0x1408");
	FAddr[35] = _T("0x1409");
	FAddr[36] = _T("0x140a");
	FAddr[37] = _T("0x140b");
	FAddr[38] = _T("0x1101");

	for(int i=0; i<5; i++)
	{		
		lvcolumn.iSubItem = i;
		lvcolumn.pszText = listcolumn[i];		
		lvcolumn.cx = width[i];
		m_listCtrl.InsertColumn(i, &lvcolumn);
	}
	sList[0][0] = _T("Babo");

	lvcolumn.iSubItem = 0;
	lvcolumn.pszText = listcolumn[0];		
	lvcolumn.cx = width[0];
	m_listCtrl.SetColumn(0,&lvcolumn);
	m_listCtrl.m_iSetDataIdx = 0;

	CPC_LDRApp *pApp=(CPC_LDRApp *)AfxGetApp();
	pApp->list2 = &m_listCtrl;

	_getcwd(m_init_path, _MAX_PATH); 

	if(strlen(m_init_path)!=3) strcat(m_init_path,"\\");
	strcat(m_init_path,"\\config.ini");
	FILE *fp;
	char sTmp[200];
	if( (fp=fopen(m_init_path,"rt")) == NULL){
		m_iPort = 1;
		m_sFileDir = _T("C:\\");
	 }
	else{
		CString sFileDir;
		fscanf(fp,"%d",&m_iPort);
		m_sFileDir = _T("");
		fscanf(fp,"%s",sTmp);
		m_sFileDir = sTmp;
		while(m_sFileDir.Right(1)!="\\"){
			m_sFileDir+=_T(" ");			
			fscanf(fp,"%s",sTmp);
			m_sFileDir+=sTmp;			
		}
		
		fclose(fp);

	}

	int listCnt;	
	listCnt = 38;
	for(i=0;i<MAX_ITEM;i++){
		AddVari(i);
	}


	if(m_iPort==1){
		m_bCom1 = 1;
		m_bCom2 = 0;
	}
	else{
		m_bCom1 = 0;
		m_bCom2 = 1;
	}

	m_bCommEn = 0;
	m_iListCnt = 0;
	m_iRxWait = FALSE;
	m_iRxWaitCnt = 0;
	m_iTxWait = FALSE;
	m_iTxWaitCnt = 0;
	m_iRxIdx = 0;
	m_tic = 0;
	m_listUpdate = 0;
	m_wSetDataAddr = 0;
	m_iSetData = 0;

	m_GroupSet.SetCurSel(1);
	m_wIndex = 1;
	m_wIndexSet = _T("1");
	m_iDnCnt = 0;
	m_bDnAvail = FALSE;
	m_bReloading = FALSE;
	m_iDispDelay = 0;
	m_iCommCnt = 0;
	m_bWithNoUnit = FALSE;

//	CWnd *pWnd;
//	pWnd = GetDlgItem(IDC_PROGRESS);
//	pWnd->ShowWindow(SW_HIDE);
	m_Progress.ShowWindow(SW_HIDE);
	OnCommEn();
}

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRView printing

BOOL CPC_LDRView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CPC_LDRView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CPC_LDRView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}

void CPC_LDRView::OnPrint(CDC* pDC, CPrintInfo* /*pInfo*/)
{
	// TODO: add customized printing code here
}

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRView diagnostics

#ifdef _DEBUG
void CPC_LDRView::AssertValid() const
{
	CFormView::AssertValid();
}

void CPC_LDRView::Dump(CDumpContext& dc) const
{
	CFormView::Dump(dc);
}

CPC_LDRDoc* CPC_LDRView::GetDocument() // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CPC_LDRDoc)));
	return (CPC_LDRDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRView message handlers


void CPC_LDRView::AddVariable(CMyListCtrl *list)
{
	CString sTmp;
//	int num = m_VarSelCombo.GetCurSel();
//	sTmp.Format("0X%04x",VarAddrs[num]);

//	int list_count = m_listCtrl.GetItemCount();
	int list_count = list->GetItemCount();

	for(int i = 0;i<list_count;i++){
		CString Names;
//		Names = m_listCtrl.GetItemText( i, 0);
		Names = list->GetItemText( i, 0);
//		if(VarNames[num]==Names) return;
	}
	
	LV_ITEM lvitem;
	CString str0;

//	lvitem.iItem = m_listCtrl.GetItemCount();
	lvitem.iItem = list->GetItemCount();
//	str0.Format("%d", m_listCtrl.GetItemCount()); 
	str0.Format("%d", list->GetItemCount()); 
	lvitem.mask = LVIF_TEXT;
	lvitem.iSubItem = 0;	
	lvitem.pszText = (LPSTR)(LPCSTR)str0; 

//	m_listCtrl.InsertItem(&lvitem);
	list->InsertItem(&lvitem);

	UpdateData(TRUE);

		//각 컬럼의 텍스트 설정
//	m_listCtrl.SetItemText(lvitem.iItem, 0, (LPSTR)(LPCSTR)VarNames[num]);
//	m_listCtrl.SetItemText(lvitem.iItem, 1, (LPSTR)(LPCSTR)sTmp);
//	m_listCtrl.SetItemText(lvitem.iItem, 3, "UINT");
//	list->SetItemText(lvitem.iItem, 0, (LPSTR)(LPCSTR)VarNames[num]);
	list->SetItemText(lvitem.iItem, 1, (LPSTR)(LPCSTR)sTmp);
	list->SetItemText(lvitem.iItem, 3, "WORD");
	UpdateData(FALSE);	
}

LONG CPC_LDRView::OnReceiveData(UINT WParam, LONG LParam)
{
	int i;
	char ReadData;
	CString sTmp;

	UpdateData(TRUE);	

	for(i=0;i<m_pComm.abLength;i++){	
		ReadData = m_pComm.abIn[i];
		m_RxBuf[m_iRxIdx++] = ReadData;		
	}
	if(m_RxBuf[0]==0x01){
		if(m_RxBuf[1]==0x03) {
			if(m_iRxIdx>=m_RxBuf[2]+5){
				RxService();
				m_iRxWait = FALSE;
				m_iRxWaitCnt = 0;
				m_iRxIdx = 0;

				m_iCommCnt++;
				if(m_iCommCnt<=5){
					sTmp = _T("*");			
					CWnd *pWnd;
					pWnd = GetDlgItem(IDC_COMM);
					pWnd->SetWindowText(sTmp);					
				}
				else if(m_iCommCnt<=10){
					sTmp = _T(" ");
					CWnd *pWnd;
					pWnd = GetDlgItem(IDC_COMM);
					pWnd->SetWindowText(sTmp);					
				}
				else m_iCommCnt = 0;

				if(!m_bReloading){
					if(m_iDispDelay>25){
						m_disp = _T(" Communication OK !!! ");			
						CWnd *pWnd;
						pWnd = GetDlgItem(IDC_DISP);
						pWnd->SetWindowText(m_disp);

					}
					else
						m_iDispDelay++;
				}
				else{
					m_iDispDelay=0;
				}
			}
		}
		else if(m_RxBuf[1]==0x06) {
			if(m_iRxIdx>=8){
				m_iTxWait = FALSE;
				m_iRxWaitCnt = 0;
			}
		}
	}

	return TRUE;
}

BOOL CPC_LDRView::PreTranslateMessage(MSG* pMsg) 
{
	// TODO: Add your specialized code here and/or call the base class
	
	CString sTmp;

/*	if(pMsg->message == WM_KEYDOWN 
		&& pMsg->hwnd == GetDlgItem(IDC_VAR_LIST)->m_hWnd 
		&& (pMsg->wParam == VK_UP) ){
			SHORT sKey = GetKeyState( VK_CONTROL);
			if(sKey&0x80){
				OnUp();			
			}			
	}

	if(pMsg->message == WM_KEYDOWN 
		&& pMsg->hwnd == GetDlgItem(IDC_VAR_LIST)->m_hWnd 
		&& (pMsg->wParam == VK_DOWN) ){
			SHORT sKey = GetKeyState( VK_CONTROL);
			if(sKey&0x80){
				OnDown();			
			}			
	}

	if(pMsg->message == WM_KEYDOWN 
		&& pMsg->hwnd == GetDlgItem(IDC_VAR_LIST)->m_hWnd 
		&& pMsg->wParam == VK_DELETE){
		UpdateData(TRUE);
		OnDel();
	}
*/
	if(pMsg->message == WM_KEYDOWN 
		&& pMsg->hwnd == GetDlgItem(IDC_IDX)->m_hWnd 
		&& pMsg->wParam == VK_RETURN){
		UpdateData(TRUE);
		if(!sscanf(m_wIndexSet,"%d",&m_wIndex))
			AfxMessageBox("Not a Valid Data !");
		else
			GetDlgItem(IDC_DATA_SET)->SetFocus();
		
	}

//	if(pMsg->message == WM_KEYDOWN 
//		&& pMsg->hwnd == GetDlgItem(IDC_SET_VARI)->m_hWnd 
//		&& pMsg->wParam == VK_RETURN){
//		UpdateData(TRUE);
//		AfxMessageBox(m_sSelVari);
//		if(AddVari(m_sSelVari))
//			AfxMessageBox("Not a Valid Variable!!!");
//
//	}

	if(pMsg->message == WM_KEYDOWN 
		&& pMsg->hwnd == GetDlgItem(IDC_DATA_SET)->m_hWnd 
		&& pMsg->wParam == VK_RETURN){
		unsigned int Addr,wTmp;
		Addr = m_GroupSet.GetCurSel();		

		if(Addr==3) Addr = 1;
		else Addr+=2;
		Addr = 0x1000 + (Addr<<8);
		Addr += m_wIndex;
		m_wSetDataAddr = Addr;
		UpdateData(TRUE);

		if(!sscanf(m_iDataSet,"%d",&wTmp))
			AfxMessageBox("Not a Valid Data !");

		m_iSetData = wTmp;
		m_bWithNoUnit = TRUE;

	}

/*
	if(pMsg->message == WM_KEYDOWN 
		&& pMsg->hwnd == GetDlgItem(IDC_SET_VARI)->m_hWnd 
		&& (pMsg->wParam == 'V' || pMsg->wParam == 'v')){
			SHORT sKey = GetKeyState( VK_CONTROL);
			if(sKey&0x80){
				CString sTmp;
				if(OpenClipboard()){
					sTmp = (char*)GetClipboardData(CF_TEXT);	
					m_sSelVari = sTmp;
					UpdateData(FALSE);
				}
				CloseClipboard(); 
				return FALSE;
			}
			
	}
*/

	return CFormView::PreTranslateMessage(pMsg);
}


void CPC_LDRView::OnCom1() 
{
	// TODO: Add your command handler code here
	KillTimer(20);

	m_bCom1 = 1;
	m_bCom2 = 0;
	m_iPort = 1;
	m_iRxWait = FALSE;
	m_iTxWait = FALSE;
	m_iRxWaitCnt = 0;
	m_iTxWaitCnt =0;

	OpenComm();
}

void CPC_LDRView::OnCom2() 
{
	// TODO: Add your command handler code here
	KillTimer(20);
	m_bCom1 = 0;
	m_bCom2 = 1;
	m_iPort = 2;
	m_iRxWait = FALSE;
	m_iTxWait = FALSE;
	m_iRxWaitCnt = 0;
	m_iTxWaitCnt =0;
	OpenComm();
}

//DEL void CPC_LDRView::OnUpdateCom1(CCmdUI* pCmdUI) 
//DEL {
//DEL 	// TODO: Add your command update UI handler code here
//DEL 	if(m_bCom1){
//DEL 		pCmdUI->SetCheck(1);
//DEL 	}
//DEL 	else{
//DEL 		pCmdUI->SetCheck(0);
//DEL 	}
//DEL 	
//DEL }

//DEL void CPC_LDRView::OnUpdateCom2(CCmdUI* pCmdUI) 
//DEL {
//DEL 	// TODO: Add your command update UI handler code here
//DEL 	if(m_bCom2){
//DEL 		pCmdUI->SetCheck(1);
//DEL 	}
//DEL 	else{
//DEL 		pCmdUI->SetCheck(0);
//DEL 	}
//DEL 	
//DEL }
void CPC_LDRView::OpenComm()
{
	if(m_bCommEn){
		m_pComm.DestroyComm();
		m_pComm.SetComPort(m_iPort,9600,8,0,0);
		m_pComm.CreateCommInfo();
		if( m_pComm.OpenComPort() ) 
//			m_disp.Format(" COM%1d으로 연결 !!!",m_iPort);
			m_disp.Format(" Connected to COM%1d !!!",m_iPort);
//		else m_disp = _T(" COM%1d연결 실패 !!!");
		else m_disp = _T(" Fail to Connect to COM%1d !!!");
//		m_pComm.SetRts();
//		m_pComm.ClrDtr();
//		Sleep(100);
//		m_pComm.SetDtr();
		m_pComm.SetHwnd(this->m_hWnd);

		SetTimer(20,20,NULL);
	}
	else{
		m_pComm.DestroyComm();
//		m_disp.Format(" 통신중지 !!!");
		m_disp.Format(" Stop Communicaion !!!");
		KillTimer(20);
	}
	UpdateData(FALSE);

}
void CPC_LDRView::OnCommEn() 
{
	// TODO: Add your control notification handler code here
	m_bCommEn = 1 - m_bCommEn;
	if(!m_bCommEn){
		m_iTxWait = FALSE;
		m_iRxWait = FALSE;
	}
	MinTrace("%d,%d",m_wSetDataAddr,m_iSetData);

	OpenComm();

}

void CPC_LDRView::OnTimer(UINT nIDEvent) 
{
	// TODO: Add your message handler code here and/or call default

/*	if(++m_iListCnt>=MaxCnt) m_iListCnt = 0;
	
	CString sTmp = m_listCtrl.GetItemText( m_iListCnt, 1);
	m_disp = sTmp;
	UpdateData(FALSE);
*/
//	m_pComm.RdDataReq(1,0x0070,1);
//	m_iRxWait = TRUE;
//	m_iRxWaitCnt = 0;
//	m_iRxIdx = 0;

	if(m_listCtrl.m_bOK==1){
		GetDlgItem(IDC_STOP)->SetFocus();
		m_listCtrl.m_bOK=0;
	}

	if(nIDEvent==100){
		int Addr;
		unsigned int Data;
		float fData;
		CString sTmp;

		if(m_iDnCnt<38){
			if(m_iDnCnt%2==0) m_bDnBlink = 1 - m_bDnBlink;

			if(!m_wSetDataAddr){
				sTmp = m_listCtrl.GetItemText(m_iDnCnt,1);
				sTmp = sTmp.Right(sTmp.GetLength()-2);
				sscanf(sTmp,"%x",&Addr);
				sTmp = m_listCtrl.GetItemText(m_iDnCnt,4);
				sscanf(sTmp,"%f",&fData);
				Data = (unsigned int)((fData+0.05) * Dec10[DotPos[m_iDnCnt]]);
				m_wSetDataAddr = Addr;
				m_iSetData = Data;
//				m_listCtrl.m_iSetData[m_listCtrl.m_iSetDataIdx++] = Data;
//				sTmp.Format("%d : %x, %d",m_iDnCnt,Addr,Data);
				m_Progress.SetRange(0,28);
				m_Progress.SetPos(m_iDnCnt);
				m_iDnCnt++;
				sTmp.Format("%d",m_iDnCnt);
/*				if(m_bDnBlink)
					sTmp = _T("PC ->  인버터");
				else
					sTmp = _T("PC --> 인버터");
				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_DISP);
				pWnd->SetWindowText(sTmp);
*/			}
		}
		else{
			CString sTmp;
			m_wSetDataAddr = 0;
			m_bReloading = FALSE;
			KillTimer(100);
			sTmp = _T("Transfer Complete!");
			CWnd *pWnd;
			pWnd = GetDlgItem(IDC_DISP);
			pWnd->SetWindowText(sTmp);
			m_Progress.ShowWindow(SW_HIDE);
		}
	}
	else{  //monitoring 용 타이머이면
		if(!(m_iRxWait||m_iTxWait)){

			if(m_wSetDataAddr){

				m_SendAddr = m_wSetDataAddr;
				m_SendData = m_iSetData;
				m_wSetDataAddr = 0;
				m_iSetData = 0;

				m_iTxWait = TRUE;
				m_iTxWaitCnt = 0;
				m_pComm.WrDataReq(1, m_SendAddr, &m_SendData, 1);
				MinTrace("1, %d, %d\n",m_SendAddr,m_SendData);
			}
			else if(m_listCtrl.m_iSetDataIdx){
				int Addr;
				unsigned int	Data;

					CString sTmp;
					sTmp = m_listCtrl.GetItemText(m_listCtrl.m_iClickRow,1);
					sTmp = sTmp.Right(sTmp.GetLength()-2);
					sscanf(sTmp,"%x",&Addr);

					float fDataIn;
					sscanf(m_listCtrl.m_sSetData[m_listCtrl.m_iSetDataIdx-1],"%f",&fDataIn);
					Data = (unsigned int)((fDataIn+0.05) * (float)Dec10[DotPos[m_listCtrl.m_iClickRow]]);
					m_listCtrl.m_iSetDataIdx=0;

	//						sTmp.Format("%f,%d, %d",fDataIn,Dec10[DotPos[m_listCtrl.m_iClickRow]], Data);
	//						m_disp.Format("%d,%x,%x",++m_tic,Addr,Data);
	//						CWnd *pWnd;
	//						pWnd = GetDlgItem(IDC_DISP);
	//						pWnd->SetWindowText(m_disp);
				
				m_iTxWait = TRUE;
				m_iTxWaitCnt = 0;
				m_pComm.WrDataReq(1, Addr, &Data, 1);
				MinTrace("2, %d, %d\n",m_SendAddr,m_SendData);
			}
			else{
				if(m_iListCnt>=1000){
					unsigned int Addr;

					if(m_iListCnt==1008){
						Addr = m_GroupSet.GetCurSel();		
						if(Addr==3) Addr = 1;
						else Addr+=2;
						Addr = 0x1000 + (Addr<<8);
						Addr += m_wIndex;
					}
					else	
						Addr = DgrAddr[m_iListCnt-1000];

					m_pComm.RdDataReq(1,Addr,1);

				}
				else{
					CString sTmp = m_listCtrl.GetItemText( m_iListCnt, 1);
					unsigned int Addr;
					sTmp = sTmp.Right(sTmp.GetLength()-2);
					sscanf(sTmp,"%x",&Addr);
					m_pComm.RdDataReq(1,Addr,1);

				}

				m_iRxWait = TRUE;
				m_iRxWaitCnt = 0;
				m_iRxIdx = 0;

			}
		}
		else{
			if(m_iRxWaitCnt++>50){
	//			CMainFrame* pMainFrame = (CMainFrame*)AfxGetMainWnd();
	//			pMainFrame->m_wndStatusBar.SetPaneText(0," Target Not Respond !!");

//				m_disp = _T(" 통신이상 !!!");			
				m_disp = _T(" Communication Error !!!");			
				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_DISP);
				pWnd->SetWindowText(m_disp);

				m_iRxWaitCnt = 0;
				m_iRxWait = FALSE;
			}
			if(m_iTxWait && m_iTxWaitCnt++>100){
				m_iTxWait = TRUE;
				m_iTxWaitCnt = 0;
				WrDataReq(1, m_SendAddr, &m_SendData, 1);
				MinTrace("10, %d, %d\n",m_SendAddr,m_SendData);
			}
		}
	}

	CFormView::OnTimer(nIDEvent);
}

void CPC_LDRView::RdDataReq(unsigned int ID, unsigned int Addr, unsigned int Size)
{
	unsigned int wTmp,tx_len;
	char TxBuf[50];
	CString strTmp;

	tx_len = 8;

	TxBuf[0] = ID;
	TxBuf[1] = 0x03;
	
	TxBuf[2] = (Addr>>8)&0x0ff;
	TxBuf[3] = Addr&0x0ff;
	TxBuf[4] = (Size>>8)&0x0ff;
	TxBuf[5] = Size&0x0ff;
	
	wTmp = m_pComm.GetCRC(&TxBuf[0],6);

	TxBuf[6] = (wTmp>>8)&0xff;
	TxBuf[7] = wTmp&0xff;

	m_pComm.WriteCommBlock((LPSTR)TxBuf, tx_len);

	m_iRxWait = TRUE;
	m_iRxWaitCnt = 0;
	m_iRxIdx = 0;

	m_disp.Format("0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x",TxBuf[0],TxBuf[1],TxBuf[2],TxBuf[3],TxBuf[4],TxBuf[5],TxBuf[6],TxBuf[7]);
	CWnd *pWnd;
	pWnd = GetDlgItem(IDC_DISP);
	pWnd->SetWindowText(m_disp);		
	m_pComm.RdDataReq(1,Addr,1);
}

void CPC_LDRView::WrDataReq(unsigned int ID, unsigned int Addr, unsigned int *Data, unsigned int Len)
{
	unsigned int wTmp,tx_len;
	char TxBuf[500];	
	CString strTmp;

	tx_len = 8;

	TxBuf[0] = ID;
	TxBuf[1] = 0x06;
	
	TxBuf[2] = (Addr>>8)&0xff;
	TxBuf[3] = Addr& 0xff;
	TxBuf[4] = (*Data>>8)&0xff;
	TxBuf[5] = (*Data & 0xff);
	
	wTmp = m_pComm.GetCRC(&TxBuf[0],6);

	TxBuf[6] = (wTmp>>8)&0xff;
	TxBuf[7] = wTmp&0xff;

	m_pComm.WriteCommBlock((LPSTR)TxBuf, tx_len);
	m_iRxWait = TRUE;
	m_iRxWaitCnt = 0;
	m_iRxIdx = 0;

}

void CPC_LDRView::RxService()
{
//	int MaxCnt = m_listCtrl.GetItemCount();

	int MaxCnt = 2;

	int Data;
	CString sTmp;
	
	if(m_iListCnt>=1000){
		Data = ASCII2Int(&m_RxBuf[3]);

		if(m_iListCnt==1008){
			m_wData.Format("%d",Data);
			CWnd *pWnd;
			pWnd = GetDlgItem(IDC_DATA);
			pWnd->SetWindowText(m_wData);
			m_iListCnt = 0;
		}
		else{
			if(m_iListCnt==1000){
				sTmp.Format("%5.2f",(float)Data/100);
				sTmp = _T("Ver.") + sTmp;
				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_VER);
				pWnd->SetWindowText(sTmp);


			}
			if(m_iListCnt==1001){
				sTmp.Format("%5.1f",(float)Data/10);

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_OutFreq);
				pWnd->SetWindowText(sTmp);
			}
			if(m_iListCnt==1002){
				sTmp.Format("%5.1f",(float)Data/10);

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_RefFreq);
				pWnd->SetWindowText(sTmp);
			}
			if(m_iListCnt==1003){
				sTmp.Format("%5.2f",(float)Data/100);

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_OutCur);
				pWnd->SetWindowText(sTmp);
			}
			if(m_iListCnt==1004){
				sTmp.Format("%d",Data);

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_OutV);
				pWnd->SetWindowText(sTmp);
			}
			if(m_iListCnt==1005){
				sTmp.Format("%d",Data);

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_DCV);
				pWnd->SetWindowText(sTmp);
			}
			if(m_iListCnt==1006){
				if(Data==0) sTmp = _T("Normal");
				if(Data==1) sTmp = _T("IPM Error");
				if(Data==2) sTmp = _T("Over C");
				if(Data==3) sTmp = _T("Over V");
				if(Data==4) sTmp = _T("Over Heat");
				if(Data==5) sTmp = _T("Low V");
				if(Data==6) sTmp = _T("Ext. Trip");
				if(Data==7) sTmp = _T("ETH");
				if(Data==8) sTmp = _T("MTH Trip");
				if(Data==9) sTmp = _T("Photo");

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_TRIP);
				pWnd->SetWindowText(sTmp);
			}
			if(m_iListCnt==1007){
				sTmp.Format("%x",Data);

				CWnd *pWnd;
				pWnd = GetDlgItem(IDC_PORT_IN);
				pWnd->SetWindowText(sTmp);
				
				if(!(Data&0x20))
					m_led_close.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
				else
					m_led_close.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
				if(!(Data&0x40))
					m_led_open.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
				else
					m_led_open.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
				if(!(Data&0x80))
					m_led_nudge.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
				else
					m_led_nudge.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
				if(!(Data&0x100))
					m_led_hcl.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
				else
					m_led_hcl.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);


			}
			m_iListCnt++;
		}
	}
	else{

		CString TYPE = m_listCtrl.GetItemText( m_iListCnt, 3);
		Data = ASCII2Int(&m_RxBuf[3]);

		if(DotPos[m_iListCnt]==0)
			sTmp.Format("%d",Data);
		if(DotPos[m_iListCnt]==1)
			sTmp.Format("%5.1f",(float)Data/Dec10[DotPos[m_iListCnt]]);
		if(DotPos[m_iListCnt]==2)
			sTmp.Format("%5.1f",(float)Data/Dec10[DotPos[m_iListCnt]]);

		m_listCtrl.SetItemText(m_iListCnt, 2, sTmp);

		if(++m_iListCnt>=MaxCnt) m_iListCnt = 1000;

	}

}

int CPC_LDRView::ASCII2Int(BYTE *addr)
{
	int hh, ll;

	hh = *addr++;
	ll = *addr;
	return hh*16*16 + ll;
}

void CPC_LDRView::OnDel() 
{
	// TODO: Add your command handler code here
	if(m_listCtrl.m_iClickRow==-1) return;

//	m_listCtrl.DeleteItem(m_listCtrl.m_iClickRow);	
	LV_ITEM lvitem;
	int count = m_listCtrl.GetItemCount();
	int i;
	lvitem.mask = LVIF_STATE;

	for(i=count-1; i>=0; i--)
	{
		lvitem.iItem = i;
		if(m_listCtrl.GetItemState(i, LVIS_SELECTED)!=0)
			m_listCtrl.DeleteItem(i);	
	}

}

void CPC_LDRView::OnDown() 
{
	// TODO: Add your command handler code here
	CString sTmp;
	int count = m_listCtrl.GetItemCount();

	int Src = m_listCtrl.GetSelectionMark();
	if(Src==(count-1)) return;
	if(Src==-1) return;
	int Dest = Src + 1;

	CString NameSrc = m_listCtrl.GetItemText( Src, 0);
	CString AddrSrc = m_listCtrl.GetItemText( Src, 1);
	CString NameDest = m_listCtrl.GetItemText( Dest, 0);
	CString AddrDest = m_listCtrl.GetItemText( Dest, 1);

	m_listCtrl.SetItemText(Src, 0, (LPSTR)(LPCSTR)NameDest);
	m_listCtrl.SetItemText(Src, 1, (LPSTR)(LPCSTR)AddrDest);
	m_listCtrl.SetItemText(Dest, 0, (LPSTR)(LPCSTR)NameSrc);
	m_listCtrl.SetItemText(Dest, 1, (LPSTR)(LPCSTR)AddrSrc);

	m_listCtrl.SetItemState(Src, 0,  LVIS_SELECTED|LVIS_FOCUSED);
	m_listCtrl.EnsureVisible(Dest, TRUE);
	m_listCtrl.SetItemState(Dest, LVIS_SELECTED|LVIS_FOCUSED,  LVIS_SELECTED|LVIS_FOCUSED);
	m_listCtrl.SetFocus(); 
	m_listCtrl.SetSelectionMark(Dest);
//	UpdateData(FALSE);		
	
}

void CPC_LDRView::OnSetData() 
{
	// TODO: Add your command handler code here
	CString sTmp;
//	sTmp.Format("%d,%d",m_listCtrl.m_iClickRow,m_listCtrl.m_iClickCol);

//	AfxMessageBox(sTmp);	
/*
	if(m_listCtrl.m_iClickRow!=-1){
		CDataInDlg pDlg;
		if(pDlg.DoModal()==IDOK){
			int iTmp = pDlg.m_iSetData;
			sTmp.Format("%d",iTmp);
			m_listCtrl.m_iSetData[m_listCtrl.m_iSetDataIdx++]=iTmp;
			m_listCtrl.SetItemText(m_listCtrl.m_iClickRow, 2, (LPSTR)(LPCSTR)sTmp);
		}
		else{
		}	

	}		
*/	
}

void CPC_LDRView::OnSetInt() 
{
	// TODO: Add your command handler code here
	m_listCtrl.SetItemText(m_listCtrl.m_iClickRow, 3, "SWORD");	
}

void CPC_LDRView::OnSetUint() 
{
	// TODO: Add your command handler code here
	m_listCtrl.SetItemText(m_listCtrl.m_iClickRow, 3, "WORD");	
}

void CPC_LDRView::OnSetBin() 
{
	// TODO: Add your command handler code here
	m_listCtrl.SetItemText(m_listCtrl.m_iClickRow, 3, "BIN");	
	
}

void CPC_LDRView::OnSetHex() 
{
	// TODO: Add your command handler code here
	m_listCtrl.SetItemText(m_listCtrl.m_iClickRow, 3, "HEX2");	
	
}

void CPC_LDRView::OnUp() 
{
	// TODO: Add your command handler code here
	int count = m_listCtrl.GetItemCount();

	int Src = m_listCtrl.GetSelectionMark();
	if(Src==0) return;
	int Dest = Src - 1;

	CString NameSrc = m_listCtrl.GetItemText( Src, 0);
	CString AddrSrc = m_listCtrl.GetItemText( Src, 1);
	CString NameDest = m_listCtrl.GetItemText( Dest, 0);
	CString AddrDest = m_listCtrl.GetItemText( Dest, 1);

	m_listCtrl.SetItemText(Src, 0, (LPSTR)(LPCSTR)NameDest);
	m_listCtrl.SetItemText(Src, 1, (LPSTR)(LPCSTR)AddrDest);
	m_listCtrl.SetItemText(Dest, 0, (LPSTR)(LPCSTR)NameSrc);
	m_listCtrl.SetItemText(Dest, 1, (LPSTR)(LPCSTR)AddrSrc);

	m_listCtrl.SetItemState(Src, 0,  LVIS_SELECTED|LVIS_FOCUSED);
	m_listCtrl.EnsureVisible(Dest, TRUE);
	m_listCtrl.SetItemState(Dest, LVIS_SELECTED|LVIS_FOCUSED,  LVIS_SELECTED|LVIS_FOCUSED);
	m_listCtrl.SetFocus(); 
	m_listCtrl.SetSelectionMark(Dest);

//	UpdateData(FALSE);		
}



int CPC_LDRView::AddVari(int Idx)
{

	CString VarName,Addr,Unit;

	LV_ITEM lvitem;
	VarName = FName[Idx];
	Addr = FAddr[Idx];
	Unit = FUnit[Idx];
	int list_count = m_listCtrl.GetItemCount();

	lvitem.iItem = m_listCtrl.GetItemCount();
	lvitem.mask = LVIF_TEXT;
	lvitem.iSubItem = 0;	
	lvitem.pszText = (LPSTR)(LPCSTR)VarName; 

	m_listCtrl.InsertItem(&lvitem);

	//각 컬럼의 텍스트 설정
	m_listCtrl.SetItemText(lvitem.iItem, 0, (LPSTR)(LPCSTR)VarName);
	m_listCtrl.SetItemText(lvitem.iItem, 1, (LPSTR)(LPCSTR)Addr);
	m_listCtrl.SetItemText(lvitem.iItem, 3, (LPSTR)(LPCSTR)Unit);

	return 0;

}

void CPC_LDRView::OnFileNew() 
{
	// TODO: Add your command handler code here
	CPC_LDRApp *pApp=(CPC_LDRApp*)AfxGetApp();

	CFileDialog* fileDialog= NULL;
	fileDialog = new CFileDialog(FALSE, "xMap", NULL, OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST, "Map File Format (*.xMap)|*.xMap|");
	fileDialog->m_ofn.lpstrInitialDir = m_sFileDir;
//	fileDialog->m_ofn.lpstrTitle ="데이터 저장하기";

	if(fileDialog->DoModal() == IDOK)
	{
		m_sMapFileName = fileDialog->GetPathName();		
		char	drive[20],dir[200],fname[200],ext[20];
		_splitpath( (LPSTR)(LPCSTR)m_sMapFileName, drive, dir, fname, ext );

		m_sFileDir = drive;
		CString sTmp = dir;
		m_sFileDir = m_sFileDir + sTmp;
		
		Map2List(m_sMapFileName);
	}

}

int CPC_LDRView::Map2List(CString sFileName)
{
	CWnd *pWnd;
	pWnd = GetDlgItem(IDC_MAPFILE_NAME);
	pWnd->SetWindowText((_T("Open File Name : ") + sFileName));

	FILE *fp;
	CString Line;
	CString sTmp;
	char LineIn[255];
	int start = 0;
	int	Data[30];

	if( (fp=fopen(sFileName,"rt")) == NULL)
	{
		AfxMessageBox(".fun File Open Error!");
		return -1;
	}
	CString Babo = _T("# .main_application_data");
	CString EOL = _T("\n\r");

	int Idx =0;
	while(!feof(fp)){
		fgets(LineIn,255,fp);
		Line = LineIn;
		sscanf(LineIn,"%ds",&Data[Idx++]);			
	}
	fclose(fp);

	LV_ITEM lvitem;
	CString str0;
	lvitem.mask = LVIF_TEXT;
	lvitem.iSubItem = 0;	

//	m_Inlist.DeleteAllItems();

	//각 컬럼의 텍스트 설정
	for(int i=0;i<Idx;i++){
//		lvitem.iItem = m_Inlist.GetItemCount();
		lvitem.iSubItem = 0;	
		lvitem.pszText = (LPSTR)(LPCSTR)VarNames[i];
//		m_Inlist.InsertItem(&lvitem);		
	}

	for(i=0;i<Idx;i++){
		sTmp.Format("0X%04x",VarAddrs[i]);
//		m_Inlist.SetItemText(i,1,(LPSTR)(LPCSTR)sTmp);
	}

//	m_Inlist.SortTextItems(0,1,0,-1);
	return 0;

}

void CPC_LDRView::OnUpdateCom1(CCmdUI* pCmdUI) 
{
	// TODO: Add your command update UI handler code here
	if(m_bCom1){
 		pCmdUI->SetCheck(1);
 	}
 	else{
 		pCmdUI->SetCheck(0);
 	}	
}

void CPC_LDRView::OnUpdateCom2(CCmdUI* pCmdUI) 
{
	// TODO: Add your command update UI handler code here
	if(m_bCom2){
 		pCmdUI->SetCheck(1);
 	}
 	else{
 		pCmdUI->SetCheck(0);
 	}	
	
}

void CPC_LDRView::OnDestroy() 
{
	CFormView::OnDestroy();
	FILE *fp;
	fp = fopen(m_init_path,"wt");

	fprintf(fp,"%d\r\n",m_iPort);
	fprintf(fp,"%s\r\n",m_sFileDir);

	fclose(fp);	

	// TODO: Add your message handler code here
	
}

void CPC_LDRView::OnDelAll() 
{
	// TODO: Add your command handler code here
	m_listCtrl.DeleteAllItems();
}

void CPC_LDRView::OnReload() 
{
	// TODO: Add your command handler code here
	//	AfxMessageBox("Good");
	if(m_bDnAvail){
		if(!m_bReloading){
			m_bReloading = TRUE;
			SetTimer(100,100,NULL);
			m_iDnCnt = 0;
		}
		CString sTmp;
		m_bDnBlink = 0;
		m_Progress.SetRange(0,28);
		m_Progress.SetPos(0);
		m_Progress.ShowWindow(!SW_HIDE);
	
/*		sTmp = _T("PC ->  인버터");
		CWnd *pWnd;
		pWnd = GetDlgItem(IDC_DISP);
		pWnd->SetWindowText(sTmp);
*/
	}
	else{
//		AfxMessageBox("전송할 파일 데이타가 없습니다.");
		AfxMessageBox("No File to Transfer !!!");
	}

}

void CPC_LDRView::RefreshList()
{
	int count = m_listCtrl.GetItemCount();
	int idx;
	CString sTmp;

	for(int i=0;i<count;i++){
		sTmp = m_listCtrl.GetItemText(i,0);
		idx = SearchString(sTmp);
		if(idx==-1) 	
			m_listCtrl.DeleteItem(i);	
//		sTmp = m_Inlist.GetItemText(idx,1);
		m_listCtrl.SetItemText(i,1,sTmp);
	}
		
}

int CPC_LDRView::SearchString(CString sName)
{
//	int count = m_Inlist.GetItemCount();
	CString sTmp;

//	for(int i = 0;i<count;i++){
//		sTmp = m_Inlist.GetItemText(i,0);	
//		if(sTmp==sName) 
	return 0;
//	}
//	return -1;
}


void CPC_LDRView::OnSelchangeGroup() 
{
	// TODO: Add your control notification handler code here
	m_wIndex = 1;
	m_wIndexSet = _T("1");
//	UpdateData(FALSE);	
}

void CPC_LDRView::OnSet() 
{
	// TODO: Add your control notification handler code here

	unsigned int Addr,wTmp;
	UpdateData(TRUE);

	Addr = m_GroupSet.GetCurSel();		
	if(Addr==3) Addr = 1;
	else Addr+=2;
	Addr = 0x1000 + (Addr<<8);
	Addr += m_wIndex;
	m_wSetDataAddr = Addr;

	if(!sscanf(m_iDataSet,"%d",&wTmp))
		AfxMessageBox("Not a Valid Data !");

	m_iSetData = wTmp;
	m_bWithNoUnit = TRUE;

//	m_disp.Format("%x",Addr);
//	CWnd *pWnd;
//	pWnd = GetDlgItem(IDC_DISP);
//	pWnd->SetWindowText(m_disp);		
//	m_pComm.RdDataReq(1,Addr,1);

//	m_iRxWait = TRUE;
//	m_iRxWaitCnt = 0;
//	m_iRxIdx = 0;

}

void CPC_LDRView::OnStop() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x1001;
	m_iSetData = 0x01;
//	m_listCtrl.m_iSetData[m_listCtrl.m_iSetDataIdx++]=0x01;	
	
}

void CPC_LDRView::OnFwdRun() 
{
	// TODO: Add your control notification handler code here
//	m_wSetDataAddr = 0x1001;
//	m_iSetData = 0x02;

	m_led_close.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
	m_led_open.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
	m_led_nudge.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
	m_led_hcl.SetLed(CLed::LED_COLOR_RED,CLed::LED_ON,CLed::LED_ROUND);
	UpdateData(FALSE);
}

void CPC_LDRView::OnRevRun() 
{
	// TODO: Add your control notification handler code here
//	m_wSetDataAddr = 0x1001;
//	m_iSetData = 0x04;
	m_led_close.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
	m_led_open.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
	m_led_nudge.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
	m_led_hcl.SetLed(CLed::LED_COLOR_RED,CLed::LED_OFF,CLed::LED_ROUND);
	UpdateData(FALSE);
	
}


void CPC_LDRView::OnFileOpen() 
{
	// TODO: Add your command handler code here

	if(!File2Data())
		m_bDnAvail = TRUE;

}

void CPC_LDRView::OnFileSave() 
{
	// TODO: Add your command handler code here
	Data2File();
}

int CPC_LDRView::Data2File()
{
	CFileDialog* fileDialog= NULL;
	fileDialog = new CFileDialog(FALSE, "fun", NULL, OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST, "Funtion File Format (*.fun)|*.fun|");
	fileDialog->m_ofn.lpstrInitialDir = m_sFileDir;
//	fileDialog->m_ofn.lpstrTitle ="데이터 저장하기";
	fileDialog->m_ofn.lpstrTitle ="Save Data";


	if(fileDialog->DoModal() == IDOK)
	{
		m_sMapFileName = fileDialog->GetPathName();		
		char	drive[20],dir[200],fname[200],ext[20];
		_splitpath( (LPSTR)(LPCSTR)m_sMapFileName, drive, dir, fname, ext );

		m_sFileDir = drive;
		CString sTmp = dir;
		m_sFileDir = m_sFileDir + sTmp;

		FILE *fp;
		fp = fopen(m_sMapFileName,"wt");
		for(int i=0;i<MAX_ITEM;i++){
			sTmp = m_listCtrl.GetItemText(i,2);	
			fprintf(fp,"%s\r\n",sTmp);
		}

		fclose(fp);	

	}
	return 1;
}

int CPC_LDRView::File2Data()
{
	CString Data,Line;
	char LineIn[255];
	CFileDialog* fileDialog= NULL;
	fileDialog = new CFileDialog(TRUE, "fun", NULL, OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST, "Funtion File Format (*.fun)|*.fun|");
	fileDialog->m_ofn.lpstrInitialDir = m_sFileDir;
//	fileDialog->m_ofn.lpstrTitle ="데이터 읽기";
	fileDialog->m_ofn.lpstrTitle ="Read Data";

	FILE *fp;

	if(fileDialog->DoModal() == IDOK)
	{
		m_sMapFileName = fileDialog->GetPathName();		

		CWnd *pWnd;
		pWnd = GetDlgItem(IDC_MAPFILE_NAME);
		pWnd->SetWindowText((_T("Open File Name : ") + m_sMapFileName));
		
		if( (fp=fopen(m_sMapFileName,"rt")) == NULL)
		{
			AfxMessageBox(".fun File Open Error!");
			return -1;
		}

		int Idx =0;
		for(int i = 0;i<MAX_ITEM;i++){
			fscanf(fp,"%s",LineIn);
			m_listCtrl.SetItemText(i, 4, LineIn);
		}

		fclose(fp);
	}

	return 0;
}

void CPC_LDRView::OnAppExit() 
{
	// TODO: Add your command handler code here
//	OnDestroy();
}

void CPC_LDRView::OnParaSave() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x1321;
	m_iSetData = 0x01;
	
}

void CPC_LDRView::OnParaInit() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x1321;
	m_iSetData = 0x02;
	
}

void CPC_LDRView::OnDo2() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 0x02;
	
}

void CPC_LDRView::OnDo3() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 0x03;
	
}

void CPC_LDRView::OnDo4() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 0x04;
	
}

void CPC_LDRView::OnDo5() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 0x05;
	
}

void CPC_LDRView::OnClear() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 0x0;
	
}

void CPC_LDRView::OnDo12() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 12;
	
}

void CPC_LDRView::OnDo13() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 13;
	
}

void CPC_LDRView::OnDo15() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x111b;
	m_iSetData = 15;
	
}

void CPC_LDRView::OnClear2() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x1103;
	m_iSetData = 13;
	
}

void CPC_LDRView::OnDoReady() 
{
	// TODO: Add your control notification handler code here
	m_wSetDataAddr = 0x1103;
	m_iSetData = 2;
	
}
