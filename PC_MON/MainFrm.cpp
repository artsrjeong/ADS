// MainFrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include "PC_LDR.h"

#include "MainFrm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMainFrame

IMPLEMENT_DYNCREATE(CMainFrame, CFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)
	//{{AFX_MSG_MAP(CMainFrame)
	ON_WM_CREATE()
	ON_COMMAND(ID_FILE_OPEN, OnFileOpen)
	//}}AFX_MSG_MAP
	ON_UPDATE_COMMAND_UI(ID_INDICATOR_STATUS, OnUpdateStatus)

END_MESSAGE_MAP()

static UINT indicators[] =
{
	ID_SEPARATOR,           // status line indicator
	ID_INDICATOR_STATUS,
//	ID_INDICATOR_CAPS,
//	ID_INDICATOR_NUM,
//	ID_INDICATOR_SCRL,
};

/////////////////////////////////////////////////////////////////////////////
// CMainFrame construction/destruction

CMainFrame::CMainFrame()
{
	// TODO: add member initialization code here
	
}

CMainFrame::~CMainFrame()
{
}

int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CFrameWnd::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	if (!m_wndToolBar.CreateEx(this, TBSTYLE_FLAT, WS_CHILD | WS_VISIBLE | CBRS_TOP
		| CBRS_GRIPPER | CBRS_TOOLTIPS | CBRS_FLYBY | CBRS_SIZE_DYNAMIC) ||
		!m_wndToolBar.LoadToolBar(IDR_MAINFRAME))
	{
		TRACE0("Failed to create toolbar\n");
		return -1;      // fail to create
	}

	if (!m_wndStatusBar.Create(this) ||
		!m_wndStatusBar.SetIndicators(indicators,
		  sizeof(indicators)/sizeof(UINT)))
	{
		TRACE0("Failed to create status bar\n");
		return -1;      // fail to create
	}

	// TODO: Delete these three lines if you don't want the toolbar to
	//  be dockable
	m_wndToolBar.EnableDocking(CBRS_ALIGN_ANY);

	m_wndStatusBar.SetPaneInfo(0,m_wndStatusBar.GetItemID(0),SBPS_NOBORDERS|SBPS_STRETCH,60);
	m_wndStatusBar.SetPaneInfo(1,m_wndStatusBar.GetItemID(1),SBPS_NOBORDERS,50);

	EnableDocking(CBRS_ALIGN_ANY);
	DockControlBar(&m_wndToolBar);

	return 0;
}

BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	if( !CFrameWnd::PreCreateWindow(cs) )
		return FALSE;
	cs.style &= ~WS_THICKFRAME;
	cs.style &= ~FWS_ADDTOTITLE;	// TODO: Modify the Window class or styles here by modifying
	cs.lpszName = "PC Tool for i-Master";
	cs.cx = 1400;
	cs.cy = 600;
	return TRUE;
}


void CMainFrame::OnUpdateStatus(CCmdUI *pCmdUI)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs
	CPC_LDRApp * pApp = (CPC_LDRApp *)AfxGetApp();
    ASSERT_VALID(pApp);


//    pCmdUI->SetText("BABO babo BABO");

/*    if(pApp->m_isDatabaseConnected)
         pCmdUI->SetText("Connected to: "+ pApp->m_strDSN);
    else
         pCmdUI->SetText("Database not connected");
*/
}

/////////////////////////////////////////////////////////////////////////////
// CMainFrame diagnostics

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
	CFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
	CFrameWnd::Dump(dc);
}

#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMainFrame message handlers


void CMainFrame::OnFileOpen() 
{
	// TODO: Add your command handler code here
	


}
