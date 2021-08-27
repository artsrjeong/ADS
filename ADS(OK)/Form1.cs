using System;
using System.Drawing;
using System.Collections;
using System.Windows.Forms;
using System.Data;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using System.Threading;
using System.Xml;


namespace ADS
{
	/// <summary>
	/// Form1에 대한 요약 설명입니다.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		public bool bIdle=false;
		public int curSec;
		public StreamWriter swCapture;
		byte[] mdm_rx_buf=new byte[256];
		byte[] ring_rx_buf=new byte[256];
		byte mdm_rx_ptw=0;
		byte ring_rx_ptw=0;
		public Thread txThread;
		public byte reqBlock=0;
		public byte curBlock=0;
		bool bDownOk=false;
		bool m_Connected=false;
		public byte endLine=0;
		public int lineNum=0;
		char m_prevChar;
		public DownLoad down;
		public fmEsmiDownLoad esmiDown;
		public fmRingMon ringMon;
		public fmSimul	simul;
		public fmMonitor mon;
		public fmParam param;
		public fmTcd tcd;
		public fmSvcTool svcTool;
		public string[] strArr;	
		byte[] byteLine=new byte[100];
		int byteInx=0;
		public const int MAX_LINE=256;
		public const int DISP_LINE=12;
		public const int MAX_COL=37;
		public enum STATUS {NORMAL,DOWNLOAD,MONITOR,ERRORLOG,SVCTOOL,ESMI_DOWNLOAD,GRAPH,RING,SIMUL};
		public enum NODE {ROMFILE,PORTNAME,BAUDRATE,DATABIT,PARITY,STOPBITS,FLOWCONTROL,REUSE};
		public enum ESMI {Z,L};
		public ESMI esmi;
		public STATUS state;
		public int nFileLine;
		public string m_fileName="";
		public string m_captureFile="";
		public string m_portName="";
		public string m_baudRate="";
		public string m_dataBit="";
		public string m_parity="";
		public string m_stopBits="";
		public string m_flowControl="";
		public string m_reUse="";
		public NODE m_curNode;
		public bool m_bPdaMode=true;
		public PDAPort m_pdaPort;
		public PCPort	m_pcPort;
		private System.Windows.Forms.Timer tmr_mon;
		public bool m_bDownLoadStart=false;
		public byte[] m_RxBuf=new byte[100];
		public int m_iRxIdx=0;
		public bool m_iRxWait=false;
		public bool m_iTxWait=false;
		public int m_iRxWaitCnt=0;
		public int m_iTxWaitCnt=0;
		public int m_iCommCnt=0;
		public int m_iListCnt=0;
		public int m_wIndex=1;
		public uint m_SendAddr;
		public uint m_SendData;
		public uint[] addrDown=new uint[256];
		public uint[] dataDown=new uint[256];
		public int carId;					//for simulation
		public int[] floor=new int[9];		//for simulation
		public byte downWp=0;
		public byte downRp=0;
		uint[] DgrAddr=new uint[8];
		public ArrayList m_tableList=new ArrayList();
		public uint[] pointAddr;
		public uint[] pointGpInx;
		string[] strDisp=new string[DISP_LINE];
		byte dispLine;
		Brush br=new SolidBrush(Color.Black);
		Font DispFont=new Font("Terminal",8,FontStyle.Bold);
		fmGraph grp;
		StreamWriter sr;
		public int ringCnt=0;
		
		public const int MSG_LEN=6;
		private System.Windows.Forms.MenuItem menuItem5;
		private System.Windows.Forms.MenuItem mnuAdsDownLoad;
		private System.Windows.Forms.MenuItem mnuAdsMon;
		private System.Windows.Forms.Timer tmr_Update;
		private System.Windows.Forms.MenuItem mnuTCD;
		private System.Windows.Forms.MenuItem menuItem3;
		private System.Windows.Forms.MenuItem mnuEsmiDownLoad;
		private System.Windows.Forms.MenuItem mnuGraph;
		private System.Windows.Forms.MenuItem menuItem4;
		private System.Windows.Forms.MenuItem mnuESMIZDown;
		private System.Windows.Forms.MenuItem menuItem6;
		private System.Windows.Forms.MenuItem mnuCaptureStart;
		private System.Windows.Forms.MenuItem menuItem8;
		private System.Windows.Forms.MenuItem mnuCaptureStop;
		private System.Windows.Forms.SaveFileDialog saveFileDialog1;
		private System.Windows.Forms.MenuItem menuItem7;
		private System.Windows.Forms.MenuItem mnuRingMon;
		private System.Windows.Forms.MenuItem mnuRingFilter;
		private System.Windows.Forms.MenuItem mnuSimul;
		private System.Windows.Forms.MenuItem mnuPort;
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

		public Form1()
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			strArr=new string[MAX_LINE];	
			for(int i=0;i<MAX_LINE;i++)
			{
				strArr[i]="";
			}
			
			//
			// TODO: InitializeComponent를 호출한 다음 생성자 코드를 추가합니다.
			//
		}
		/// <summary>
		/// 사용 중인 모든 리소스를 정리합니다.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			base.Dispose( disposing );
		}
		#region Windows Form 디자이너에서 생성한 코드
		/// <summary>
		/// 디자이너 지원에 필요한 메서드입니다.
		/// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
		/// </summary>
		private void InitializeComponent()
		{
			this.timer1 = new System.Windows.Forms.Timer();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuFile = new System.Windows.Forms.MenuItem();
			this.menuItem8 = new System.Windows.Forms.MenuItem();
			this.mnuCaptureStart = new System.Windows.Forms.MenuItem();
			this.mnuCaptureStop = new System.Windows.Forms.MenuItem();
			this.mnuPort = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.menuItem6 = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.mnuAdsDownLoad = new System.Windows.Forms.MenuItem();
			this.mnuAdsMon = new System.Windows.Forms.MenuItem();
			this.mnuTCD = new System.Windows.Forms.MenuItem();
			this.mnuGraph = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.mnuRingMon = new System.Windows.Forms.MenuItem();
			this.mnuRingFilter = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.mnuEsmiDownLoad = new System.Windows.Forms.MenuItem();
			this.mnuESMIZDown = new System.Windows.Forms.MenuItem();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.tmr_mon = new System.Windows.Forms.Timer();
			this.tmr_Update = new System.Windows.Forms.Timer();
			this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
			this.mnuSimul = new System.Windows.Forms.MenuItem();
			// 
			// timer1
			// 
			this.timer1.Interval = 10;
			this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.menuItem1);
			this.mainMenu1.MenuItems.Add(this.menuItem5);
			this.mainMenu1.MenuItems.Add(this.menuItem7);
			this.mainMenu1.MenuItems.Add(this.menuItem3);
			// 
			// menuItem1
			// 
			this.menuItem1.MenuItems.Add(this.mnuFile);
			this.menuItem1.MenuItems.Add(this.menuItem8);
			this.menuItem1.MenuItems.Add(this.mnuCaptureStart);
			this.menuItem1.MenuItems.Add(this.mnuCaptureStop);
			this.menuItem1.MenuItems.Add(this.mnuPort);
			this.menuItem1.MenuItems.Add(this.menuItem2);
			this.menuItem1.MenuItems.Add(this.menuItem4);
			this.menuItem1.MenuItems.Add(this.menuItem6);
			this.menuItem1.Text = "기본기능";
			this.menuItem1.Click += new System.EventHandler(this.menuItem1_Click);
			// 
			// mnuFile
			// 
			this.mnuFile.Text = "ROM File 선택";
			this.mnuFile.Click += new System.EventHandler(this.mnuFile_Click);
			// 
			// menuItem8
			// 
			this.menuItem8.Text = "-";
			// 
			// mnuCaptureStart
			// 
			this.mnuCaptureStart.Text = "텍스트 캡쳐 시작";
			this.mnuCaptureStart.Click += new System.EventHandler(this.mnuCaptureStart_Click);
			// 
			// mnuCaptureStop
			// 
			this.mnuCaptureStop.Enabled = false;
			this.mnuCaptureStop.Text = "텍스트 캡쳐 중지";
			this.mnuCaptureStop.Click += new System.EventHandler(this.mnuCaptureStop_Click);
			// 
			// mnuPort
			// 
			this.mnuPort.Text = "포트 설정";
			this.mnuPort.Click += new System.EventHandler(this.mnuPort_Click);
			// 
			// menuItem2
			// 
			this.menuItem2.Text = "Exit";
			this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Text = "";
			// 
			// menuItem6
			// 
			this.menuItem6.Text = "";
			// 
			// menuItem5
			// 
			this.menuItem5.MenuItems.Add(this.mnuAdsDownLoad);
			this.menuItem5.MenuItems.Add(this.mnuAdsMon);
			this.menuItem5.MenuItems.Add(this.mnuTCD);
			this.menuItem5.MenuItems.Add(this.mnuGraph);
			this.menuItem5.Text = "ADS";
			// 
			// mnuAdsDownLoad
			// 
			this.mnuAdsDownLoad.Text = "Download";
			this.mnuAdsDownLoad.Click += new System.EventHandler(this.mnuAdsDownLoad_Click);
			// 
			// mnuAdsMon
			// 
			this.mnuAdsMon.Text = "Monitoring";
			this.mnuAdsMon.Click += new System.EventHandler(this.mnuAdsMon_Click);
			// 
			// mnuTCD
			// 
			this.mnuTCD.Text = "TCD 조회";
			this.mnuTCD.Click += new System.EventHandler(this.mnuTCD_Click);
			// 
			// mnuGraph
			// 
			this.mnuGraph.Text = "Graph";
			this.mnuGraph.Click += new System.EventHandler(this.mnuGraph_Click);
			// 
			// menuItem7
			// 
			this.menuItem7.MenuItems.Add(this.mnuRingMon);
			this.menuItem7.MenuItems.Add(this.mnuRingFilter);
			this.menuItem7.MenuItems.Add(this.mnuSimul);
			this.menuItem7.Text = "RING";
			// 
			// mnuRingMon
			// 
			this.mnuRingMon.Text = "Monitor";
			this.mnuRingMon.Click += new System.EventHandler(this.mnuRingMon_Click);
			// 
			// mnuRingFilter
			// 
			this.mnuRingFilter.Text = "Filter";
			// 
			// menuItem3
			// 
			this.menuItem3.MenuItems.Add(this.mnuEsmiDownLoad);
			this.menuItem3.MenuItems.Add(this.mnuESMIZDown);
			this.menuItem3.Text = "ESMI";
			// 
			// mnuEsmiDownLoad
			// 
			this.mnuEsmiDownLoad.Text = "염가형 DownLoad";
			this.mnuEsmiDownLoad.Click += new System.EventHandler(this.mnuEsmiDownLoad_Click);
			// 
			// mnuESMIZDown
			// 
			this.mnuESMIZDown.Text = "ESMI400 DownLoad";
			this.mnuESMIZDown.Click += new System.EventHandler(this.mnuEsmiDownLoad_Click);
			// 
			// tmr_mon
			// 
			this.tmr_mon.Interval = 50;
			this.tmr_mon.Tick += new System.EventHandler(this.tmr_mon_Tick);
			// 
			// tmr_Update
			// 
			this.tmr_Update.Tick += new System.EventHandler(this.tmr_Update_Tick);
			// 
			// saveFileDialog1
			// 
			this.saveFileDialog1.FileName = "doc1";
			// 
			// mnuSimul
			// 
			this.mnuSimul.Text = "Simulation";
			this.mnuSimul.Click += new System.EventHandler(this.mnuSimul_Click);
			// 
			// Form1
			// 
			this.ClientSize = new System.Drawing.Size(234, 778);
			this.Menu = this.mainMenu1;
			this.Text = "Door Service Tool";
			this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.Form1_KeyPress);
			this.Load += new System.EventHandler(this.Form1_Load);
			this.Closed += new System.EventHandler(this.Form1_Closed);
			this.Paint += new System.Windows.Forms.PaintEventHandler(this.Form1_Paint);

		}
		#endregion

		/// <summary>
		/// 해당 응용 프로그램의 주 진입점입니다.
		/// </summary>

		public void AddLine(string str)
		{
			endLine++;
			strArr[endLine]=str;
			if(lineNum<DISP_LINE+10)
				lineNum++;	
			ScreenUpdate();
			this.Refresh();
		}
		static void Main() 
		{
			Application.Run(new Form1());
		}
		
		//		private static extern IntPtr CreateFile(string file,int n1,int n2,int n3,int n4,int n5,int n6);
		[DllImport("coredll.dll", SetLastError=true, CharSet=CharSet.Auto)]
		static extern uint CreateFile(string filename, uint access, uint sharemode, uint security_attributes, uint creation, uint flags, uint template);
		[DllImport("coredll.dll", SetLastError=true)]
		static extern bool SetCommState(uint hFile, ref DCB lpDCB);

		[DllImport("coredll.dll", SetLastError=true, CharSet=CharSet.Auto)]
		static extern void SystemIdleTimerReset();

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

		public void MapRead()
		{
			XmlTextReader reader;
			try
			{
				if(this.m_bPdaMode)
					reader=new XmlTextReader("\\doa.xml");
				else
					reader=new XmlTextReader("\\doa.xml");
				string group_id="";
				string prev_group_inx="";
				string element,name="";
				DataTable dt=new DataTable();
				dt.Columns.Add(new DataColumn("Group_inx",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Group_id",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Group_des",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Index",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Description",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Res",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Unit",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Bit",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Addr",System.Type.GetType("System.String"))); 
				dt.Columns.Add(new DataColumn("Data",System.Type.GetType("System.String")));


				DataRow row=dt.NewRow();
				while(reader.Read())
				{
					switch(reader.NodeType)
					{
						case XmlNodeType.Element:
							name=reader.Name;
							break;
						case XmlNodeType.Text:
							//내일 와서 Value 부분의 값이 바뀐 것을 체크하는 것으로 바꿀 것
							if(name.Equals("Group_inx")) //Group_inx 가 나오면 한행을 추가한다.
							{
								if(!reader.Value.Equals(prev_group_inx)) //그룹이 바뀌면 테이블 추가
								{
									//이전에 만든 테이블이 있으면 이전 것의 마지막 행을 추가하고 신규 테이블 제작
									if(m_tableList.Count>0)
									{
										try
										{
											row["Data"]="";
											dt.Rows.Add(row);
										}
										catch{}
									}

									dt=new DataTable();
									dt.Columns.Add(new DataColumn("Group_inx",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Group_id",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Group_des",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Index",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Description",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Res",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Unit",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Bit",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Addr",System.Type.GetType("System.String"))); 
									dt.Columns.Add(new DataColumn("Data",System.Type.GetType("System.String")));
									this.m_tableList.Add(dt);
									row=dt.NewRow();
									prev_group_inx=reader.Value;
								}
								else //행이 하나 추가 되야 함
								{
									row["Data"]="";
									dt.Rows.Add(row);
									row=dt.NewRow();
								}

							}
							try
							{
								row[name]=reader.Value;	  //실제 데이타 입력
							}
							catch
							{
								MessageBox.Show("Xml Insert Error"+" : "+name+">"+reader.Value);
							}
							break;
					}
				}
				if(m_tableList.Count>0)//이전에 만든 테이블이 있으면 마지막 Record를 table에 추가, 다음번 Group_Inx가 오지 않으므로
				{
					try
					{
						row["Data"]="";
						dt.Rows.Add(row);
					}
					catch{}
				}

				reader.Close();
			}
			catch
			{
				
			}

			//입출력 접점 및 기본 정보를 보기 위한 Address Setting
			int pointCnt=0;
			foreach(DataTable dt in m_tableList)
			{
				uint groupInx;
				string strGpInx=(string)dt.Rows[0]["Group_inx"];
				strGpInx=strGpInx.Trim();
				groupInx=Convert.ToUInt32(strGpInx,16);
				if(groupInx<10)
					pointCnt++;
			}
			pointAddr=new uint[pointCnt];
			pointGpInx=new uint[pointCnt];
			pointCnt=0;
			foreach(DataTable dt in m_tableList)
			{
				uint groupInx,Addr;
				string strAddr;
				string strGpInx=(string)dt.Rows[0]["Group_inx"];
				strGpInx=strGpInx.Trim();
				groupInx=Convert.ToUInt32(strGpInx,16);
				if(groupInx<10)
				{
					strAddr=(string)dt.Rows[0]["Addr"];
					strAddr=strAddr.Trim();
					Addr=Convert.ToUInt32(strAddr,16);
					pointAddr[pointCnt]=Addr;
					pointGpInx[pointCnt]=groupInx;
					pointCnt++;
				}
			}
			
		}




		private void Form1_Load(object sender, System.EventArgs e)
		{

			MapRead();
			carId=1;
			for(int i=0;i<9;i++)
			{
				floor[i]=1;
			}
			try
			{
				DataTable dt=new DataTable();
				XmlTextReader reader;
				if(this.m_bPdaMode)
					reader=new XmlTextReader("\\ads.xml");
				else
					reader=new XmlTextReader("\\ads.xml");
				
				while(reader.Read())
				{
					switch (reader.NodeType) 
					{
						case XmlNodeType.Element:
							if(reader.Name.Equals("RomFile"))
								m_curNode=NODE.ROMFILE;
							else if(reader.Name.Equals("PortName"))
								m_curNode=NODE.PORTNAME;
							else if(reader.Name.Equals("BaudRate"))
								m_curNode=NODE.BAUDRATE;
							else if(reader.Name.Equals("DataBit"))
								m_curNode=NODE.DATABIT;
							else if(reader.Name.Equals("Parity"))
								m_curNode=NODE.PARITY;
							else if(reader.Name.Equals("StopBits"))
								m_curNode=NODE.STOPBITS;
							else if(reader.Name.Equals("FlowControl"))
								m_curNode=NODE.FLOWCONTROL;
							else if(reader.Name.Equals("ReUse"))
								m_curNode=NODE.REUSE;
							break;
						case XmlNodeType.Text:
						switch(m_curNode)
						{
							case NODE.ROMFILE:
								this.m_fileName=reader.Value;
								break;
							case NODE.PORTNAME:
								this.m_portName=reader.Value;
								break;
							case NODE.BAUDRATE:
								this.m_baudRate=reader.Value;
								break;
							case NODE.DATABIT:
								this.m_dataBit=reader.Value;
								break;
							case NODE.PARITY:
								this.m_parity=reader.Value;
								break;
							case NODE.STOPBITS:
								this.m_stopBits=reader.Value;
								break;
							case NODE.FLOWCONTROL:
								this.m_flowControl=reader.Value;
								break;
							case NODE.REUSE:
								this.m_reUse=reader.Value;
								break;
							default:
								break;

						}
							break;
						case XmlNodeType.CDATA:
							//AddLine(reader.Value);
							break;
						case XmlNodeType.ProcessingInstruction:
							//Console.Write("<?{0} {1}?>", reader.Name, reader.Value);
							break;
						case XmlNodeType.Comment:
							//Console.Write("<!--{0}-->", reader.Value);
							break;
						case XmlNodeType.XmlDeclaration:
							//Console.Write("<?xml version='1.0'?>");
							break;
						case XmlNodeType.Document:
							break;
						case XmlNodeType.DocumentType:
							//Console.Write("<!DOCTYPE {0} [{1}]", reader.Name, reader.Value);
							break;
						case XmlNodeType.EntityReference:
							//Console.Write(reader.Name);
							break;
						case XmlNodeType.EndElement:
							//Console.Write("</{0}>", reader.Name);
							break;
					}
				}
				//dsConfig.ReadXml(xmlReader,System.Data.XmlReadMode.Auto);
				reader.Close();
			}
			catch(Exception ex)
			{}

			
			string strOS=System.Environment.OSVersion.ToString();
			AddLine(strOS);
			if(strOS.IndexOf("Windows CE")>0)
				m_bPdaMode=true;
			else
				m_bPdaMode=false;
			//if(this.m_reUse.Equals("false"))  //Settting을 재사용하지 않으면
			{
				
				fmPortSetup fm=new fmPortSetup();
				if(m_bPdaMode)
				{
					fm.cbPortName.Items.Add("COM1:");
					fm.cbPortName.SelectedIndex=0;
				}
				else
				{
					fm.cbPortName.Items.Add("COM1");
					fm.cbPortName.Items.Add("COM2");
					fm.cbPortName.Items.Add("COM3");
					fm.cbPortName.Items.Add("COM4");
					fm.cbPortName.SelectedIndex=0;
				}
				if(this.m_baudRate.Length>0)
					fm.cbBaudRate.Text=m_baudRate;
				else
					fm.cbBaudRate.SelectedIndex=2;
				if(this.m_dataBit.Length>0)
					fm.cbDataBit.Text=m_dataBit;
				else
					fm.cbDataBit.SelectedIndex=3;
				if(this.m_flowControl.Length>0)
					fm.cbFlowControl.Text=m_flowControl;
				else
					fm.cbFlowControl.SelectedIndex=0;
				if(this.m_parity.Length>0)
					fm.cbParity.Text=m_parity;
				else
					fm.cbParity.SelectedIndex=0;
				if(this.m_stopBits.Length>0)
					fm.cbStopBits.Text=m_stopBits;
				else
					fm.cbStopBits.SelectedIndex=0;
				fm.ckReUse.Checked=false;
				fm.SetParent(this);
				fm.ShowDialog();

			}
//
			state=STATUS.NORMAL;
			try
			{
				AddLine("Port : "+this.m_portName);
				AddLine("BaudRate : "+this.m_baudRate);
				AddLine("flowControl : "+this.m_flowControl);

				if(m_bPdaMode)
				{
					PdaPortOpen();
					AddLine("PDA Port Open");
				}
				else
				{
					PcPortOpen();
					this.Width=300;
					this.Height=500;
					AddLine("Pc Port Open");
				}
				//PortOpen();
			}
			catch(Exception dd)
			{}
			state=STATUS.NORMAL;	
			
			m_Connected=true;
			timer1.Enabled=true;
			
			tmr_mon.Enabled=true;
			DgrAddr[0] = 0x1204;
			DgrAddr[1] = 0x1203;
			DgrAddr[2] = 0x1209;
			DgrAddr[3] = 0x1202;
			DgrAddr[4] = 0x1201;
			DgrAddr[5] = 0x120a;
			DgrAddr[6] = 0x120d;
			DgrAddr[7] = 0x1119;
		}
		
		public void PdaPortOpen()
		{
			m_pdaPort=new PDAPort();
			m_pdaPort.SetParent(this);
			//Stop Bit 체크
			PDAPort.StopBits stopBits;
			if(this.m_stopBits.Equals("1"))
				stopBits=PDAPort.StopBits.One;
			else if(this.m_stopBits.Equals("1.5"))
				stopBits=PDAPort.StopBits.OneAndHalf;
			else if(this.m_stopBits.Equals("2"))
				stopBits=PDAPort.StopBits.Two;
			else
				stopBits=PDAPort.StopBits.One;
			//Parity 체크

			PDAPort.Parity parity;
			if(this.m_parity.Equals("None"))
				parity=PDAPort.Parity.None;
			else if(this.m_parity.Equals("Odd"))
				parity=PDAPort.Parity.Odd;
			else if(this.m_parity.Equals("Even"))
				parity=PDAPort.Parity.Even;
			else if(this.m_parity.Equals("Mark"))
				parity=PDAPort.Parity.Mark;
			else if(this.m_parity.Equals("Space"))
				parity=PDAPort.Parity.Space;
			else
				parity=PDAPort.Parity.None;
			//Flow Control
			PDAPort.FlowControl flowControl;

			if(this.m_flowControl.Equals("None"))
				flowControl=PDAPort.FlowControl.None;
			else if(this.m_flowControl.Equals("XOnXOff"))
				flowControl=PDAPort.FlowControl.XOnXOff;
			else if(this.m_flowControl.Equals("Hardware"))
				flowControl=PDAPort.FlowControl.Hardware;
			else 
				flowControl=PDAPort.FlowControl.None;
			m_pdaPort.PortOpen(this.m_portName,UInt32.Parse(m_baudRate),byte.Parse(m_dataBit),stopBits,parity,flowControl );
		}

		public void PcPortOpen()
		{
			m_pcPort=new PCPort();
			m_pcPort.SetParent(this);
			//Stop Bit 체크
			PCPort.StopBits stopBits;
			if(this.m_stopBits.Equals("1"))
				stopBits=PCPort.StopBits.One;
			else if(this.m_stopBits.Equals("1.5"))
				stopBits=PCPort.StopBits.OneAndHalf;
			else if(this.m_stopBits.Equals("2"))
				stopBits=PCPort.StopBits.Two;
			else
				stopBits=PCPort.StopBits.One;
			//Parity 체크

			PCPort.Parity parity;
			if(this.m_parity.Equals("None"))
				parity=PCPort.Parity.None;
			else if(this.m_parity.Equals("Odd"))
				parity=PCPort.Parity.Odd;
			else if(this.m_parity.Equals("Even"))
				parity=PCPort.Parity.Even;
			else if(this.m_parity.Equals("Mark"))
				parity=PCPort.Parity.Mark;
			else if(this.m_parity.Equals("Space"))
				parity=PCPort.Parity.Space;
			else
				parity=PCPort.Parity.None;
			//Flow Control
			PCPort.FlowControl flowControl;

			if(this.m_flowControl.Equals("None"))
				flowControl=PCPort.FlowControl.None;
			else if(this.m_flowControl.Equals("XOnXOff"))
				flowControl=PCPort.FlowControl.XOnXOff;
			else if(this.m_flowControl.Equals("Hardware"))
				flowControl=PCPort.FlowControl.Hardware;
			else 
				flowControl=PCPort.FlowControl.None;
			m_pcPort.PortOpen(this.m_portName,UInt32.Parse(m_baudRate),byte.Parse(m_dataBit),stopBits,parity,flowControl );
			
		}


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

		public System.Windows.Forms.Timer timer1;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.MenuItem mnuFile;
		private System.Windows.Forms.MenuItem menuItem2;
		string m_sPort = "COM1:";
		private void button1_Click(object sender, System.EventArgs e)
		{
		}
		

		private void btnExit_Click(object sender, System.EventArgs e)
		{
			this.Dispose();
		}

		private void btnSend_Click(object sender, System.EventArgs e)
		{

		}
		
		public byte  M_checksum (byte[] msg_ptr, int size)
		{
   
			byte  chksm;
			byte  i;
   
			chksm = 0xff;
			for (i=0; i<size-1; i++) 
			{
				chksm = (byte)(chksm ^ msg_ptr[i]);
			}
			return(chksm);
		} /* M_checksum */

		public void generateRing()
		{
			byte[] message=new byte[6];
			message[0] = 0x80;  /*   type 0, sub 1   hall call enter */
			message[0]+=(byte)carId;
			message[1]=0xa0;
			message[2] = 0x82; 
			message[3] = 0x80;
			message[4] = (byte)(0x80 | floor[carId]);
			message[5] = M_checksum(message,MSG_LEN);
			
			/*--------------------------------------
			 ; Transmit the message on both rings
			 --------------------------------------*/
			SendBytes(message);
			floor[carId]++;
			if(floor[carId]>25)
				floor[carId]=1;
			carId++;
			if(carId>8)
				carId=1;
			this.simul.sendPkt();

		}

		private void timer1_Tick(object sender, System.EventArgs e)
		{
			ReadBuff();
			if(this.state.Equals(STATUS.SIMUL))
			{
				generateRing();
			}
			if(this.state.Equals(STATUS.DOWNLOAD) && this.m_bDownLoadStart)
			{
				AddLine("다운로드 시작");
				timer1.Enabled=false;
				try
				{
					down.lbStatus.Text="다운로드 중";
					Application.DoEvents();
				}
				catch(Exception kj)
				{}
				if(this.m_bPdaMode)
					m_pdaPort.downLoad();
				else
					m_pcPort.downLoad();

				m_bDownLoadStart=false;
				down.Close();
				state=STATUS.NORMAL;
				timer1.Enabled=true;
			}
			if(this.state.Equals(STATUS.ESMI_DOWNLOAD) && this.m_bDownLoadStart)
			{
				timer1.Enabled=false;
				AddLine("다운로드 시작");
				try
				{
					Application.DoEvents();
				}
				catch(Exception e1)
				{}
				esmiDownLoad();
				timer1.Enabled=true;
				m_bDownLoadStart=false;
			}
		}

		public void esmiDownLoad()
		{
			byte[] txHeader=new byte[3];
			byte[] txData=new byte[1];
			byte[] txCheckSum=new byte[4];
			byte[] romData;
			int i=0;
			uint chkSum=0; 
			uint count=0;
			reqBlock=0;
			bDownOk=false;
			esmiDown.progressBar1.Maximum=128;
			esmiDown.progressBar1.Value=0;
			esmiDown.lbComment.Text="다운로드중";
			try 
			{
				using (FileStream fs = new FileStream(this.m_fileName,FileMode.Open,FileAccess.Read)) 
				{
					BinaryReader r = new BinaryReader(fs);
					romData=r.ReadBytes(128*1024);
					txHeader[0]=(byte)'B';
					txHeader[1]=(byte)'L';
					curBlock=0;
					txHeader[2]=0;
					this.SendBytes(txHeader);
					while(!bDownOk)
					{
						if(reqBlock>=128)
						{
							ReadBuff();
							Thread.Sleep(10);
							continue;
						}
						try
						{
							if(curBlock!=reqBlock) //어떠한 요청이 들어 왔으면
							{
								Console.WriteLine("Resend Block "+reqBlock.ToString());
								curBlock=reqBlock;
								count=0;
								chkSum=0;
								txHeader[0]=(byte)'B';
								txHeader[1]=(byte)'L';
								txHeader[2]=curBlock;
								SendBytes(txHeader);
							}
							byte k=romData[curBlock*1024+count];
							txData[0]=k;
							chkSum+=k;
							SendBytes(txData);
							count++;
							if(count>=1024) //한 블럭을 다 보냈으면
							{
								
								for(i=0;i<4;i++)
								{
									txCheckSum[i]=(byte)(chkSum>>8*(3-i));
								}
								SendBytes(txCheckSum);
								Console.Write("*");

								count=0;
								chkSum=0;
								
								curBlock++;
								reqBlock=curBlock;
								if(reqBlock==64) //64K 보낸뒤 응답을 기다림
								{
									reqBlock=curBlock=128;
								}

								Application.DoEvents();

								if(curBlock>=128)
									continue;
								txHeader[0]=(byte)'B';
								txHeader[1]=(byte)'L';
								txHeader[2]=curBlock;
								SendBytes(txHeader);
								ReadBuff();
								esmiDown.progressBar1.Value=curBlock;
							}
						}
						catch
						{
							break;
						}
					}
					r.Close();
					fs.Close();
				}
				
			}
			catch (Exception ex) 
			{
			}
		}



		public void ScreenUpdate()
		{
			byte line;
			
			//MAX_COL 단위로 한줄 씩 만든다.
			if(lineNum<DISP_LINE)
			{
				dispLine=0;
				for(int i=0;i<=endLine;i++)
				{
					
					for(int j=0;j<strArr[i].Length;j=j+MAX_COL)
					{
						if(dispLine>=DISP_LINE) //Scroll
						{
							for(int k=1;k<DISP_LINE;k++)
							{
								strDisp[k-1]=strDisp[k];
							}
							dispLine=DISP_LINE-1;
						}

						try
						{
							int sublen=(strArr[i].Length-j)>MAX_COL ? MAX_COL : (strArr[i].Length-j);
							strDisp[dispLine++]=strArr[i].Substring(j,sublen);
						}
						catch(Exception e1)
						{
							MessageBox.Show("j:"+j.ToString()+" "+strArr[i]+" "+strArr[i].Length.ToString());
						}
					}
				}
			}
			else
			{
				line=(byte)((int)endLine-(DISP_LINE-1));
				dispLine=0;
				//각 줄에 대하여 MAX_COL 단위로 줄을 만듬
				while(line!=endLine)
				{
					for(int j=0;j<strArr[line].Length;j=j+MAX_COL)
					{
						if(dispLine>=DISP_LINE) //Scroll
						{
							for(int k=1;k<DISP_LINE;k++)
							{
								strDisp[k-1]=strDisp[k];
							}
							dispLine=DISP_LINE-1;
						}
						int sublen=(strArr[line].Length-j)>MAX_COL ? MAX_COL : (strArr[line].Length-j);
						strDisp[dispLine++]=strArr[line].Substring(j,sublen);
					}
					line++;
				}
				//마지막 줄에 대한 MAX_COL 단위로 줄을 만듬
				for(int j=0;j<strArr[line].Length;j=j+MAX_COL)
				{
					if(dispLine>=DISP_LINE) //Scroll
					{
						for(int k=1;k<DISP_LINE;k++)
						{
							strDisp[k-1]=strDisp[k];
						}
						dispLine=DISP_LINE-1;
					}
					int sublen=(strArr[line].Length-j)>MAX_COL ? MAX_COL : (strArr[line].Length-j);
					strDisp[dispLine++]=strArr[line].Substring(j,sublen);
				}
			}
		}
		
		public bool ReadBuff()
		{
			byte[] rcvData=new byte[100];
			uint dwBytes;
			ArrayList m_list=new ArrayList();

			if(this.m_bPdaMode)
			{
				dwBytes=this.m_pdaPort.ReadSerial(rcvData);
				curSec=System.DateTime.Now.Second;
				if(curSec%10==1) //조명이 안꺼지게 Idle Timer  를 걸어준다.
				{	
					if(bIdle.Equals(false))
					{
						bIdle=true;
						SystemIdleTimerReset();
					}
				}
				else
				{
					bIdle=false;
				}
			}
			else
				dwBytes=this.m_pcPort.ReadSerial(rcvData);
			if(dwBytes<=0) //받은 데이터가 없으면 return;
				return false;
			else
			{
				if(!state.Equals(STATUS.MONITOR) && !state.Equals(STATUS.GRAPH) && !state.Equals(STATUS.RING) && !state.Equals(STATUS.SIMUL)) // 모니터링 모드나 그래프 모드나 RING 모드가 아니면
				{
					for(int i=0;i<dwBytes;i++)
					{
						//줄 추가
						if((char)rcvData[i]=='\n')
						{
							//strArr[endLine]=Encoding.GetEncoding("euc-kr").GetString(byteLine,0,byteInx);
							byteInx=0;
							m_list.Add(strArr[endLine]);
							if(this.mnuCaptureStart.Enabled.Equals(false))
								this.swCapture.WriteLine(strArr[endLine]);

							strArr[++endLine]="";  //endLine은 바이트 타입이기 때문에 255 이후 반복
							if(lineNum<DISP_LINE+10)  // lineNum는 화면 사이즈 이상 커질때 까지만 증가
								lineNum++;	
						}
							//현재 글자는 일반 글자이고 이전 글자가 \r 이면 끝행 바꿈
						else if((char)rcvData[i]!='\r' && (char)rcvData[i]!='\n' && m_prevChar== '\r')
						{
							byteInx=0;
							byteLine[byteInx++]=rcvData[i];
							strArr[endLine]="";
							strArr[endLine]+=(char)rcvData[i];
						}
						else if((char)rcvData[i]=='\r')  //\r 은 무시
						{
						}
						else if((byte)rcvData[i]==0x08) // Back Space
						{
							byteInx--;
							int len=strArr[endLine].Length;
							if(len>0)
							{
								strArr[endLine]=strArr[endLine].Substring(0,len-1);
							}
						}
						else if(rcvData[i]==0) //null 문자가 오면
						{
							this.byteLine[byteInx++]=32;
							if(byteInx>=byteLine.Length)
								byteInx=byteLine.Length-5;
							strArr[endLine]+=' ';
						}
						else //일반 글자이면
						{
							this.byteLine[byteInx++]=rcvData[i];
							if(byteInx>=byteLine.Length)
								byteInx=byteLine.Length-5;
							strArr[endLine]+=(char)rcvData[i];
							//strArr[endLine]=Encoding.GetEncoding("euc-kr").GetString(byteLine,0,byteInx); //한글로 변환할 때
						}
						m_prevChar=(char)rcvData[i];
					}
					m_list.Add(strArr[endLine]);
					ScreenUpdate();
					Refresh();
				}
				if(state.Equals(STATUS.GRAPH)) //그래프 모드이면
				{
					for(int i=0;i<dwBytes;i++)
					{	
						m_RxBuf[m_iRxIdx++] = rcvData[i];	
						//AddLine(string.Format("{0:02X}",rcvData[i]));
					}
					
					if(m_RxBuf[0]==0x01)
					{
						if(m_RxBuf[1]==0x03) 
						{
							if(m_iRxIdx>=m_RxBuf[2]+5)
							{
								RxGrpService();
								m_iRxWait = false;
								m_iRxWaitCnt = 0;
								m_iRxIdx = 0;
							}
						}
						else if(m_RxBuf[1]==0x06) 
						{
							if(m_iRxIdx>=8)
							{
								m_iTxWait = false;
								m_iTxWaitCnt = 0;
								m_iRxIdx = 0;
							}
						}
					}
				}
				if(state==Form1.STATUS.MONITOR) //모니터링 모드 이면
				{
					
					for(int i=0;i<dwBytes;i++)
					{	
						m_RxBuf[m_iRxIdx++] = rcvData[i];	
						//AddLine(string.Format("{0:02X}",rcvData[i]));
					}
					
					if(m_RxBuf[0]==0x01)
					{
						if(m_RxBuf[1]==0x03) 
						{
							if(m_iRxIdx>=m_RxBuf[2]+5)
							{
								RxService();
								m_iRxWait = false;
								m_iRxWaitCnt = 0;
								m_iRxIdx = 0;

								m_iCommCnt++;
								if(m_iCommCnt<=5)
								{
									param.picCom.Image=param.imageList1.Images[0];
								}
								else if(m_iCommCnt<=10)
								{
									param.picCom.Image=param.imageList1.Images[1];
								}
								else m_iCommCnt = 0;

							}
						}
						else if(m_RxBuf[1]==0x06) 
						{
							if(m_iRxIdx>=8)
							{
								m_iTxWait = false;
								m_iTxWaitCnt = 0;
								m_iRxIdx=0;
							}
						}
					}
				}
				if(state==Form1.STATUS.DOWNLOAD)
				{
					if(dwBytes>10 && dwBytes<50)
					{
						foreach(string str in m_list)
						{
							if(str.IndexOf("Motorola")>0)
							{
								if(m_bDownLoadStart==false)
									m_bDownLoadStart=true;
							}
						}
					}
				}
				if(state==Form1.STATUS.ESMI_DOWNLOAD)
				{
					byte[] txData=new byte[5];
					byte[] txKey=new byte[1];
					for(int i=0;i<dwBytes;i++)
					{
						mdm_rx_buf[mdm_rx_ptw]=rcvData[i];
						//DownLoad 중에 BL? 값이 오면
						if(mdm_rx_buf[(byte)(mdm_rx_ptw-2)]==(byte)'B' &&   
							mdm_rx_buf[(byte)(mdm_rx_ptw-1)]==(byte)'L')
						{
							reqBlock=mdm_rx_buf[mdm_rx_ptw];
						}
						mdm_rx_ptw++;
					}

					if(dwBytes>3)
					{
						foreach(string str in m_list)
						{
							if(str.IndexOf("OOT>")>0) //BOOT>로 하지 않은 이유는 인덱스를 0이상으로 만들기 위해
							{
								txData[0]=(byte)'r';
								txData[1]=(byte)'i';
								txData[2]=(byte)'m';
								txData[3]=(byte)'g';
								txData[4]=(byte)'\r';
								SendBytes(txData);
							}
							if(str.IndexOf("EADY>")>0) //READY>로 하지 않은 이유는 인덱스를 0이상으로 만들기 위해
							{
								if(esmi==ESMI.L)
								{
									AddLine("BuadRate Change 38400");
									EsmiDownLoadMode(38400);
								}
								else if(esmi==ESMI.Z)
								{
									EsmiDownLoadMode(115200);
								}

								if(m_bDownLoadStart==false)
									m_bDownLoadStart=true;
							}
							if(str.IndexOf("!@!@!@!@")>=0) //끊으라는 신호가 오면
							{
								bDownOk=true;
								this.esmiDown.Close();
								this.state=STATUS.NORMAL;
								
								if(this.m_bPdaMode)
									this.m_pdaPort.MonMode();
								else
									this.m_pcPort.MonMode();
							}
						}
					}
				}
				if(state==Form1.STATUS.RING)
				{
					byte[] txData=new byte[6];
					for(int i=0;i<dwBytes;i++)
					{
						ring_rx_buf[ring_rx_ptw]=rcvData[i];
						//Ring Packet check
						if((ring_rx_buf[ring_rx_ptw] & 0x80)==0) // if last byte
						{
							for(int j=0;j<6;j++)
							{
								txData[j]=ring_rx_buf[(byte)(ring_rx_ptw-5+j)];
							}
							if(M_checksum(txData,MSG_LEN)==txData[5])
							{
								SendBytes(txData);
								if((txData[0]&0x70)==0x00)
								{
									int car=txData[0]&0x0f;
									if((txData[1]&0x60)==0x20 && !ringMon.btnCapture.Text.Equals("Stop")) //subtype 1
									{
										int floor=txData[4]&0x7f;
										ringMon.setFloor(car,floor);
										int dir=(txData[3]&0x30)>>4;
										ringMon.setDir(car,dir);
										int fDoor=txData[3]&0x03;
										ringMon.setDoor(car,fDoor);
									}
								}

								try
								{
									if(ringMon.btnCapture.Text.Equals("Stop"))
									{
										int origin=txData[0]&0x0f;
										int type=(txData[0]&0x70)>>4;
										sr.WriteLine(string.Format("{0:D},{1:D},{2:X2},{3:X2},{4:X2},{5:X2},{6:X2},{7:X2},",origin,type,txData[0],txData[1],txData[2],txData[3],txData[4],txData[5])+DateTime.Now.Minute.ToString()+":"+DateTime.Now.Second.ToString()+":"+DateTime.Now.Millisecond.ToString());
										ringCnt++;
										if((ringCnt%10)==0 && ringCnt<ringMon.proRing.Maximum)
											ringMon.proRing.Value=ringCnt;
									}
								}
								catch(Exception e)
								{
								}
							}
						}
						ring_rx_ptw++;
					}
				}
				return true;
			}
		}

		public void RxGrpService()
		{
			int MaxCnt = 2;

			int Data;
			string sTmp;
			
			Data = m_RxBuf[3]*256+m_RxBuf[4];
			switch(pointGpInx[m_wIndex])
			{
				case 0://입력접점인 경우
					grp.nCurInput=Data;
					break;
				case 1: //출력접점인 경우
					grp.nCurOutput=Data;
					break;
				case 2: //출력주파수 
					grp.nCurFreqOut=Data;
					break;
				case 3: // 도어운전상태
					break;
				case 4: // 도어 위치
					grp.nCurDoorPos=Data;
					grp.AddData();
					break;
			}
			m_wIndex++;
			if(m_wIndex.Equals(3)) //도어운전 상태이면 그래프에 그릴 필요 없으니 index를 4로 올린다.
				m_wIndex=4;
			if(m_wIndex>=pointAddr.Length)
				m_wIndex=0;
		}

		public void RxService()
		{
			int MaxCnt = 2;
			double dData,dRes;
			DataTable dtPoint;
			int Data;
			string sTmp;
			
			//접점 화면이 떠 있으면
			if(param.tabControl1.TabPages[param.tabControl1.SelectedIndex].Text.Equals("Point"))
			{
				Data = m_RxBuf[3]*256+m_RxBuf[4];
				if(this.m_wIndex>=pointAddr.Length)
				{
					this.m_wIndex=0;
					return;
				}
				switch(pointGpInx[m_wIndex])
				{
					case 0://입력접점인 경우
						dtPoint=(DataTable)param.gridInput.DataSource;
						for(int i=0;i<param.dtInput.Rows.Count;i++)
						{
							if((Data & 1<<(param.dtInput.Rows.Count-i-1)) >0) //접점이 On인지 Check
							{
								dtPoint.Rows[i]["값"]="1";
								//param.gridInput.Select(i);
							}
							else
							{
								dtPoint.Rows[i]["값"]="0";
								//param.gridInput.UnSelect(i);
							}
						}
						break;
					case 1: //출력접점인 경우
						dtPoint=(DataTable)param.gridOutput.DataSource;
						for(int i=0;i<param.dtOutput.Rows.Count;i++)
						{
							if((Data & 1<<(param.dtOutput.Rows.Count-i-1))>0)
							{
								dtPoint.Rows[i]["값"]="1";
								//param.gridOutput.Select(i);
							}
							else
							{
								dtPoint.Rows[i]["값"]="0";
								//param.gridOutput.UnSelect(i);
							}
						}
						break;
					case 2: //출력주파수 
						double dbData=(double)Data*0.1;
						param.txtOutFreq.Text=dbData.ToString();
						break;
					case 3: // 도어운전상태
					switch(Data)
					{
						case 0:
							param.txtOpMode.Text="Close";
							break;
						case 1:
							param.txtOpMode.Text="Open 가속";
							break;
						case 2:
							param.txtOpMode.Text="Open 정속";
							break;
						case 3:
							param.txtOpMode.Text="Open 감속";
							break;
						case 4:
							param.txtOpMode.Text="Open";
							break;
						case 5:
							param.txtOpMode.Text="Close 가속";
							break;
						case 6:
							param.txtOpMode.Text="Close 정속";
							break;
						case 7:
							param.txtOpMode.Text="Close 감속";
							break;
					}
						break;
					case 4: // 도어 위치
						dData=Data*0.1;			
						param.txtDoorPos.Text=dData.ToString()+"% Close";
						break;
				}
				m_wIndex++;
				if(m_wIndex>=pointAddr.Length)
					m_wIndex=0;
			}
			else
			{
				DataTable dtParam=(DataTable)this.m_tableList[param.cbGroup.SelectedIndex];
				Data = m_RxBuf[3]*256+m_RxBuf[4];
				if(this.m_wIndex>=dtParam.Rows.Count)
					return;
				dtParam.Rows[m_wIndex]["Data"]=Data.ToString();
				if(m_wIndex<param.dt.Rows.Count)
				{
					try
					{
						sTmp=(string)dtParam.Rows[m_wIndex]["Res"];
						sTmp=sTmp.Trim();
					
						if(sTmp.Equals("0.1") || sTmp.Equals("0.01") || sTmp.Equals("0.001"))
						{
							dRes=double.Parse(sTmp);
						}
						else
						{
							dRes=1;
						}
					}
					catch
					{
						dRes=1;
					}
					//S/W 날짜 처리
					if(param.cbGroup.SelectedIndex==0 && m_wIndex==4)
					{
						int date=Data & 0x1f;
						int month=(Data>>5) & 0x0f;
						int year=Data>>9;
						param.dt.Rows[m_wIndex]["데이타"]=string.Format("{0:00}",year)+"/"+string.Format("{0:00}",month)+"/"+string.Format("{0:00}",date);
					}
					else if(param.cbGroup.SelectedIndex==0 && m_wIndex==5)
					{
						string val="";
						for(int iBit=5;iBit>=0;iBit--)
						{
							val+=((Data>>iBit) & 1 )>0 ? "1" : "0";
						}
						param.dt.Rows[m_wIndex]["데이타"]=val;
					}
					else if(param.cbGroup.SelectedIndex==0 && m_wIndex==6)
					{
						string val="";
						for(int iBit=6;iBit>=0;iBit--)
						{
							val+=((Data>>iBit) & 1 )>0 ? "1" : "0";
						}
						param.dt.Rows[m_wIndex]["데이타"]=val;
					}
					else if(param.cbGroup.SelectedIndex==0 && (m_wIndex==16 || m_wIndex==19 || m_wIndex==21))
					{
						param.dt.Rows[m_wIndex]["데이타"]=string.Format("{0:0000}",Data);
					}
					else if(param.cbGroup.SelectedIndex==3 && m_wIndex>=0 && m_wIndex<=19)
					{
						int Status=Data>>8;
						int val=Data & 0x0FF;
						param.dt.Rows[m_wIndex]["데이타"]=Status.ToString()+ "/"+string.Format("{0:000}",val);
					}
					else if(param.cbGroup.SelectedIndex==3 && m_wIndex==21)
					{
						int Status=Data>>14;
						string s1="";
						switch(Status)
						{
							case 0:
								s1="A";
								break;
							case 1:
								s1="B";
								break;
							case 2:
								s1="C";
								break;
							case 3:
								s1="D";
								break;
						}
						int val=Data & 0x3FFF;
						param.dt.Rows[m_wIndex]["데이타"]=s1+"/"+string.Format("{0:00000}",val);
					}
					else
					{
						dData=Data*dRes;
						if(dRes==0.1)
						{
							param.dt.Rows[m_wIndex]["데이타"]=string.Format("{0:####0.0}",dData);
						}
						else if(dRes==0.01)
						{
							param.dt.Rows[m_wIndex]["데이타"]=string.Format("{0:####0.00}",dData);
						}
						else
							param.dt.Rows[m_wIndex]["데이타"]=dData.ToString();
					}
				}
				m_wIndex++;
				if(m_wIndex>=dtParam.Rows.Count)
					m_wIndex=0;
			}
		}
		
		public bool bSend=true;
		public bool bStart=false;


		private void menuItem1_Click(object sender, System.EventArgs e)
		{
		}

		private void mnuFile_Click(object sender, System.EventArgs e)
		{
			timer1.Enabled=false;
			tmr_mon.Enabled=false;
			this.openFileDialog1.ShowDialog();
			m_fileName=openFileDialog1.FileName;
			this.lineCheck();
			timer1.Enabled=true;
			tmr_mon.Enabled=true;
		}

		public void lineCheck()
		{
			try 
			{
				// Create an instance of StreamReader to read from a file.
				// The using statement also closes the StreamReader.
				using (StreamReader sr = new StreamReader(m_fileName)) 
				{
					nFileLine=0;
					// Read and display lines from the file until the end of 
					// the file is reached.
					while (sr.ReadLine() != null) 
					{
						nFileLine++;
					}
				}
			}
			catch (Exception ex) 
			{
				// Let the user know what went wrong.
				Console.WriteLine("The file could not be read:");
				Console.WriteLine(ex.Message);
			}
		}

		private void mnuDownLoad_Click(object sender, System.EventArgs e)
		{
			if(m_fileName.Length<2)
			{
				openFileDialog1.ShowDialog();
				m_fileName=openFileDialog1.FileName;
			}
			lineCheck();
			down=new DownLoad(m_fileName);
			down.Show();
			down.SetParent(this);
			down.progressBar1.Maximum=nFileLine;
			//MessageBox.Show(nFileLine.ToString());
			state=STATUS.DOWNLOAD;
			this.mnuFile.Enabled=true;
		}


		private void menuItem2_Click(object sender, System.EventArgs e)
		{
			if(this.m_bPdaMode)
			{
				m_pdaPort.PortClose();
			}
			else
			{
				m_pcPort.PortClose();
			}
			this.Close();
		}

		private void Form1_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
			Graphics g=e.Graphics;

			//화면에 디스플레이
			for(int i=0;i<dispLine;i++)
			{
				g.DrawString(strDisp[i],DispFont,br,3,5+(i)*15);
			}
			

/*
			if(lineNum<DISP_LINE)
			{
				for(int i=0;i<=endLine;i++)
				{
					g.DrawString(strArr[i],DispFont,br,10,20+(i)*15);
				}
			}
			else
			{
				line=(byte)((int)endLine-(DISP_LINE-1));
				int i=0;
				while(line!=endLine)
				{
					g.DrawString(strArr[line],DispFont,br,10,20+i*15);
					i++;
					line++;
				}
				g.DrawString(strArr[line],DispFont,br,10,20+i*15);
			}
*/			
		}

		private void mnuManDown_Click(object sender, System.EventArgs e)
		{
			try 
			{
				if(this.m_bPdaMode)
					m_pdaPort.downLoad();
				else
				{
					AddLine("수동 전송");
					m_pcPort.downLoad();
				}
			}
			catch (Exception ex) 
			{
				// Let the user know what went wrong.
				Console.WriteLine("The file could not be read:");
				Console.WriteLine(ex.Message);
			}
		}

		private void Form1_Closed(object sender, System.EventArgs e)
		{
			XmlTextWriter writer;
			if(this.m_bPdaMode)
				writer = new XmlTextWriter("\\ads.xml",System.Text.Encoding.UTF8);
			else
				writer = new XmlTextWriter("\\ads.xml",System.Text.Encoding.UTF8);

			//Use indentation for readability.
			writer.Formatting = Formatting.Indented;
			writer.Indentation = 4;
        
			//Write an element (this one is the root).
			writer.WriteStartElement("Setting");

			//Write the title element.
			writer.WriteStartElement("RomFile");
			writer.WriteString(this.m_fileName);
			writer.WriteEndElement();
			writer.WriteStartElement("PortName");
			writer.WriteString(this.m_portName);
			writer.WriteEndElement();
			writer.WriteStartElement("BaudRate");
			writer.WriteString(this.m_baudRate);
			writer.WriteEndElement();
			writer.WriteStartElement("DataBit");
			writer.WriteString(this.m_dataBit);
			writer.WriteEndElement();
			writer.WriteStartElement("Parity");
			writer.WriteString(this.m_parity);
			writer.WriteEndElement();
			writer.WriteStartElement("StopBits");
			writer.WriteString(this.m_stopBits);
			writer.WriteEndElement();
			writer.WriteStartElement("FlowControl");
			writer.WriteString(this.m_flowControl);
			writer.WriteEndElement();
			writer.WriteStartElement("ReUse");
			writer.WriteString(this.m_reUse);
			writer.WriteEndElement();
			//Write the close tag for the root element.
			writer.WriteEndElement();
             
			//Write the XML to file and close the writer.
			writer.Close();
		}

		public void ringCaptureStart()
		{
			sr = File.CreateText(@"ringCap.csv");
			sr.WriteLine("CAR,TYPE,MSG0,MSG1,MSG2,MSG3,MSG4,MSG5,TIME");
		}

		public void ringCaptureStop()
		{
			sr.Close();
		}

		public void SetBar(int n)
		{
			try
			{
				down.lbProgress.Text=n.ToString()+"/"+down.progressBar1.Maximum.ToString();
				down.progressBar1.Value=n;			
			}
			catch(Exception kj)
			{}
		}

		private void menuItem4_Click(object sender, System.EventArgs e)
		{
			mon=new fmMonitor(this);
			mon.Show();
			state=Form1.STATUS.MONITOR;
		}

		private void tmr_mon_Tick(object sender, System.EventArgs e)
		{
			if(state.Equals(Form1.STATUS.MONITOR))
			{
				if(m_iRxWait==false && m_iTxWait==false)
				{
					if(param.m_wSetDataAddr>0) //Button으로 명령을 줄 때
					{
						m_SendAddr = param.m_wSetDataAddr;
						m_SendData = param.m_iSetData;
						param.m_wSetDataAddr = 0;
						param.m_iSetData = 0;

						m_iTxWait = true;
						m_iTxWaitCnt = 0;
						WrDataReq(1, m_SendAddr, m_SendData, 1);
					}
					else if(param.m_iSetDataIdx>0) //DataGrid에서 직접 선택한 부분이면
					{
						//m_SendAddr=Convert.ToUInt32((string)param.dt.Rows[param.m_curRow]["Addr"],16);
						DataTable dtGroup=(DataTable)this.m_tableList[param.cbGroup.SelectedIndex];
						m_SendAddr=0;
						int wIndex=param.m_curRow;

						if(wIndex>=dtGroup.Rows.Count) //index가 초과 되면 return;
							return;
						try
						{
							string strAddr=(string)dtGroup.Rows[wIndex]["Group_inx"];
							strAddr=strAddr.Trim();
							m_SendAddr=Convert.ToUInt32(strAddr,16)<<8;
						}
						catch
						{
							MessageBox.Show("Group_inx : "+(string)dtGroup.Rows[m_wIndex]["Group_inx"]);
						}
						string strIndex=(string)dtGroup.Rows[wIndex]["Index"];
						strIndex=strIndex.Trim();
						m_SendAddr+=Convert.ToUInt32(strIndex,10);

						//float fDataIn=float.Parse(param.m_sSetData[param.m_iSetDataIdx-1]);
						double dSendData=double.Parse(param.m_sSetData[param.m_iSetDataIdx-1]);
						double Res;
						try
						{
							Res=double.Parse((string)dtGroup.Rows[wIndex]["Res"]);
						}
						catch
						{
							Res=1;
						}
						if(Res==0)
							Res=1;
						m_SendData=(uint)Math.Floor(dSendData/Res+0.5);
						param.m_iSetDataIdx=0;

						//						sTmp.Format("%f,%d, %d",fDataIn,Dec10[DotPos[m_listCtrl.m_iClickRow]], Data);
						//						m_disp.Format("%d,%x,%x",++m_tic,Addr,Data);
						//						CWnd *pWnd;
						//						pWnd = GetDlgItem(IDC_DISP);
						//						pWnd->SetWindowText(m_disp);
				
						m_iTxWait = true;
						m_iTxWaitCnt = 0;
						WrDataReq(1, m_SendAddr, m_SendData, 1);
					}
					else if(downWp!=downRp)
					{
						m_SendAddr=this.addrDown[downRp];
						m_SendData=this.dataDown[downRp];
						try
						{
							param.progressBar1.Value=(int)(m_SendAddr & 0xff);
							if(param.progressBar1.Value>=param.progressBar1.Maximum-1)
								param.progressBar1.Visible=false;
						}
						catch
						{}
						downRp++;
						m_iTxWait=true;
						m_iTxWaitCnt=0;
						WrDataReq(1, m_SendAddr, m_SendData, 1);
					}
					else  //Normal 모드에서 모니터링 요청 Packet전송
					{
						if(param.tabControl1.TabPages[param.tabControl1.SelectedIndex].Text.Equals("Point"))
						{
							PointReq();
						}
						else
						{
							DataTable dtGroup=(DataTable)this.m_tableList[param.cbGroup.SelectedIndex];
							uint Addr=0;
							if(m_wIndex>=dtGroup.Rows.Count) //index가 초과 되면 return;
								return;
							try
							{
								string strAddr=(string)dtGroup.Rows[m_wIndex]["Group_inx"];
								strAddr=strAddr.Trim();
								Addr=Convert.ToUInt32(strAddr,16)<<8;
							}
							catch
							{
								MessageBox.Show("Group_inx : "+(string)dtGroup.Rows[m_wIndex]["Group_inx"]);
							}
							string strIndex=(string)dtGroup.Rows[m_wIndex]["Index"];
							strIndex=strIndex.Trim();
							Addr+=Convert.ToUInt32(strIndex,10);
							RdDataReq(1,Addr,1);
					
							m_iRxWait = true;
							m_iRxWaitCnt = 0;
							m_iRxIdx = 0;
						}
					}
				}
				else // 받는 것을 기다리던가 보내는 것을 기다림
				{
					if(++m_iRxWaitCnt>10)
					{
						m_iRxWaitCnt = 0;
						m_iRxWait = false;
					}
					if(m_iTxWait && m_iTxWaitCnt++>10)
					{
						m_iTxWait = true;
						m_iTxWaitCnt = 0;
						WrDataReq(1, m_SendAddr, m_SendData, 1);
					}

				}
			}
			else if(state.Equals(Form1.STATUS.GRAPH)) //Graph 모드에서는 PointReq 함수로 Reading 만함
			{
				if(m_iRxWait==false && m_iTxWait==false)
				{
					PointReq();
				}
				else // 받는 것을 기다리던가 보내는 것을 기다림
				{
					if(++m_iRxWaitCnt>10)
					{
						m_iRxWaitCnt = 0;
						m_iRxWait = false;
					}
					if(m_iTxWait && m_iTxWaitCnt++>10)
					{
						m_iTxWait = true;
						m_iTxWaitCnt = 0;
						WrDataReq(1, m_SendAddr, m_SendData, 1);
					}

				}
				
			}
		}

		public void PointReq()
		{
			uint Addr=0;
			if(m_wIndex>=pointAddr.Length) //index가 초과 되면 return;
				m_wIndex=0;
			Addr=pointAddr[m_wIndex];
			RdDataReq(1,Addr,1);
					
			m_iRxWait = true;
			m_iRxWaitCnt = 0;
			m_iRxIdx = 0;
		}

		public void WrDataReq(uint id,uint addr,uint data,uint len)
		{
			uint wTmp,tx_len;
			byte[] TxBuf=new byte[8];

			tx_len = 8;

			TxBuf[0] = (byte)id;
			TxBuf[1] = 0x06;
	
			TxBuf[2] = (byte)((addr>>8)&0xff);
			TxBuf[3] = (byte)(addr& 0xff);
			TxBuf[4] = (byte)((data>>8)&0xff);
			TxBuf[5] = (byte)((data & 0xff));
	
			wTmp = GetCRC(TxBuf,6);

			TxBuf[6] = (byte)((wTmp>>8)&0xff);
			TxBuf[7] = (byte)(wTmp&0xff);
			SendBytes(TxBuf);
		}

		public void RdDataReq(uint id,uint addr,uint size)
		{
			uint wTmp,tx_len;
			byte[] TxBuf=new byte[8];

			tx_len = 8;

			TxBuf[0] = (byte)id;
			TxBuf[1] = 0x03;
	
			TxBuf[2] = (byte)((addr>>8)&0xff);
			TxBuf[3] = (byte)(addr&0x0ff);
			TxBuf[4] = (byte)((size>>8)&0x0ff);
			TxBuf[5] = (byte)(size&0x0ff);
	
			wTmp = GetCRC(TxBuf,6);

			TxBuf[6] = (byte)((wTmp>>8)&0xff);
			TxBuf[7] = (byte)(wTmp&0xff);
			SendBytes(TxBuf);
		}

		public void SendBytes(byte[] TxBuf)
		{
			if(this.m_bPdaMode)
				this.m_pdaPort.SendBytes(TxBuf);
			else 
				this.m_pcPort.SendBytes(TxBuf);
		}

		public ushort GetCRC(byte[] TxBuf,uint len)
		{
			ushort wSeed,i;
	
			wSeed = 0xffff;

			for(i=0;i<len;i++)
			{
				wSeed = AddData(wSeed,(byte)(TxBuf[i]&0xff));
			}
			return ((ushort)(((wSeed<<8)&0xff00)|((wSeed>>8)&0xff)));
		}

		public ushort AddData(ushort crc,byte data)
		{
			ushort rv,i;
			rv = (ushort)(crc^data);

			for(i=0;i<8;i++)
			{
				if((rv&1)>0)
				{
					rv= (ushort)((rv>>1)^0xa001);
				}		
				else
					rv= (ushort)(rv>>1);		
			}
			return rv;

		}

		private void mnuAdsDownLoad_Click(object sender, System.EventArgs e)
		{
			if(this.m_Connected)
			{
				if(this.m_bPdaMode)  //BaudRate Change
				{
					this.m_pdaPort.DownLoadMode();
				}
				else
				{
					this.m_pcPort.DownLoadMode();
				}
				if(m_fileName.Length<2)
				{
					openFileDialog1.ShowDialog();
					m_fileName=openFileDialog1.FileName;
				}
				lineCheck();
				down=new DownLoad(m_fileName);
				down.Show();
				down.SetParent(this);
				down.progressBar1.Maximum=nFileLine;
				//MessageBox.Show(nFileLine.ToString());
				state=STATUS.DOWNLOAD;
				this.mnuFile.Enabled=true;
				
			}
		}

		private void mnuAdsMon_Click(object sender, System.EventArgs e)
		{
			string path;
			if(this.m_bPdaMode)
				path = "\\doa.xml";
			else
				path="\\doa.xml";

			if (!File.Exists(path)) 
			{
				MessageBox.Show("루트 디렉토리에 doa.xml 파일을 놓아 주십시요");
				return;
			}
			if(m_Connected)
			{
				if(this.m_bPdaMode)
					this.m_pdaPort.MonMode();
				else
					this.m_pcPort.MonMode();
				
				param=new fmParam(this);
				param.Show();
				Application.DoEvents();
				state=Form1.STATUS.MONITOR;
			}
		}

		private void tmr_Update_Tick(object sender, System.EventArgs e)
		{
			if(state.Equals(Form1.STATUS.MONITOR))
			{
				DataTable dtGroup=(DataTable)this.m_tableList[param.cbGroup.SelectedIndex];
				if(dtGroup.Rows.Count>param.dt.Rows.Count)
					return;
				for(int i=0;i<dtGroup.Rows.Count;i++)
				{
					param.dt.Rows[i]["데이타"]=dtGroup.Rows[i]["Data"];
				}
			}
		}

		private void mnuSvcTool_Click(object sender, System.EventArgs e)
		{
			string path;
			if(this.m_bPdaMode)
				path = "\\doa.xml";
			else
				path="\\doa.xml";

			if (!File.Exists(path)) 
			{
				MessageBox.Show("루트 디렉토리에 doa.xml 파일을 놓아 주십시요");
				return;
			}
			if(m_Connected)
			{
				if(this.m_bPdaMode)
					this.m_pdaPort.MonMode();
				else
					this.m_pcPort.MonMode();
				/*
				mon=new fmMonitor(this);
				mon.Show();
				state=Form1.STATUS.MONITOR;
				*/
				svcTool=new fmSvcTool(this);
				svcTool.Show();
				Application.DoEvents();
				state=Form1.STATUS.SVCTOOL;
			}
		}
		
		private void mnuTCD_Click(object sender, System.EventArgs e)
		{
			tcd=new fmTcd(this);
			tcd.Show();
		}

		public void EsmiDownLoadMode(uint baudrate)
		{
			if(this.m_bPdaMode)
			{
				this.m_pdaPort.EsmiDownLoadMode(baudrate);
			}
			else
			{
				this.m_pcPort.EsmiDownLoadMode(baudrate);
			}
		}

		private void mnuEsmiDownLoad_Click(object sender, System.EventArgs e)
		{
			if(this.m_Connected)
			{
				if(mnuEsmiDownLoad.Equals(sender))
				{
					esmi=ESMI.L;
				}
				else if(this.mnuESMIZDown.Equals(sender))
				{
					esmi=ESMI.Z;
				}

				if(m_fileName.Length<2)
				{
					openFileDialog1.ShowDialog();
					m_fileName=openFileDialog1.FileName;
				}

				esmiDown=new fmEsmiDownLoad(m_fileName);
				esmiDown.Show();
				esmiDown.SetParent(this);
				esmiDown.progressBar1.Maximum=128;
				esmiDown.btnEsmiReset.Enabled=true;
				esmiDown.btnManualReset.Enabled=true;
				state=STATUS.ESMI_DOWNLOAD;
				//MessageBox.Show(nFileLine.ToString());
				this.mnuFile.Enabled=true;
			}
		}

		private void Form1_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
		{
			byte[] txData;
			txData=new byte[1];
			txData[0]=(byte)e.KeyChar;
			SendBytes(txData);
		}

		private void mnuGraph_Click(object sender, System.EventArgs e)
		{
			string path;
			if(this.m_bPdaMode)
				path = "\\doa.xml";
			else
				path="\\doa.xml";

			if (!File.Exists(path)) 
			{
				MessageBox.Show("루트 디렉토리에 doa.xml 파일을 놓아 주십시요");
				return;
			}
			if(m_Connected)
			{
				if(this.m_bPdaMode)
					this.m_pdaPort.MonMode();
				else
					this.m_pcPort.MonMode();
				
				grp=new fmGraph(this);
				grp.Show();
				Application.DoEvents();
				state=Form1.STATUS.GRAPH;
			}
		}

		public void MonMode()
		{
			if(this.m_bPdaMode)
				this.m_pdaPort.MonMode();
			else
				this.m_pcPort.MonMode();
		}

		public void RingMode()
		{
			if(this.m_bPdaMode)
				this.m_pdaPort.RingMode();
			else
				this.m_pcPort.RingMode();
		}

		private void mnuPort_Click(object sender, System.EventArgs e)
		{
			if(!state.Equals(Form1.STATUS.NORMAL))
				return;

			fmPortSetup fm=new fmPortSetup();
			if(m_bPdaMode)
			{
				fm.cbPortName.Items.Add("COM1:");
				fm.cbPortName.SelectedIndex=0;
			}
			else
			{
				fm.cbPortName.Items.Add("COM1");
				fm.cbPortName.Items.Add("COM2");
				fm.cbPortName.Items.Add("COM3");
				fm.cbPortName.Items.Add("COM4");
				fm.cbPortName.SelectedIndex=0;
			}
			if(this.m_baudRate.Length>0)
				fm.cbBaudRate.Text=m_baudRate;
			else
				fm.cbBaudRate.SelectedIndex=2;
			if(this.m_dataBit.Length>0)
				fm.cbDataBit.Text=m_dataBit;
			else
				fm.cbDataBit.SelectedIndex=3;
			if(this.m_flowControl.Length>0)
				fm.cbFlowControl.Text=m_flowControl;
			else
				fm.cbFlowControl.SelectedIndex=0;
			if(this.m_parity.Length>0)
				fm.cbParity.Text=m_parity;
			else
				fm.cbParity.SelectedIndex=0;
			if(this.m_stopBits.Length>0)
				fm.cbStopBits.Text=m_stopBits;
			else
				fm.cbStopBits.SelectedIndex=0;
			fm.ckReUse.Checked=false;
			fm.SetParent(this);
			fm.ShowDialog();

			try
			{
				AddLine("Port : "+this.m_portName);
				AddLine("BaudRate : "+this.m_baudRate);
				AddLine("flowControl : "+this.m_flowControl);



				if(m_bPdaMode)
				{
					PdaModeChange();
					AddLine("PDA Port Setting Changed");
				}
				else
				{
					PcModeChange();
					AddLine("Pc Port Setting Changed");
				}
				//PortOpen();
			}
			catch(Exception dd)
			{}

		}

		public void PcModeChange()
		{
			//Stop Bit 체크
			PCPort.StopBits stopBits;
			if(this.m_stopBits.Equals("1"))
				stopBits=PCPort.StopBits.One;
			else if(this.m_stopBits.Equals("1.5"))
				stopBits=PCPort.StopBits.OneAndHalf;
			else if(this.m_stopBits.Equals("2"))
				stopBits=PCPort.StopBits.Two;
			else
				stopBits=PCPort.StopBits.One;
			//Parity 체크

			PCPort.Parity parity;
			if(this.m_parity.Equals("None"))
				parity=PCPort.Parity.None;
			else if(this.m_parity.Equals("Odd"))
				parity=PCPort.Parity.Odd;
			else if(this.m_parity.Equals("Even"))
				parity=PCPort.Parity.Even;
			else if(this.m_parity.Equals("Mark"))
				parity=PCPort.Parity.Mark;
			else if(this.m_parity.Equals("Space"))
				parity=PCPort.Parity.Space;
			else
				parity=PCPort.Parity.None;
			//Flow Control
			PCPort.FlowControl flowControl;

			if(this.m_flowControl.Equals("None"))
				flowControl=PCPort.FlowControl.None;
			else if(this.m_flowControl.Equals("XOnXOff"))
				flowControl=PCPort.FlowControl.XOnXOff;
			else if(this.m_flowControl.Equals("Hardware"))
				flowControl=PCPort.FlowControl.Hardware;
			else 
				flowControl=PCPort.FlowControl.None;
			m_pcPort.PortChange(this.m_portName,UInt32.Parse(m_baudRate),byte.Parse(m_dataBit),stopBits,parity,flowControl );
		}


		public void PdaModeChange()
		{
			//Stop Bit 체크
			PDAPort.StopBits stopBits;
			if(this.m_stopBits.Equals("1"))
				stopBits=PDAPort.StopBits.One;
			else if(this.m_stopBits.Equals("1.5"))
				stopBits=PDAPort.StopBits.OneAndHalf;
			else if(this.m_stopBits.Equals("2"))
				stopBits=PDAPort.StopBits.Two;
			else
				stopBits=PDAPort.StopBits.One;
			//Parity 체크

			PDAPort.Parity parity;
			if(this.m_parity.Equals("None"))
				parity=PDAPort.Parity.None;
			else if(this.m_parity.Equals("Odd"))
				parity=PDAPort.Parity.Odd;
			else if(this.m_parity.Equals("Even"))
				parity=PDAPort.Parity.Even;
			else if(this.m_parity.Equals("Mark"))
				parity=PDAPort.Parity.Mark;
			else if(this.m_parity.Equals("Space"))
				parity=PDAPort.Parity.Space;
			else
				parity=PDAPort.Parity.None;
			//Flow Control
			PDAPort.FlowControl flowControl;

			if(this.m_flowControl.Equals("None"))
				flowControl=PDAPort.FlowControl.None;
			else if(this.m_flowControl.Equals("XOnXOff"))
				flowControl=PDAPort.FlowControl.XOnXOff;
			else if(this.m_flowControl.Equals("Hardware"))
				flowControl=PDAPort.FlowControl.Hardware;
			else 
				flowControl=PDAPort.FlowControl.None;
			m_pdaPort.PortChange(this.m_portName,UInt32.Parse(m_baudRate),byte.Parse(m_dataBit),stopBits,parity,flowControl );
		}

		private void mnuFileSave_Click(object sender, System.EventArgs e)
		{
		
		}

		private void mnuSave_Click(object sender, System.EventArgs e)
		{
						
		}

		private void mnuCaptureStart_Click(object sender, System.EventArgs e)
		{
			this.saveFileDialog1.ShowDialog();
			this.m_captureFile=saveFileDialog1.FileName;
			swCapture = new StreamWriter(this.m_captureFile);
			this.mnuCaptureStart.Enabled=false;
			this.mnuCaptureStop.Enabled=true;
		}

		private void mnuCaptureStop_Click(object sender, System.EventArgs e)
		{
			swCapture.Close();
			this.mnuCaptureStart.Enabled=true;
			this.mnuCaptureStop.Enabled=false;
		}

		private void mnuMdmDown_Click(object sender, System.EventArgs e)
		{
		
		}

		private void mnuRingMon_Click(object sender, System.EventArgs e)
		{
			if(this.m_Connected)
			{
				ringMon=new fmRingMon();
				ringMon.Show();
				ringMon.SetParent(this);
				state=STATUS.RING;
				//Timer 를 먼저 죽인다.
				timer1.Enabled=false;
				RingMode();  //19200, Odd 로 바꿈
				timer1.Enabled=true;
			}
		}

		private void mnuSimul_Click(object sender, System.EventArgs e)
		{
			if(this.m_Connected)
			{
				simul=new fmSimul();
				simul.Show();
				simul.SetParent(this);
				state=STATUS.SIMUL;
				//Timer 를 먼저 죽인다.
				timer1.Enabled=false;
				RingMode();  //19200, Odd 로 바꿈
				timer1.Enabled=true;
			}
		}
	}
}
