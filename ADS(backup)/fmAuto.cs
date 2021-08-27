using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmAuto에 대한 요약 설명입니다.
	/// </summary>
	public class fmAuto : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Label label1;
	
		public fmAuto()
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();

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
			this.panel1 = new System.Windows.Forms.Panel();
			this.label1 = new System.Windows.Forms.Label();
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.label1);
			this.panel1.Location = new System.Drawing.Point(32, 56);
			this.panel1.Size = new System.Drawing.Size(136, 128);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 48);
			this.label1.Size = new System.Drawing.Size(112, 20);
			this.label1.Text = "기존 프로토콜 사용";
			// 
			// fmAuto
			// 
			this.ClientSize = new System.Drawing.Size(186, 263);
			this.Controls.Add(this.panel1);
			this.Text = "fmAuto";
			this.Load += new System.EventHandler(this.fmAuto_Load);

		}
		#endregion

		private void fmAuto_Load(object sender, System.EventArgs e)
		{
		}
	}
}
