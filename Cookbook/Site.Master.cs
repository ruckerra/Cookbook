using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Configuration;

namespace Cookbook
{

    public partial class SiteMaster : MasterPage
    {
        HttpCookie c = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            Check_Authority();
            c = Request.Cookies.Get("active_user_uid");
            if(Session["Admin"] != null)
            {
                active_user_uid.Text = Session["Admin"].ToString();
            }
            else if (c != null)
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    string q = "SELECT user_uid FROM users WHERE user_uid = @uuid";
                    SqlCommand cmd = new SqlCommand(q, conn);
                    cmd.Parameters.AddWithValue("@uuid", c.Value);
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (!sdr.HasRows)
                    {
                        Response.Cookies.Get("active_user_uid").Expires = DateTime.Now.AddDays(-1);
                        active_user_uid.Text = "[NULL]";
                    } else
                    {
                        active_user_uid.Text = c.Value;
                    }
                    conn.Close();
                }
                
            }
            else
            {
                active_user_uid.Text = "[NULL]";
            }
        }

        private void Check_Authority()
        {
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
            if (c != null)
            {
                using (conn)
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM users WHERE user_uid = @uuid AND admin = 1", conn);
                    cmd.Parameters.AddWithValue("@uuid", c.Value);
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (sdr.HasRows)
                    {
                        c.Expires = DateTime.Now.AddDays(-1);
                        conn.Close();
                    }
                }
            }
            if (Session["Admin"] != null)
            {
                using (conn)
                {
                    SqlCommand cmd = new SqlCommand("SELECT admin FROM users WHERE user_uid = @uuid AND admin = 1", conn);
                    cmd.Parameters.AddWithValue("@uuid", Session["Admin"].ToString());
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (!sdr.HasRows)
                    {
                        Session.Remove("Admin");
                        conn.Close();
                    }
                }
            }
        }

    }
}