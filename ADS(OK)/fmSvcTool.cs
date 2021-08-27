using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmSvcTool�� ���� ��� �����Դϴ�.
	/// </summary>
	public class fmSvcTool : System.Windows.Forms.Form
	{
		Form1 fmParent;
		private System.Windows.Forms.ListBox listBox1;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.MainMenu mainMenu1;
		private System.Windows.Forms.MenuItem menuItem1;
		private System.Windows.Forms.MenuItem mnuSvcTool;
		Button[] btn=new Button[16];
		public fmSvcTool(Form1 fm)
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
			this.listBox1 = new System.Windows.Forms.ListBox();
			this.button1 = new System.Windows.Forms.Button();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.mnuSvcTool = new System.Windows.Forms.MenuItem();
			// 
			// listBox1
			// 
			this.listBox1.Font = new System.Drawing.Font("����ü", 12F, System.Drawing.FontStyle.Bold);
			this.listBox1.Items.Add("1234567890");
			this.listBox1.Items.Add("abcdefghij\t");
			this.listBox1.Items.Add("ABCDEFGHIJ");
			this.listBox1.Items.Add("!@#$%^&*()");
			this.listBox1.Location = new System.Drawing.Point(24, 8);
			this.listBox1.Size = new System.Drawing.Size(194, 82);
			// 
			// button1
			// 
			this.button1.Font = new System.Drawing.Font("����", 12F, System.Drawing.FontStyle.Bold);
			this.button1.Location = new System.Drawing.Point(216, 272);
			this.button1.Size = new System.Drawing.Size(24, 32);
			this.button1.Text = "button1";
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.Add(this.menuItem1);
			// 
			// menuItem1
			// 
			this.menuItem1.MenuItems.Add(this.mnuSvcTool);
			this.menuItem1.Text = "����";
			// 
			// mnuSvcTool
			// 
			this.mnuSvcTool.Text = "������ ����";
			this.mnuSvcTool.Click += new System.EventHandler(this.mnuSvcTool_Click);
			// 
			// fmSvcTool
			// 
			this.ClientSize = new System.Drawing.Size(242, 326);
			this.Controls.Add(this.button1);
			this.Controls.Add(this.listBox1);
			this.Menu = this.mainMenu1;
			this.Text = "fmSvcTool";
			this.Load += new System.EventHandler(this.fmSvcTool_Load);

		}
		#endregion

		private void fmSvcTool_Load(object sender, System.EventArgs e)
		{
			
			for(int i=0;i<4;i++)
				for(int j=0;j<4;j++)
			{
				int inx=i*4+j;
				btn[inx]=new Button();
				btn[inx].Text=string.Format("{0:X}",inx);
				btn[inx].Left=j*50+listBox1.Left;
				btn[inx].Top=i*45+listBox1.Top+listBox1.Height+5;
				btn[inx].Width=46;
				btn[inx].Height=40;
				btn[inx].Font = new System.Drawing.Font("����", 12F, System.Drawing.FontStyle.Bold);
				btn[inx].Parent=this;
				btn[inx].Click += new System.EventHandler(this.btn_Click);
			}
		}

		private void btn_Click(object sender, System.EventArgs e)
		{
			for(int i=0;i<16;i++)
			{
				if(btn[i].Equals(sender))
				{
					MessageBox.Show(i.ToString());
					break;
				}
			}
		}

		private void mnuSvcTool_Click(object sender, System.EventArgs e)
		{
			fmParent.state=Form1.STATUS.NORMAL;
			this.Close();
		}
		
	}
}
