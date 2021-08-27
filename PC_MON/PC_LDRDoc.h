// PC_LDRDoc.h : interface of the CPC_LDRDoc class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_PC_LDRDOC_H__1E4266AC_5934_42F3_8AAC_2D27A7F5365C__INCLUDED_)
#define AFX_PC_LDRDOC_H__1E4266AC_5934_42F3_8AAC_2D27A7F5365C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


class CPC_LDRDoc : public CDocument
{
protected: // create from serialization only
	CPC_LDRDoc();
	DECLARE_DYNCREATE(CPC_LDRDoc)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPC_LDRDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CPC_LDRDoc();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	//{{AFX_MSG(CPC_LDRDoc)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PC_LDRDOC_H__1E4266AC_5934_42F3_8AAC_2D27A7F5365C__INCLUDED_)
