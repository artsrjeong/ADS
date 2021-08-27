using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
namespace ADS
{
	/// <summary>
	/// fmMonitor에 대한 요약 설명입니다.
	/// </summary>
	public class fmMonitor : System.Windows.Forms.Form
	{
		public System.Windows.Forms.StatusBar statusBar1;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem mnuExit;
		private System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.Label label1;
		public System.Windows.Forms.TextBox txtVer;
		public System.Windows.Forms.TextBox txtOutFreq;
		private System.Windows.Forms.Label label2;
		public System.Windows.Forms.TextBox txtFreqCmd;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		public System.Windows.Forms.TextBox txtOutAmps;
		private System.Windows.Forms.Label label5;
		public System.Windows.Forms.TextBox txtOutVolt;
		private System.Windows.Forms.Label label6;
		public System.Windows.Forms.TextBox txtDcV;
		private System.Windows.Forms.Label label7;
		public System.Windows.Forms.TextBox txtTripInfo;
		public System.Windows.Forms.TextBox txtData;
		private System.Windows.Forms.Label label8;
		public System.Windows.Forms.TextBox txtInPort;
		private System.Windows.Forms.Label label9;
		public  System.Windows.Forms.ImageList imageList1;
		private System.Windows.Forms.Label label10;
		private System.Windows.Forms.Label label11;
		private System.Windows.Forms.Label label12;
		private System.Windows.Forms.Label label13;
		public  System.Windows.Forms.PictureBox picClose;
		public  System.Windows.Forms.PictureBox picOpen;
		public  System.Windows.Forms.PictureBox picNudge;
		public  System.Windows.Forms.PictureBox picHcl;
		private System.Windows.Forms.Label label14;
		public  System.Windows.Forms.PictureBox picCom;
		private System.Windows.Forms.Label label15;
		public  System.Windows.Forms.ComboBox cbGroup;
		private System.Windows.Forms.TabPage tabPage2;
		public DataTable dt=new DataTable("AddrData");
		
		public const int MAX_ITEM=39;
		public int m_curRow=0;
		Form1 fmParent;
		string[] FName=new string[MAX_ITEM];
		public double[] Dec10=new double[4];
		public int[] DotPos=new int[MAX_ITEM];
		string[] FUnit=new string[MAX_ITEM];
		private System.Windows.Forms.DataGrid gridData;
		private System.Windows.Forms.Panel pnDataIn;
		private System.Windows.Forms.TextBox txtDataIn;
		private System.Windows.Forms.Button btnDataIn;
		private System.Windows.Forms.Label label16;
		string[] FAddr=new string[MAX_ITEM];
		
		public int m_iSetDataIdx=0;
		private System.Windows.Forms.TabPage tabPage3;
		private System.Windows.Forms.ComboBox cbControlGroup;
		private System.Windows.Forms.TextBox txtControlData;
		private System.Windows.Forms.Button btnSet;
		private System.Windows.Forms.Button btnStop;
		private System.Windows.Forms.Button btnDoCtrl;
		private System.Windows.Forms.Button btnDo2;
		private System.Windows.Forms.Button btnDo3;
		private System.Windows.Forms.Button btnDo5;
		private System.Windows.Forms.Button btnDo4;
		private System.Windows.Forms.Button btnDo13;
		private System.Windows.Forms.Button btnDo12;
		private System.Windows.Forms.Button btnDo15;
		private System.Windows.Forms.Button btnWdog;
		private System.Windows.Forms.Button btnClear;
		public string[] m_sSetData=new string[30];
		public uint m_wSetDataAddr;
		public uint m_iSetData;
		public uint m_wIndex=1;
		public fmMonitor(Form1 fm)
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			fmParent=fm;
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(fmMonitor));
			this.statusBar1 = new System.Windows.Forms.StatusBar();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuExit = new System.Windows.Forms.MenuItem();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.cbGroup = new System.Windows.Forms.ComboBox();
			this.label10 = new System.Windows.Forms.Label();
			this.picClose = new System.Windows.Forms.PictureBox();
			this.txtVer = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.txtOutFreq = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.txtFreqCmd = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.txtOutAmps = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this.txtOutVolt = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.txtDcV = new System.Windows.Forms.TextBox();
			this.label7 = new System.Windows.Forms.Label();
			this.txtTripInfo = new System.Windows.Forms.TextBox();
			this.txtData = new System.Windows.Forms.TextBox();
			this.label8 = new System.Windows.Forms.Label();
			this.txtInPort = new System.Windows.Forms.TextBox();
			this.label9 = new System.Windows.Forms.Label();
			this.picOpen = new System.Windows.Forms.PictureBox();
			this.label11 = new System.Windows.Forms.Label();
			this.label12 = new System.Windows.Forms.Label();
			this.picNudge = new System.Windows.Forms.PictureBox();
			this.label13 = new System.Windows.Forms.Label();
			this.picHcl = new System.Windows.Forms.PictureBox();
			this.picCom = new System.Windows.Forms.PictureBox();
			this.label14 = new System.Windows.Forms.Label();
			this.label15 = new System.Windows.Forms.Label();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.pnDataIn = new System.Windows.Forms.Panel();
			this.label16 = new System.Windows.Forms.Label();
			this.btnDataIn = new System.Windows.Forms.Button();
			this.txtDataIn = new System.Windows.Forms.TextBox();
			this.gridData = new System.Windows.Forms.DataGrid();
			this.tabPage3 = new System.Windows.Forms.TabPage();
			this.btnDo2 = new System.Windows.Forms.Button();
			this.btnDoCtrl = new System.Windows.Forms.Button();
			this.btnStop = new System.Windows.Forms.Button();
			this.btnSet = new System.Windows.Forms.Button();
			this.txtControlData = new System.Windows.Forms.TextBox();
			this.cbControlGroup = new System.Windows.Forms.ComboBox();
			this.btnDo3 = new System.Windows.Forms.Button();
			this.btnDo5 = new System.Windows.Forms.Button();
			this.btnDo4 = new System.Windows.Forms.Button();
			this.btnDo13 = new System.Windows.Forms.Button();
			this.btnDo12 = new System.Windows.Forms.Button();
			this.btnDo15 = new System.Windows.Forms.Button();
			this.btnWdog = new System.Windows.Forms.Button();
			this.btnClear = new System.Windows.Forms.Button();
			this.imageList1 = new System.Windows.Forms.ImageList();
			// 
			// statusBar1
			// 
			this.statusBar1.Location = new System.Drawing.Point(0, 434);
			this.statusBar1.Size = new System.Drawing.Size(258, 22);
			this.statusBar1.Text = "통신 체크중";
			this.statusBar1.ParentChanged += new System.EventHandler(this.statusBar1_ParentChanged);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.menuItem1);
			// 
			// menuItem1
			// 
			this.menuItem1.MenuItems.Add(this.mnuExit);
			this.menuItem1.Text = "파일";
			// 
			// mnuExit
			// 
			this.mnuExit.Text = "모티터링 종료";
			this.mnuExit.Click += new System.EventHandler(this.mnuExit_Click);
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabPage1);
			this.tabControl1.Controls.Add(this.tabPage2);
			this.tabControl1.Controls.Add(this.tabPage3);
			this.tabControl1.Location = new System.Drawing.Point(0, 24);
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(256, 272);
			this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.cbGroup);
			this.tabPage1.Controls.Add(this.label10);
			this.tabPage1.Controls.Add(this.picClose);
			this.tabPage1.Controls.Add(this.txtVer);
			this.tabPage1.Controls.Add(this.label1);
			this.tabPage1.Controls.Add(this.txtOutFreq);
			this.tabPage1.Controls.Add(this.label2);
			this.tabPage1.Controls.Add(this.txtFreqCmd);
			this.tabPage1.Controls.Add(this.label3);
			this.tabPage1.Controls.Add(this.label4);
			this.tabPage1.Controls.Add(this.txtOutAmps);
			this.tabPage1.Controls.Add(this.label5);
			this.tabPage1.Controls.Add(this.txtOutVolt);
			this.tabPage1.Controls.Add(this.label6);
			this.tabPage1.Controls.Add(this.txtDcV);
			this.tabPage1.Controls.Add(this.label7);
			this.tabPage1.Controls.Add(this.txtTripInfo);
			this.tabPage1.Controls.Add(this.txtData);
			this.tabPage1.Controls.Add(this.label8);
			this.tabPage1.Controls.Add(this.txtInPort);
			this.tabPage1.Controls.Add(this.label9);
			this.tabPage1.Controls.Add(this.picOpen);
			this.tabPage1.Controls.Add(this.label11);
			this.tabPage1.Controls.Add(this.label12);
			this.tabPage1.Controls.Add(this.picNudge);
			this.tabPage1.Controls.Add(this.label13);
			this.tabPage1.Controls.Add(this.picHcl);
			this.tabPage1.Controls.Add(this.picCom);
			this.tabPage1.Controls.Add(this.label14);
			this.tabPage1.Controls.Add(this.label15);
			this.tabPage1.Location = new System.Drawing.Point(4, 21);
			this.tabPage1.Size = new System.Drawing.Size(248, 247);
			this.tabPage1.Text = "일반정보";
			this.tabPage1.EnabledChanged += new System.EventHandler(this.tabPage1_EnabledChanged);
			// 
			// cbGroup
			// 
			this.cbGroup.Items.Add("D");
			this.cbGroup.Items.Add("F");
			this.cbGroup.Items.Add("A");
			this.cbGroup.Items.Add("M");
			this.cbGroup.Location = new System.Drawing.Point(80, 3);
			this.cbGroup.Size = new System.Drawing.Size(80, 20);
			// 
			// label10
			// 
			this.label10.Location = new System.Drawing.Point(192, 8);
			this.label10.Size = new System.Drawing.Size(96, 16);
			this.label10.Text = "Close";
			// 
			// picClose
			// 
			this.picClose.Image = ((System.Drawing.Image)(resources.GetObject("picClose.Image")));
			this.picClose.Location = new System.Drawing.Point(200, 29);
			this.picClose.Size = new System.Drawing.Size(16, 16);
			// 
			// txtVer
			// 
			this.txtVer.Location = new System.Drawing.Point(80, 24);
			this.txtVer.Size = new System.Drawing.Size(80, 21);
			this.txtVer.Text = "";
			this.txtVer.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(0, 27);
			this.label1.Size = new System.Drawing.Size(64, 20);
			this.label1.Text = "S/W Ver.";
			this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtOutFreq
			// 
			this.txtOutFreq.Location = new System.Drawing.Point(80, 48);
			this.txtOutFreq.Size = new System.Drawing.Size(80, 21);
			this.txtOutFreq.Text = "";
			this.txtOutFreq.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(0, 51);
			this.label2.Size = new System.Drawing.Size(64, 21);
			this.label2.Text = "Out Freq";
			this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtFreqCmd
			// 
			this.txtFreqCmd.Location = new System.Drawing.Point(80, 72);
			this.txtFreqCmd.Size = new System.Drawing.Size(80, 21);
			this.txtFreqCmd.Text = "";
			this.txtFreqCmd.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(0, 76);
			this.label3.Size = new System.Drawing.Size(64, 20);
			this.label3.Text = "Freq Cmd";
			this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(0, 100);
			this.label4.Size = new System.Drawing.Size(64, 20);
			this.label4.Text = "Out Amps";
			this.label4.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtOutAmps
			// 
			this.txtOutAmps.Location = new System.Drawing.Point(80, 96);
			this.txtOutAmps.Size = new System.Drawing.Size(80, 21);
			this.txtOutAmps.Text = "";
			this.txtOutAmps.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(0, 124);
			this.label5.Size = new System.Drawing.Size(64, 20);
			this.label5.Text = "Out Volt";
			this.label5.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtOutVolt
			// 
			this.txtOutVolt.Location = new System.Drawing.Point(80, 120);
			this.txtOutVolt.Size = new System.Drawing.Size(80, 21);
			this.txtOutVolt.Text = "";
			this.txtOutVolt.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(0, 148);
			this.label6.Size = new System.Drawing.Size(64, 20);
			this.label6.Text = "DC Bus V";
			this.label6.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtDcV
			// 
			this.txtDcV.Location = new System.Drawing.Point(80, 144);
			this.txtDcV.Size = new System.Drawing.Size(80, 21);
			this.txtDcV.Text = "";
			this.txtDcV.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(0, 172);
			this.label7.Size = new System.Drawing.Size(64, 20);
			this.label7.Text = "Trip Info";
			this.label7.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtTripInfo
			// 
			this.txtTripInfo.Location = new System.Drawing.Point(80, 168);
			this.txtTripInfo.Size = new System.Drawing.Size(80, 21);
			this.txtTripInfo.Text = "";
			this.txtTripInfo.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// txtData
			// 
			this.txtData.Location = new System.Drawing.Point(80, 216);
			this.txtData.Size = new System.Drawing.Size(80, 21);
			this.txtData.Text = "";
			this.txtData.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label8
			// 
			this.label8.Location = new System.Drawing.Point(0, 220);
			this.label8.Size = new System.Drawing.Size(64, 20);
			this.label8.Text = "Data";
			this.label8.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// txtInPort
			// 
			this.txtInPort.Location = new System.Drawing.Point(80, 192);
			this.txtInPort.Size = new System.Drawing.Size(80, 21);
			this.txtInPort.Text = "";
			this.txtInPort.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label9
			// 
			this.label9.Location = new System.Drawing.Point(0, 196);
			this.label9.Size = new System.Drawing.Size(64, 20);
			this.label9.Text = "InPort";
			this.label9.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// picOpen
			// 
			this.picOpen.Image = ((System.Drawing.Image)(resources.GetObject("picOpen.Image")));
			this.picOpen.Location = new System.Drawing.Point(200, 67);
			this.picOpen.Size = new System.Drawing.Size(16, 14);
			// 
			// label11
			// 
			this.label11.Location = new System.Drawing.Point(192, 49);
			this.label11.Size = new System.Drawing.Size(100, 15);
			this.label11.Text = "Open";
			// 
			// label12
			// 
			this.label12.Location = new System.Drawing.Point(192, 90);
			this.label12.Size = new System.Drawing.Size(100, 12);
			this.label12.Text = "Nudge";
			// 
			// picNudge
			// 
			this.picNudge.Image = ((System.Drawing.Image)(resources.GetObject("picNudge.Image")));
			this.picNudge.Location = new System.Drawing.Point(200, 112);
			this.picNudge.Size = new System.Drawing.Size(16, 16);
			// 
			// label13
			// 
			this.label13.Location = new System.Drawing.Point(192, 142);
			this.label13.Size = new System.Drawing.Size(100, 18);
			this.label13.Text = "HCL";
			// 
			// picHcl
			// 
			this.picHcl.Image = ((System.Drawing.Image)(resources.GetObject("picHcl.Image")));
			this.picHcl.Location = new System.Drawing.Point(200, 165);
			this.picHcl.Size = new System.Drawing.Size(16, 16);
			// 
			// picCom
			// 
			this.picCom.Image = ((System.Drawing.Image)(resources.GetObject("picCom.Image")));
			this.picCom.Location = new System.Drawing.Point(200, 208);
			this.picCom.Size = new System.Drawing.Size(16, 16);
			// 
			// label14
			// 
			this.label14.Location = new System.Drawing.Point(192, 192);
			this.label14.Size = new System.Drawing.Size(100, 16);
			this.label14.Text = "통신";
			// 
			// label15
			// 
			this.label15.Location = new System.Drawing.Point(0, 8);
			this.label15.Size = new System.Drawing.Size(64, 20);
			this.label15.Text = "Group";
			this.label15.TextAlign = System.Drawing.ContentAlignment.TopRight;
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.pnDataIn);
			this.tabPage2.Controls.Add(this.gridData);
			this.tabPage2.Location = new System.Drawing.Point(4, 21);
			this.tabPage2.Size = new System.Drawing.Size(248, 247);
			this.tabPage2.Text = "쓰기";
			this.tabPage2.EnabledChanged += new System.EventHandler(this.tabPage2_EnabledChanged);
			// 
			// pnDataIn
			// 
			this.pnDataIn.BackColor = System.Drawing.SystemColors.MenuText;
			this.pnDataIn.Controls.Add(this.label16);
			this.pnDataIn.Controls.Add(this.btnDataIn);
			this.pnDataIn.Controls.Add(this.txtDataIn);
			this.pnDataIn.Location = new System.Drawing.Point(32, 64);
			this.pnDataIn.Size = new System.Drawing.Size(176, 64);
			this.pnDataIn.Visible = false;
			// 
			// label16
			// 
			this.label16.ForeColor = System.Drawing.SystemColors.ControlLightLight;
			this.label16.Location = new System.Drawing.Point(8, 8);
			this.label16.Text = "Input Data";
			// 
			// btnDataIn
			// 
			this.btnDataIn.Location = new System.Drawing.Point(104, 32);
			this.btnDataIn.Size = new System.Drawing.Size(64, 20);
			this.btnDataIn.Text = "OK";
			this.btnDataIn.Click += new System.EventHandler(this.btnDataIn_Click);
			// 
			// txtDataIn
			// 
			this.txtDataIn.Location = new System.Drawing.Point(8, 32);
			this.txtDataIn.Size = new System.Drawing.Size(80, 21);
			this.txtDataIn.Text = "";
			// 
			// gridData
			// 
			this.gridData.Location = new System.Drawing.Point(8, 8);
			this.gridData.Size = new System.Drawing.Size(232, 176);
			this.gridData.Text = "dataGrid1";
			this.gridData.Click += new System.EventHandler(this.gridData_Click);
			this.gridData.MouseDown += new System.Windows.Forms.MouseEventHandler(this.gridData_MouseDown);
			// 
			// tabPage3
			// 
			this.tabPage3.Controls.Add(this.btnDo2);
			this.tabPage3.Controls.Add(this.btnDoCtrl);
			this.tabPage3.Controls.Add(this.btnStop);
			this.tabPage3.Controls.Add(this.btnSet);
			this.tabPage3.Controls.Add(this.txtControlData);
			this.tabPage3.Controls.Add(this.cbControlGroup);
			this.tabPage3.Controls.Add(this.btnDo3);
			this.tabPage3.Controls.Add(this.btnDo5);
			this.tabPage3.Controls.Add(this.btnDo4);
			this.tabPage3.Controls.Add(this.btnDo13);
			this.tabPage3.Controls.Add(this.btnDo12);
			this.tabPage3.Controls.Add(this.btnDo15);
			this.tabPage3.Controls.Add(this.btnWdog);
			this.tabPage3.Controls.Add(this.btnClear);
			this.tabPage3.Location = new System.Drawing.Point(4, 21);
			this.tabPage3.Size = new System.Drawing.Size(248, 247);
			this.tabPage3.Text = "콘트롤";
			this.tabPage3.EnabledChanged += new System.EventHandler(this.tabPage3_EnabledChanged);
			// 
			// btnDo2
			// 
			this.btnDo2.Location = new System.Drawing.Point(168, 56);
			this.btnDo2.Size = new System.Drawing.Size(72, 24);
			this.btnDo2.Text = "DO2";
			this.btnDo2.Click += new System.EventHandler(this.btnDo2_Click);
			// 
			// btnDoCtrl
			// 
			this.btnDoCtrl.Location = new System.Drawing.Point(88, 56);
			this.btnDoCtrl.Size = new System.Drawing.Size(72, 24);
			this.btnDoCtrl.Text = "DO Ctrl";
			this.btnDoCtrl.Click += new System.EventHandler(this.btnDoCtrl_Click);
			// 
			// btnStop
			// 
			this.btnStop.Location = new System.Drawing.Point(8, 56);
			this.btnStop.Size = new System.Drawing.Size(72, 24);
			this.btnStop.Text = "Stop";
			this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
			// 
			// btnSet
			// 
			this.btnSet.Location = new System.Drawing.Point(168, 24);
			this.btnSet.Size = new System.Drawing.Size(72, 24);
			this.btnSet.Text = "SET";
			this.btnSet.Click += new System.EventHandler(this.btnSet_Click);
			// 
			// txtControlData
			// 
			this.txtControlData.Location = new System.Drawing.Point(96, 24);
			this.txtControlData.Size = new System.Drawing.Size(64, 21);
			this.txtControlData.Text = "";
			// 
			// cbControlGroup
			// 
			this.cbControlGroup.Items.Add("D");
			this.cbControlGroup.Items.Add("F");
			this.cbControlGroup.Items.Add("A");
			this.cbControlGroup.Items.Add("M");
			this.cbControlGroup.Location = new System.Drawing.Point(8, 24);
			this.cbControlGroup.Size = new System.Drawing.Size(80, 20);
			// 
			// btnDo3
			// 
			this.btnDo3.Location = new System.Drawing.Point(8, 88);
			this.btnDo3.Size = new System.Drawing.Size(72, 24);
			this.btnDo3.Text = "DO3";
			this.btnDo3.Click += new System.EventHandler(this.btnDo3_Click);
			// 
			// btnDo5
			// 
			this.btnDo5.Location = new System.Drawing.Point(168, 88);
			this.btnDo5.Size = new System.Drawing.Size(72, 24);
			this.btnDo5.Text = "DO5";
			this.btnDo5.Click += new System.EventHandler(this.btnDo5_Click);
			// 
			// btnDo4
			// 
			this.btnDo4.Location = new System.Drawing.Point(88, 88);
			this.btnDo4.Size = new System.Drawing.Size(72, 24);
			this.btnDo4.Text = "DO4";
			this.btnDo4.Click += new System.EventHandler(this.btnDo4_Click);
			// 
			// btnDo13
			// 
			this.btnDo13.Location = new System.Drawing.Point(88, 120);
			this.btnDo13.Size = new System.Drawing.Size(72, 24);
			this.btnDo13.Text = "DO13";
			this.btnDo13.Click += new System.EventHandler(this.btnDo13_Click);
			// 
			// btnDo12
			// 
			this.btnDo12.Location = new System.Drawing.Point(8, 120);
			this.btnDo12.Size = new System.Drawing.Size(72, 24);
			this.btnDo12.Text = "DO12";
			this.btnDo12.Click += new System.EventHandler(this.btnDo12_Click);
			// 
			// btnDo15
			// 
			this.btnDo15.Location = new System.Drawing.Point(168, 120);
			this.btnDo15.Size = new System.Drawing.Size(72, 24);
			this.btnDo15.Text = "DO15";
			this.btnDo15.Click += new System.EventHandler(this.btnDo15_Click);
			// 
			// btnWdog
			// 
			this.btnWdog.Location = new System.Drawing.Point(8, 152);
			this.btnWdog.Size = new System.Drawing.Size(72, 24);
			this.btnWdog.Text = "WDOG";
			this.btnWdog.Click += new System.EventHandler(this.btnWdog_Click);
			// 
			// btnClear
			// 
			this.btnClear.Location = new System.Drawing.Point(88, 152);
			this.btnClear.Size = new System.Drawing.Size(72, 24);
			this.btnClear.Text = "CLEAR";
			this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
			// 
			// imageList1
			// 
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource"))));
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource1"))));
			this.imageList1.ImageSize = new System.Drawing.Size(16, 16);
			// 
			// fmMonitor
			// 
			this.ClientSize = new System.Drawing.Size(258, 456);
			this.Controls.Add(this.tabControl1);
			this.Controls.Add(this.statusBar1);
			this.Menu = this.mainMenu1;
			this.Text = "fmMonitor";
			this.Load += new System.EventHandler(this.fmMonitor_Load);

		}
		#endregion

		private void fmMonitor_Load(object sender, System.EventArgs e)
		{
			this.picClose.Image=imageList1.Images[1];
			this.picOpen.Image=imageList1.Images[1];
			this.picNudge.Image=imageList1.Images[1];
			this.picHcl.Image=imageList1.Images[1];
			this.cbGroup.SelectedIndex=1;
			this.cbControlGroup.SelectedIndex=1;
			
			dt.Columns.Add(new DataColumn("Name",System.Type.GetType("System.String"))); 
			dt.Columns.Add(new DataColumn("Addr",System.Type.GetType("System.String")));
			dt.Columns.Add(new DataColumn("Data",System.Type.GetType("System.String")));
			dt.Columns.Add(new DataColumn("Unit",System.Type.GetType("System.String")));
			
			Dec10[0] = 1;
			Dec10[1] = 10;
			Dec10[2] = 100;
			Dec10[3] = 1000;


			FName[0] = "wPCBTest";				DotPos[0] = 0;	FUnit[0] = "";	
			FName[1] = "wDOImage";				DotPos[1] = 0;	FUnit[1] = "";	
			FName[2] = "Acc Time";				DotPos[2] = 1;	FUnit[2] = "sec";	
			FName[3] = "Dec Time";				DotPos[3] = 1;	FUnit[3] = "sec";
			FName[4] = "Dir Cmd";				DotPos[4] = 0;	FUnit[4] = "";
			FName[5] = "Freq. CmdSrc";			DotPos[5] = 0;	FUnit[5] = "";
			FName[6] = "Run CmdSrc";			DotPos[6] = 0;	FUnit[6] = "";
			FName[7] = "Stop Mode";				DotPos[7] = 0;	FUnit[7] = "";

			FName[8] = "Ctrl Mode";				DotPos[8] = 0;	FUnit[8] = "";
			FName[9] = "Start Freq.";			DotPos[9] = 1;	FUnit[9] = "Hz";
			FName[10] = "Max Freq.";			DotPos[10] = 1;	FUnit[10] = "Hz";
			FName[11] = "Base Freq.";			DotPos[11] = 1;	FUnit[11] = "Hz";
			FName[12] = "Base Volt";			DotPos[12] = 0;	FUnit[12] = "V";
			FName[13] = "V Out Gain";			DotPos[13] = 1;	FUnit[13] = "%";
			FName[14] = "Trq Boost Qty.";		DotPos[14] = 1;	FUnit[14] = "%";
			FName[15] = "Trq Boost Freq.";		DotPos[15] = 1;	FUnit[15] = "%";
			FName[16] = "ETH Level";			DotPos[16] = 1;	FUnit[16] = "%";
			FName[17] = "Over Load Level";		DotPos[17] = 1;	FUnit[17] = "%";
			FName[18] = "PWM Freq.";			DotPos[18] = 1;	FUnit[18] = "kHz";
			FName[19] = "Motor Rated Amps";		DotPos[19] = 2; FUnit[19] = "A";
			FName[20] = "Motor Pole";			DotPos[20] = 0;	FUnit[20] = "Pole";
			FName[21] = "Motor Rated Slip";		DotPos[21] = 1;	FUnit[21] = "Hz";
			FName[22] = "Motor Flux Current";	DotPos[22] = 2;	FUnit[22] = "A";
			FName[23] = "Motor R1";				DotPos[23] = 1;	FUnit[23] = "%";
			FName[24] = "Motor R2";				DotPos[24] = 1;	FUnit[24] = "%";
			FName[25] = "Motor L";				DotPos[25] = 2;	FUnit[25] = "%";
			FName[26] = "Motor Lsigma";			DotPos[26] = 1;	FUnit[26] = "%";

			FName[27] = "Di1 Def.";				DotPos[27] = 0;	FUnit[27] = "";
			FName[28] = "Di2 Def.";				DotPos[28] = 0;	FUnit[28] = "";
			FName[29] = "Di3 Def.";				DotPos[29] = 0;	FUnit[29] = "";
			FName[30] = "Di1 Type";				DotPos[30] = 0;	FUnit[30] = "";
			FName[31] = "Di2 Type";				DotPos[31] = 0;	FUnit[31] = "";
			FName[32] = "Di3 Type";				DotPos[32] = 0;	FUnit[32] = "";
			FName[33] = "Do1 Def.";				DotPos[33] = 0;	FUnit[33] = "";
			FName[34] = "Do1 Type";				DotPos[34] = 0;	FUnit[34] = "";


			FName[35] = "Ain Offset";			DotPos[35] = 1;	FUnit[35] = "%";
			FName[36] = "Ain Gain";				DotPos[36] = 1;	FUnit[36] = "%";
			FName[37] = "Ain LPF";				DotPos[37] = 1;	FUnit[37] = "";
			FName[38] = "Drive Type";			DotPos[38] = 0;	FUnit[38] = "";

			FAddr[0] = "0x1103";
			FAddr[1] = "0x111b";	
			FAddr[2] = "0x1302";	
			FAddr[3] = "0x1303";
			FAddr[4] = "0x1304";
			FAddr[5] = "0x1305";
			FAddr[6] = "0x1306";
			FAddr[7] = "0x1307";
			FAddr[8] = "0x1308";
			FAddr[9] = "0x130b";
			FAddr[10] = "0x130c";
			FAddr[11] = "0x130d";
			FAddr[12] = "0x130e";
			FAddr[13] = "0x130f";	//F15
			FAddr[14] = "0x1313";
			FAddr[15] = "0x1314";
			FAddr[16] = "0x131d";
			FAddr[17] = "0x131f";
			FAddr[18] = "0x1323";
			FAddr[19] = "0x1324";
			FAddr[20] = "0x1325";
			FAddr[21] = "0x1326";
			FAddr[22] = "0x1328";
			FAddr[23] = "0x1329";
			FAddr[24] = "0x132a";
			FAddr[25] = "0x132b";
			FAddr[26] = "0x132c";
			FAddr[27] = "0x1401";
			FAddr[28] = "0x1402";
			FAddr[29] = "0x1403";
			FAddr[30] = "0x1404";
			FAddr[31] = "0x1405";
			FAddr[32] = "0x1406";
			FAddr[33] = "0x1407";
			FAddr[34] = "0x1408";
			FAddr[35] = "0x1409";
			FAddr[36] = "0x140a";
			FAddr[37] = "0x140b";
			FAddr[38] = "0x1101";
			for(int i=0;i<MAX_ITEM;i++)
			{
				dt.Rows.Add(new object[] {FName[i],FAddr[i],"",FUnit[i]});
			}
			gridData.DataSource=dt;
			
			DataGridTableStyle ts = new DataGridTableStyle();

			// Set the DataGridTableStyle.MappingName property
			// to the table in the data source to map to.
			ts.MappingName = gridData.DataSource.ToString();

			// Add it to the datagrid's TableStyles collection
			gridData.TableStyles.Add(ts);

			// Hide the first column (index 0)
			gridData.TableStyles[0].GridColumnStyles[0].Width = 90;
			gridData.TableStyles[0].GridColumnStyles[1].Width = 0;
			gridData.TableStyles[0].GridColumnStyles[2].Width = 50;
			gridData.TableStyles[0].GridColumnStyles[3].Width = 30;
			if(tabControl1.TabPages[tabControl1.SelectedIndex].Text.Equals("일반정보"))
				fmParent.m_iListCnt=1000;
			
			for(int i=0;i<fmParent.m_tableList.Count;i++)
			{
				this.tabControl1.TabPages.Add(new TabPage());
				DataTable dtParam=(DataTable)fmParent.m_tableList[i];
				this.tabControl1.TabPages[i+3].Width=100;
				this.tabControl1.TabPages[i+3].Text=(string)dtParam.Rows[0]["Group_des"];
			}
		}

		private void mnuExit_Click(object sender, System.EventArgs e)
		{
			fmParent.state=Form1.STATUS.NORMAL;
			this.Close();
		}

		private void tabPage1_EnabledChanged(object sender, System.EventArgs e)
		{
		
		}

		private void tabControl1_SelectedIndexChanged(object sender, System.EventArgs e)
		{
		
		}

		private void tabPage2_EnabledChanged(object sender, System.EventArgs e)
		{
		
		}

		private void gridData_MouseDown(object sender, System.Windows.Forms.MouseEventArgs e)
		{
			//pnDataIn.Visible=true;
		}

		private void gridData_Click(object sender, System.EventArgs e)
		{
			try
			{
				if(gridData.CurrentCell.ColumnNumber.Equals(2)) //데이타 부분을 선택했으면
				{
					pnDataIn.Visible=true;
					m_curRow=gridData.CurrentCell.RowNumber;
					this.txtDataIn.Text=(string)dt.Rows[m_curRow]["Data"];
					txtDataIn.Focus();
				}
			}
			finally
			{}
		}

		private void btnDataIn_Click(object sender, System.EventArgs e)
		{
			dt.Rows[m_curRow]["Data"]=this.txtDataIn.Text;
			m_sSetData[m_iSetDataIdx++]=this.txtDataIn.Text;
			pnDataIn.Visible=false;
		}

		private void btnSet_Click(object sender, System.EventArgs e)
		{
			uint Addr,wTmp;
			Addr = (uint)cbControlGroup.SelectedIndex;
			if(Addr==3) Addr = 1;
			else Addr+=2;
			Addr = 0x1000 + (Addr<<8);
			Addr += (uint)m_wIndex;

			m_wSetDataAddr = Addr;
			
			m_iSetData=uint.Parse(this.txtControlData.Text);
		}

		private void btnStop_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x1001;
			m_iSetData = 0x01;
		}

		private void btnDoCtrl_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x1103;
			m_iSetData = 2;
		}

		private void btnDo2_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 0x02;
		}

		private void btnDo3_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 0x03;		
		}

		private void btnDo4_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 0x04;				
		}

		private void btnDo5_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 0x05;
		}

		private void btnDo12_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 12;
		}

		private void btnDo13_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 13;
		}

		private void btnDo15_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 15;
		}

		private void btnWdog_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x1103;
			m_iSetData = 13;
		}

		private void btnClear_Click(object sender, System.EventArgs e)
		{
			m_wSetDataAddr = 0x111b;
			m_iSetData = 0x0;
		}

		private void tabPage3_EnabledChanged(object sender, System.EventArgs e)
		{
		
		}

		private void statusBar1_ParentChanged(object sender, System.EventArgs e)
		{
		
		}

	}
}
