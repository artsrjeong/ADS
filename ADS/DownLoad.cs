using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Threading;

namespace ADS
{
	/// <summary>
	/// DownLoad�� ���� ��� �����Դϴ�.
	/// </summary>
	public class DownLoad : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Button btnExit;
		public  System.Windows.Forms.ProgressBar progressBar1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label lbFileName;
		string m_fileName;
		public  System.Windows.Forms.Label lbStatus;
		public  System.Windows.Forms.Label lbProgress;
	
		public enum STATUS {NORMAL,DOWNLOAD,MONITOR};

		Form1 fmParent;	
		public DownLoad()
		{
			//
			// Windows Form �����̳� ������ �ʿ��մϴ�.
			//
			InitializeComponent();

			//
			// TODO: InitializeComponent�� ȣ���� ���� ������ �ڵ带 �߰��մϴ�.
			//
		}

		public DownLoad(string str)
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
			fmParent.state=Form1.STATUS.NORMAL;
			base.Dispose( disposing );
		}

		#region Windows Form �����̳ʿ��� ������ �ڵ�
		/// <summary>
		/// �����̳� ������ �ʿ��� �޼����Դϴ�.
		/// �� �޼����� ������ �ڵ� ������� �������� ���ʽÿ�.
		/// </summary>
		private void InitializeComponent()
		{
			this.progressBar1 = new System.Windows.Forms.ProgressBar();
			this.btnExit = new System.Windows.Forms.Button();
			this.lbFileName = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.lbStatus = new System.Windows.Forms.Label();
			this.lbProgress = new System.Windows.Forms.Label();
			// 
			// progressBar1
			// 
			this.progressBar1.Location = new System.Drawing.Point(16, 208);
			this.progressBar1.Maximum = 3000;
			this.progressBar1.Size = new System.Drawing.Size(176, 20);
			// 
			// btnExit
			// 
			this.btnExit.Location = new System.Drawing.Point(136, 240);
			this.btnExit.Text = "Exit";
			this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
			// 
			// lbFileName
			// 
			this.lbFileName.Location = new System.Drawing.Point(64, 8);
			this.lbFileName.Size = new System.Drawing.Size(136, 48);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(16, 16);
			this.label2.Size = new System.Drawing.Size(40, 20);
			this.label2.Text = "ȭ��";
			// 
			// lbStatus
			// 
			this.lbStatus.Location = new System.Drawing.Point(8, 112);
			this.lbStatus.Size = new System.Drawing.Size(200, 20);
			this.lbStatus.Text = "���� ��Ʈ�ѷ��� ���� �� �ֽʽÿ�";
			// 
			// lbProgress
			// 
			this.lbProgress.Location = new System.Drawing.Point(16, 184);
			// 
			// DownLoad
			// 
			this.ClientSize = new System.Drawing.Size(210, 263);
			this.Controls.Add(this.lbProgress);
			this.Controls.Add(this.lbStatus);
			this.Controls.Add(this.lbFileName);
			this.Controls.Add(this.btnExit);
			this.Controls.Add(this.progressBar1);
			this.Controls.Add(this.label2);
			this.Text = "DownLoad";
			this.Load += new System.EventHandler(this.DownLoad_Load);

		}
		#endregion

		private void btnExit_Click(object sender, System.EventArgs e)
		{
			this.Dispose();
		}

		private void DownLoad_Load(object sender, System.EventArgs e)
		{
			lbFileName.Text=m_fileName;
		}
		public void finish()
		{
			lbStatus.Text="�ٿ�ε尡 �������ϴ�";
			Thread.Sleep(1000);
			this.Dispose();
		}
	}
}
