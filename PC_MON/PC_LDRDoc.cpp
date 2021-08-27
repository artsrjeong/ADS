// PC_LDRDoc.cpp : implementation of the CPC_LDRDoc class
//

#include "stdafx.h"
#include "PC_LDR.h"

#include "PC_LDRDoc.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRDoc

IMPLEMENT_DYNCREATE(CPC_LDRDoc, CDocument)

BEGIN_MESSAGE_MAP(CPC_LDRDoc, CDocument)
	//{{AFX_MSG_MAP(CPC_LDRDoc)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRDoc construction/destruction

CPC_LDRDoc::CPC_LDRDoc()
{
	// TODO: add one-time construction code here

}

CPC_LDRDoc::~CPC_LDRDoc()
{
}

BOOL CPC_LDRDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// TODO: add reinitialization code here
	// (SDI documents will reuse this document)

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CPC_LDRDoc serialization

void CPC_LDRDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// TODO: add storing code here
	}
	else
	{
		// TODO: add loading code here
	}
}

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRDoc diagnostics

#ifdef _DEBUG
void CPC_LDRDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CPC_LDRDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CPC_LDRDoc commands
