// PC_LDRView.h : interface of the CPC_LDRView class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_PC_LDRVIEW_H__8661F10C_6A12_41CC_B1DC_99DAFF29D915__INCLUDED_)
#define AFX_PC_LDRVIEW_H__8661F10C_6A12_41CC_B1DC_99DAFF29D915__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "MyListCtrl.h"
#include "Comm.h"
#include "led.h"

#define MAX_ITEM 39

typedef struct
{
	CString name;
	CString addr;
	CString unit;
	int		dot;
} PARA;
#define ITEM(name,addr,unit,dot) {_T("name"),_T("addr"),_T("unit"),dot}
//const PARA param[]={
//	{_T("name"),_T("addr"),_T("unit"),5}
//}
class CPC_LDRView : public CFormView
{
protected: // create from serialization only
	CPC_LDRView();
	DECLARE_DYNCREATE(CPC_LDRView)

public:
	//{{AFX_DATA(CPC_LDRView)
	enum { IDD = IDD_PC_LDR_FORM };
	CLed	m_led_open;
	CLed	m_led_nudge;
	CLed	m_led_hcl;
	CLed	m_led_close;
	CProgressCtrl	m_Progress;
	CComboBox	m_GroupSet;
	CMyListCtrl	m_listCtrl;
	CComboBox	m_VarSelCombo;
	BOOL	m_bCommEn;
	CString	m_disp;
	CString	m_sSelVari;
	CString	m_iDataSet;
	CString	m_wData;
	CString	m_wIndexSet;
	//}}AFX_DATA

	CString m_sFileDir;
	CString VarNames[2000];
	int		VarAddrs[2000];
	CString VarType;
	CComm	m_pComm;
	BYTE	m_RxBuf[100];
	char	m_init_path[_MAX_DIR];
// Attributes
public:
	CPC_LDRDoc* GetDocument();

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPC_LDRView)
	public:
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual void OnInitialUpdate(); // called first time after construct
	virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
	virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnPrint(CDC* pDC, CPrintInfo* pInfo);
	//}}AFX_VIRTUAL

// Implementation
public:
	bool m_bWithNoUnit;
	int m_iTxWait;
	int m_iTxWaitCnt;
	unsigned int m_SendData;
	int m_SendAddr;
	int m_iSetData;
	int m_iCommCnt;
	void OpenComm();
	int m_iDispDelay;
	bool m_bDnBlink;
	bool m_bReloading;
	bool m_bDnAvail;
	int m_iDnCnt;
	int DgrAddr[10];
	int File2Data();
	int Data2File();
	CString FUnit[50];
	int Dec10[4];
	int DotPos[50];
	CString FAddr[50];
	CString FName[50];
	
	int m_wSetDataAddr;
	int m_wIndex;
	int SearchString(CString);
	void RefreshList(void);
	int m_listUpdate;
	CString sList[2000][3];
	CString m_sMapFileName;
	int m_iPort;
	int Map2List(CString);
	int AddVari(int);
	int ASCII2Int(	BYTE* addr);
	int m_tic;
	void RxService(void);
	int m_iRxIdx;
	int m_iRxWaitCnt;
	int m_iRxWait;
	void WrDataReq(unsigned int ID, unsigned int Addr, unsigned int *Data, unsigned int Len);
	void RdDataReq(unsigned int ID, unsigned int Addr, unsigned int Size);
	int m_iListCnt;
	bool m_bCom2;
	bool m_bCom1;
	void AddVariable(CMyListCtrl*);
	virtual ~CPC_LDRView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CPC_LDRView)
	afx_msg void OnCom1();
	afx_msg void OnCom2();
	afx_msg void OnCommEn();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnDel();
	afx_msg void OnDown();
	afx_msg void OnSetData();
	afx_msg void OnSetInt();
	afx_msg void OnSetUint();
	afx_msg void OnUp();
	afx_msg void OnSetBin();
	afx_msg void OnSetHex();
	afx_msg void OnFileNew();
	afx_msg void OnUpdateCom1(CCmdUI* pCmdUI);
	afx_msg void OnUpdateCom2(CCmdUI* pCmdUI);
	afx_msg void OnDestroy();
	afx_msg void OnDelAll();
	afx_msg void OnReload();
	afx_msg void OnSelchangeGroup();
	afx_msg void OnSet();
	afx_msg void OnStop();
	afx_msg void OnFwdRun();
	afx_msg void OnRevRun();
	afx_msg void OnFileOpen();
	afx_msg void OnFileSave();
	afx_msg void OnAppExit();
	afx_msg void OnParaSave();
	afx_msg void OnParaInit();
	afx_msg void OnDo2();
	afx_msg void OnDo3();
	afx_msg void OnDo4();
	afx_msg void OnDo5();
	afx_msg void OnClear();
	afx_msg void OnDo12();
	afx_msg void OnDo13();
	afx_msg void OnDo15();
	afx_msg void OnClear2();
	afx_msg void OnDoReady();
	//}}AFX_MSG
	afx_msg LONG OnReceiveData(UINT, LONG);
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // debug version in PC_LDRView.cpp
inline CPC_LDRDoc* CPC_LDRView::GetDocument()
   { return (CPC_LDRDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PC_LDRVIEW_H__8661F10C_6A12_41CC_B1DC_99DAFF29D915__INCLUDED_)
