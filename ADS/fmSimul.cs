using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmSimul�� ���� ��� �����Դϴ�.
	/// </summary>
	public class fmSimul : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label lbSendPkt;
		public Form1 fmParent;
		public int pktCnt=0;
		public fmSimul()
		{
			//
			// Windows Form �����̳� ������ �ʿ��մϴ�.
			//
			InitializeComponent();

			//
			// TODO: InitializeComponent�� ȣ���� ���� ������ �ڵ带 �߰��մϴ�.
			//
		}

		public void sendPkt()
		{
			this.lbSendPkt.Text=pktCnt.ToString();
			pktCnt++;
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
			this.label1 = new System.Windows.Forms.Label();
			this.lbSendPkt = new System.Windows.Forms.Label();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(16, 32);
			this.label1.Size = new System.Drawing.Size(64, 20);
			this.label1.Text = "SendPkt : ";
			// 
			// lbSendPkt
			// 
			this.lbSendPkt.Location = new System.Drawing.Point(88, 32);
			// 
			// fmSimul
			// 
			this.ClientSize = new System.Drawing.Size(258, 432);
			this.Controls.Add(this.lbSendPkt);
			this.Controls.Add(this.label1);
			this.Text = "fmSimul";
			this.Load += new System.EventHandler(this.fmSimul_Load);

		}
		#endregion

		private void fmSimul_Load(object sender, System.EventArgs e)
		{
		
		}
	}
}
