#if !defined(AFX_DATAINDLG_H__D602C9D1_887F_43D6_80EB_65183FAC5CB2__INCLUDED_)
#define AFX_DATAINDLG_H__D602C9D1_887F_43D6_80EB_65183FAC5CB2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// DataInDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CDataInDlg dialog

class CDataInDlg : public CDialog
{
// Construction
public:
	CDataInDlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(CDataInDlg)
	enum { IDD = IDD_DATAIN_DLG };
	CString	m_sSetData;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDataInDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CDataInDlg)
	afx_msg void OnPaint();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DATAINDLG_H__D602C9D1_887F_43D6_80EB_65183FAC5CB2__INCLUDED_)
