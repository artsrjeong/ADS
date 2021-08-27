//Comm.cpp Rs232c통신을 하기 위한 클래스
#include "stdafx.h"
#include "comm.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

IMPLEMENT_DYNCREATE(CComm, CObject)



CComm::CComm( )
{
   idComDev=NULL;
//   bFlowCtrl= FC_XONXOFF ;
   fConnected      = FALSE ;
}

CComm::~CComm( )
{
    DestroyComm();
}

//BEGIN_MESSAGE_MAP(CComm, CObject)
	//{{AFX_MSG_MAP(CComm)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
//END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CComm message handlers
//CommWatchProc()
//통신을 하는 프로세저 즉 데이타가 들어왔을대 감시하는
//루틴 본루틴은 OpenComPort 함수 실행시 프로시저로 연결됨
//OpenComPort 함수 참조
DWORD CommWatchProc(LPVOID lpData)
{
   DWORD       dwEvtMask ;
   OVERLAPPED  os ;
   CComm*      npComm = (CComm*) lpData ;
   char InData[MAXBLOCK + 1];
//	int        nLength ;
   //idCommDev 라는 핸들에 아무런 com 포트가 안붙어 잇으면
   // 에라 리턴
   if ( npComm == NULL || 
      !npComm->IsKindOf( RUNTIME_CLASS( CComm ) ) )
      return (DWORD)(-1);

   memset( &os, 0, sizeof( OVERLAPPED ) ) ;


   os.hEvent = CreateEvent( NULL,    // no security
                            TRUE,    // explicit reset req
                            FALSE,   // initial event reset
                            NULL ) ; // no name
   if ( os.hEvent == NULL )
   {
      MessageBox( NULL, "Failed to create event for thread!", "comm Error!",
                  MB_ICONEXCLAMATION | MB_OK ) ;
      return ( FALSE ) ;
   }

   if (!SetCommMask(npComm->idComDev, EV_RXCHAR ))
      return ( FALSE ) ;

   while (npComm->fConnected )
   {
		dwEvtMask = 0 ;

		WaitCommEvent(npComm->idComDev, &dwEvtMask, NULL );

		if ((dwEvtMask & EV_RXCHAR) == EV_RXCHAR)
		{
			do
		   {
			   memset(InData,0,80);
				if (npComm->nLength = npComm->ReadCommBlock((LPSTR) InData, MAXBLOCK ))
				{
                  npComm->SetReadData(InData);
               //이곳에서 데이타를 받는다.
		      	}
		   }
		   while ( npComm->nLength > 0 ) ;
		}
   }

  
   CloseHandle( os.hEvent ) ;


   return( TRUE ) ;

} 
//데이타를 일고 데이타를 읽었다는
//메세지를 리턴한다.
void CComm::SetReadData(LPSTR data)
{
 	int	i;
	for(i=0;i<nLength;i++) abIn[i]=data[i];
//	abIn[i] = 0x00;
	abLength = nLength;
	//ConverData
	//설정된 윈도우에 WM_RECEIVEDATA메시지를 날려주어
	// 현재 데이터가 들어왔다는 것을 알려준다.
	SendMessage(m_hwnd,WM_RECEIVEDATA,0,0);

//	lstrcpy((LPSTR)abIn,(LPSTR)data);
 //  	abLength = nLength;
   //ConverData
   //설정된 윈도우에 WM_RECEIVEDATA메세지를
   //날려주어 현제 데이타가 들어왔다는것을
   //알려준다.
  // SendMessage(m_hwnd,WM_RECEIVEDATA,0,0);
 }
//메세지를 전달할 hwnd설정

BOOL CComm::SetRts()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb의 기본값을 받는다.
//	dcb.fRtsControl = RTS_CONTROL_ENABLE; //Ctr Control for TECH MATE && FC
	dcb.fRtsControl = RTS_CONTROL_DISABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //변경된 dcb설정
	return(fRetVal);
}

BOOL CComm::ClrRts()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb의 기본값을 받는다.
//	dcb.fRtsControl = RTS_CONTROL_DISABLE; //Ctr Control for TECH MATE && FC
	dcb.fRtsControl = RTS_CONTROL_ENABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //변경된 dcb설정
	return(fRetVal);
}

BOOL CComm::SetDtr()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb의 기본값을 받는다.
//	dcb.fDtrControl = DTR_CONTROL_ENABLE; //Ctr Control  for TECH MATE && FC
	dcb.fDtrControl = DTR_CONTROL_DISABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //변경된 dcb설정
	return(fRetVal);
}

BOOL CComm::ClrDtr()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb의 기본값을 받는다.
//	dcb.fDtrControl = DTR_CONTROL_DISABLE; //Ctr Control for TECH MATE && FC
	dcb.fDtrControl = DTR_CONTROL_ENABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //변경된 dcb설정
	return(fRetVal);
}

void CComm::SetHwnd(HWND hwnd)
{
   m_hwnd=hwnd;
}
//컴포트를 설정한다.
void CComm::SetComPort(int port,DWORD rate,BYTE bytesize,BYTE stop,BYTE parity)
{
   bPort=port;
   dwBaudRate=rate;
   bByteSize=bytesize;
   bStopBits=stop;
   bParity=parity;
}
//XonOff 즉 리턴값 더블 설정
void CComm::SetXonOff(BOOL chk)
{
   fXonXoff=chk;
}

//컴포트 정보를 만든다.
//이것을 만들때 이전에 할일이
// SetComPort(); -> SetXonOff() ->SetDtrRts() 한다음 설정한다.
BOOL CComm::CreateCommInfo()
{
   osWrite.Offset = 0 ;
   osWrite.OffsetHigh = 0 ;
   osRead.Offset = 0 ;
   osRead.OffsetHigh = 0 ;

//이벤트 창구 설정
   osRead.hEvent = CreateEvent( NULL, TRUE, FALSE, NULL ) ; 
   if (osRead.hEvent == NULL)
   {
      return FALSE ;
   }
   osWrite.hEvent = CreateEvent( NULL,   TRUE,  FALSE,   NULL ) ;
   if (NULL == osWrite.hEvent)
   {
      CloseHandle( osRead.hEvent ) ;
      return FALSE;
   }


   return TRUE ;

} 

//com 포트를 열고 연결을 시도한다.
//OpenComport()
BOOL CComm::OpenComPort( )
{            
   char       szPort[ 15 ] ;
   BOOL       fRetVal ;
   COMMTIMEOUTS  CommTimeOuts ;


   if (bPort > MAXPORTS)
      lstrcpy( szPort, "\\\\.\\TELNET" ) ;
   else
      wsprintf( szPort, "COM%d", bPort ) ;

   // COMM device를 화일형식으로 연결한다.

   if ((idComDev =
      CreateFile( szPort, GENERIC_READ | GENERIC_WRITE,
                  0,                    // exclusive access
                  NULL,                 // no security attrs
                  OPEN_EXISTING,
                   FILE_ATTRIBUTE_NORMAL | 
                  FILE_FLAG_OVERLAPPED, // overlapped I/O
                  NULL )) == (HANDLE) -1 )
      return ( FALSE ) ;
   else
   {
      //컴포트에서 데이타를 교환하는 방법을 char단위를 기본으로 설정
      //하자
      SetCommMask( idComDev, EV_RXCHAR ) ;
      SetupComm( idComDev, 4096, 4096 ) ;
      //디바이스에 쓰레기가 있을지 모르니까 깨끗이 청소를 하자!
      PurgeComm( idComDev, PURGE_TXABORT | PURGE_RXABORT |
                                      PURGE_TXCLEAR | PURGE_RXCLEAR ) ;

     
      CommTimeOuts.ReadIntervalTimeout = 0xFFFFFFFF ;
      CommTimeOuts.ReadTotalTimeoutMultiplier = 0 ;
      CommTimeOuts.ReadTotalTimeoutConstant = 1000 ;
      CommTimeOuts.WriteTotalTimeoutMultiplier = 0 ;
      CommTimeOuts.WriteTotalTimeoutConstant = 1000 ;
      SetCommTimeouts( idComDev, &CommTimeOuts ) ;
   }

   fRetVal = SetupConnection() ;

   if (fRetVal)//연결이 되었다면 fRetVal TRUE이므로
   {
      fConnected = TRUE ;//연결되었다고 말해줌
      //프로시전를 CommWatchProc에 연결하니까 나중에 데이타가 왔다갔다
      //하면 모든 내용은 CommWatchProc가 담당한다.
      AfxBeginThread((AFX_THREADPROC)CommWatchProc,(LPVOID)this);
   }
   else
   {
      fConnected = FALSE ;
      CloseHandle( idComDev) ;
   }

   return ( fRetVal ) ;

} 

//화일로 설정된 컴포트와 실질 포트와 연결을 시킨다.
//SetupConnection 이전에 CreateComPort를 해주어야 한다.
BOOL CComm::SetupConnection()
{
   BOOL       fRetVal ;
// BYTE       bSet ;
   DCB        dcb ;

   dcb.DCBlength = sizeof( DCB ) ;

   GetCommState( idComDev, &dcb ) ;//dcb의 기본값을 받는다.


   //이부분을 수정해야 합니다.
   dcb.BaudRate = dwBaudRate;//전송속도
   dcb.ByteSize = bByteSize ;//데이타비트
   dcb.Parity = bParity;//패리티 체크
   dcb.StopBits = bStopBits;//스톱비튼
   dcb.fOutxDsrFlow =0 ;//Dsr Flow
   dcb.fDtrControl = DTR_CONTROL_ENABLE ;//Dtr Control
   dcb.fOutxCtsFlow = 0 ;//Cts Flow
   dcb.fRtsControl = RTS_CONTROL_ENABLE ; //Ctr Control
   dcb.fInX = dcb.fOutX = 0 ; //XON/XOFF 관한것
   dcb.XonChar = ASCII_XON ;			//
   dcb.XoffChar = ASCII_XOFF ;			//
   dcb.XonLim = 100 ;
   dcb.XoffLim = 100 ;
   dcb.fBinary = TRUE ;
   dcb.fParity = TRUE ;

   fRetVal = SetCommState( idComDev, &dcb ) ; //변경된 Dcb 설정

   return ( fRetVal ) ;

} 

//컴포트로 부터 데이타를 읽는다.
int CComm::ReadCommBlock(LPSTR lpszBlock, int nMaxLength )
{
	BOOL       fReadStat ;
	COMSTAT    ComStat ;
	DWORD      dwErrorFlags;
	DWORD      dwLength;

	// only try to read number of bytes in queue 
	ClearCommError( idComDev, &dwErrorFlags, &ComStat ) ;
	dwLength = min( (DWORD) nMaxLength, ComStat.cbInQue ) ;

	if (dwLength > 0)
	{
		fReadStat = ReadFile( idComDev, lpszBlock,
		                    dwLength, &dwLength, &osRead ) ;
		if (!fReadStat)
		{
         //이곳에 에라를 넣는것이다.
         //즉 ReadFile 했을때 데이타가 제대로 안나오면 fReadState에 여러
         //에라 코드를 리턴한다. 이때 복구할수있으면 좋지만 실질적인
         //복구가 불가능하다 따라서 재송출을 해달라는 메세지를 해주는것이
         //좋다.
		}
   }
   
   return ( dwLength ) ;

} 
//컴포트를 완전히 해제한다.

BOOL CComm::DestroyComm()
{


   if (fConnected)
      CloseConnection( ) ;


   CloseHandle( osRead.hEvent ) ;
   CloseHandle( osWrite.hEvent ) ;

   return ( TRUE ) ;

} 

//연결을 닫는다.
BOOL CComm::CloseConnection()
{

   // set connected flag to FALSE

   fConnected = FALSE ;

   // disable event notification and wait for thread
   // to halt

   SetCommMask( idComDev, 0 ) ;

   EscapeCommFunction( idComDev, CLRDTR ) ;


   PurgeComm( idComDev, PURGE_TXABORT | PURGE_RXABORT |
                                   PURGE_TXCLEAR | PURGE_RXCLEAR ) ;
   CloseHandle( idComDev ) ;
   return ( TRUE ) ;

} 


BOOL CComm::WriteCommBlock( LPSTR lpByte , DWORD dwBytesToWrite)
{

	BOOL        fWriteStat ;
	DWORD       dwBytesWritten ;
	CString		strTmp;

//	ClearCommError(idComDev,&lpError, &ComStat);
//	ClearCommBreak(idComDev);
//	strTmp.Format("%d  %d  %d",ComStat.fTxim,ComStat.cbOutQue,lpError);
//	AfxMessageBox(strTmp);
	//	for(i=0;i<dwBytesToWrite;i++)
	//		TransmitCommChar(idComDev,*lpByte++);

	//	return ( TRUE );

	fWriteStat = WriteFile( idComDev, lpByte, dwBytesToWrite,
	                       &dwBytesWritten, &osWrite ) ;
	if (!fWriteStat) 
	{
		return ( FALSE );
      //이때는 어떻게 할까 그것은 사용자 마음이겠다.
      //다시 보내고 싶으면 제귀송출을 하면 된다.
      //그러나 주의점 무한 루프를 돌수 있다는점을 생각하라
	}
	return ( TRUE ) ;
} 

unsigned int CComm::GetCRC(char *data, unsigned int len)
{
	unsigned short wSeed,i;
	
	wSeed = 0xffff;

	for(i=0;i<len;i++){
		wSeed = AddData(wSeed,(*data++&0xff));
	}
	return (((wSeed<<8)&0xff00)|((wSeed>>8)&0xff));
}

unsigned int CComm::AddData(unsigned short crc, unsigned short data)
{
	unsigned short out,i;
	out = crc^data;

	for(i=0;i<8;i++){
		if(out&1){
			out= (out>>1)^0xa001;
		}		
		else
			out= out>>1;		
	}
	return out;
}

void CComm::WrDataReq(unsigned int ID, unsigned int Addr, unsigned int *Data, unsigned int Len)
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
	
	wTmp = GetCRC(&TxBuf[0],6);

	TxBuf[6] = (wTmp>>8)&0xff;
	TxBuf[7] = wTmp&0xff;

	WriteCommBlock((LPSTR)TxBuf, tx_len);
}

void CComm::RdDataReq(unsigned int ID, unsigned int Addr, unsigned int Size)
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
	
	wTmp = GetCRC(&TxBuf[0],6);

	TxBuf[6] = (wTmp>>8)&0xff;
	TxBuf[7] = wTmp&0xff;

	WriteCommBlock((LPSTR)TxBuf, tx_len);

//	m_iRxWait = TRUE;
//	m_iRxWaitCnt = 0;
//	m_iRxIdx = 0;
}
