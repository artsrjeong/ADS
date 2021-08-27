using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Text;
using System.IO;
using System.Threading;
using System.Collections;


namespace ADS
{
	/// <summary>
	/// PCPort에 대한 요약 설명입니다.
	/// </summary>
	public class PCPort
	{
		char m_prevChar;
		private uint m_hFile = 0;
		private const uint FILE_ATTRIBUTE_NORMAL=0x80;
		private const uint EVT_RXCHAR = 0x01;
		private const uint GENERIC_READ = 0x80000000;
		private const uint GENERIC_WRITE = 0x40000000;
		private const uint ERROR_IO_PENDING = 0x03E4;
		private const uint WAIT_OBJECT_0 = 0x00;		
		private const uint OPEN_EXISTING = 0x03;
		private const uint FILE_FLAG_OVERLAPPED = 0x40000000;
		private const uint ERROR_OPERATION_ABORTED = 0x03E3;		
		private const uint WAIT_FAILED = 0xFFFFFFFF; // if WaitForMultipleObjects() failed, return
		Form1 fmParent;
		public enum Parity {None, Odd, Even, Mark, Space};
		public enum StopBits {One, OneAndHalf, Two};
		public enum FlowControl {None, XOnXOff, Hardware};

		private struct COMMTIMEOUTS
		{
			public uint ReadIntervalTimeout;
			public uint ReadTotalTimeoutMultiplier;
			public uint ReadTotalTimeoutConstant;
			public uint WriteTotalTimeoutMultiplier;
			public uint WriteTotalTimeoutConstant;
		} 

		private struct DCB
		{
			public int DCBlength;
			public uint BaudRate; 
			public uint Flags;
			public uint fBinary { get { return Flags&0x0001; } 
				set { Flags = Flags & ~1U | value; } 
			}
			public uint fParity { get { return (Flags>>1)&1; }
				set { Flags = Flags & ~(1U << 1) | (value << 1); } 
			}
			public uint fOutxCtsFlow { get { return (Flags>>2)&1; }
				set { Flags = Flags & ~(1U << 2) | (value << 2); } 
			}
			public uint fOutxDsrFlow { get { return (Flags>>3)&1; }
				set { Flags = Flags & ~(1U << 3) | (value << 3); } 
			}
			public uint fDtrControl { get { return (Flags>>4)&3; }
				set { Flags = Flags & ~(3U << 4) | (value << 4); } 
			}
			public uint fDsrSensitivity { get { return (Flags>>6)&1; }
				set { Flags = Flags & ~(1U << 6) | (value << 6); } 
			}
			public uint fTXContinueOnXoff { get { return (Flags>>7)&1; }
				set { Flags = Flags & ~(1U << 7) | (value << 7); } 
			}
			public uint fOutX { get { return (Flags>>8)&1; }
				set { Flags = Flags & ~(1U << 8) | (value << 8); } 
			}
			public uint fInX { get { return (Flags>>9)&1; }
				set { Flags = Flags & ~(1U << 9) | (value << 9); } 
			}
			public uint fErrorChar { get { return (Flags>>10)&1; }
				set { Flags = Flags & ~(1U << 10) | (value << 10); } 
			}
			public uint fNull { get { return (Flags>>11)&1; }
				set { Flags = Flags & ~(1U << 11) | (value << 11); } 
			}
			public uint fRtsControl { get { return (Flags>>12)&3; }
				set { Flags = Flags & ~(3U << 12) | (value << 12); } 
			}
			public uint fAbortOnError { get { return (Flags>>13)&1; }
				set { Flags = Flags & ~(1U << 13) | (value << 13); } 
			}

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
		}


		[DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Auto)]
		static extern uint CreateFile(string filename, uint access, uint sharemode, uint security_attributes, uint creation, uint flags, uint template);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool CloseHandle(uint handle);


		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool ReadFile(uint hFile, IntPtr lpBuffer, int nNumberOfBytesToRead, ref uint lpNumberOfBytesRead, IntPtr lpOverlapped);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool WriteFile(uint hFile, IntPtr lpBuffer, int nNumberOfBytesToWrite, ref uint lpNumberOfBytesWritten, IntPtr lpOverlapped);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern int TransmitCommChar(uint hFile, byte TxChar);



		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool GetCommTimeouts(uint hFile,ref COMMTIMEOUTS lpCTO);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool SetCommTimeouts(uint hFile,ref COMMTIMEOUTS lpCTO);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool SetCommState(uint hFile, ref DCB lpDCB);

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool GetCommState(uint hFile, ref DCB lpDCB);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool BuildCommDCB(string def, DCB* lpDCB);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern int GetLastError();

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool FlushFileBuffers(uint hFile);

		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool PurgeComm(uint hFile, uint dwFlags);

		[DllImport("kernel32.dll", SetLastError=true)]
		private static extern bool SetCommMask(uint hFile, uint dwMask);
		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern uint WaitForMultipleObjects(int nCount,int* lpHandles,bool bWaitAll, int dwMilliseconds );				

		[DllImport("kernel32.dll", SetLastError=true)]
		static extern int WaitForSingleObject(int Handle, int dwMilliseconds);
		

/*
		[DllImport("kernel32.dll", SetLastError=true)]
		static unsafe extern bool ClearCommError(int hFile, uint *lpErrors, COMSTAT* comStat);
*/
		[DllImport("kernel32.dll", SetLastError=true)]
		static extern bool SetupComm(int hFile, uint dwInQue, uint dwOutQue);


		public PCPort()
		{
			//
			// TODO: 여기에 생성자 논리를 추가합니다.
			//
		}
		
		public bool RingMode()
		{
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= 19200;
			dcb.ByteSize		= 8;
			dcb.Parity			= (byte)Parity.Odd;
			dcb.StopBits		= (byte)StopBits.One;
			dcb.fBinary			= 1;
			dcb.fParity = 0U;
			dcb.fOutxCtsFlow =dcb.fAbortOnError = 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= dcb.fTXContinueOnXoff = 1;
			dcb.fOutX = dcb.fInX = 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = 1U;
			dcb.XonLim = 2048;
			dcb.XoffLim = 512;
			dcb.XonChar = 0x11;  // Ctrl-Q
			dcb.XoffChar = 0x13; // Ctrl-S				

			// Port 의 통신설정을 한다.
			if(!SetCommState(m_hFile,ref dcb))
			{
				MessageBox.Show("Settting Comport Error");
				CloseHandle(m_hFile);
				m_hFile = 0;
				return false;
			}
			return true;
		}

		public bool MonMode()
		{
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= 9600;
			dcb.ByteSize		= 8;
			dcb.Parity			= (byte)Parity.None;
			dcb.StopBits		= (byte)StopBits.One;
			dcb.fBinary			= 1;
			dcb.fParity = 0U;
			dcb.fOutxCtsFlow =dcb.fAbortOnError = 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= dcb.fTXContinueOnXoff = 1;
			dcb.fOutX = dcb.fInX = 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = 1U;
			dcb.XonLim = 2048;
			dcb.XoffLim = 512;
			dcb.XonChar = 0x11;  // Ctrl-Q
			dcb.XoffChar = 0x13; // Ctrl-S				

			// Port 의 통신설정을 한다.
			if(!SetCommState(m_hFile,ref dcb))
			{
				MessageBox.Show("Settting Comport Error");
				CloseHandle(m_hFile);
				m_hFile = 0;
				return false;
			}
			return true;
		}

		public bool EsmiDownLoadMode(uint baudrate)
		{
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= baudrate;
			dcb.ByteSize		= 8;
			dcb.Parity			= (byte)Parity.None;
			dcb.StopBits		= (byte)StopBits.One;
			dcb.fBinary			= 1;
			dcb.fParity = 0U;
			dcb.fOutxCtsFlow =dcb.fAbortOnError = 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= dcb.fTXContinueOnXoff = 1;
			dcb.fOutX = dcb.fInX = 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = 1U;
			dcb.XonLim = 2048;
			dcb.XoffLim = 512;
			dcb.XonChar = 0x11;  // Ctrl-Q
			dcb.XoffChar = 0x13; // Ctrl-S				


			// Port 의 통신설정을 한다.
			if(!SetCommState(m_hFile,ref dcb))
			{
				MessageBox.Show("Settting Comport Error");
				CloseHandle(m_hFile);
				m_hFile = 0;
				return false;
			}
			return true;

		}

		public bool DownLoadMode()
		{
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= 115200;
			dcb.ByteSize		= 8;
			dcb.Parity			= (byte)Parity.None;
			dcb.StopBits		= (byte)StopBits.One;
			dcb.fBinary			= 1;
			dcb.fParity = 0U;
			dcb.fOutxCtsFlow =dcb.fAbortOnError = 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= dcb.fTXContinueOnXoff = 1;
			dcb.fOutX = dcb.fInX = 1U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = 1U;
			dcb.XonLim = 2048;
			dcb.XoffLim = 512;
			dcb.XonChar = 0x11;  // Ctrl-Q
			dcb.XoffChar = 0x13; // Ctrl-S				


			// Port 의 통신설정을 한다.
			if(!SetCommState(m_hFile,ref dcb))
			{
				MessageBox.Show("Settting Comport Error");
				CloseHandle(m_hFile);
				m_hFile = 0;
				return false;
			}
			return true;
		}

		public void PortClose()
		{
			CloseHandle(m_hFile);
		}

		public bool PortOpen(string portName,uint baudrate, byte databits, StopBits stopbits, Parity parity, FlowControl flowcontrol) 
		{
			m_hFile = CreateFile(portName, (uint)(GENERIC_READ | GENERIC_WRITE), 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0U);
			if (m_hFile == 0) 				
			{
				MessageBox.Show(portName+"Open ComPort Error");
				return false;
			}
/*
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
*/
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= baudrate;
			dcb.ByteSize		= databits;
			dcb.Parity			= (byte)parity;
			dcb.StopBits		= (byte)stopbits;
			dcb.fBinary			= 1;
			dcb.fParity = (parity > 0) ? 1U : 0U;
			dcb.fOutxCtsFlow =dcb.fAbortOnError = (flowcontrol == FlowControl.Hardware)? 1U : 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= dcb.fTXContinueOnXoff = 1;
			dcb.fOutX = dcb.fInX = (flowcontrol == FlowControl.XOnXOff)? 1U : 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = (flowcontrol == FlowControl.Hardware)? 2U : 1U;
			dcb.XonLim = 2048;
			dcb.XoffLim = 512;
			dcb.XonChar = 0x11;  // Ctrl-Q
			dcb.XoffChar = 0x13; // Ctrl-S				


			// Port 의 통신설정을 한다.
			if(!SetCommState(m_hFile,ref dcb))
			{
				MessageBox.Show("Settting Comport Error");
				CloseHandle(m_hFile);
				m_hFile = 0;
				return false;
			}

			COMMTIMEOUTS cto=new COMMTIMEOUTS();
			GetCommTimeouts(m_hFile,ref cto);
			cto.ReadIntervalTimeout=1;
			cto.ReadTotalTimeoutConstant=1;
			cto.ReadTotalTimeoutMultiplier=0;
			if(!SetCommTimeouts(m_hFile,ref cto))
			{
				MessageBox.Show("Setting Timeout Error");
				CloseHandle(m_hFile);
				return false;
			}
			return true;
		}


		public bool PortChange(string portName,uint baudrate, byte databits, StopBits stopbits, Parity parity, FlowControl flowcontrol) 
		{
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= baudrate;
			dcb.ByteSize		= databits;
			dcb.Parity			= (byte)parity;
			dcb.StopBits		= (byte)stopbits;
			dcb.fBinary			= 1;
			dcb.fParity = (parity > 0) ? 1U : 0U;
			dcb.fOutxCtsFlow =dcb.fAbortOnError = (flowcontrol == FlowControl.Hardware)? 1U : 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= dcb.fTXContinueOnXoff = 1;
			dcb.fOutX = dcb.fInX = (flowcontrol == FlowControl.XOnXOff)? 1U : 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = (flowcontrol == FlowControl.Hardware)? 2U : 1U;
			dcb.XonLim = 2048;
			dcb.XoffLim = 512;
			dcb.XonChar = 0x11;  // Ctrl-Q
			dcb.XoffChar = 0x13; // Ctrl-S				


			// Port 의 통신설정을 한다.
			if(!SetCommState(m_hFile,ref dcb))
			{
				MessageBox.Show("Settting Comport Error");
				CloseHandle(m_hFile);
				m_hFile = 0;
				return false;
			}

			return true;
		}


		public uint ReadSerial(byte[] data)
		{
			uint dwBytes=0;
			unsafe
			{
				fixed(byte* pBuf=data)
				{
					ReadFile(m_hFile,(IntPtr)pBuf,100,ref dwBytes,(IntPtr)0);
				}
			}
			return dwBytes;
		}

		public void ReadBuff()
		{
			byte[] data=new byte[100];
			uint dwBytes=0;
			unsafe
			{
				fixed(byte* pBuf=data)
				{
					ReadFile(m_hFile,(IntPtr)pBuf,100,ref dwBytes,(IntPtr)0);
				}
			}

			if(dwBytes>0)
			{
				string sTmp="";
				ArrayList m_list=new ArrayList();
				for(int i=0;i<dwBytes;i++)
				{
					//줄 추가
					if((char)data[i]=='\n')
					{
						m_list.Add(fmParent.strArr[fmParent.endLine]);
						fmParent.strArr[++fmParent.endLine]="";
						if(fmParent.lineNum<Form1.DISP_LINE+10)
							fmParent.lineNum++;	
					}
						//현재 글자는 일반 글자이고 이전 글자가 \r 이면 끝행 바꿈
					else if((char)data[i]!='\r' && (char)data[i]!='\n' && m_prevChar== '\r')
					{
						fmParent.strArr[fmParent.endLine]="";
						fmParent.strArr[fmParent.endLine]+=(char)data[i];
					}
					else if((char)data[i]=='\r')  //\r 은 무시
					{
					}
					else
						fmParent.strArr[fmParent.endLine]+=(char)data[i];
					
					m_prevChar=(char)data[i];
				}
				m_list.Add(fmParent.strArr[fmParent.endLine]);

				if(dwBytes>0)
				{
					fmParent.Refresh();
				}
				if(fmParent.state==Form1.STATUS.DOWNLOAD)
				{
					if(dwBytes>10 && dwBytes<50)
					{
						foreach(string str in m_list)
						{
							if(str.IndexOf("Motorola")>0)
							{
								if(fmParent.m_bDownLoadStart==false)
									fmParent.m_bDownLoadStart=true;
							}
						}
					}
				}
			}
		}
		
		public void SendBytes(byte[] txBuf)
		{
			uint dwBytes=0;
			IntPtr ptr=(IntPtr)0;
			int len=txBuf.Length;
			unsafe
			{
				fixed (byte* pBuf = txBuf)
				{				
					WriteFile(m_hFile,(IntPtr)pBuf,len,ref dwBytes,(IntPtr)0);
				}				
			}

		}

		public void downLoad()
		{
			Thread.Sleep(50);
			try 
			{
				// Create an instance of StreamReader to read from a file.
				// The using statement also closes the StreamReader.
				//SendCRLF();
				using (StreamReader sr = new StreamReader(fmParent.m_fileName)) 
				{
					String line;
					// Read and display lines from the file until the end of 
					// the file is reached.
					int i=0;
					
					//down.progressBar1.Maximum=nFileLine;

					while ((line = sr.ReadLine()) != null) 
					{
						SendLine(line);
						SendCRLF();
						if(i%100==0)
						{
							try
							{
								fmParent.SetBar(i);
							}
							catch(Exception k)
							{}
							Application.DoEvents();
						}
						i++;
						ReadBuff();
						Application.DoEvents();
					}
					ReadBuff();
					
				}
				//down.finish();
				
			}
			catch (Exception ex) 
			{
			}
		}

		public void SendLine(string str)
		{
			uint dwBytes=0;
			IntPtr ptr=(IntPtr)0;
			Byte[] byteDateLine = System.Text.Encoding.ASCII.GetBytes( str.ToCharArray() );
			unsafe
			{
				fixed (byte* pBuf = byteDateLine)
				{				
					WriteFile(m_hFile,(IntPtr)pBuf,str.Length,ref dwBytes,(IntPtr)0);
				}				
			}
		}

		public void SendCRLF()
		{
			byte[] data=new byte[30];
			data[0]=(byte)'\r';
			data[1]=(byte)'\n';
			uint dwBytes=0;
			IntPtr ptr=(IntPtr)0;
			unsafe
			{
				fixed (byte* pBuf = data)
				{				
					WriteFile(m_hFile,(IntPtr)pBuf,2,ref dwBytes,(IntPtr)0);
				}				
			}
			
		}
		
		public void SetParent(Form1 fm)
		{
			fmParent=fm;
		}
	}
}
