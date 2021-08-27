using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Threading;

namespace ADS
{
	/// <summary>
	/// fmEsmiDownLoad에 대한 요약 설명입니다.
	/// </summary>
	public class fmEsmiDownLoad : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label lbFileName;
		private System.Windows.Forms.Button btnExit;
		public System.Windows.Forms.ProgressBar progressBar1;
		private System.Windows.Forms.Label label2;
		string m_fileName;
		public System.Windows.Forms.Button btnEsmiReset;
		public System.Windows.Forms.Label label1;
		public System.Windows.Forms.Label label5;
		public System.Windows.Forms.Button btnManualReset;
		public System.Windows.Forms.Label lbComment;
		Form1 fmParent;
		public fmEsmiDownLoad(string str)
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			m_fileName=str;
			//
			// TODO: InitializeComponent를 호출한 다음 생성자 코드를 추가합니다.
			//
		}

		public void SetParent(Form1 fm)
		{
			fmParent=fm;
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
			this.lbFileName = new System.Windows.Forms.Label();
			this.btnExit = new System.Windows.Forms.Button();
			this.progressBar1 = new System.Windows.Forms.ProgressBar();
			this.label2 = new System.Windows.Forms.Label();
			this.btnEsmiReset = new System.Windows.Forms.Button();
			this.btnManualReset = new System.Windows.Forms.Button();
			this.label1 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.lbComment = new System.Windows.Forms.Label();
			// 
			// lbFileName
			// 
			this.lbFileName.Location = new System.Drawing.Point(69, 9);
			this.lbFileName.Size = new System.Drawing.Size(136, 48);
			// 
			// btnExit
			// 
			this.btnExit.Location = new System.Drawing.Point(136, 248);
			this.btnExit.Text = "Exit";
			this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
			// 
			// progressBar1
			// 
			this.progressBar1.Location = new System.Drawing.Point(16, 224);
			this.progressBar1.Maximum = 3000;
			this.progressBar1.Size = new System.Drawing.Size(176, 20);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(21, 17);
			this.label2.Size = new System.Drawing.Size(40, 20);
			this.label2.Text = "화일";
			// 
			// btnEsmiReset
			// 
			this.btnEsmiReset.Location = new System.Drawing.Point(16, 72);
			this.btnEsmiReset.Size = new System.Drawing.Size(96, 24);
			this.btnEsmiReset.Text = "ESMI Reset";
			this.btnEsmiReset.Click += new System.EventHandler(this.btnEsmiReset_Click);
			// 
			// btnManualReset
			// 
			this.btnManualReset.Location = new System.Drawing.Point(16, 128);
			this.btnManualReset.Size = new System.Drawing.Size(96, 24);
			this.btnManualReset.Text = "수동 Reset";
			this.btnManualReset.Click += new System.EventHandler(this.btnManualReset_Click);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(120, 72);
			this.label1.Size = new System.Drawing.Size(88, 29);
			this.label1.Text = "ESMI 프로그램이 동작중일 때";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(120, 120);
			this.label5.Size = new System.Drawing.Size(88, 40);
			this.label5.Text = "전원스위치나 Svc 스위치로 리셋";
			// 
			// lbComment
			// 
			this.lbComment.Location = new System.Drawing.Point(16, 200);
			this.lbComment.Size = new System.Drawing.Size(184, 20);
			// 
			// fmEsmiDownLoad
			// 
			this.ClientSize = new System.Drawing.Size(226, 271);
			this.Controls.Add(this.lbComment);
			this.Controls.Add(this.btnEsmiReset);
			this.Controls.Add(this.lbFileName);
			this.Controls.Add(this.btnExit);
			this.Controls.Add(this.progressBar1);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.btnManualReset);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.label5);
			this.Text = "fmEsmiDownLoad";
			this.Load += new System.EventHandler(this.fmEsmiDownLoad_Load);

		}
		#endregion

		private void fmEsmiDownLoad_Load(object sender, System.EventArgs e)
		{
			this.lbFileName.Text=m_fileName;
		}

		private void btnExit_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}

		private void btnManualReset_Click(object sender, System.EventArgs e)
		{
			btnEsmiReset.Enabled=false;
			btnManualReset.Enabled=false;
			fmParent.MonMode();  //9600으로 바꿈
			lbComment.Text="전원을 껏다 켜 주세요";
		}
	
		private void btnEsmiReset_Click(object sender, System.EventArgs e)
		{
			btnEsmiReset.Enabled=false;
			btnManualReset.Enabled=false;

			//Timer 를 먼저 죽인다.
			fmParent.timer1.Enabled=false;
			fmParent.MonMode();  //9600으로 바꿈
			byte[] txData=new byte[1];
			txData[0]=27; //ESC 5번 누름
			long startTick=System.DateTime.Now.Ticks;
			long curTick;
			this.lbComment.Text="ESMI 재부팅중";
			for(int i=0;i<3;i++)
			{
				fmParent.SendBytes(txData);
				curTick=System.DateTime.Now.Ticks;
				while((curTick-startTick)/10000<1200) //1200 ms 기다림
				{
					curTick=System.DateTime.Now.Ticks;
					fmParent.ReadBuff();
					Application.DoEvents();
				}
				this.progressBar1.Value=this.progressBar1.Maximum/(3-i);
				startTick=curTick;
			}
			
			fmParent.AddLine("0 Out");
			txData[0]=(byte)'0'; //Reset 명령
			fmParent.SendBytes(txData);
			curTick=System.DateTime.Now.Ticks;
			while((curTick-startTick)/10000<2000)
			{
				curTick=System.DateTime.Now.Ticks;
				fmParent.ReadBuff();
			}
			startTick=curTick;

			fmParent.AddLine("2 Out");
			txData[0]=(byte)'2'; //Cold Boot
			fmParent.SendBytes(txData);
			while(!fmParent.ReadBuff()); //어떠한 응답이 올때까지 기다림
			fmParent.SendBytes(txData);
			fmParent.timer1.Enabled=true;
		}
	}
}
