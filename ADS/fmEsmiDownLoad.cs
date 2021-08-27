using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Threading;

namespace ADS
{
	/// <summary>
	/// fmEsmiDownLoad�� ���� ��� �����Դϴ�.
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
			// Windows Form �����̳� ������ �ʿ��մϴ�.
			//
			InitializeComponent();
			m_fileName=str;
			//
			// TODO: InitializeComponent�� ȣ���� ���� ������ �ڵ带 �߰��մϴ�.
			//
		}

		public void SetParent(Form1 fm)
		{
			fmParent=fm;
		}

		/// <summary>
		/// ��� ���� ��� ���ҽ��� �����մϴ�.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			base.Dispose( disposing );
		}

		#region Windows Form �����̳ʿ��� ������ �ڵ�
		/// <summary>
		/// �����̳� ������ �ʿ��� �޼����Դϴ�.
		/// �� �޼����� ������ �ڵ� ������� �������� ���ʽÿ�.
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
			this.label2.Text = "ȭ��";
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
			this.btnManualReset.Text = "���� Reset";
			this.btnManualReset.Click += new System.EventHandler(this.btnManualReset_Click);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(120, 72);
			this.label1.Size = new System.Drawing.Size(88, 29);
			this.label1.Text = "ESMI ���α׷��� �������� ��";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(120, 120);
			this.label5.Size = new System.Drawing.Size(88, 40);
			this.label5.Text = "��������ġ�� Svc ����ġ�� ����";
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
			fmParent.MonMode();  //9600���� �ٲ�
			lbComment.Text="������ ���� �� �ּ���";
		}
	
		private void btnEsmiReset_Click(object sender, System.EventArgs e)
		{
			btnEsmiReset.Enabled=false;
			btnManualReset.Enabled=false;

			//Timer �� ���� ���δ�.
			fmParent.timer1.Enabled=false;
			fmParent.MonMode();  //9600���� �ٲ�
			byte[] txData=new byte[1];
			txData[0]=27; //ESC 5�� ����
			long startTick=System.DateTime.Now.Ticks;
			long curTick;
			this.lbComment.Text="ESMI �������";
			for(int i=0;i<3;i++)
			{
				fmParent.SendBytes(txData);
				curTick=System.DateTime.Now.Ticks;
				while((curTick-startTick)/10000<1200) //1200 ms ��ٸ�
				{
					curTick=System.DateTime.Now.Ticks;
					fmParent.ReadBuff();
					Application.DoEvents();
				}
				this.progressBar1.Value=this.progressBar1.Maximum/(3-i);
				startTick=curTick;
			}
			
			fmParent.AddLine("0 Out");
			txData[0]=(byte)'0'; //Reset ���
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
			while(!fmParent.ReadBuff()); //��� ������ �ö����� ��ٸ�
			fmParent.SendBytes(txData);
			fmParent.timer1.Enabled=true;
		}
	}
}
