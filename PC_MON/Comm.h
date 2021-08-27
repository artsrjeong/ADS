//Comm.h
//Rs232c를 하기위한 클래스 헤더
#define MAXBLOCK        80
#define MAXPORTS        4


// Flow control flags

#define FC_DTRDSR       0x01
#define FC_RTSCTS       0x02
#define FC_XONXOFF      0x04

// ascii definitions

#define ASCII_BEL       0x07
#define ASCII_BS        0x08
#define ASCII_LF        0x0A
#define ASCII_CR        0x0D
#define ASCII_XON       0x11
#define ASCII_XOFF      0x13
#define WM_RECEIVEDATA WM_USER+1

// global stuff



// function prototypes (private)

/////////////////////////////////////////////////////////////////////////////
// CComm window

class CComm : public CObject
{

   DECLARE_DYNCREATE( CComm )
public:
   HANDLE      idComDev ;//컴포트 디바이스 연결 핸들
   BOOL        fConnected;//컴포트가 연결되면 1로 설정
   BYTE       abIn[ MAXBLOCK + 1] ;//컴포트에서 들어오는 데이타
   HWND		m_hwnd;//메세지를 전달할 윈도우 플러그

   // Construction
public:
	CComm( );
   void SetXonOff(BOOL chk);//XonOff 설정
   //컴포트를 설정함
   void SetComPort(int port,DWORD rate,BYTE bytesize,BYTE stop,BYTE parity);
   //Dtr Rts설정
   //comm 포트를 만든다.
   BOOL CreateCommInfo();
   //comm 포트를 해제한다.
   BOOL DestroyComm();
   //컴포트에서 데이타를 받는다.
   int  ReadCommBlock( LPSTR, int ) ;
   //컴포트에 데이타를 넣는다.
   BOOL WriteCommBlock( LPSTR, DWORD);
   BOOL OpenComPort( ) ;//컴포트를 열고 연결을 시도한다.
   //포트를 연결한다.
   BOOL SetupConnection( ) ;
   //연결을 해제한다.
   BOOL CloseConnection( ) ;
   //읽은 데이타를 버퍼에 저장한다.
   void SetReadData(LPSTR data);
   //메세재를 보낼 윈도우 플래를 설정한다.
   void SetHwnd(HWND hwnd);
   BOOL SetRts();
   BOOL ClrRts();
   BOOL SetDtr();
   BOOL ClrDtr();

// Attributes
public:
   BYTE        bPort;
   BOOL         fXonXoff;
   BYTE        bByteSize, bFlowCtrl, bParity, bStopBits ;
   DWORD       dwBaudRate ;
   HANDLE hWatchThread;
   HWND        hTermWnd ;
   DWORD       dwThreadID ;
   OVERLAPPED  osWrite, osRead ;
	int		nLength, abLength;

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CComm)
	//}}AFX_VIRTUAL

// Implementation
public:
	void RdDataReq(unsigned int ID, unsigned int Addr, unsigned int Size);
	void WrDataReq(unsigned int ID, unsigned int Addr, unsigned int *Data, unsigned int Len);
	unsigned int AddData(unsigned short crc, unsigned short data);
	unsigned int GetCRC(char *data, unsigned int len);
	virtual ~CComm();

	// Generated message map functions
//	DECLARE_MESSAGE_MAP()
protected:
};


/////////////////////////////////////////////////////////////////////////////
