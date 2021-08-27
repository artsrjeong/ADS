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
	/// fmTcd�� ���� ��� �����Դϴ�.
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
			// Windows Form �����̳� ������ �ʿ��մϴ�.
			//
			InitializeComponent();
			fmParent=fm;
			//
			// TODO: InitializeComponent�� ȣ���� ���� ������ �ڵ带 �߰��մϴ�.
			//
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
			this.txtTcd.Text = "TCD CODE�� �����ϼ���";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 8);
			this.label1.Size = new System.Drawing.Size(96, 16);
			this.label1.Text = "TCD �׸�";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 92);
			this.label2.Size = new System.Drawing.Size(160, 16);
			this.label2.Text = "TCD ���� ���� �� ó��";
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

				DataRow row=dtTcd.NewRow();//�ϴ� ���� �ϳ� �����.
				while(reader.Read())
				{
					switch(reader.NodeType)
					{
						case XmlNodeType.Element:
							name=reader.Name;
							break;
						case XmlNodeType.Text:
							//���� �ͼ� Value �κ��� ���� �ٲ� ���� üũ�ϴ� ������ �ٲ� ��
							try
							{
								row[name]=reader.Value;	  //���� ����Ÿ �Է�
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
