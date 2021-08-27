//Comm.cpp Rs232c����� �ϱ� ���� Ŭ����
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
//����� �ϴ� ���μ��� �� ����Ÿ�� �������� �����ϴ�
//��ƾ ����ƾ�� OpenComPort �Լ� ����� ���ν����� �����
//OpenComPort �Լ� ����
DWORD CommWatchProc(LPVOID lpData)
{
   DWORD       dwEvtMask ;
   OVERLAPPED  os ;
   CComm*      npComm = (CComm*) lpData ;
   char InData[MAXBLOCK + 1];
//	int        nLength ;
   //idCommDev ��� �ڵ鿡 �ƹ��� com ��Ʈ�� �Ⱥپ� ������
   // ���� ����
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
               //�̰����� ����Ÿ�� �޴´�.
		      	}
		   }
		   while ( npComm->nLength > 0 ) ;
		}
   }

  
   CloseHandle( os.hEvent ) ;


   return( TRUE ) ;

} 
//����Ÿ�� �ϰ� ����Ÿ�� �о��ٴ�
//�޼����� �����Ѵ�.
void CComm::SetReadData(LPSTR data)
{
 	int	i;
	for(i=0;i<nLength;i++) abIn[i]=data[i];
//	abIn[i] = 0x00;
	abLength = nLength;
	//ConverData
	//������ �����쿡 WM_RECEIVEDATA�޽����� �����־�
	// ���� �����Ͱ� ���Դٴ� ���� �˷��ش�.
	SendMessage(m_hwnd,WM_RECEIVEDATA,0,0);

//	lstrcpy((LPSTR)abIn,(LPSTR)data);
 //  	abLength = nLength;
   //ConverData
   //������ �����쿡 WM_RECEIVEDATA�޼�����
   //�����־� ���� ����Ÿ�� ���Դٴ°���
   //�˷��ش�.
  // SendMessage(m_hwnd,WM_RECEIVEDATA,0,0);
 }
//�޼����� ������ hwnd����

BOOL CComm::SetRts()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb�� �⺻���� �޴´�.
//	dcb.fRtsControl = RTS_CONTROL_ENABLE; //Ctr Control for TECH MATE && FC
	dcb.fRtsControl = RTS_CONTROL_DISABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //����� dcb����
	return(fRetVal);
}

BOOL CComm::ClrRts()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb�� �⺻���� �޴´�.
//	dcb.fRtsControl = RTS_CONTROL_DISABLE; //Ctr Control for TECH MATE && FC
	dcb.fRtsControl = RTS_CONTROL_ENABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //����� dcb����
	return(fRetVal);
}

BOOL CComm::SetDtr()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb�� �⺻���� �޴´�.
//	dcb.fDtrControl = DTR_CONTROL_ENABLE; //Ctr Control  for TECH MATE && FC
	dcb.fDtrControl = DTR_CONTROL_DISABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //����� dcb����
	return(fRetVal);
}

BOOL CComm::ClrDtr()
{
	BOOL	fRetVal;
	DCB		dcb;
	dcb.DCBlength = sizeof(DCB);
	GetCommState(idComDev,&dcb);	//dcb�� �⺻���� �޴´�.
//	dcb.fDtrControl = DTR_CONTROL_DISABLE; //Ctr Control for TECH MATE && FC
	dcb.fDtrControl = DTR_CONTROL_ENABLE; //Ctr Control for HHi
	fRetVal = SetCommState(idComDev,&dcb); //����� dcb����
	return(fRetVal);
}

void CComm::SetHwnd(HWND hwnd)
{
   m_hwnd=hwnd;
}
//����Ʈ�� �����Ѵ�.
void CComm::SetComPort(int port,DWORD rate,BYTE bytesize,BYTE stop,BYTE parity)
{
   bPort=port;
   dwBaudRate=rate;
   bByteSize=bytesize;
   bStopBits=stop;
   bParity=parity;
}
//XonOff �� ���ϰ� ���� ����
void CComm::SetXonOff(BOOL chk)
{
   fXonXoff=chk;
}

//����Ʈ ������ �����.
//�̰��� ���鶧 ������ ������
// SetComPort(); -> SetXonOff() ->SetDtrRts() �Ѵ��� �����Ѵ�.
BOOL CComm::CreateCommInfo()
{
   osWrite.Offset = 0 ;
   osWrite.OffsetHigh = 0 ;
   osRead.Offset = 0 ;
   osRead.OffsetHigh = 0 ;

//�̺�Ʈ â�� ����
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

//com ��Ʈ�� ���� ������ �õ��Ѵ�.
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

   // COMM device�� ȭ���������� �����Ѵ�.

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
      //����Ʈ���� ����Ÿ�� ��ȯ�ϴ� ����� char������ �⺻���� ����
      //����
      SetCommMask( idComDev, EV_RXCHAR ) ;
      SetupComm( idComDev, 4096, 4096 ) ;
      //����̽��� �����Ⱑ ������ �𸣴ϱ� ������ û�Ҹ� ����!
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

   if (fRetVal)//������ �Ǿ��ٸ� fRetVal TRUE�̹Ƿ�
   {
      fConnected = TRUE ;//����Ǿ��ٰ� ������
      //���ν����� CommWatchProc�� �����ϴϱ� ���߿� ����Ÿ�� �Դٰ���
      //�ϸ� ��� ������ CommWatchProc�� ����Ѵ�.
      AfxBeginThread((AFX_THREADPROC)CommWatchProc,(LPVOID)this);
   }
   else
   {
      fConnected = FALSE ;
      CloseHandle( idComDev) ;
   }

   return ( fRetVal ) ;

} 

//ȭ�Ϸ� ������ ����Ʈ�� ���� ��Ʈ�� ������ ��Ų��.
//SetupConnection ������ CreateComPort�� ���־�� �Ѵ�.
BOOL CComm::SetupConnection()
{
   BOOL       fRetVal ;
// BYTE       bSet ;
   DCB        dcb ;

   dcb.DCBlength = sizeof( DCB ) ;

   GetCommState( idComDev, &dcb ) ;//dcb�� �⺻���� �޴´�.


   //�̺κ��� �����ؾ� �մϴ�.
   dcb.BaudRate = dwBaudRate;//���ۼӵ�
   dcb.ByteSize = bByteSize ;//����Ÿ��Ʈ
   dcb.Parity = bParity;//�и�Ƽ üũ
   dcb.StopBits = bStopBits;//�����ư
   dcb.fOutxDsrFlow =0 ;//Dsr Flow
   dcb.fDtrControl = DTR_CONTROL_ENABLE ;//Dtr Control
   dcb.fOutxCtsFlow = 0 ;//Cts Flow
   dcb.fRtsControl = RTS_CONTROL_ENABLE ; //Ctr Control
   dcb.fInX = dcb.fOutX = 0 ; //XON/XOFF ���Ѱ�
   dcb.XonChar = ASCII_XON ;			//
   dcb.XoffChar = ASCII_XOFF ;			//
   dcb.XonLim = 100 ;
   dcb.XoffLim = 100 ;
   dcb.fBinary = TRUE ;
   dcb.fParity = TRUE ;

   fRetVal = SetCommState( idComDev, &dcb ) ; //����� Dcb ����

   return ( fRetVal ) ;

} 

//����Ʈ�� ���� ����Ÿ�� �д´�.
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
         //�̰��� ���� �ִ°��̴�.
         //�� ReadFile ������ ����Ÿ�� ����� �ȳ����� fReadState�� ����
         //���� �ڵ带 �����Ѵ�. �̶� �����Ҽ������� ������ ��������
         //������ �Ұ����ϴ� ���� ������� �ش޶�� �޼����� ���ִ°���
         //����.
		}
   }
   
   return ( dwLength ) ;

} 
//����Ʈ�� ������ �����Ѵ�.

BOOL CComm::DestroyComm()
{


   if (fConnected)
      CloseConnection( ) ;


   CloseHandle( osRead.hEvent ) ;
   CloseHandle( osWrite.hEvent ) ;

   return ( TRUE ) ;

} 

//������ �ݴ´�.
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
      //�̶��� ��� �ұ� �װ��� ����� �����̰ڴ�.
      //�ٽ� ������ ������ ���ͼ����� �ϸ� �ȴ�.
      //�׷��� ������ ���� ������ ���� �ִٴ����� �����϶�
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
