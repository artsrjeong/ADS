using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Text;
using System.IO;
using System.Threading;

namespace PCTool
{
	/// <summary>
	/// Form1에 대한 요약 설명입니다.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem menuItem2;
		private System.Windows.Forms.MenuItem mnuSend;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		private System.Windows.Forms.MenuItem mnuOpen;
		/// <summary>
		/// 필수 디자이너 변수입니다.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			strArr=new string[MAX_LINE];
			//
			// TODO: InitializeComponent를 호출한 다음 생성자 코드를 추가합니다.
			//
		}

		/// <summary>
		/// 사용 중인 모든 리소스를 정리합니다.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form 디자이너에서 생성한 코드
		/// <summary>
		/// 디자이너 지원에 필요한 메서드입니다.
		/// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
		/// </summary>
		private void InitializeComponent()
		{
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.mnuSend = new System.Windows.Forms.MenuItem();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.mnuOpen = new System.Windows.Forms.MenuItem();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem2,
																					  this.mnuSend,
																					  this.mnuOpen});
			this.menuItem1.Text = "File";
			// 
			// menuItem2
			// 
			this.menuItem2.Index = 0;
			this.menuItem2.Text = "Exit";
			// 
			// mnuSend
			// 
			this.mnuSend.Index = 1;
			this.mnuSend.Text = "Send Motorola";
			this.mnuSend.Click += new System.EventHandler(this.mnuSend_Click);
			// 
			// mnuOpen
			// 
			this.mnuOpen.Index = 2;
			this.mnuOpen.Text = "File oPen";
			this.mnuOpen.Click += new System.EventHandler(this.mnuOpen_Click);
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(6, 14);
			this.ClientSize = new System.Drawing.Size(240, 293);
			this.Menu = this.mainMenu1;
			this.Name = "Form1";
			this.Text = "Form1";
			this.Load += new System.EventHandler(this.Form1_Load);
			this.Paint += new System.Windows.Forms.PaintEventHandler(this.OnPaint);

		}
		#endregion

		/// <summary>
		/// 해당 응용 프로그램의 주 진입점입니다.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}
		
		private CommPort m_Port=null;
		public string[] strArr;
		public const int MAX_LINE=256;
		public const int DISP_LINE=15;
		public void AddString(string str)
		{
			endLine++;
			strArr[endLine]=str;
			if(lineNum<DISP_LINE+10)
				lineNum++;	
			this.Refresh();
		}
		public byte endLine=0;
		public int lineNum=0;


		public void downLoad()
		{
			try 
			{
				// Create an instance of StreamReader to read from a file.
				// The using statement also closes the StreamReader.
				//SendCRLF();
				using (StreamReader sr = new StreamReader(m_fileName)) 
				{
					String line;
					// Read and display lines from the file until the end of 
					// the file is reached.
					int i=0;
					
					while ((line = sr.ReadLine()) != null) 
					{
						SendLine(line);
						SendCRLF();
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

		public void SendLine(string str)
		{

			byte[] byteDateLine = System.Text.Encoding.ASCII.GetBytes( str.ToCharArray() );

			//byte[] TxBuf = new Byte[0x400];
			int Count = m_Port.Write(byteDateLine, byteDateLine.Length);


		}

		public void SendCRLF()
		{


			byte[] data=new byte[30];
			data[0]=(byte)'\r';
			data[1]=(byte)'\n';
			string str="";
			str+=(char)data[0];
			str+=(char)data[1];
			byte[] byteDateLine = System.Text.Encoding.ASCII.GetBytes( str.ToCharArray() );

			//byte[] TxBuf = new Byte[0x400];
			int Count = m_Port.Write(byteDateLine, byteDateLine.Length);

		}


		private void Form1_Load(object sender, System.EventArgs e)
		{
			m_Port = new CommPort();
			m_Port.Port = "COM1";
			if(m_Port.Port!="COM1")
			{
				MessageBox.Show("Port Open Error");
				return;
			}

			m_Port.WatchPtr += new WatchHandler(this.WatchHandler);
			m_Port.SetTimeouts(-1, 0, 0, 100, 1000);			
			m_Port.SetCommBuffer(4096,4096);
			m_Port.SetPortSettings(115200, 8, CommPort.StopBits.One, CommPort.Parity.None, CommPort.FlowControl.XOnXOff);
			m_Port.StartWatchThread();
			AddString("Port Opened");

		}

		public string strLine="";
		public bool bNewLine=false;
		private void WatchHandler(int iLen)
		{
			byte[] RxBuf = new Byte[iLen];
			byte bMsgKind,sum;
			ushort wReceiveData;

			int Count = m_Port.Read( RxBuf, iLen);
			for(int i=0;i<iLen;i++)
			{
				int k=RxBuf[i];
				if(k!=13 && k!=10)
				{
					strLine+=(char)RxBuf[i];
					bNewLine=false;
					AddString(strLine);
				}
				else
				{
					if(bNewLine.Equals(false))
					{
						bNewLine=true;
						if(strLine.IndexOf("Motorola")>0 && strLine.Length<50)
						{
							Thread.Sleep(50);
							AddString("Download Start");
							downLoad();
						}

						AddString(strLine);
						strLine="";
					}
				}

			}
			
		}

		private void mnuSend_Click(object sender, System.EventArgs e)
		{
			string str="2000 Motorola";
			byte[] byteDateLine = System.Text.Encoding.ASCII.GetBytes( str.ToCharArray() );

			//byte[] TxBuf = new Byte[0x400];
			int Count = m_Port.Write(byteDateLine, byteDateLine.Length);
		}

		private void OnPaint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
			Graphics g=e.Graphics;
			Brush br=new SolidBrush(Color.CadetBlue);
			Font DispFont=new Font("Arial",10,FontStyle.Bold);

			byte line;
			if(lineNum<=DISP_LINE)
			{
				for(int i=1;i<=endLine;i++)
				{
					g.DrawString(strArr[i],DispFont,br,10,20+(i-1)*15);
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
		}
		string m_fileName;
		private void mnuOpen_Click(object sender, System.EventArgs e)
		{
			this.openFileDialog1.ShowDialog();
			m_fileName=openFileDialog1.FileName;
		}
	}
}
