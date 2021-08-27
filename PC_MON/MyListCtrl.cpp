// MyListCtrl.cpp : implementation file
//

#include "stdafx.h"
#include "PC_LDR.h"
#include "MyListCtrl.h"
#include "DataInDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMyListCtrl

CMyListCtrl::CMyListCtrl()
{
}

CMyListCtrl::~CMyListCtrl()
{
//	AfxMessageBox("list");
}


BEGIN_MESSAGE_MAP(CMyListCtrl, CListCtrl)
	//{{AFX_MSG_MAP(CMyListCtrl)
	ON_WM_LBUTTONDBLCLK()
	ON_WM_RBUTTONDOWN()
	ON_NOTIFY_REFLECT(NM_RCLICK, OnRclick)
	ON_WM_RBUTTONUP()
	ON_NOTIFY_REFLECT(NM_DBLCLK, OnDblclk)
	ON_NOTIFY(HDN_ITEMCLICKA, 0, OnHeaderClicked) 
	ON_NOTIFY(HDN_ITEMCLICKW, 0, OnHeaderClicked)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


BOOL CMyListCtrl::SortTextItems( int nCol, BOOL bAscending, int low , int high)
{
	if( nCol >= ((CHeaderCtrl*)GetDlgItem(0))->GetItemCount() )
		return FALSE;

	if( high == -1 ) high = GetItemCount() - 1;

	int lo = low;
	int hi = high;
	CString midItem;

	if( hi <= lo ) return FALSE;

	midItem = GetItemText( (lo+hi)/2, nCol );

	// loop through the list until indices cross
	while( lo <= hi )
	{
		// rowText will hold all column text for one row
		CStringArray rowText;

		// find the first element that is greater than or equal to 
		// the partition element starting from the left Index.
		if( bAscending )
			while( ( lo < high ) && ( GetItemText(lo, nCol) < midItem ) )
				++lo;
		else
			while( ( lo < high ) && ( GetItemText(lo, nCol) > midItem ) )
				++lo;

		// find an element that is smaller than or equal to 
		// the partition element starting from the right Index.
		if( bAscending )
			while( ( hi > low ) && ( GetItemText(hi, nCol) > midItem ) )
				--hi;
		else
			while( ( hi > low ) && ( GetItemText(hi, nCol) < midItem ) )
				--hi;

		// if the indexes have not crossed, swap
		// and if the items are not equal
		if( lo <= hi )
		{
			// swap only if the items are not equal
			if( GetItemText(lo, nCol) != GetItemText(hi, nCol))
			{
				// swap the rows
				LV_ITEM lvitemlo, lvitemhi;
				int nColCount = 
					((CHeaderCtrl*)GetDlgItem(0))->GetItemCount();
				rowText.SetSize( nColCount );
				int i;
				for( i=0; i<nColCount; i++)
					rowText[i] = GetItemText(lo, i);
				lvitemlo.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
				lvitemlo.iItem = lo;
				lvitemlo.iSubItem = 0;
				lvitemlo.stateMask = LVIS_CUT | LVIS_DROPHILITED | 
						LVIS_FOCUSED |  LVIS_SELECTED | 
						LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;

				lvitemhi = lvitemlo;
				lvitemhi.iItem = hi;

				GetItem( &lvitemlo );
				GetItem( &lvitemhi );

				for( i=0; i<nColCount; i++)
					SetItemText(lo, i, GetItemText(hi, i));

				lvitemhi.iItem = lo;
				SetItem( &lvitemhi );

				for( i=0; i<nColCount; i++)
					SetItemText(hi, i, rowText[i]);

				lvitemlo.iItem = hi;
				SetItem( &lvitemlo );
			}

			++lo;
			--hi;
		}
	}

	// If the right index has not reached the left side of array
	// must now sort the left partition.
	if( low < hi )
		SortTextItems( nCol, bAscending , low, hi);

	// If the left index has not reached the right side of array
	// must now sort the right partition.
	if( lo < high )
		SortTextItems( nCol, bAscending , lo, high );

	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// CMyListCtrl message handlers
void CMyListCtrl::OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult) 
{
        HD_NOTIFY *phdn = (HD_NOTIFY *) pNMHDR;

/*        if( phdn->iButton == 0 )
        {
                // User clicked on header using left mouse button
                if( phdn->iItem == nSortedCol )
                        bSortAscending = !bSortAscending;
                else
                        bSortAscending = TRUE;

                nSortedCol = phdn->iItem;
                SortTextItems( nSortedCol, bSortAscending, 0,-1);

        }
*/
        *pResult = 0;
}

int CMyListCtrl::HitTestEx(CPoint &point, int *col)
{
	int colnum = 0;
	int row = HitTest( point, NULL );
	
	if( col ) *col = 0;

	// Make sure that the ListView is in LVS_REPORT
	if( (GetWindowLong(m_hWnd, GWL_STYLE) & LVS_TYPEMASK) != LVS_REPORT )
		return row;

	// Get the top and bottom row visible
	row = GetTopIndex();
	int bottom = row + GetCountPerPage();
	if( bottom > GetItemCount() )
		bottom = GetItemCount();
	
	// Get the number of columns
	CHeaderCtrl* pHeader = (CHeaderCtrl*)GetDlgItem(0);
	int nColumnCount = pHeader->GetItemCount();

	// Loop through the visible rows
	for( ;row <=bottom;row++)
	{
		// Get bounding rect of item and check whether point falls in it.
		CRect rect;
		GetItemRect( row, &rect, LVIR_BOUNDS );
		if( rect.PtInRect(point) )
		{
			// Now find the column
			for( colnum = 0; colnum < nColumnCount; colnum++ )
			{
				int colwidth = GetColumnWidth(colnum);
				if( point.x >= rect.left 
					&& point.x <= (rect.left + colwidth ) )
				{
					if( col ) *col = colnum;
					return row;
				}
				rect.left += colwidth;
			}
		}
	}
	return -1;

}

void CMyListCtrl::OnLButtonDblClk(UINT nFlags, CPoint point) 
{
	// TODO: Add your message handler code here and/or call default
	m_iClickRow = HitTestEx(point, &m_iClickCol);

	CString sTmp;
	CMyListCtrl *who;
	CPC_LDRApp *pApp=(CPC_LDRApp *)AfxGetApp();
	who = this;

	if(m_iClickCol==2){
		CDataInDlg pDlg;
		if(pDlg.DoModal()==IDOK){
//				int iTmp = pDlg.m_iSetData;
			float fin;
			CString DataIn = pDlg.m_sSetData;
			sscanf(DataIn,"%5.1f",&fin);
			sTmp.Format("%d",0);

//				m_iSetData[m_iSetDataIdx++] = iTmp;
			m_sSetData[m_iSetDataIdx++] = DataIn;
			SetItemText(m_iClickRow, m_iClickCol, (LPSTR)(LPCSTR)DataIn);
//				SetItemText(m_iClickRow, m_iClickCol, (LPSTR)(LPCSTR)sTmp);
			m_bOK = TRUE;
		}
		else{
			m_bOK = TRUE;
		}	

	}		

	CListCtrl::OnLButtonDblClk(nFlags, point);
}

void CMyListCtrl::OnRButtonDown(UINT nFlags, CPoint point) 
{
	// TODO: Add your message handler code here and/or call default
	m_point = point;
/*	CMenu contmenu;
	CMenu *pMenu;

	m_iClickRow = HitTestEx(point, &m_iClickCol);

	contmenu.LoadMenu(IDR_LIST_MENU);
	pMenu=contmenu.GetSubMenu(0);
	ClientToScreen(&point);

	pMenu->TrackPopupMenu( TPM_LEFTALIGN | TPM_RIGHTBUTTON,point.x,point.y,AfxGetMainWnd());
*/
	CListCtrl::OnRButtonDown(nFlags, point);
}

void CMyListCtrl::OnRclick(NMHDR* pNMHDR, LRESULT* pResult) 
{
	// TODO: Add your control notification handler code here
	return;
	CMenu contmenu;
	CMenu *pMenu;

	m_iClickRow = HitTestEx(m_point, &m_iClickCol);

	contmenu.LoadMenu(IDR_LIST_MENU);
	pMenu=contmenu.GetSubMenu(0);

	ClientToScreen(&m_point);

	pMenu->TrackPopupMenu( TPM_LEFTALIGN | TPM_RIGHTBUTTON,m_point.x,m_point.y,AfxGetMainWnd());
	
	*pResult = 0;
}

BOOL CMyListCtrl::OnNotify(WPARAM wParam, LPARAM lParam, LRESULT* pResult) 
{
	// TODO: Add your specialized code here and/or call the base class
    switch (((NMHDR*)lParam)->code)
    {
            case HDN_BEGINTRACKW:
            case HDN_BEGINTRACKA:
                    *pResult = TRUE;                // disable tracking
                    return TRUE;                    // Processed message
    }
	
	return CListCtrl::OnNotify(wParam, lParam, pResult);
}

void CMyListCtrl::OnDblclk(NMHDR* pNMHDR, LRESULT* pResult) 
{
	// TODO: Add your control notification handler code here
	
	NMLISTVIEW* pNMListView = (NM_LISTVIEW*)pNMHDR; 
	*pResult = 0; 
	// 사각형 영역을 얻어옵니다. 
/*	CListCtrl* pList = &GetListCtrl(); 
	CRect rc; 
	pList->GetSubItemRect(pNMListView->iItem, pNMListView->iSubItem, LVIR_BOUNDS, rc); 
*/
// 에디트 컨트롤을 생성합니다. 

}
