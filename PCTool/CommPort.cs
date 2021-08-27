/*
 * Author: Marcus Lorentzon, 2001
 * 
 * Freeware: Do not remove this header
 * 
 * File: Serial.cs
 * 
 * Description: Implements a Stream for asynchronous
 *              transfers and COMM. Uses .NET Beta 2.
 *
 * Version: 2.01 beta
 * _______________________________________________________
 * 
 * Modify by Kyl,In-Ho. Uses .NET RC0
 * forsky@innogen.co.kr or forsky@netsgo.com
 * www.zini.pe.kr
 * Date: 2001-12-20
 * Update: Read, Write, WaitCommEvent, etc..
 *  
 * Marcus Lorentzon 님이 만드신 것을 일부 수정했습니다. 
 * (Stream 처리 한 것을 API로 교체했습니다.)
 * Read() 쪽의 Blocking 이 처리가 안 되어 있어서요.
 * 수정후 보니,, 쩝~ 50% 이상 소스가 변질(?)되었군염. 
 * 수정부분의 상당량은, DELPHI의 CommPort 컴포넌트의
 * 소스를 포팅한 것입니다.
 * 
 * Write() 함수 쪽은, 현재 TrasmitComChar() 로 처리했습니다.
 * 주석처리 해 놓은 부분은 사용해도 되지만, 전송한 Byte 수가
 * 정상적으로 return 되지 않습니다.
 * 
 * 일부 소스에 오류를 발견하시면,
 * forsky@netsgo.com 또는 forsky@innogen.co.kr 로
 * 메일 날려 주시면 많은 도움이 되겠습니다.
 * 
 */
 

namespace PCTool
{
	using System;
	using System.IO;
	using System.Threading;
	using System.Runtime.InteropServices;	
	using System.Windows.Forms;

	public delegate void WatchHandler(int iLen);

	public class CommPort {		
		private int m_hFile = 0;
		private Thread m_CommThread = null;
		private string m_sPort = null;

		private	bool m_Connected = false;		
		private bool m_ThreadCreated = false;		
		private ManualResetEvent m_StopEvent = new ManualResetEvent(false);
		public WatchHandler WatchPtr = null;	

		public string Port 	
		{	get { return m_sPort;}	
			set { if (m_sPort != value) { Close(); if(value != null) Open(value);}}
		}
		public bool Connected {	get { return m_Connected;}	}
		public bool ThreadCreated {	get { return m_ThreadCreated; }	}		

		private const uint EVT_RXCHAR = 0x01;
		private const uint GENERIC_READ = 0x80000000;
		private const uint GENERIC_WRITE = 0x40000000;
		private const uint ERROR_IO_PENDING = 0x03E4;
		private const uint WAIT_OBJECT_0 = 0x00;		
		private const uint OPEN_EXISTING = 0x03;
		private const uint FILE_FLAG_OVERLAPPED = 0x40000000;
		private const uint ERROR_OPERATION_ABORTED = 0x03E3;		
		private const uint WAIT_FAILED = 0xFFFFFFFF; // if WaitForMultipleObjects() failed, return
		



		private void Open(string port) 
		{			
			m_hFile = CreateFile(port, (uint)(GENERIC_READ | GENERIC_WRITE), 0, 0, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0U);
			if (m_hFile <= 0) 				
				return;

			m_Connected = true;
			m_sPort = port;
		}

		public void Close() 
		{
			if(m_ThreadCreated)
				StopWatchThread();

			CloseHandle(m_hFile);
			m_hFile = 0;
			m_sPort = null;
			m_Connected = false;
		}

		public void Flush() { FlushFileBuffers(m_hFile); }

		private const uint PURGE_TXABORT = 0x0001;  // Kill the pending/current writes to the comm port.
		private const uint PURGE_RXABORT = 0x0002;  // Kill the pending/current reads to the comm port.
		private const uint PURGE_TXCLEAR = 0x0004;  // Kill the transmit queue if there.
		private const uint PURGE_RXCLEAR = 0x0008;  // Kill the typeahead buffer if there.

		public bool PurgeRead() { return(PurgeComm(m_hFile, PURGE_RXCLEAR)); }
		public bool PurgeWrite() { return(PurgeComm(m_hFile, PURGE_TXCLEAR)); }
		public bool CancelRead() { return(PurgeComm(m_hFile, PURGE_RXABORT)); }
		public bool CancelWrite() { return(PurgeComm(m_hFile, PURGE_TXABORT)); }


		public void SetTimeouts(int ReadIntervalTimeout, int ReadTotalTimeoutMultiplier, int ReadTotalTimeoutConstant, 
								int WriteTotalTimeoutMultiplier, int WriteTotalTimeoutConstant) {
			SerialTimeouts Timeouts = new SerialTimeouts(ReadIntervalTimeout, ReadTotalTimeoutMultiplier, ReadTotalTimeoutConstant, 
										 WriteTotalTimeoutMultiplier, WriteTotalTimeoutConstant);
			unsafe { SetCommTimeouts(m_hFile, &Timeouts); }
		}

		public void SetCommBuffer(uint dwInQue, uint dwOutQue)
		{
			SetupComm(m_hFile, dwInQue, dwOutQue);
		}

		public enum Parity {None, Odd, Even, Mark, Space};
		public enum StopBits {One, OneAndHalf, Two};
		public enum FlowControl {None, XOnXOff, Hardware};

		[StructLayout(LayoutKind.Sequential)]
		public struct COMSTAT 
		{
			public uint uiFlag;
			public uint cbInQue;
			public uint cbOutQue;
		}

		[StructLayout(LayoutKind.Sequential)]
		public struct DCB 
		{
			public int DCBlength;
			public uint BaudRate;
			public uint Flags;
			public uint fBinary { get { return Flags&0x0001; } 
								  set { Flags = Flags & ~1U | value; } }
			public uint fParity { get { return (Flags>>1)&1; }
								  set { Flags = Flags & ~(1U << 1) | (value << 1); } }
			public uint fOutxCtsFlow { get { return (Flags>>2)&1; }
								  set { Flags = Flags & ~(1U << 2) | (value << 2); } }
			public uint fOutxDsrFlow { get { return (Flags>>3)&1; }
								  set { Flags = Flags & ~(1U << 3) | (value << 3); } }
			public uint fDtrControl { get { return (Flags>>4)&3; }
								  set { Flags = Flags & ~(3U << 4) | (value << 4); } }
			public uint fDsrSensitivity { get { return (Flags>>6)&1; }
								  set { Flags = Flags & ~(1U << 6) | (value << 6); } }
			public uint fTXContinueOnXoff { get { return (Flags>>7)&1; }
								  set { Flags = Flags & ~(1U << 7) | (value << 7); } }
			public uint fOutX { get { return (Flags>>8)&1; }
								  set { Flags = Flags & ~(1U << 8) | (value << 8); } }
			public uint fInX { get { return (Flags>>9)&1; }
								  set { Flags = Flags & ~(1U << 9) | (value << 9); } }
			public uint fErrorChar { get { return (Flags>>10)&1; }
								  set { Flags = Flags & ~(1U << 10) | (value << 10); } }
			public uint fNull { get { return (Flags>>11)&1; }
								  set { Flags = Flags & ~(1U << 11) | (value << 11); } }
			public uint fRtsControl { get { return (Flags>>12)&3; }
								  set { Flags = Flags & ~(3U << 12) | (value << 12); } }
			public uint fAbortOnError { get { return (Flags>>13)&1; }
								  set { Flags = Flags & ~(1U << 13) | (value << 13); } }
			public ushort wReserved;
			public ushort XonLim;
			public ushort XoffLim;
			public byte ByteSize;
			public byte Parity;
			public byte StopBits;
			public sbyte XonChar;
			public sbyte XoffChar;
			public sbyte ErrorChar;
			public sbyte EofChar;
			public sbyte EvtChar;
			public ushort wReserved1;

			public override string ToString() {
				return "DCBlength: " + DCBlength + "\r\n" +
					"BaudRate: " + BaudRate + "\r\n" +
					"fBinary: " + fBinary + "\r\n" +
					"fParity: " + fParity + "\r\n" +
					"fOutxCtsFlow: " + fOutxCtsFlow + "\r\n" +
					"fOutxDsrFlow: " + fOutxDsrFlow + "\r\n" +
					"fDtrControl: " + fDtrControl + "\r\n" +
					"fDsrSensitivity: " + fDsrSensitivity + "\r\n" +
					"fTXContinueOnXoff: " + fTXContinueOnXoff + "\r\n" +
					"fOutX: " + fOutX + "\r\n" +
					"fInX: " + fInX + "\r\n" +
					"fErrorChar: " + fErrorChar + "\r\n" +
					"fNull: " + fNull + "\r\n" +
					"fRtsControl: " + fRtsControl + "\r\n" +
					"fAbortOnError: " + fAbortOnError + "\r\n" +
					"XonLim: " + XonLim + "\r\n" +
					"XoffLim: " + XoffLim + "\r\n" +
					"ByteSize: " + ByteSize + "\r\n" +
					"Parity: " + Parity + "\r\n" +
					"StopBits: " + StopBits + "\r\n" +
					"XonChar: " + XonChar + "\r\n" +
					"XoffChar: " + XoffChar + "\r\n" +
					"EofChar: " + EofChar + "\r\n" +
					"EvtChar: " + EvtChar + "\r\n";
			}
		}

		public bool SetPortSettings(uint baudrate, byte databits, StopBits stopbits, Parity parity, FlowControl flowcontrol) {
			unsafe {
				DCB dcb = new DCB();
				dcb.DCBlength = sizeof(DCB);
				dcb.BaudRate = baudrate;
				dcb.ByteSize = databits;
				dcb.StopBits = (byte)stopbits;
				dcb.Parity = (byte)parity;
				dcb.fParity = (parity > 0)? 1U : 0U;
				dcb.fBinary = dcb.fDtrControl = dcb.fTXContinueOnXoff = 1;
				dcb.fOutxCtsFlow = dcb.fAbortOnError = (flowcontrol == FlowControl.Hardware)? 1U : 0U;
				dcb.fOutX = dcb.fInX = (flowcontrol == FlowControl.XOnXOff)? 1U : 0U;
				dcb.fRtsControl = (flowcontrol == FlowControl.Hardware)? 2U : 1U;
				dcb.XonLim = 2048;
				dcb.XoffLim = 512;
				dcb.XonChar = 0x11;  // Ctrl-Q
				dcb.XoffChar = 0x13; // Ctrl-S				
				return (SetCommMask(m_hFile, EVT_RXCHAR) && SetCommState(m_hFile, &dcb));
			}
		}

		public bool GetPortSettings(out DCB dcb) {
			unsafe {
				DCB dcb2 = new DCB();
				dcb2.DCBlength = sizeof(DCB);
				bool ret = GetCommState(m_hFile, &dcb2);
				dcb = dcb2;
				return ret;
			}
		}

		public bool StartWatchThread()
		{
			if(!Connected)
				return false;

			m_StopEvent.Reset();
			m_CommThread = new Thread(new ThreadStart(this.WatchThreadProc));
			m_CommThread.Start();
			m_ThreadCreated = true;
			return true;
		}

		public void StopWatchThread()
		{
			if(ThreadCreated)
			{
				m_StopEvent.Set();	
				m_CommThread.Abort();
				m_CommThread.Join();
				Thread.Sleep(500);
				m_CommThread = null;
				m_ThreadCreated = false;
			}
		}

		private void WatchThreadProc()
		{		
			uint Signaled = 0;
			COMSTAT	comStat = new COMSTAT();
			NativeOverlapped Overlapped = new NativeOverlapped();
			ManualResetEvent WatchEvent = new ManualResetEvent(true);
			Overlapped.EventHandle = WatchEvent.Handle.ToInt32();			
			
			unsafe
			{	
				COMSTAT* pComStat = &comStat;
				NativeOverlapped *pOverlapped = &Overlapped;
				do
				{			
					uint dwMask = 0;
					WaitCommEvent(m_hFile, &dwMask, pOverlapped);	
					
					int[] EventHandles = {m_StopEvent.Handle.ToInt32(), 
									      WatchEvent.Handle.ToInt32() };
					fixed(int* pEventHandles = EventHandles )
						{
							Signaled = WaitForMultipleObjects(2, pEventHandles, false, Timeout.Infinite);							
						}					

					if(Signaled == WAIT_FAILED)
					{
						MessageBox.Show("WaitForMultipleObjects function failed : " + GetLastError().ToString());
						continue;
					}

					if(Signaled == WAIT_OBJECT_0+1)
					{						
						int ReadBytes = 0;
						GetOverlappedResult(m_hFile, pOverlapped, &ReadBytes, false);
					
						uint dwErrors = 0;
						ClearCommError(m_hFile, &dwErrors, pComStat );
						if( pComStat->cbInQue > 0 && WatchPtr != null)
						{
							WatchPtr((int)pComStat->cbInQue );						
						}
					}										
				}while(Signaled != WAIT_OBJECT_0 && m_hFile != 0);
			}
			
			SetCommMask(m_hFile, 0);
			PurgeComm(m_hFile, PURGE_TXCLEAR | PURGE_RXCLEAR);			
		}

		public int Read(byte[] RxBuf, int iLen)
		{
			NativeOverlapped Overlapped = new NativeOverlapped();
			ManualResetEvent ManualEvent = new ManualResetEvent(true);
			Overlapped.EventHandle = ManualEvent.Handle.ToInt32();			
			
			unsafe
			{				
				NativeOverlapped* pOverlapped = &Overlapped;

				int ReadBytes=0;
				fixed (byte* pBuf = &RxBuf[0])
					{				
						if(!(ReadFile(m_hFile, pBuf, iLen, &ReadBytes, (NativeOverlapped*)pOverlapped) ||
								(GetLastError() == ERROR_IO_PENDING))) return -1;
					}				

				int ReadDoneBytes = 0;
				int Signaled= WaitForSingleObject(pOverlapped->EventHandle, Timeout.Infinite);
				if(! ((Signaled == WAIT_OBJECT_0) &&				
		             GetOverlappedResult(m_hFile, pOverlapped, &ReadDoneBytes, false)))	return -2;

				return ReadDoneBytes;
			}
		}

		public int Write(byte[] TxBuf, int iLen)
		{
			if(!m_Connected)
				return -9;

			int i;
			for(i=0;i<iLen;i++)
				if(TransmitCommChar(m_hFile, TxBuf[i]) == 0) break;

			return i;
	
			/*
			NativeOverlapped Overlapped = new NativeOverlapped();
			ManualResetEvent ManualEvent = new ManualResetEvent(true);			
			unsafe
			{
				int WriteDoneBytes = 0;
				Overlapped.EventHandle = ManualEvent.Handle.ToInt32();
				NativeOverlapped* pOverlapped = &Overlapped;				

				fixed (byte* pBuf = &TxBuf[0])
				{				
					if(! (WriteFile(m_hFile, pBuf, iLen, &WriteDoneBytes, pOverlapped) ||
						(GetLastError() == ERROR_IO_PENDING)) ) return -1;
				}				
				int Signaled= WaitForSingleObject(pOverlapped->EventHandle, Timeout.Infinite);				
				if(! ((Signaled == WAIT_OBJECT_0) &&				
					GetOverlappedResult(m_hFile, pOverlapped, &WriteDoneBytes, false)))	return -2;

				return WriteDoneBytes;
			}
			*/
		}

		[DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Auto)]
		static extern int CreateFile(string filename, uint access, uint sharemode, uint security_attributes, uint creation, uint flags, uint template);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool CloseHandle(int handle);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool ReadFile(int hFile, byte* lpBuffer, int nNumberOfBytesToRead, int* lpNumberOfBytesRead, NativeOverlapped* lpOverlapped);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool WriteFile(int hFile, byte* lpBuffer, int nNumberOfBytesToWrite, int* lpNumberOfBytesWritten, NativeOverlapped* lpOverlapped);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern int TransmitCommChar(int hFile, byte TxChar);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool SetCommTimeouts(int hFile, SerialTimeouts* lpCommTimeouts);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool SetCommState(int hFile, DCB* lpDCB);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool GetCommState(int hFile, DCB* lpDCB);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool BuildCommDCB(string def, DCB* lpDCB);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern int GetLastError();

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool FlushFileBuffers(int hFile);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool PurgeComm(int hFile, uint dwFlags);

		[DllImport("kernel32.dll", SetLastError=true)]
		private static extern bool SetCommMask(int hFile, uint dwMask);
		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern uint WaitForMultipleObjects(int nCount,int* lpHandles,bool bWaitAll, int dwMilliseconds );				

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern int WaitForSingleObject(int Handle, int dwMilliseconds);
		
		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool WaitCommEvent(int hFile, uint* lpMask, NativeOverlapped* pOverlapped);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool GetOverlappedResult(int hFile,NativeOverlapped* pOverlapped, int* lpNumberOfBytesTransferred,bool bWait );	

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool ClearCommError(int hFile, uint *lpErrors, COMSTAT* comStat);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool SetupComm(int hFile, uint dwInQue, uint dwOutQue);
	}

	[StructLayout(LayoutKind.Sequential)]
	public struct SerialTimeouts {
		public int ReadIntervalTimeout;
		public int ReadTotalTimeoutMultiplier;
		public int ReadTotalTimeoutConstant;
		public int WriteTotalTimeoutMultiplier;
		public int WriteTotalTimeoutConstant;

		public SerialTimeouts(int r1, int r2, int r3, int w1, int w2) {
			ReadIntervalTimeout = r1;
			ReadTotalTimeoutMultiplier = r2;
			ReadTotalTimeoutConstant = r3;
			WriteTotalTimeoutMultiplier = w1;
			WriteTotalTimeoutConstant = w2;
		}

		public override string ToString() {
			return "ReadIntervalTimeout: " + ReadIntervalTimeout + "\r\n" +
				   "ReadTotalTimeoutMultiplier: " + ReadTotalTimeoutMultiplier + "\r\n" +
				   "ReadTotalTimeoutConstant: " + ReadTotalTimeoutConstant + "\r\n" +
				   "WriteTotalTimeoutMultiplier: " + WriteTotalTimeoutMultiplier + "\r\n" +
				   "WriteTotalTimeoutConstant: " + WriteTotalTimeoutConstant + "\r\n";
		}
	}

	public class SerialSettings {
		private bool m_bDirty = false;
		public bool Dirty { get { return m_bDirty; } }

		// Timeouts
		private SerialTimeouts Timeouts = new SerialTimeouts(1, 0, 0, 0, 0);

		public int ReadIntervalTimeout {
			get { return Timeouts.ReadIntervalTimeout; }
			set { if (Timeouts.ReadIntervalTimeout != value) {
					  Timeouts.ReadIntervalTimeout = value;
					  m_bDirty = true;
				  }
			}
		}

		public int ReadTotalTimeoutMultiplier {
			get { return Timeouts.ReadTotalTimeoutMultiplier; }
			set { if (Timeouts.ReadTotalTimeoutMultiplier != value) {
					Timeouts.ReadTotalTimeoutMultiplier = value;
					m_bDirty = true;
				  }
			}
		}

		public int ReadTotalTimeoutConstant {
			get { return Timeouts.ReadTotalTimeoutConstant; }
			set { if (Timeouts.ReadTotalTimeoutConstant != value) {
					  Timeouts.ReadTotalTimeoutConstant = value;
					  m_bDirty = true;
				  }
			}
		}

		public int WriteTotalTimeoutMultiplier {
			get { return Timeouts.WriteTotalTimeoutMultiplier; }
			set { if (Timeouts.WriteTotalTimeoutMultiplier != value) {
					  Timeouts.WriteTotalTimeoutMultiplier = value;
					  m_bDirty = true;
				  }
			}
		}

		public int WriteTotalTimeoutConstant {
			get { return Timeouts.WriteTotalTimeoutConstant; }
			set { if (Timeouts.WriteTotalTimeoutConstant != value) {
					  Timeouts.WriteTotalTimeoutConstant = value;
					  m_bDirty = true;
				  }
			}
		}

		// Valid stuff
		private static readonly object[] s_iValidBitRates = new object[] {75u, 110u, 134u, 150u, 300u, 600u, 1200u, 1800u, 2400u, 4800u, 
				7200u, 9600u, 14400u, 19200u, 38400u, 57600u, 115200u, 128000u};
		public static object[] ValidBitRates {
			get { return s_iValidBitRates; }
		}

		private static readonly object[] s_iValidDataBits = new object[] {(byte)5, (byte)6, (byte)7, (byte)8};
		public static object[] ValidDataBits {
			get { return s_iValidDataBits; }
		}

		// Port settings
		private uint m_iBitRate = 57600;
		public uint BitRate {
			get { return m_iBitRate; }
			set { if (m_iBitRate != value) {
					  m_iBitRate = value;
					  m_bDirty = true;
				  }
			}
		}

		private byte m_iDataBits = 8;
		public byte DataBits {
			get { return m_iDataBits; }
			set { if (m_iDataBits != value) {
					  m_iDataBits = value;
					  m_bDirty = true;
				  }
			}
		}

		private CommPort.Parity m_Parity = CommPort.Parity.None;
		public CommPort.Parity Parity {
			get { return m_Parity; }
			set { if (m_Parity != value) {
					  m_Parity = value;
					  m_bDirty = true;
				  }
			}
		}

		private CommPort.StopBits m_StopBits = CommPort.StopBits.One;
		public CommPort.StopBits StopBits {
			get { return m_StopBits; }
			set { if (m_StopBits != value) {
					  m_StopBits = value;
					  m_bDirty = true;
				  }
			}
		}

		private CommPort.FlowControl m_FlowControl = CommPort.FlowControl.None;
		public CommPort.FlowControl FlowControl {
			get { return m_FlowControl; }
			set { if (m_FlowControl != value) {
					  m_FlowControl = value;
					  m_bDirty = true;
				  }
			}
		}
	}
	
	class HexCon 
	{
		//converter hex string to byte and byte to hex string
		public static string ByteToString(byte[] InBytes) 
		{
			string StringOut="";
			foreach (byte InByte in InBytes) 
			{
				StringOut=StringOut + String.Format("{0:X2} ",InByte);
			}
			return StringOut; 
		}

		public static byte[] StringToByte(string InString) 
		{
			string[] ByteStrings;
			ByteStrings = InString.Split(" ".ToCharArray());
			byte[] ByteOut;
			ByteOut = new byte[ByteStrings.Length-1];
			for (int i = 0;i==ByteStrings.Length-1;i++) 
			{
				ByteOut[i] = Convert.ToByte(("0x" + ByteStrings[i]));
			} 
			return ByteOut;
		}
	}

/*
	public class SerialTest {
		public void open_click()		
		{
			m_SHController = new CommPort();
			m_SHController.Port = "COM1";		
			m_SHController.WatchPtr += new WatchHandler(this.WatchHandler);
			m_SHController.SetTimeouts(-1, 0, 0, 100, 1000);
			m_SHController.SetPortSettings(9600, 8, CommPort.StopBits.One, CommPort.Parity.None, CommPort.FlowControl.None);
			m_SHController.StartWatchThread();
		}
		
		private void WatchHandler(int iLen)
		{
			byte[] RxBuf = new Byte[iLen];

			int Count = m_SHController.Read( RxBuf, iLen);
			
			listBox1.Items.Add("RECEIVE: "+ Count.ToString());
			listBox1.Items.Add("-->" + HexCon.ByteToString(RxBuf));
		}
				
		public void close_click()
		{
			if( m_SHController != null)
			{
				m_SHController.StopWatchThread();
				m_SHController.Close();			
			}
		}
	}
*/
}
