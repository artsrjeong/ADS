//Comm.h
//Rs232c�� �ϱ����� Ŭ���� ���
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
   HANDLE      idComDev ;//����Ʈ ����̽� ���� �ڵ�
   BOOL        fConnected;//����Ʈ�� ����Ǹ� 1�� ����
   BYTE       abIn[ MAXBLOCK + 1] ;//����Ʈ���� ������ ����Ÿ
   HWND		m_hwnd;//�޼����� ������ ������ �÷���

   // Construction
public:
	CComm( );
   void SetXonOff(BOOL chk);//XonOff ����
   //����Ʈ�� ������
   void SetComPort(int port,DWORD rate,BYTE bytesize,BYTE stop,BYTE parity);
   //Dtr Rts����
   //comm ��Ʈ�� �����.
   BOOL CreateCommInfo();
   //comm ��Ʈ�� �����Ѵ�.
   BOOL DestroyComm();
   //����Ʈ���� ����Ÿ�� �޴´�.
   int  ReadCommBlock( LPSTR, int ) ;
   //����Ʈ�� ����Ÿ�� �ִ´�.
   BOOL WriteCommBlock( LPSTR, DWORD);
   BOOL OpenComPort( ) ;//����Ʈ�� ���� ������ �õ��Ѵ�.
   //��Ʈ�� �����Ѵ�.
   BOOL SetupConnection( ) ;
   //������ �����Ѵ�.
   BOOL CloseConnection( ) ;
   //���� ����Ÿ�� ���ۿ� �����Ѵ�.
   void SetReadData(LPSTR data);
   //�޼��縦 ���� ������ �÷��� �����Ѵ�.
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
