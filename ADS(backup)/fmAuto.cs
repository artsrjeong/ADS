using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmAuto�� ���� ��� �����Դϴ�.
	/// </summary>
	public class fmAuto : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.Label label1;
	
		public fmAuto()
		{
			//
			// Windows Form �����̳� ������ �ʿ��մϴ�.
			//
			InitializeComponent();

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
			this.label1.Text = "���� �������� ���";
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
