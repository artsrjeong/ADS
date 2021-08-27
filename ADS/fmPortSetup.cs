using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace ADS
{
	/// <summary>
	/// fmPortSetup에 대한 요약 설명입니다.
	/// </summary>
	public class fmPortSetup : System.Windows.Forms.Form
	{
		public System.Windows.Forms.ComboBox cbPortName;
		public System.Windows.Forms.ComboBox cbBaudRate;
		public System.Windows.Forms.ComboBox cbDataBit;
		public System.Windows.Forms.ComboBox cbParity;
		public System.Windows.Forms.ComboBox cbStopBits;
		public System.Windows.Forms.ComboBox cbFlowControl;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Button btnOK;
		public System.Windows.Forms.CheckBox ckReUse;
		Form1 fmParent;
	
		public void SetParent(Form1 fm)
		{
			fmParent=fm;
		}

		public fmPortSetup()
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
			this.cbPortName = new System.Windows.Forms.ComboBox();
			this.cbBaudRate = new System.Windows.Forms.ComboBox();
			this.cbDataBit = new System.Windows.Forms.ComboBox();
			this.cbParity = new System.Windows.Forms.ComboBox();
			this.cbStopBits = new System.Windows.Forms.ComboBox();
			this.cbFlowControl = new System.Windows.Forms.ComboBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.btnOK = new System.Windows.Forms.Button();
			this.ckReUse = new System.Windows.Forms.CheckBox();
			// 
			// cbPortName
			// 
			this.cbPortName.Location = new System.Drawing.Point(112, 16);
			this.cbPortName.Size = new System.Drawing.Size(100, 20);
			// 
			// cbBaudRate
			// 
			this.cbBaudRate.Items.Add("2400");
			this.cbBaudRate.Items.Add("4800");
			this.cbBaudRate.Items.Add("9600");
			this.cbBaudRate.Items.Add("19200");
			this.cbBaudRate.Items.Add("38400");
			this.cbBaudRate.Items.Add("57600");
			this.cbBaudRate.Items.Add("115200");
			this.cbBaudRate.Items.Add("230400");
			this.cbBaudRate.Location = new System.Drawing.Point(112, 48);
			this.cbBaudRate.Size = new System.Drawing.Size(100, 20);
			// 
			// cbDataBit
			// 
			this.cbDataBit.Items.Add("5");
			this.cbDataBit.Items.Add("6");
			this.cbDataBit.Items.Add("7");
			this.cbDataBit.Items.Add("8");
			this.cbDataBit.Location = new System.Drawing.Point(112, 80);
			this.cbDataBit.Size = new System.Drawing.Size(100, 20);
			// 
			// cbParity
			// 
			this.cbParity.Items.Add("None");
			this.cbParity.Items.Add("Odd");
			this.cbParity.Items.Add("Even");
			this.cbParity.Items.Add("Mark");
			this.cbParity.Items.Add("Space");
			this.cbParity.Location = new System.Drawing.Point(112, 112);
			this.cbParity.Size = new System.Drawing.Size(100, 20);
			// 
			// cbStopBits
			// 
			this.cbStopBits.Items.Add("1");
			this.cbStopBits.Items.Add("1.5");
			this.cbStopBits.Items.Add("2");
			this.cbStopBits.Location = new System.Drawing.Point(112, 144);
			this.cbStopBits.Size = new System.Drawing.Size(100, 20);
			// 
			// cbFlowControl
			// 
			this.cbFlowControl.Items.Add("None");
			this.cbFlowControl.Items.Add("XOnXOff");
			this.cbFlowControl.Items.Add("Hardware");
			this.cbFlowControl.Location = new System.Drawing.Point(112, 176);
			this.cbFlowControl.Size = new System.Drawing.Size(100, 20);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 16);
			this.label1.Size = new System.Drawing.Size(80, 20);
			this.label1.Text = "Port";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(8, 48);
			this.label2.Size = new System.Drawing.Size(80, 20);
			this.label2.Text = "BaudRate";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 80);
			this.label3.Size = new System.Drawing.Size(80, 20);
			this.label3.Text = "DataBit";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(8, 112);
			this.label4.Size = new System.Drawing.Size(80, 20);
			this.label4.Text = "Parity";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(8, 144);
			this.label5.Size = new System.Drawing.Size(80, 20);
			this.label5.Text = "StopBits";
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(8, 176);
			this.label6.Size = new System.Drawing.Size(80, 20);
			this.label6.Text = "FlowControl";
			// 
			// btnOK
			// 
			this.btnOK.Location = new System.Drawing.Point(8, 216);
			this.btnOK.Size = new System.Drawing.Size(88, 32);
			this.btnOK.Text = "OK";
			this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
			// 
			// ckReUse
			// 
			this.ckReUse.Location = new System.Drawing.Point(104, 224);
			this.ckReUse.Size = new System.Drawing.Size(128, 20);
			this.ckReUse.Text = "ReUse Next Time";
			// 
			// fmPortSetup
			// 
			this.ClientSize = new System.Drawing.Size(234, 287);
			this.Controls.Add(this.ckReUse);
			this.Controls.Add(this.btnOK);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.cbPortName);
			this.Controls.Add(this.cbBaudRate);
			this.Controls.Add(this.cbDataBit);
			this.Controls.Add(this.cbParity);
			this.Controls.Add(this.cbStopBits);
			this.Controls.Add(this.cbFlowControl);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.label5);
			this.Controls.Add(this.label6);
			this.Text = "fmPortSetup";
			this.Load += new System.EventHandler(this.fmPortSetup_Load);

		}
		#endregion

		private void fmPortSetup_Load(object sender, System.EventArgs e)
		{
		
		}

		private void btnOK_Click(object sender, System.EventArgs e)
		{
			fmParent.m_portName=this.cbPortName.Text;
			fmParent.m_baudRate=this.cbBaudRate.Text;
			fmParent.m_dataBit=this.cbDataBit.Text;
			fmParent.m_parity=this.cbParity.Text;
			fmParent.m_stopBits=this.cbStopBits.Text;
			fmParent.m_flowControl=this.cbFlowControl.Text;
			if(this.ckReUse.Checked)
				fmParent.m_reUse="true";
			else
				fmParent.m_reUse="false";
			this.Close();
		}
	}
}
