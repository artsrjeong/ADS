// DataInDlg.cpp : implementation file
//

#include "stdafx.h"
#include "PC_LDR.h"
#include "DataInDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDataInDlg dialog


CDataInDlg::CDataInDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDataInDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDataInDlg)
	m_sSetData = _T("");
	//}}AFX_DATA_INIT
}


void CDataInDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDataInDlg)
	DDX_Text(pDX, IDC_DATA2, m_sSetData);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CDataInDlg, CDialog)
	//{{AFX_MSG_MAP(CDataInDlg)
	ON_WM_PAINT()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDataInDlg message handlers

void CDataInDlg::OnPaint() 
{
	CPaintDC dc(this); // device context for painting
//	GetDlgItem(IDC_DATA)->SetFocus();								
//	((CEdit*)(GetDlgItem(IDC_DATA)))->SetSel( 0, -1, TRUE );		// 키 입력이 바로 되게 ^^
	GetDlgItem(IDC_DATA2)->SetFocus();								
	((CEdit*)(GetDlgItem(IDC_DATA2)))->SetSel( 0, -1, TRUE );		// 키 입력이 바로 되게 ^^
	
	// TODO: Add your message handler code here
	
	// Do not call CDialog::OnPaint() for painting messages
}
