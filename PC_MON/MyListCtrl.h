#if !defined(AFX_MYLISTCTRL_H__87F1D360_41E1_47D6_AEE7_BA93516A2BDD__INCLUDED_)
#define AFX_MYLISTCTRL_H__87F1D360_41E1_47D6_AEE7_BA93516A2BDD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// MyListCtrl.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CMyListCtrl window

class CMyListCtrl : public CListCtrl
{
// Construction
public:
	CMyListCtrl();

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMyListCtrl)
	protected:
	virtual BOOL OnNotify(WPARAM wParam, LPARAM lParam, LRESULT* pResult);
	//}}AFX_VIRTUAL

// Implementation
public:
	bool m_bOK;
	CString m_sSetData[30];
	BOOL SortTextItems(int,BOOL,int,int);
	BOOL bSortAscending;
	int nSortedCol;
	CPoint m_point;
	int m_iSetDataIdx;
	int m_iSetData[50];
	int m_iClickCol;
	int m_iClickRow;
	int HitTestEx(CPoint &point, int *col);
	virtual ~CMyListCtrl();

	// Generated message map functions
protected:
	//{{AFX_MSG(CMyListCtrl)
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnRclick(NMHDR* pNMHDR, LRESULT* pResult);
	afx_msg void OnDblclk(NMHDR* pNMHDR, LRESULT* pResult);
	//}}AFX_MSG
	afx_msg void OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult);
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MYLISTCTRL_H__87F1D360_41E1_47D6_AEE7_BA93516A2BDD__INCLUDED_)
