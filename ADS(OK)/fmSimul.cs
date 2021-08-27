using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmSimul에 대한 요약 설명입니다.
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
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();

			//
			// TODO: InitializeComponent를 호출한 다음 생성자 코드를 추가합니다.
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
