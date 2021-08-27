using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace ADS
{
	/// <summary>
	/// fmGraph에 대한 요약 설명입니다.
	/// </summary>
	public class fmGraph : System.Windows.Forms.Form
	{
		Form1 fmParent;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem mnuClose;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Panel pnDoorPos;
		public const int GRP_BORDER=5;
		public const int MAX_GRP_ARR=25;
		public DataTable dtInput=new DataTable("InputPoint");
		public DataTable dtOutput=new DataTable("OutputPoint");
		public int nCurDoorPos;
		public int nCurInput;
		public int nCurOutput;
		public int nCurFreqOut;
		public int[] nDoorPosArr;
		public int[] nInputArr;
		public int[] nOutputArr;
		public int[] nFreqOutArr;
		int XX1,YY1,XX2,YY2,GX1,GY1,GX2,GY2,DX,DY;
		public const int Y_INTERVAL=15;
		public int horiY;
		bool bPause=false;
		public fmGraph(Form1 fm)
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			fmParent=fm;
			nDoorPosArr=new int[MAX_GRP_ARR];
			nInputArr=new int[MAX_GRP_ARR];
			nOutputArr=new int[MAX_GRP_ARR];
			nFreqOutArr=new int[MAX_GRP_ARR];

			dtInput.Columns.Add(new DataColumn("입력접점",System.Type.GetType("System.String")));
			dtInput.Columns.Add(new DataColumn("값",System.Type.GetType("System.String")));
			dtOutput.Columns.Add(new DataColumn("출력접점",System.Type.GetType("System.String")));
			dtOutput.Columns.Add(new DataColumn("값",System.Type.GetType("System.String")));
			uint groupInx;

			for(int i=0;i<fmParent.m_tableList.Count;i++)
			{
				DataTable dtParam=(DataTable)fmParent.m_tableList[i];
				string strGroupInx=(string)dtParam.Rows[0]["Group_inx"];
				strGroupInx=strGroupInx.Trim();
				groupInx=Convert.ToUInt32(strGroupInx,16);
				if(groupInx==0) //입력접점 Table
				{
					foreach(DataRow row in dtParam.Rows)
					{
						dtInput.Rows.Add(new object[]{(string)row["Description"],""});
					}

				}
				else if(groupInx==1) //출력접점 Table
				{
					foreach(DataRow row in dtParam.Rows)
					{
						dtOutput.Rows.Add(new object[]{(string)row["Description"],""});
					}
				}
			}

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
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuClose = new System.Windows.Forms.MenuItem();
			this.panel1 = new System.Windows.Forms.Panel();
			this.pnDoorPos = new System.Windows.Forms.Panel();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.menuItem1);
			// 
			// menuItem1
			// 
			this.menuItem1.MenuItems.Add(this.mnuClose);
			this.menuItem1.Text = "File";
			// 
			// mnuClose
			// 
			this.mnuClose.Text = "Graph종료";
			this.mnuClose.Click += new System.EventHandler(this.mnuClose_Click);
			// 
			// panel1
			// 
			this.panel1.BackColor = System.Drawing.Color.Red;
			this.panel1.Location = new System.Drawing.Point(4, 248);
			this.panel1.Size = new System.Drawing.Size(32, 16);
			// 
			// pnDoorPos
			// 
			this.pnDoorPos.BackColor = System.Drawing.Color.DodgerBlue;
			this.pnDoorPos.Location = new System.Drawing.Point(104, 248);
			this.pnDoorPos.Size = new System.Drawing.Size(32, 16);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(144, 250);
			this.label1.Size = new System.Drawing.Size(88, 20);
			this.label1.Text = "Door Position";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(41, 250);
			this.label2.Size = new System.Drawing.Size(55, 20);
			this.label2.Text = "Freq Out";
			// 
			// fmGraph
			// 
			this.ClientSize = new System.Drawing.Size(250, 365);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.pnDoorPos);
			this.Controls.Add(this.label2);
			this.Menu = this.mainMenu1;
			this.Text = "fmGraph";
			this.Click += new System.EventHandler(this.fmGraph_Click);
			this.Load += new System.EventHandler(this.fmGraph_Load);
			this.Paint += new System.Windows.Forms.PaintEventHandler(this.fmGraph_Paint);

		}
		#endregion

		private void fmGraph_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
			this.DrawGrpFrame();
			this.DrawGrp();
		}

		
		private void mnuClose_Click(object sender, System.EventArgs e)
		{
			fmParent.state=Form1.STATUS.NORMAL;
			this.Close();
		}

		private void fmGraph_Load(object sender, System.EventArgs e)
		{
		}

		public void AddData()
		{
			for(int i=1;i<MAX_GRP_ARR;i++)
			{
				nDoorPosArr[i-1]=nDoorPosArr[i];
				nFreqOutArr[i-1]=nFreqOutArr[i];
				nInputArr[i-1]=nInputArr[i];
				nOutputArr[i-1]=nOutputArr[i];
			}
			nDoorPosArr[MAX_GRP_ARR-1]=nCurDoorPos;
			nFreqOutArr[MAX_GRP_ARR-1]=nCurFreqOut;
			nInputArr[MAX_GRP_ARR-1]=nCurInput;
			nOutputArr[MAX_GRP_ARR-1]=nCurOutput;
			if(!bPause)
				DrawGrp();
		}
		
		public void EraseBack()
		{
			Graphics dc=this.CreateGraphics();
		}

		public void DrawGrpFrame()
		{
			int i;
			Graphics dc=this.CreateGraphics();
			Brush br=new SolidBrush(Color.White);
			dc.FillRectangle(br,0,0,this.Width,this.Height);
			Font DispFont=new Font("Arial",8,FontStyle.Bold);
			
			XX1 = 50;
			YY1 = 0;
			XX2 = this.Width-1;
			YY2 = this.pnDoorPos.Top-2;
			GX1 = XX1 + GRP_BORDER;
			GY1 = YY1 + GRP_BORDER;
			GX2 = XX2 - GRP_BORDER;
			GY2 = YY2 - GRP_BORDER;
			
			DX = GX2 - GX1;
			DY = GY2 - GY1;
			Pen pen=new Pen(Color.Black);
			dc.DrawRectangle(pen,XX1, YY1, XX2, YY2);
			//pen.Color=Color.FromArgb(0xc0,0xc0,0xc0);
			dc.DrawRectangle(pen,GX1, GY1, DX, DY);

			br=new SolidBrush(Color.Red);
			dc.DrawString("INPUT",DispFont,br,5,0);
			br=new SolidBrush(Color.Black);
			for(i=0;i<dtInput.Rows.Count;i++)
			{
				dc.DrawString((string)dtInput.Rows[i][0],DispFont,br,5,Y_INTERVAL*i+15);
			}
			horiY=i*Y_INTERVAL+25;
			//pen=new Pen(Color.Yellow);
			//dc.DrawLine(pen,0,horiY,this.Width,horiY);
			br=new SolidBrush(Color.Red);
			dc.DrawString("OUTPUT",DispFont,br,5,horiY);
			br=new SolidBrush(Color.Black);

			for(i=0;i<dtOutput.Rows.Count;i++)
			{
				dc.DrawString((string)dtOutput.Rows[i][0],DispFont,br,5,Y_INTERVAL*i+horiY+15);
			}
			

			/*
			for (i=0; i<10; i++)
			{
				dc.DrawLine(pen,GX1, GY1 + DY * i /10,GX2, GY1 + DY * i /10);
			}
			for (i=0; i<10; i++)
			{
				dc.DrawLine(pen,GX1 + DX * i /10, GY1,GX1 + DX * i /10, GY2);
			}
			pen.Color=Color.FromArgb(0,0,0);
			dc.DrawLine(pen,GX1,GY1,GX1,GY2);
			dc.DrawLine(pen,GX1,GY2,GX2,GY2);
			*/
		}

		public void DrawGrp()
		{
			int x1,y1,x2,y2;
			Graphics dc=this.CreateGraphics();
			Brush br=new SolidBrush(Color.White);
			dc.FillRectangle(br,GX1+1,GY1+1,GX2-1,GY2-1);

			//Door Position 표시
			Pen pen=new Pen(Color.Blue);
			for(int i=0;i<MAX_GRP_ARR-1;i++)
			{
				dc.DrawLine(pen,GX1+i*(DX/MAX_GRP_ARR),GY2-DY*nDoorPosArr[i]/1100,GX1+(i+1)*(DX/MAX_GRP_ARR),GY2-DY*nDoorPosArr[i+1]/1100);
			}
			//FreqOut 표시
			pen=new Pen(Color.Red);
			for(int i=0;i<MAX_GRP_ARR-1;i++)
			{
				dc.DrawLine(pen,GX1+i*(DX/MAX_GRP_ARR),GY2-DY*nFreqOutArr[i]/500,GX1+(i+1)*(DX/MAX_GRP_ARR),GY2-DY*nFreqOutArr[i+1]/500);
			}
			pen=new Pen(Color.Black);
			for(int i=0;i<MAX_GRP_ARR-1;i++)
			{
				x1=GX1+i*(DX/MAX_GRP_ARR);
				x2=GX1+(i+1)*(DX/MAX_GRP_ARR);
				for(int j=0;j<dtInput.Rows.Count;j++)
				{
					if((nInputArr[i] & 1<<(dtInput.Rows.Count-j-1)) >0) //접점이 On이면
						y1=Y_INTERVAL*j+15;
					else
						y1=Y_INTERVAL*j+25;
					if((nInputArr[i+1] & 1<< (dtInput.Rows.Count-j-1)) > 0) //두번째 접점이 On이면
						y2=Y_INTERVAL*j+15;
					else
						y2=Y_INTERVAL*j+25;
					if(y1==y2)//값의 변화가 없으면
					{
						dc.DrawLine(pen,x1,y1,x2,y2);
					}
					else
					{
						dc.DrawLine(pen,x1,y1,x2,y1); //처음에 옆으로 갔다가
						dc.DrawLine(pen,x2,y1,x2,y2); //밑이나 위로 감
					}
				}

				for(int j=0;j<dtOutput.Rows.Count;j++)
				{
					if((nOutputArr[i] & 1<<(dtOutput.Rows.Count-j-1)) >0) //접점이 On이면
						y1=Y_INTERVAL*j+horiY+15;
					else
						y1=Y_INTERVAL*j+horiY+25;
					if((nOutputArr[i+1] & 1<< (dtOutput.Rows.Count-j-1)) > 0) //두번째 접점이 On이면
						y2=Y_INTERVAL*j+horiY+15;
					else
						y2=Y_INTERVAL*j+horiY+25;

					if(y1==y2)//값의 변화가 없으면
					{
						dc.DrawLine(pen,x1,y1,x2,y2);
					}
					else
					{
						dc.DrawLine(pen,x1,y1,x2,y1); //처음에 옆으로 갔다가
						dc.DrawLine(pen,x2,y1,x2,y2); //밑이나 위로 감
					}
				}
			}
		}

		private void fmGraph_Click(object sender, System.EventArgs e)
		{
			if(bPause)
				bPause=false;
			else
			{
				bPause=true;
				Graphics dc=this.CreateGraphics();
				Font DispFont=new Font("Arial",8,FontStyle.Bold);
				Brush br=new SolidBrush(Color.Black);
				dc.DrawString("Pause",DispFont,br,100,100);
				
			}
		}
	}
}
