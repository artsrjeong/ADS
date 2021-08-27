// PC_LDR.h : main header file for the PC_LDR application
//

#if !defined(AFX_PC_LDR_H__F794D160_EBE2_4404_9374_50F0C8A9016B__INCLUDED_)
#define AFX_PC_LDR_H__F794D160_EBE2_4404_9374_50F0C8A9016B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols
#include "MyListCtrl.h"	// Added by ClassView

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRApp:
// See PC_LDR.cpp for the implementation of this class
//

class CPC_LDRApp : public CWinApp
{
public:
	CMyListCtrl *list1,*list2;
	CPC_LDRApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPC_LDRApp)
	public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();
	//}}AFX_VIRTUAL

// Implementation
	//{{AFX_MSG(CPC_LDRApp)
	afx_msg void OnAppAbout();
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PC_LDR_H__F794D160_EBE2_4404_9374_50F0C8A9016B__INCLUDED_)
