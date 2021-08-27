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
	/// fmParam에 대한 요약 설명입니다.
	/// </summary>
	public class fmParam : System.Windows.Forms.Form
	{
		string m_fileName;
		public Form1 fmParent;
		public uint m_wSetDataAddr;
		public uint m_iSetData;
		public uint m_wIndex=1;
		public int m_iSetDataIdx=0;
		public int m_curRow=0;
		public string[] m_sSetData=new string[30];
		public double[] Dec10=new double[4];
		public int[] DotPos=new int[MAX_ITEM];
		public const int MAX_ITEM=39;
		public const int MAX_GRAPH_ARR=20;
		public System.Windows.Forms.PictureBox picCom;
		public System.Windows.Forms.ImageList imageList1;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem mnuMonitor;
		public  System.Windows.Forms.TabControl tabControl1;
		private System.Windows.Forms.TabPage tabPage1;
		public System.Windows.Forms.ComboBox cbGroup;
		private System.Windows.Forms.DataGrid gridData;
		private System.Windows.Forms.Panel pnDataIn;
		private System.Windows.Forms.Label label16;
		private System.Windows.Forms.Button btnDataIn;
		private System.Windows.Forms.TextBox txtDataIn;
		private System.Windows.Forms.TabPage tabPage2;
		private System.Windows.Forms.Label lbDoorPos;
		public  System.Windows.Forms.TextBox txtDoorPos;
		public  System.Windows.Forms.TextBox txtOpMode;
		private System.Windows.Forms.Label lbOpMode;
		private System.Windows.Forms.Label lbOutFreq;
		public  System.Windows.Forms.TextBox txtOutFreq;
		public DataTable dt=new DataTable("AddrData");
		public DataTable dtInput=new DataTable("InputPoint");
		public System.Windows.Forms.DataGrid gridInput;
		public System.Windows.Forms.DataGrid gridOutput;
		private System.Windows.Forms.Button btnCancel;
		public DataTable dtOutput=new DataTable("OuputPoint");
		public int nCurDoorPos;
		public int nCurFreqOut;
		public int nCurInput;
		public int nCurOutput;
		public int[] nDoorPosArr=new int[MAX_GRAPH_ARR];
		public int[] nFreqOutArr=new int[MAX_GRAPH_ARR];
		public int[] nInputArr=new int[MAX_GRAPH_ARR];
		public int[] nOutputArr=new int[MAX_GRAPH_ARR];
		int GraphInx;
		private System.Windows.Forms.MenuItem mnuSave;
		private System.Windows.Forms.SaveFileDialog saveFileDialog1;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		public System.Windows.Forms.ProgressBar progressBar1;
		private System.Windows.Forms.MenuItem mnuParamDown;
		public const int GRP_BORDER=10;
		public fmParam(Form1 fm)
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			fmParent=fm;
			//
			// TODO: InitializeComponent를 호출한 다음 생성자 코드를 추가합니다.
			//
			dt.Columns.Add(new DataColumn("No",System.Type.GetType("System.String"))); 
			dt.Columns.Add(new DataColumn("항목",System.Type.GetType("System.String"))); 
			dt.Columns.Add(new DataColumn("데이타",System.Type.GetType("System.String"))); 
			dt.Columns.Add(new DataColumn("Unit",System.Type.GetType("System.String")));
			this.gridData.DataSource=dt;
			dtInput.Columns.Add(new DataColumn("입력접점",System.Type.GetType("System.String")));
			dtInput.Columns.Add(new DataColumn("값",System.Type.GetType("System.String")));
			this.gridInput.DataSource=dtInput;
			dtOutput.Columns.Add(new DataColumn("출력접점",System.Type.GetType("System.String")));
			dtOutput.Columns.Add(new DataColumn("값",System.Type.GetType("System.String")));
			this.gridOutput.DataSource=dtOutput;
			
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(fmParam));
			this.picCom = new System.Windows.Forms.PictureBox();
			this.imageList1 = new System.Windows.Forms.ImageList();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuMonitor = new System.Windows.Forms.MenuItem();
			this.mnuSave = new System.Windows.Forms.MenuItem();
			this.mnuParamDown = new System.Windows.Forms.MenuItem();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.progressBar1 = new System.Windows.Forms.ProgressBar();
			this.pnDataIn = new System.Windows.Forms.Panel();
			this.btnCancel = new System.Windows.Forms.Button();
			this.label16 = new System.Windows.Forms.Label();
			this.btnDataIn = new System.Windows.Forms.Button();
			this.txtDataIn = new System.Windows.Forms.TextBox();
			this.gridData = new System.Windows.Forms.DataGrid();
			this.cbGroup = new System.Windows.Forms.ComboBox();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.txtDoorPos = new System.Windows.Forms.TextBox();
			this.lbDoorPos = new System.Windows.Forms.Label();
			this.gridInput = new System.Windows.Forms.DataGrid();
			this.gridOutput = new System.Windows.Forms.DataGrid();
			this.txtOpMode = new System.Windows.Forms.TextBox();
			this.lbOpMode = new System.Windows.Forms.Label();
			this.lbOutFreq = new System.Windows.Forms.Label();
			this.txtOutFreq = new System.Windows.Forms.TextBox();
			this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			// 
			// picCom
			// 
			this.picCom.Location = new System.Drawing.Point(208, 16);
			this.picCom.Size = new System.Drawing.Size(24, 16);
			// 
			// imageList1
			// 
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource"))));
			this.imageList1.Images.Add(((System.Drawing.Image)(resources.GetObject("resource1"))));
			this.imageList1.ImageSize = new System.Drawing.Size(16, 16);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.menuItem1);
			// 
			// menuItem1
			// 
			this.menuItem1.MenuItems.Add(this.mnuMonitor);
			this.menuItem1.MenuItems.Add(this.mnuSave);
			this.menuItem1.MenuItems.Add(this.mnuParamDown);
			this.menuItem1.Text = "파일";
			// 
			// mnuMonitor
			// 
			this.mnuMonitor.Text = "모니터링 종료";
			this.mnuMonitor.Click += new System.EventHandler(this.mnuMonitor_Click);
			// 
			// mnuSave
			// 
			this.mnuSave.Text = "현재 테이블 파일로 저장";
			this.mnuSave.Click += new System.EventHandler(this.mnuSave_Click);
			// 
			// mnuParamDown
			// 
			this.mnuParamDown.Text = "파일에서 Download";
			this.mnuParamDown.Click += new System.EventHandler(this.mnuParamDown_Click);
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabPage1);
			this.tabControl1.Controls.Add(this.tabPage2);
			this.tabControl1.Location = new System.Drawing.Point(8, 24);
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(256, 272);
			this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
			// 
			// tabPage1
			// 
			this.tabPage1.Controls.Add(this.progressBar1);
			this.tabPage1.Controls.Add(this.pnDataIn);
			this.tabPage1.Controls.Add(this.gridData);
			this.tabPage1.Controls.Add(this.cbGroup);
			this.tabPage1.Location = new System.Drawing.Point(4, 21);
			this.tabPage1.Size = new System.Drawing.Size(248, 247);
			this.tabPage1.Text = "Parameter";
			// 
			// progressBar1
			// 
			this.progressBar1.Location = new System.Drawing.Point(40, 152);
			this.progressBar1.Visible = false;
			// 
			// pnDataIn
			// 
			this.pnDataIn.BackColor = System.Drawing.SystemColors.MenuText;
			this.pnDataIn.Controls.Add(this.btnCancel);
			this.pnDataIn.Controls.Add(this.label16);
			this.pnDataIn.Controls.Add(this.btnDataIn);
			this.pnDataIn.Controls.Add(this.txtDataIn);
			this.pnDataIn.Location = new System.Drawing.Point(24, 80);
			this.pnDataIn.Size = new System.Drawing.Size(176, 64);
			this.pnDataIn.Visible = false;
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(104, 5);
			this.btnCancel.Size = new System.Drawing.Size(64, 24);
			this.btnCancel.Text = "Cancel";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// label16
			// 
			this.label16.ForeColor = System.Drawing.SystemColors.ControlLightLight;
			this.label16.Location = new System.Drawing.Point(8, 8);
			this.label16.Text = "Input Data";
			// 
			// btnDataIn
			// 
			this.btnDataIn.Location = new System.Drawing.Point(104, 35);
			this.btnDataIn.Size = new System.Drawing.Size(64, 20);
			this.btnDataIn.Text = "OK";
			this.btnDataIn.Click += new System.EventHandler(this.btnDataIn_Click);
			// 
			// txtDataIn
			// 
			this.txtDataIn.Location = new System.Drawing.Point(8, 32);
			this.txtDataIn.Size = new System.Drawing.Size(80, 21);
			this.txtDataIn.Text = "";
			// 
			// gridData
			// 
			this.gridData.Location = new System.Drawing.Point(0, 32);
			this.gridData.Size = new System.Drawing.Size(240, 208);
			this.gridData.Text = "dataGrid1";
			this.gridData.Click += new System.EventHandler(this.gridData_Click);
			// 
			// cbGroup
			// 
			this.cbGroup.Location = new System.Drawing.Point(0, 8);
			this.cbGroup.Size = new System.Drawing.Size(184, 20);
			this.cbGroup.SelectedIndexChanged += new System.EventHandler(this.cbGroup_SelectedIndexChanged);
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.txtDoorPos);
			this.tabPage2.Controls.Add(this.lbDoorPos);
			this.tabPage2.Controls.Add(this.gridInput);
			this.tabPage2.Controls.Add(this.gridOutput);
			this.tabPage2.Controls.Add(this.txtOpMode);
			this.tabPage2.Controls.Add(this.lbOpMode);
			this.tabPage2.Controls.Add(this.lbOutFreq);
			this.tabPage2.Controls.Add(this.txtOutFreq);
			this.tabPage2.Location = new System.Drawing.Point(4, 21);
			this.tabPage2.Size = new System.Drawing.Size(248, 247);
			this.tabPage2.Text = "Point";
			// 
			// txtDoorPos
			// 
			this.txtDoorPos.Location = new System.Drawing.Point(8, 24);
			this.txtDoorPos.Size = new System.Drawing.Size(56, 21);
			this.txtDoorPos.Text = "";
			// 
			// lbDoorPos
			// 
			this.lbDoorPos.Location = new System.Drawing.Point(8, 8);
			this.lbDoorPos.Size = new System.Drawing.Size(56, 16);
			this.lbDoorPos.Text = "도어위치";
			// 
			// gridInput
			// 
			this.gridInput.Location = new System.Drawing.Point(0, 56);
			this.gridInput.Size = new System.Drawing.Size(104, 184);
			this.gridInput.Text = "dataGrid1";
			// 
			// gridOutput
			// 
			this.gridOutput.Location = new System.Drawing.Point(112, 56);
			this.gridOutput.Size = new System.Drawing.Size(104, 184);
			this.gridOutput.Text = "dataGrid1";
			// 
			// txtOpMode
			// 
			this.txtOpMode.Location = new System.Drawing.Point(80, 24);
			this.txtOpMode.Size = new System.Drawing.Size(56, 21);
			this.txtOpMode.Text = "";
			// 
			// lbOpMode
			// 
			this.lbOpMode.Location = new System.Drawing.Point(80, 8);
			this.lbOpMode.Size = new System.Drawing.Size(56, 16);
			this.lbOpMode.Text = "운전상태";
			// 
			// lbOutFreq
			// 
			this.lbOutFreq.Location = new System.Drawing.Point(147, 8);
			this.lbOutFreq.Size = new System.Drawing.Size(72, 16);
			this.lbOutFreq.Text = "출력주파수";
			// 
			// txtOutFreq
			// 
			this.txtOutFreq.Location = new System.Drawing.Point(152, 24);
			this.txtOutFreq.Size = new System.Drawing.Size(56, 21);
			this.txtOutFreq.Text = "";
			// 
			// saveFileDialog1
			// 
			this.saveFileDialog1.FileName = "doc1";
			// 
			// fmParam
			// 
			this.ClientSize = new System.Drawing.Size(266, 594);
			this.Controls.Add(this.tabControl1);
			this.Controls.Add(this.picCom);
			this.Menu = this.mainMenu1;
			this.Text = "fmParam";
			this.Closing += new System.ComponentModel.CancelEventHandler(this.fmParam_Closing);
			this.Load += new System.EventHandler(this.fmParam_Load);
			this.Paint += new System.Windows.Forms.PaintEventHandler(this.fmParam_Paint);

		}
		#endregion

		private void fmParam_Load(object sender, System.EventArgs e)
		{
			uint groupInx;
			for(int i=0;i<fmParent.m_tableList.Count;i++)
			{
				DataTable dtParam=(DataTable)fmParent.m_tableList[i];
				string strGroupInx=(string)dtParam.Rows[0]["Group_inx"];
				strGroupInx=strGroupInx.Trim();
				groupInx=Convert.ToUInt32(strGroupInx,16);
				if(groupInx>10)
				{
					try
					{
						string sDes=(string)dtParam.Rows[0]["Group_des"];
						sDes=sDes.Trim();
						string sId=(string)dtParam.Rows[0]["Group_id"];
						sId=sId.Trim();
						this.cbGroup.Items.Add(sDes+"("+sId+")");
					}
					catch(Exception e1)
					{
						MessageBox.Show(e1.Message);
					}
				}
				else if(groupInx==0) //입력접점 Table
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
			
			this.cbGroup.SelectedIndex=0;


			DataGridTableStyle ts = new DataGridTableStyle();

			// Set the DataGridTableStyle.MappingName property
			// to the table in the data source to map to.
			ts.MappingName = this.gridData.DataSource.ToString();
		
			// Add it to the datagrid's TableStyles collection
			gridData.TableStyles.Add(ts);

			// Hide the first column (index 0)
			gridData.TableStyles[0].GridColumnStyles[0].Width = 20;
			gridData.TableStyles[0].GridColumnStyles[1].Width = 100;
			gridData.TableStyles[0].GridColumnStyles[2].Width = 50;
			gridData.TableStyles[0].GridColumnStyles[3].Width = 30;
		}

		private void cbGroup_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			fmParent.m_wIndex=0;
			DataTable dtGroup=(DataTable)fmParent.m_tableList[cbGroup.SelectedIndex];
			if(cbGroup.SelectedIndex==0 && cbGroup.SelectedIndex==3)
			{
				this.mnuParamDown.Enabled=false;
			}
			else
				this.mnuParamDown.Enabled=true;

			dt.Rows.Clear();
			
			for(int i=0;i<dtGroup.Rows.Count;i++)
			{
				string strDes=(string)dtGroup.Rows[i]["Description"];
				strDes=strDes.Trim();
				string strAddr=(string)dtGroup.Rows[i]["Group_inx"];
				strAddr=strAddr.Trim();

				string strUnit;
				try
				{
					strUnit=(string)dtGroup.Rows[i]["Unit"];
				}
				catch
				{
					strUnit="";
				}
				strUnit=strUnit.Trim();
				int inx=i+1;
				dt.Rows.Add(new object[]{inx.ToString(),strDes,"",strUnit});
			}
		}

		private void mnuMonitor_Click(object sender, System.EventArgs e)
		{
			fmParent.state=Form1.STATUS.NORMAL;
			this.Close();
		}

		private void gridData_Click(object sender, System.EventArgs e)
		{
			try
			{
				if((this.cbGroup.SelectedIndex==1 || this.cbGroup.SelectedIndex==2) && gridData.CurrentCell.ColumnNumber.Equals(2)) //데이타 부분을 선택했으면
				{
					pnDataIn.Visible=true;
					m_curRow=gridData.CurrentCell.RowNumber;
					this.txtDataIn.Text=(string)dt.Rows[m_curRow]["데이타"];
					txtDataIn.Focus();
				}
			}
			finally
			{}

		}

		private void btnDataIn_Click(object sender, System.EventArgs e)
		{
			dt.Rows[m_curRow]["데이타"]=this.txtDataIn.Text;
			if(this.txtDataIn.Text.Length>0)
				m_sSetData[m_iSetDataIdx++]=this.txtDataIn.Text;
			pnDataIn.Visible=false;
		}

		private void fmParam_Closing(object sender, System.ComponentModel.CancelEventArgs e)
		{
		}

		private void tabControl1_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			
			fmParent.m_wIndex=0;
		}

		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			pnDataIn.Visible=false;
		}

		public void AddData()
		{
		}

		private void fmParam_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
		{
		}

		public void DrawGrpFrame()
		{
		}

		private void mnuSave_Click(object sender, System.EventArgs e)
		{
			string str;
			this.saveFileDialog1.ShowDialog();
			m_fileName=this.saveFileDialog1.FileName;
			DataTable dtSave=(DataTable)fmParent.m_tableList[cbGroup.SelectedIndex];
			using (StreamWriter sw = new StreamWriter(m_fileName)) 
			{
				for(int i=0;i<dtSave.Rows.Count;i++)
				{
					str=(string)dtSave.Rows[i]["Group_inx"];
					str+="^"+(string)dtSave.Rows[i]["index"];
					str+="^"+(string)dtSave.Rows[i]["Description"];
					str+="^"+(string)dtSave.Rows[i]["Data"];
					sw.WriteLine(str);
				}
			}			
		}

		private void mnuParamDown_Click(object sender, System.EventArgs e)
		{
			string str;
			this.openFileDialog1.ShowDialog();
			if(openFileDialog1.FileName.Length<=0)
				return;
			m_fileName=this.openFileDialog1.FileName;
			DataTable dtGroup=(DataTable)fmParent.m_tableList[cbGroup.SelectedIndex];
			this.progressBar1.Visible=true;
			this.progressBar1.Maximum=dtGroup.Rows.Count;
			uint sendAddr;
			uint sendData;
			using (StreamReader sr=new StreamReader(m_fileName))
			{	
				int wIndex=0;
				while ((str = sr.ReadLine()) != null) 
				{
					str=str.Trim();
					string[] strArr=str.Split('^');
					sendAddr=0;
					try
					{
						string strAddr=strArr[0];
						strAddr=strAddr.Trim();
						sendAddr=Convert.ToUInt32(strAddr,16)<<8;
					}
					catch
					{
						MessageBox.Show("Group_inx Err: "+strArr[0]);
					}
					string strIndex=strArr[1];
					strIndex=strIndex.Trim();
					sendAddr+=Convert.ToUInt32(strIndex,10);

					//float fDataIn=float.Parse(param.m_sSetData[param.m_iSetDataIdx-1]);
					sendData=uint.Parse(strArr[3].Trim());
					fmParent.addrDown[fmParent.downWp]=sendAddr;
					fmParent.dataDown[fmParent.downWp]=sendData;
					fmParent.downWp++;
				}
			}
		}
	}
}
