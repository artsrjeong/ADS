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
	/// PDAPort에 대한 요약 설명입니다.
	/// </summary>
	public class PDAPort
	{
		public Form1 fmParent;
		private uint m_hFile = 0;
		bool m_Connected=false;
		char m_prevChar;
		public enum Parity {None, Odd, Even, Mark, Space};
		public enum StopBits {One, OneAndHalf, Two};
		public enum FlowControl {None, XOnXOff, Hardware};
		private const uint FILE_ATTRIBUTE_NORMAL=0x80;
		private const uint EVT_RXCHAR = 0x01;
		private const uint GENERIC_READ = 0x80000000;
		private const uint GENERIC_WRITE = 0x40000000;
		private const uint ERROR_IO_PENDING = 0x03E4;
		private const uint WAIT_OBJECT_0 = 0x00;		
		private const uint OPEN_EXISTING = 0x03;
		private const uint FILE_FLAG_OVERLAPPED = 0x40000000;
		private const uint ERROR_OPERATION_ABORTED = 0x03E;		
		private const uint WAIT_FAILED = 0xFFFFFFFF; // if WaitForMultipleObjects() failed, return
		private const uint NOPARITY          =  0;
		private const uint ODDPARITY         =  1;
		private const uint EVENPARITY        =  2;
		private const uint MARKPARITY        =  3;
		private const uint SPACEPARITY       =  4;

		private const uint ONESTOPBIT        =  0;
		private const uint ONE5STOPBITS       = 1;
		private const uint TWOSTOPBITS       =  2;

		private const uint DTR_CONTROL_DISABLE  =  0x00;
		private const uint DTR_CONTROL_ENABLE    = 0x01;
		private const uint DTR_CONTROL_HANDSHAKE = 0x02;

		//
		// RTS Control Flow Values
		//
		private const uint RTS_CONTROL_DISABLE   = 0x00;
		private const uint RTS_CONTROL_ENABLE   =  0x01;
		private const uint RTS_CONTROL_HANDSHAKE = 0x02;
		private const uint RTS_CONTROL_TOGGLE    = 0x03;


		private const uint GPIO_BASE_U_VIRTUAL=0xA7000000;
		private const uint ALLIN_UART_SW=0x00000010;
		private const uint GPIO_68_AF3=0x00000300;

		private struct GPIO_REGS
		{
			public uint GPLR_x;	// 0x40E00000 Pin Level Registers
			public uint GPLR_y;	// 0x40E00004
			public uint GPLR_z;	// 0x40E00008

			public uint GPDR_x;	// 0x40E0000C Pin Direction Registers
			public uint GPDR_y;	// 0x40E00010
			public uint GPDR_z;	// 0x40E00014

			public uint GPSR_x;	// 0x40E00018 Pin Output Set Registers
			public uint GPSR_y;	// 0x40E0001C
			public uint GPSR_z;	// 0x40E00020

			public uint GPCR_x;	// 0x40E00024 Pin Output Clear Registers
			public uint GPCR_y;	// 0x40E00028
			public uint GPCR_z;	// 0x40E0002C

			public uint GRER_x;	// 0x40E00030 Rising Edge Detect Enable Registers
			public uint GRER_y;	// 0x40E00034
			public uint GRER_z;	// 0x40E00038

			public uint GFER_x;	// 0x40E0003C Falling Edge Detect Enable Registers
			public uint GFER_y;	// 0x40E00040
			public uint GFER_z;	// 0x40E00044

			public uint GEDR_x;	// 0x40E00048 Edge Detect Status Registers
			public uint GEDR_y;	// 0x40E0004C
			public uint GEDR_z;	// 0x40E00050

			public uint GAFR0_x;	// 0x40E00054 Alternate Function Registers
			public uint GAFR1_x;	// 0x40E00058
			public uint GAFR0_y;	// 0x40E0005C
			public uint GAFR1_y;	// 0x40E00060
			public uint GAFR0_z;	// 0x40E00064
			public uint GAFR1_z;	// 0x40E00068
		} 

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

		[DllImport("coredll.dll", SetLastError=true, CharSet=CharSet.Auto)]
		static extern uint CreateFile(string filename, uint access, uint sharemode, uint security_attributes, uint creation, uint flags, uint template);
		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool SetCommState(uint hFile, ref DCB lpDCB);

		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool SetCommTimeouts(uint hFile,ref COMMTIMEOUTS lpCTO);

		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool GetCommTimeouts(uint hFile,ref COMMTIMEOUTS lpCTO);

		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool GetCommState(uint hFile, ref DCB lpDCB);

		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool CloseHandle(uint hFile);

		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool ReadFile(uint hFile, IntPtr lpBuffer, int nNumberOfBytesToRead, ref uint lpNumberOfBytesRead, IntPtr lpOverlapped);

		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool WriteFile(uint hFile, IntPtr lpBuffer, int nNumberOfBytesToWrite, ref uint lpNumberOfBytesWritten, IntPtr lpOverlapped);


		public PDAPort()
		{
			//
			// TODO: 여기에 생성자 논리를 추가합니다.
			//
		}
		
		public void SetParent(Form1 fm)
		{
			fmParent=fm;
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
			dcb.fParity = 1U;
			dcb.fOutxCtsFlow =  0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= DTR_CONTROL_DISABLE;
			dcb.fDsrSensitivity	= 0;
			dcb.fOutX = dcb.fInX = 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = RTS_CONTROL_DISABLE;

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
			dcb.fOutxCtsFlow =  0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= DTR_CONTROL_DISABLE;
			dcb.fDsrSensitivity	= 0;
			dcb.fOutX = dcb.fInX = 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = RTS_CONTROL_DISABLE;

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
			dcb.fOutxCtsFlow =  0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= DTR_CONTROL_DISABLE;
			dcb.fDsrSensitivity	= 0;
			dcb.fOutX = dcb.fInX = 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = RTS_CONTROL_DISABLE;

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
			dcb.fOutxCtsFlow =  0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= DTR_CONTROL_DISABLE;
			dcb.fDsrSensitivity	= 0;
			dcb.fOutX = dcb.fInX = 1U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = RTS_CONTROL_DISABLE;

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
			unsafe
			{
				//volatile GPIO_REGS  *v_pGPIOReg = (volatile GPIO_REGS *)GPIO_BASE_U_VIRTUAL;
				GPIO_REGS *v_pGPIOReg = (GPIO_REGS *)GPIO_BASE_U_VIRTUAL;
				v_pGPIOReg->GPDR_z |= ALLIN_UART_SW ;		
				v_pGPIOReg->GAFR1_z &= ~GPIO_68_AF3;  
				v_pGPIOReg->GPSR_z = ALLIN_UART_SW;		
			}
		}

		public bool PortOpen(string portName,uint baudrate, byte databits, StopBits stopbits, Parity parity, FlowControl flowcontrol) 
		{
			unsafe
			{
				//volatile GPIO_REGS  *v_pGPIOReg = (volatile GPIO_REGS *)GPIO_BASE_U_VIRTUAL;
				GPIO_REGS *v_pGPIOReg = (GPIO_REGS *)GPIO_BASE_U_VIRTUAL;
				v_pGPIOReg->GPDR_z |= ALLIN_UART_SW ;
				v_pGPIOReg->GAFR1_z &= ~GPIO_68_AF3;  
				v_pGPIOReg->GPCR_z = ALLIN_UART_SW;	
			}
			m_hFile = CreateFile(portName, (uint)(GENERIC_READ | GENERIC_WRITE), 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0U);
			if (m_hFile <= 0) 				
			{
				MessageBox.Show(portName+"Open ComPort Error");
				return false;
			}
			DCB dcb=new DCB();
			dcb.DCBlength=(int)Marshal.SizeOf(dcb);
			GetCommState( m_hFile, ref dcb ) ;//dcb의 기본값을 받는다.


			dcb.BaudRate		= baudrate;
			dcb.ByteSize		= databits;
			dcb.Parity			= (byte)parity;
			dcb.StopBits		= (byte)stopbits;
			dcb.fBinary			= 1;
			dcb.fParity = (parity > 0) ? 1U : 0U;
			dcb.fOutxCtsFlow =  (flowcontrol == FlowControl.Hardware)? 1U : 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= DTR_CONTROL_DISABLE;
			dcb.fDsrSensitivity	= 0;
			dcb.fOutX = dcb.fInX = (flowcontrol == FlowControl.XOnXOff)? 1U : 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = (flowcontrol == FlowControl.Hardware)? RTS_CONTROL_ENABLE : RTS_CONTROL_DISABLE;

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
			dcb.fOutxCtsFlow =  (flowcontrol == FlowControl.Hardware)? 1U : 0U;
			dcb.fOutxDsrFlow	= 0;
			dcb.fDtrControl		= DTR_CONTROL_DISABLE;
			dcb.fDsrSensitivity	= 0;
			dcb.fOutX = dcb.fInX = (flowcontrol == FlowControl.XOnXOff)? 1U : 0U;
			dcb.fErrorChar		= 0;
			dcb.fNull			= 0;
			dcb.fRtsControl = (flowcontrol == FlowControl.Hardware)? RTS_CONTROL_ENABLE : RTS_CONTROL_DISABLE;

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
							fmParent.SetBar(i);
							Application.DoEvents();
						}
						i++;
						//	if(i<=down.progressBar1.Maximum && (i%100)==0)
						//		down.progressBar1.Value=i;
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
	}
}
