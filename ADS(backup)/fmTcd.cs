using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Xml;


namespace ADS
{
	/// <summary>
	/// fmTcd에 대한 요약 설명입니다.
	/// </summary>
	public class fmTcd : System.Windows.Forms.Form
	{
		private System.Windows.Forms.ListBox lstTCD;
		private System.Windows.Forms.TextBox txtTcd;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		public Form1 fmParent;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem mnuExit;	
		DataTable dtTcd=new DataTable("TCD");
		public fmTcd(Form1 fm)
		{
			//
			// Windows Form 디자이너 지원에 필요합니다.
			//
			InitializeComponent();
			fmParent=fm;
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
			this.lstTCD = new System.Windows.Forms.ListBox();
			this.txtTcd = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.mnuExit = new System.Windows.Forms.MenuItem();
			// 
			// lstTCD
			// 
			this.lstTCD.Location = new System.Drawing.Point(8, 24);
			this.lstTCD.Size = new System.Drawing.Size(200, 62);
			this.lstTCD.SelectedIndexChanged += new System.EventHandler(this.lstTCD_SelectedIndexChanged);
			// 
			// txtTcd
			// 
			this.txtTcd.Location = new System.Drawing.Point(8, 112);
			this.txtTcd.Multiline = true;
			this.txtTcd.Size = new System.Drawing.Size(200, 160);
			this.txtTcd.Text = "TCD CODE를 선택하세요";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 8);
			this.label1.Size = new System.Drawing.Size(96, 16);
			this.label1.Text = "TCD 항목";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 92);
			this.label2.Size = new System.Drawing.Size(160, 16);
			this.label2.Text = "TCD 검출 조건 및 처리";
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.mnuExit);
			// 
			// mnuExit
			// 
			this.mnuExit.Text = "Exit";
			this.mnuExit.Click += new System.EventHandler(this.mnuExit_Click);
			// 
			// fmTcd
			// 
			this.ClientSize = new System.Drawing.Size(218, 302);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.txtTcd);
			this.Controls.Add(this.lstTCD);
			this.Controls.Add(this.label2);
			this.Menu = this.mainMenu1;
			this.Text = "B";
			this.Load += new System.EventHandler(this.fmTcd_Load);

		}
		#endregion

		private void fmTcd_Load(object sender, System.EventArgs e)
		{
			TcdRead();
		}

		public void TcdRead()
		{
			string name="";
			dtTcd.Columns.Add(new DataColumn("TCD_CODE",System.Type.GetType("System.String")));
			dtTcd.Columns.Add(new DataColumn("TCD_CONTENT",System.Type.GetType("System.String")));
			dtTcd.Columns.Add(new DataColumn("TCD_REF",System.Type.GetType("System.String")));
			XmlTextReader reader;
			
			try
			{
				if(fmParent.m_bPdaMode)
					reader=new XmlTextReader("\\TCD.xml");
				else
					reader=new XmlTextReader("TCD.xml");

				DataRow row=dtTcd.NewRow();//일단 행을 하나 만든다.
				while(reader.Read())
				{
					switch(reader.NodeType)
					{
						case XmlNodeType.Element:
							name=reader.Name;
							break;
						case XmlNodeType.Text:
							//내일 와서 Value 부분의 값이 바뀐 것을 체크하는 것으로 바꿀 것
							try
							{
								row[name]=reader.Value;	  //실제 데이타 입력
							}
							catch
							{
								MessageBox.Show("Xml Insert Error");
							}
							if(name.Equals("TCD_REF"))
							{
								dtTcd.Rows.Add(row);
								row=dtTcd.NewRow();
							}
							break;
					}
				}
				reader.Close();
			}
			catch
			{
				
			}
			foreach(DataRow row in dtTcd.Rows)
			{
				this.lstTCD.Items.Add((string)row["TCD_CODE"]+ " ("+(string)row["TCD_CONTENT"]+")");
			}

		}

		private void lstTCD_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int selectInx=this.lstTCD.SelectedIndex;
			string strTcdRef=(string)dtTcd.Rows[selectInx]["TCD_REF"];
			this.txtTcd.Text=strTcdRef;
		}

		private void mnuExit_Click(object sender, System.EventArgs e)
		{
			this.Close();
		}
	}
}
