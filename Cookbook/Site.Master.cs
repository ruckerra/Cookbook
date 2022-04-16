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
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie c = Request.Cookies.Get("active_user_uid");
            if (c != null)
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
        
    }
}