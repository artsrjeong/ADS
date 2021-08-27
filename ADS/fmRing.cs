using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.IO;

namespace ADS
{
	/// <summary>
	/// fmRing에 대한 요약 설명입니다.
	/// </summary>
	public class fmRing : System.Windows.Forms.Form
	{
		public const int STOP_NOT_IN_PROGRESS= 	0; /* No Stop in progress */
		public const int STOP_NOT_STARTED=        1; /* door cycle not yet started */
		public const int STOP_IN_PROGRESS=        2; /* Stop in progress, in door cycle */
		public const int NO_DIR=0;
		public const int UP_DIR=1;
		public const int DOWN_DIR=2;
		public const int DOORS_CLOSED=0;
		public const int DOORS_CLOSING=1;
		public const int DOORS_OPENING=2;
		public const int DOORS_OPENED=3;
		public const int HOIST_OX=5;
		public int GX1,GX2,GY1,GY2;
		public int floorHeight=10;		
		const int GRP_BORDER=60;
		const int HOIST_WIDTH=20;
		const int HOIST_HEIGHT=30;
		const int CAR_HEIGHT=20;
		const int HALL_WIDTH=10;
		const int HALL_HEIGHT=30;
		const int HOIST_GAP=10;
		public int floorCnt=25;
		public System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabMon;
		private System.Windows.Forms.TabPage tabFilter;
		private System.Windows.Forms.TabPage tabCapture;
		private System.Windows.Forms.ImageList imageList1;
		public Form1 fmParent;	
		public const int MAX_OCSS=8;
		ArrayList ocssList=new ArrayList();
		enum IMG {CAR,UP,DOWN,DOOR};
		public enum DOOR_STATE {CLOSED,CLOSING,OPENED,OPENING};
		public enum DIR_STATE {NONE,UP,DOWN,BOTH};
		
		public Panel[] pnHoist=new Panel[MAX_OCSS];
		public System.Windows.Forms.Button btnFilter;
		public PictureBox[] picDir=new PictureBox[MAX_OCSS];

		public DataTable dtCapture=new DataTable("Capture");
		public DataTable dtFilter=new DataTable("Filter");
		private System.Windows.Forms.DataGrid gridFilterResult;
		private System.Windows.Forms.DataGrid gridFilter;
		private System.Windows.Forms.Panel pnValue;
		private System.Windows.Forms.TextBox txtValue;
		private System.Windows.Forms.Button btnOK;
		private System.Windows.Forms.Button btnCancel;
		public DataTable dtFilterResult=new DataTable("FilterResult");
		public int m_curRow,m_curCol;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem mnuExit;
		public System.Windows.Forms.Panel pnRcv1;
		public System.Windows.Forms.Panel pnRcv2;
		public System.Windows.Forms.Button btnCapture;
		private System.Windows.Forms.Label lbFile;
		private System.Windows.Forms.DataGrid gridCapture;
		public System.Windows.Forms.Label lbTime;
		public System.Windows.Forms.Panel pnRcv3;
		private System.Windows.Forms.MenuItem menuItem1;

		public void setDir(int car,int dir)
		{
			if(dir==(int)DIR_STATE.NONE && picDir[car-1].Visible==true)
			{
				picDir[car-1].Visible=false;
			}
			if(dir==(int)DIR_STATE.UP && (picDir[car-1].Visible==false || !picDir[car-1].Image.Equals(this.imageList1.Images[(int)IMG.UP])))
			{
				picDir[car-1].Image=this.imageList1.Images[(int)IMG.UP];
				picDir[car-1].Visible=true;
			}
			if(dir==(int)DIR_STATE.DOWN && (picDir[car-1].Visible==false || !picDir[car-1].Image.Equals(this.imageList1.Images[(int)IMG.DOWN])))
			{
				picDir[car-1].Image=this.imageList1.Images[(int)IMG.DOWN];
				picDir[car-1].Visible=true;
			}
			/*
			if(dir==(int)DIR_STATE.BOTH && !lbDirArr[car].Text.Equals("BT"))
			{
				lbDirArr[car].Text="BT";
			}
			*/
		}
		
		public void setDoor(int car,int fDoor)
		{
			csOcss ocss_info=(csOcss)ocssList[car-1];
			if(fDoor==(int)DOOR_STATE.CLOSED && ocss_info.picDoor.Visible==true)
				ocss_info.picDoor.Visible=false;
			if(fDoor==(int)DOOR_STATE.CLOSING && (ocss_info.picDoor.Visible==false || !(ocss_info.picDoor.Width==(int)(ocss_info.picCar.Width/2))))
			{
				ocss_info.picDoor.Top=ocss_info.picCar.Top;
				ocss_info.picDoor.Left=ocss_info.picCar.Left+ocss_info.picCar.Width/4;
				ocss_info.picDoor.Height=ocss_info.picCar.Height;
				ocss_info.picDoor.Width=ocss_info.picCar.Width/2;
				ocss_info.picDoor.Visible=true;
			}
			if(fDoor==(int)DOOR_STATE.OPENING && (ocss_info.picDoor.Visible==false || !(ocss_info.picDoor.Width==(int)(ocss_info.picCar.Width/2))))
			{
				ocss_info.picDoor.Top=ocss_info.picCar.Top;
				ocss_info.picDoor.Left=ocss_info.picCar.Left+ocss_info.picCar.Width/4;
				ocss_info.picDoor.Height=ocss_info.picCar.Height;
				ocss_info.picDoor.Width=ocss_info.picCar.Width/2;
				ocss_info.picDoor.Visible=true;
			}
			if(fDoor==(int)DOOR_STATE.OPENED && (ocss_info.picDoor.Visible==false || !(ocss_info.picDoor.Width==(int)(ocss_info.picCar.Width*4/5))))
			{
				ocss_info.picDoor.Top=ocss_info.picCar.Top;
				ocss_info.picDoor.Left=ocss_info.picCar.Left+ocss_info.picCar.Width/10;
				ocss_info.picDoor.Height=ocss_info.picCar.Height;
				ocss_info.picDoor.Width=ocss_info.picCar.Width*4/5;
				ocss_info.picDoor.Visible=true;
			}
		}

		public void setFloor(int car,int floor)
		{
			if(car>8 || car<1)
				return;
			csOcss ocss_info=(csOcss)ocssList[car-1];
			if(floor>ocss_info.top_pos) //층수가 지정된 것보다 큰 갑이 오면
			{
				for(int i=0;i<MAX_OCSS;i++)
				{
					csOcss tmpOcss=(csOcss)ocssList[i];
					tmpOcss.top_pos=floor;
				}
			}
			try
			{
				if(ocss_info.actual_pos!=floor)
				{
					ocss_info.dActual_pos=floor;
					ocss_info.lbOcss.Text=floor.ToString();
					ocss_info.picCar.Top=pnHoist[car-1].Top+pnHoist[car-1].Height-ocss_info.picCar.Height-((floor-1)*(pnHoist[car-1].Height-ocss_info.picCar.Height)/ocss_info.top_pos);
				}
			}
			catch
			{
			}
		}

		public fmRing()
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
			this.tabControl1.Size=fmParent.Size;
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(fmRing));
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabMon = new System.Windows.Forms.TabPage();
			this.pnRcv1 = new System.Windows.Forms.Panel();
			this.tabFilter = new System.Windows.Forms.TabPage();
			this.pnValue = new System.Windows.Forms.Panel();
			this.btnCancel = new System.Windows.Forms.Button();
			this.btnOK = new System.Windows.Forms.Button();
			this.txtValue = new System.Windows.Forms.TextBox();
			this.btnFilter = new System.Windows.Forms.Button();
			this.gridFilterResult = new System.Windows.Forms.DataGrid();
			this.gridFilter = new System.Windows.Forms.DataGrid();
			this.pnRcv2 = new System.Windows.Forms.Panel();
			this.tabCapture = new System.Windows.Forms.TabPage();
			this.lbTime = new System.Windows.Forms.Label();
			this.lbFile = new System.Windows.Forms.Label();
			this.gridCapture = new System.Windows.Forms.DataGrid();
			this.btnCapture = new System.Windows.Forms.Button();
			this.imageList1 = new System.Windows.Forms.ImageList();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuExit = new System.Windows.Forms.MenuItem();
			this.pnRcv3 = new System.Windows.Forms.Panel();
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabMon);
			this.tabControl1.Controls.Add(this.tabFilter);
			this.tabControl1.Controls.Add(this.tabCapture);
			this.tabControl1.Location = new System.Drawing.Point(0, 24);
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(264, 360);
			// 
			// tabMon
			// 
			this.tabMon.Controls.Add(this.pnRcv1);
			this.tabMon.Location = new System.Drawing.Point(4, 21);
			this.tabMon.Size = new System.Drawing.Size(256, 335);
			this.tabMon.Text = "Monitor";
			// 
			// pnRcv1
			// 
			this.pnRcv1.BackColor = System.Drawing.SystemColors.AppWorkspace;
			this.pnRcv1.Location = new System.Drawing.Point(200, 256);
			this.pnRcv1.Size = new System.Drawing.Size(16, 16);
			// 
			// tabFilter
			// 
			this.tabFilter.Controls.Add(this.pnValue);
			this.tabFilter.Controls.Add(this.btnFilter);
			this.tabFilter.Controls.Add(this.gridFilterResult);
			this.tabFilter.Controls.Add(this.gridFilter);
			this.tabFilter.Controls.Add(this.pnRcv2);
			this.tabFilter.Location = new System.Drawing.Point(4, 21);
			this.tabFilter.Size = new System.Drawing.Size(256, 335);
			this.tabFilter.Text = "Filter";
			// 
			// pnValue
			// 
			this.pnValue.BackColor = System.Drawing.SystemColors.ControlText;
			this.pnValue.Controls.Add(this.btnCancel);
			this.pnValue.Controls.Add(this.btnOK);
			this.pnValue.Controls.Add(this.txtValue);
			this.pnValue.Location = new System.Drawing.Point(24, 16);
			this.pnValue.Size = new System.Drawing.Size(208, 56);
			this.pnValue.Visible = false;
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(120, 32);
			this.btnCancel.Text = "Cancel";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnOK
			// 
			this.btnOK.Location = new System.Drawing.Point(120, 8);
			this.btnOK.Text = "OK";
			this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
			// 
			// txtValue
			// 
			this.txtValue.Location = new System.Drawing.Point(16, 16);
			this.txtValue.Size = new System.Drawing.Size(72, 21);
			this.txtValue.Text = "";
			// 
			// btnFilter
			// 
			this.btnFilter.Location = new System.Drawing.Point(176, 24);
			this.btnFilter.Size = new System.Drawing.Size(72, 24);
			this.btnFilter.Text = "Filter";
			this.btnFilter.Click += new System.EventHandler(this.btnFilter_Click);
			// 
			// gridFilterResult
			// 
			this.gridFilterResult.Location = new System.Drawing.Point(8, 80);
			this.gridFilterResult.Size = new System.Drawing.Size(240, 160);
			this.gridFilterResult.Text = "dataGrid2";
			// 
			// gridFilter
			// 
			this.gridFilter.Location = new System.Drawing.Point(8, 8);
			this.gridFilter.Size = new System.Drawing.Size(136, 64);
			this.gridFilter.Text = "dataGrid1";
			this.gridFilter.Click += new System.EventHandler(this.gridFilter_Click);
			// 
			// pnRcv2
			// 
			this.pnRcv2.BackColor = System.Drawing.SystemColors.AppWorkspace;
			this.pnRcv2.Location = new System.Drawing.Point(152, 32);
			this.pnRcv2.Size = new System.Drawing.Size(16, 16);
			// 
			// tabCapture
			// 
			this.tabCapture.Controls.Add(this.pnRcv3);
			this.tabCapture.Controls.Add(this.lbTime);
			this.tabCapture.Controls.Add(this.lbFile);
			this.tabCapture.Controls.Add(this.gridCapture);
			this.tabCapture.Controls.Add(this.btnCapture);
			this.tabCapture.Location = new System.Drawing.Point(4, 21);
			this.tabCapture.Size = new System.Drawing.Size(256, 335);
			this.tabCapture.Text = "Capture";
			// 
			// lbTime
			// 
			this.lbTime.Location = new System.Drawing.Point(112, 32);
			this.lbTime.Text = "Time : ";
			// 
			// lbFile
			// 
			this.lbFile.Location = new System.Drawing.Point(112, 8);
			this.lbFile.Size = new System.Drawing.Size(120, 20);
			this.lbFile.Text = "File : RingCap.csv";
			// 
			// gridCapture
			// 
			this.gridCapture.Location = new System.Drawing.Point(8, 64);
			this.gridCapture.Size = new System.Drawing.Size(240, 224);
			this.gridCapture.Text = "dataGrid1";
			// 
			// btnCapture
			// 
			this.btnCapture.Location = new System.Drawing.Point(16, 16);
			this.btnCapture.Size = new System.Drawing.Size(72, 24);
			this.btnCapture.Text = "Capture";
			this.btnCapture.Click += new System.EventHandler(this.btnCapture_Click);
			// 
			// imageList1
			// 
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource"))));
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource1"))));
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource2"))));
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource3"))));
			this.imageList1.ImageSize = new System.Drawing.Size(16, 16);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.menuItem1);
			// 
			// menuItem1
			// 
			this.menuItem1.MenuItems.Add(this.mnuExit);
			this.menuItem1.Text = "File";
			// 
			// mnuExit
			// 
			this.mnuExit.Text = "Exit";
			this.mnuExit.Click += new System.EventHandler(this.menuItem2_Click);
			// 
			// pnRcv3
			// 
			this.pnRcv3.BackColor = System.Drawing.SystemColors.GrayText;
			this.pnRcv3.Location = new System.Drawing.Point(224, 32);
			this.pnRcv3.Size = new System.Drawing.Size(16, 16);
			// 
			// fmRing
			// 
			this.ClientSize = new System.Drawing.Size(266, 625);
			this.Controls.Add(this.tabControl1);
			this.Menu = this.mainMenu1;
			this.Text = "RING COMM";
			this.Resize += new System.EventHandler(this.fmRing_Resize);
			this.EnabledChanged += new System.EventHandler(this.fmRing_EnabledChanged);
			this.Load += new System.EventHandler(this.fmRing_Load);
			this.LostFocus += new System.EventHandler(this.fmRing_LostFocus);

		}
		#endregion

		private void fmRing_Load(object sender, System.EventArgs e)
		{
			GY2=200;
			for(int i=0;i<MAX_OCSS;i++)
			{
				csOcss ocss_info=new csOcss();
				ocss_init(ocss_info);
				PictureBox picDoor=new PictureBox();
				picDoor.Image=this.imageList1.Images[(int)IMG.DOOR];
				this.tabMon.Controls.Add(picDoor);
				ocss_info.picDoor=picDoor;

				PictureBox picCar=new PictureBox();
				this.tabMon.Controls.Add(picCar);
				ocss_info.picCar=picCar;
				ocssList.Add(ocss_info);
				
				pnHoist[i]=new Panel();
				this.tabMon.Controls.Add(pnHoist[i]);
				pnHoist[i].BackColor = System.Drawing.SystemColors.Highlight;
				pnHoist[i].Location = new System.Drawing.Point(5+i*(HOIST_WIDTH+HOIST_GAP), 30);
				pnHoist[i].Size = new System.Drawing.Size(HOIST_WIDTH, 180);

				picDir[i]=new PictureBox();
				this.tabMon.Controls.Add(picDir[i]);
				picDir[i].Image=this.imageList1.Images[(int)IMG.UP];
				picDir[i].Top=pnHoist[i].Top+pnHoist[i].Height;
				picDir[i].Left=(int)(HOIST_OX*1.5)+i*(HOIST_WIDTH+HOIST_GAP);
				picDir[i].Size=new System.Drawing.Size(HOIST_WIDTH, 20);
			}
			pnRcv1.Top=picDir[7].Top+picDir[7].Height+2;
			pnRcv1.Left=picDir[7].Left;
			pnRcv1.Size=new System.Drawing.Size(10, 10);

			for(int i=0;i<MAX_OCSS;i++)
			{
				csOcss ocss_info=(csOcss)ocssList[i];
				ocss_info.bottom_pos=1;
				ocss_info.top_pos=25;
				try
				{
					ocss_info.DOTime=1.5;
				}
				catch
				{
					ocss_info.DOTime=1.5;
				}
				try
				{
					ocss_info.DCTime=2.5;
				}
				catch
				{
					ocss_info.DCTime=2.5;
				}
				try
				{
					ocss_info.DWTime=3;
				}
				catch
				{
					ocss_info.DWTime=3;
				}
				PictureBox picDoor=(PictureBox)ocss_info.picDoor;
				picDoor.BackColor=Color.White;
				picDoor.Visible=false;
				PictureBox picCar=(PictureBox)ocss_info.picCar;
				picCar.BackColor=Color.Khaki;
				picCar.Image=this.imageList1.Images[(int)IMG.CAR];
				picCar.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
				picCar.Width=HOIST_WIDTH;
				picCar.Height=CAR_HEIGHT;
				picCar.Top=pnHoist[i].Top+pnHoist[i].Height-picCar.Height;
				picCar.Left=HOIST_OX+i*(HOIST_WIDTH+HOIST_GAP);
				
				//OCSS Label 만들기
				Label lbOcss=new Label();
				this.tabMon.Controls.Add(lbOcss);
				lbOcss.Text = "?";
				lbOcss.Height=25;
				lbOcss.Top=pnHoist[i].Top-20;
				lbOcss.Left=HOIST_OX*2+i*(HOIST_WIDTH+HOIST_GAP);
				lbOcss.Width=HOIST_WIDTH;
				ocss_info.lbOcss=lbOcss;				

				/*
				for(int j=0;j<floorCnt;j++)
				{
					csFloor fl=new csFloor();
					fl.carId=i+1;
					fl.floor=j+1;
					PictureBox picHoist=new PictureBox();
					this.tabMon.Controls.Add(picHoist);
					picHoist.BackColor=Color.Black;
					picHoist.Width=HOIST_WIDTH;
					picHoist.Height=floorHeight;
					picHoist.Top=GY2-((j+1)*picHoist.Height);
					picHoist.Left=HOIST_OX+i*(HOIST_WIDTH+HALL_WIDTH+5);
					//picHoist.Image=this.imageList1.Images[(int)IMG.NO_CARCALL];
					//picHoist.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;

					fl.picHoist=picHoist;
					
					PictureBox picHall=new PictureBox();
					this.tabMon.Controls.Add(picHall);
					picHall.BackColor=Color.White;
					picHall.Width=HALL_WIDTH;
					picHall.Height=floorHeight;
					picHall.Top=GY2-((j+1)*picHall.Height);
					picHall.Left=HOIST_OX+i*(HOIST_WIDTH+HALL_WIDTH+5)+picHoist.Width;
					//picHall.Image=this.imageList1.Images[(int)IMG.NO_HALLCALL];
					//picHall.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
					fl.picHall=picHall;
					ocss_info.floorList.Add(fl);
				}
				*/
			}
			dtCapture.Columns.Add(new DataColumn("Car",System.Type.GetType("System.String")));
			dtCapture.Columns.Add(new DataColumn("Type",System.Type.GetType("System.String")));
			dtCapture.Columns.Add(new DataColumn("Msg",System.Type.GetType("System.String")));
			dtCapture.Columns.Add(new DataColumn("Time",System.Type.GetType("System.String")));
			this.gridCapture.DataSource=dtCapture;
			dtFilter.Columns.Add(new DataColumn("Type",System.Type.GetType("System.String"))); 
			dtFilter.Columns.Add(new DataColumn("SubType",System.Type.GetType("System.String"))); 
			this.gridFilter.DataSource=dtFilter;
			dtFilterResult.Columns.Add(new DataColumn("Type",System.Type.GetType("System.String"))); 
			dtFilterResult.Columns.Add(new DataColumn("SubType",System.Type.GetType("System.String"))); 
			dtFilterResult.Columns.Add(new DataColumn("Content",System.Type.GetType("System.String"))); 
			this.gridFilterResult.DataSource=dtFilterResult;
			dtFilter.Rows.Add(new object[]{"",""});
			dtFilter.Rows.Add(new object[]{"",""});
		}

		public void ocss_init(csOcss ocss_info)
		{
			ocss_info.stop_status=STOP_NOT_IN_PROGRESS;
			ocss_info.f_door_state=DOORS_CLOSED;
			ocss_info.dActual_pos=1;
			ocss_info.mov_dir=NO_DIR;
		}

		private void fmRing_Resize(object sender, System.EventArgs e)
		{
		}

		private void fmRing_EnabledChanged(object sender, System.EventArgs e)
		{
		}

		private void fmRing_LostFocus(object sender, System.EventArgs e)
		{
		}

		private void gridFilter_Click(object sender, System.EventArgs e)
		{
			try
			{
				pnValue.Visible=true;
				m_curRow=gridFilter.CurrentCell.RowNumber;
				m_curCol=gridFilter.CurrentCell.ColumnNumber;
				this.txtValue.Text=(string)dtFilter.Rows[m_curRow][m_curCol];
				txtValue.Focus();
			}
			finally
			{}
		}

		private void btnOK_Click(object sender, System.EventArgs e)
		{
			dtFilter.Rows[m_curRow][m_curCol]=this.txtValue.Text;
			pnValue.Visible=false;
		}

		private void menuItem2_Click(object sender, System.EventArgs e)
		{
			fmParent.state=Form1.STATUS.NORMAL;
			this.Close();
		}

		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			pnValue.Visible=false;
		}

		private void btnFilter_Click(object sender, System.EventArgs e)
		{
			if(btnFilter.Text.Equals("Filter"))
			{
				this.btnFilter.Text="Stop";
				dtFilterResult.Clear();				
			}
			else
				this.btnFilter.Text="Filter";
		}

		private void btnCapture_Click(object sender, System.EventArgs e)
		{
			if(btnCapture.Text.Equals("Capture"))
			{
				fmParent.ringCaptureStart();
				this.btnCapture.Text="Stop";
				this.dtCapture.Clear();
			}
			else
			{
				fmParent.ringCaptureStop();
				this.btnCapture.Text="Capture";
				readCapture();
			}
		}

		public void readCapture()
		{
			int rowInx=0;
			try
			{
				StreamReader sr=new StreamReader(@"ringCap.csv");
				while (sr.Peek() >= 0) 
				{
					string str=sr.ReadLine();
					string[] strArr=str.Split(',');
					if(rowInx==0)
					{
						rowInx++;
						continue;
					}

					if(this.dtCapture.Rows.Count<=(rowInx-1)) //열이 없으면
					{
						DataRow row=dtCapture.NewRow();
						row[0]=strArr[0];
						row[1]=strArr[1];
						row[2]=strArr[2]+strArr[3]+strArr[4]+strArr[5]+strArr[6]+strArr[7];
						row[3]=strArr[8];
						dtCapture.Rows.Add(row);
					}
					rowInx++;
				}
				sr.Close();
			}
			catch(Exception eee)
			{
				MessageBox.Show(eee.Message);
			}
		}
	}

	public class csOcss
	{
		public bool b2D=false;
		public bool bUpper=false;
		public PictureBox picHoistPark;
		public PictureBox picHallPark;
		public PictureBox picCar;
		public PictureBox picDoor;
		public Label lbOcss;
		public double dActual_pos;
		public int actual_pos {get {return (int)dActual_pos;}}
		public int old_actual_pos;
		public int target_pos;
		public int top_pos;
		public int bottom_pos;
		public double DOTime;
		public double DCTime;
		public double DWTime;
		public int mov_dir;
		public int pre_dir;
		public int stop_status;
		public int NCF;
		public int stop_pos;
		public int stop_type;
		public int[] assigned_calls=new int[256];
		public ArrayList floorList=new ArrayList();
		public double openWidth;
		public int f_door_state;
		public int r_door_state;
		public int openedCnt;
		public csOcss()
		{
			openWidth=0;
			stop_status=fmRing.STOP_NOT_IN_PROGRESS;
			f_door_state=fmRing.DOORS_CLOSED;
			dActual_pos=0;
			mov_dir=fmRing.NO_DIR;
		}
	}

	internal class csFloor
	{
		public PictureBox picHoist;
		public PictureBox picHall;
		public int carId;
		public int floor;
		public uint hallCall;
		public uint carCall;
		public uint upCarCall{get {return (carCall) & 1;}
			set {carCall=carCall & ~(1U) | (value);}
		}
		public uint dnCarCall {get {return (carCall>>1) & 1;}
			set {carCall=carCall & ~(1U<<1) | (value<<1);}
		}

		public uint upHallCall{get {return (hallCall) & 1;}
			set {hallCall=hallCall & ~(1U) | (value);}
		}
		public uint dnHallCall {get {return (hallCall>>1) & 1;}
			set {hallCall=hallCall & ~(1U<<1) | (value<<1);}
		}
	}
}
