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
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label lbDoor;
		private System.Windows.Forms.DataGrid dataGrid1;
		public const int MAX_OCSS=9;
		public Label[] lbFloorArr=new Label[MAX_OCSS];
		public Label[] lbDoorArr=new Label[MAX_OCSS];
		public Label[] lbDirArr=new Label[MAX_OCSS];
		public System.Windows.Forms.Button btnCapture;
		public System.Windows.Forms.ProgressBar proRing;
		public enum DOOR_STATE {CLOSED,CLOSING,OPENED,OPENING};
		public enum DIR_STATE {NONE,UP,DOWN,BOTH};
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
			this.label2 = new System.Windows.Forms.Label();
			this.lbDoor = new System.Windows.Forms.Label();
			this.dataGrid1 = new System.Windows.Forms.DataGrid();
			this.btnCapture = new System.Windows.Forms.Button();
			this.proRing = new System.Windows.Forms.ProgressBar();
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(16, 104);
			this.label2.Size = new System.Drawing.Size(40, 20);
			this.label2.Text = "Door:";
			// 
			// lbDoor
			// 
			this.lbDoor.Location = new System.Drawing.Point(56, 104);
			this.lbDoor.Size = new System.Drawing.Size(40, 20);
			// 
			// dataGrid1
			// 
			this.dataGrid1.Location = new System.Drawing.Point(8, 136);
			this.dataGrid1.Size = new System.Drawing.Size(216, 240);
			this.dataGrid1.Text = "dataGrid1";
			// 
			// btnCapture
			// 
			this.btnCapture.Location = new System.Drawing.Point(8, 72);
			this.btnCapture.Size = new System.Drawing.Size(72, 24);
			this.btnCapture.Text = "Capture";
			this.btnCapture.Click += new System.EventHandler(this.btnCapture_Click);
			// 
			// proRing
			// 
			this.proRing.Location = new System.Drawing.Point(96, 72);
			this.proRing.Maximum = 65536;
			this.proRing.Size = new System.Drawing.Size(120, 20);
			// 
			// fmRingMon
			// 
			this.ClientSize = new System.Drawing.Size(234, 418);
			this.Controls.Add(this.proRing);
			this.Controls.Add(this.btnCapture);
			this.Controls.Add(this.dataGrid1);
			this.Controls.Add(this.lbDoor);
			this.Controls.Add(this.label2);
			this.Text = "fmRingMon";
			this.Load += new System.EventHandler(this.fmRingMon_Load);

		}
		#endregion

		private void fmRingMon_Load(object sender, System.EventArgs e)
		{
			for(int i=1;i<MAX_OCSS;i++)
			{
				lbFloorArr[i]=new Label();
				this.Controls.Add(lbFloorArr[i]);
				lbFloorArr[i].BackColor = System.Drawing.Color.Wheat;
				lbFloorArr[i].Text = "?";
				lbFloorArr[i].Height=15;
				lbFloorArr[i].Top=10;
				lbFloorArr[i].Width=25;
				lbFloorArr[i].Left=25*(i-1)+30;

				lbDoorArr[i]=new Label();
				this.Controls.Add(lbDoorArr[i]);
				lbDoorArr[i].BackColor = System.Drawing.Color.Wheat;
				lbDoorArr[i].Text = "?";
				lbDoorArr[i].Height=15;
				lbDoorArr[i].Top=30;
				lbDoorArr[i].Width=25;
				lbDoorArr[i].Left=25*(i-1)+30;

				lbDirArr[i]=new Label();
				this.Controls.Add(lbDirArr[i]);
				lbDirArr[i].BackColor = System.Drawing.Color.Wheat;
				lbDirArr[i].Text = "?";
				lbDirArr[i].Height=15;
				lbDirArr[i].Top=50;
				lbDirArr[i].Width=25;
				lbDirArr[i].Left=25*(i-1)+30;

			}
		}

		public void setDir(int car,int dir)
		{
			if(dir==(int)DIR_STATE.NONE && !lbDirArr[car].Text.Equals("NO"))
			{
				lbDirArr[car].Text="NO";
			}
			if(dir==(int)DIR_STATE.UP && !lbDirArr[car].Text.Equals("UP"))
			{
				lbDirArr[car].Text="UP";
			}
			if(dir==(int)DIR_STATE.DOWN && !lbDirArr[car].Text.Equals("DN"))
			{
				lbDirArr[car].Text="DN";
			}
			if(dir==(int)DIR_STATE.BOTH && !lbDirArr[car].Text.Equals("BT"))
			{
				lbDirArr[car].Text="BT";
			}
		}
		
		public void setDoor(int car,int fDoor)
		{
			if(fDoor==(int)DOOR_STATE.CLOSED && !lbDoorArr[car].Text.Equals("|"))
				lbDoorArr[car].Text="|";
			if(fDoor==(int)DOOR_STATE.CLOSING && !lbDoorArr[car].Text.Equals("><"))
				lbDoorArr[car].Text="><";
			if(fDoor==(int)DOOR_STATE.OPENING && !lbDoorArr[car].Text.Equals("<>"))
				lbDoorArr[car].Text="<>";
			if(fDoor==(int)DOOR_STATE.OPENED && !lbDoorArr[car].Text.Equals("| |"))
				lbDoorArr[car].Text="| |";
		}

		public void setFloor(int car,int floor)
		{
			if(car>8 || car<1)
				return;
			try
			{
				int tmpFloor=Int32.Parse(lbFloorArr[car].Text);
				if(tmpFloor!=floor)
					this.lbFloorArr[car].Text=floor.ToString();
			}
			catch
			{
				this.lbFloorArr[car].Text="0";
			}

		}

		private void btnCapture_Click(object sender, System.EventArgs e)
		{
			if(btnCapture.Text.Equals("Capture"))
			{
				fmParent.ringCaptureStart();
				this.btnCapture.Text="Stop";
			}
			else
			{
				fmParent.ringCaptureStop();
				this.btnCapture.Text="Capture";
			}
		}
	}
}
