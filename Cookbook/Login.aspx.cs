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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/RegisterAccount.aspx");
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) { 
                reject.Visible = false;
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    string q = "SELECT user_uid FROM user_details WHERE (LOWER(username) = LOWER(@user) AND password = @password) OR (LOWER(email) = LOWER(@user) AND password = @password)";
                    try
                    {
                        SqlCommand cmd = new SqlCommand(q, conn);
                        cmd.Parameters.AddWithValue("@user", TxtbxIdentifier.Text);
                        cmd.Parameters.AddWithValue("@password", TxtbxPassword.Text);
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (!sdr.HasRows)
                        {
                            reject.Visible = true;
                            conn.Close();
                            return;
                        }
                        else
                        {
                            sdr.Read();
                            if(Request.Cookies.Get("active_user_uid") == null || !(Request.Cookies.Get("active_user_uid").Value == sdr["user_uid"].ToString()))
                            {
                                HttpCookie c = new HttpCookie("active_user_uid");
                                c.Value = sdr["user_uid"].ToString();
                                Response.Cookies.Add(c);
                            }
                            conn.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Failure to open connection");
                        throw ex;
                    }
                }
                Response.Redirect("~/LandingPage.aspx", true);
                //Manual refresh to update master user_uid
            }
        }//submit
    }//class
}//namespace