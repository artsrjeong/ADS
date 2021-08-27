using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmRingMon에 대한 요약 설명입니다.
	/// </summary>
	public class fmRingMon : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label lbFloor;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label lbDoor;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label lbMovDir;
		private System.Windows.Forms.Label lbPreDir;
		private System.Windows.Forms.DataGrid dataGrid1;
		Form1 fmParent;	
		public fmRingMon()
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();

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
			this.label1 = new System.Windows.Forms.Label();
			this.lbFloor = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.lbDoor = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.lbMovDir = new System.Windows.Forms.Label();
			this.lbPreDir = new System.Windows.Forms.Label();
			this.dataGrid1 = new System.Windows.Forms.DataGrid();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 16);
			this.label1.Size = new System.Drawing.Size(40, 16);
			this.label1.Text = "floor:";
			// 
			// lbFloor
			// 
			this.lbFloor.Location = new System.Drawing.Point(48, 16);
			this.lbFloor.Size = new System.Drawing.Size(40, 20);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(128, 16);
			this.label2.Size = new System.Drawing.Size(40, 20);
			this.label2.Text = "Door:";
			// 
			// lbDoor
			// 
			this.lbDoor.Location = new System.Drawing.Point(168, 16);
			this.lbDoor.Size = new System.Drawing.Size(40, 20);
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(128, 40);
			this.label3.Size = new System.Drawing.Size(40, 20);
			this.label3.Text = "preDir:";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(8, 40);
			this.label4.Size = new System.Drawing.Size(48, 20);
			this.label4.Text = "movDir:";
			// 
			// lbMovDir
			// 
			this.lbMovDir.Location = new System.Drawing.Point(64, 40);
			this.lbMovDir.Size = new System.Drawing.Size(40, 20);
			// 
			// lbPreDir
			// 
			this.lbPreDir.Location = new System.Drawing.Point(176, 40);
			this.lbPreDir.Size = new System.Drawing.Size(32, 20);
			// 
			// dataGrid1
			// 
			this.dataGrid1.Location = new System.Drawing.Point(8, 72);
			this.dataGrid1.Size = new System.Drawing.Size(200, 240);
			this.dataGrid1.Text = "dataGrid1";
			// 
			// fmRingMon
			// 
			this.ClientSize = new System.Drawing.Size(234, 418);
			this.Controls.Add(this.dataGrid1);
			this.Controls.Add(this.lbPreDir);
			this.Controls.Add(this.lbMovDir);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.lbDoor);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.lbFloor);
			this.Controls.Add(this.label1);
			this.Text = "fmRingMon";
			this.Load += new System.EventHandler(this.fmRingMon_Load);

		}
		#endregion

		private void fmRingMon_Load(object sender, System.EventArgs e)
		{
		}
		public void setFloor(int floor)
		{
			int tmpFloor=Int32.Parse(lbFloor.Text);
			if(tmpFloor!=floor)
				this.lbFloor.Text=floor.ToString();
		}
	}
}
