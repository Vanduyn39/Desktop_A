﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Gaming_Dashboard
{
    public partial class DoiMatKhau : UserControl
    {
        
        public DoiMatKhau()
        {
            InitializeComponent();

        }
        private static DoiMatKhau _instance;
        public static DoiMatKhau Instance
        {
            get
            {
                if (_instance == null)
                    _instance = new DoiMatKhau();
                return _instance;
            }
        }

        private void guna2PictureBox2_Click(object sender, EventArgs e)
        {

        }

        private void guna2Button2_Click(object sender, EventArgs e)
        {

        }
    }
}
