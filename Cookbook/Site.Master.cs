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
            SiteMaster.Check_Authority(ref c);
            c = Request.Cookies.Get("active_user_uid");
            if (c != null)
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    string q = "SELECT user_uid FROM users WHERE user_uid = @uuid AND admin = 0";
                    SqlCommand cmd = new SqlCommand(q, conn);
                    cmd.Parameters.AddWithValue("@uuid", c.Value);
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (!sdr.HasRows)
                    {
                        Response.Cookies.Get("active_user_uid").Expires = DateTime.Now.AddDays(-1);
                        active_user_uid.Text = "[NULL]";
                    }
                    else
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

        public static void Check_Authority(ref HttpCookie c)
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
                        c = null;
                        conn.Close();
                    }
                }
            }
            if (System.Web.HttpContext.Current.Session["Admin"] != null)
            {
                using (conn)
                {
                    SqlCommand cmd = new SqlCommand("SELECT admin FROM users WHERE user_uid = @uuid AND admin = 1", conn);
                    cmd.Parameters.AddWithValue("@uuid", System.Web.HttpContext.Current.Session["Admin"].ToString());
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (!sdr.HasRows)
                    {
                        System.Web.HttpContext.Current.Session.Remove("Admin");
                        conn.Close();
                    }
                }
            }
        }

    }
}