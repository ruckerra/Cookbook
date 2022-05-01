using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Configuration;
using System.Web.Security;

namespace Cookbook
{
    public partial class Login : System.Web.UI.Page
    {
        HttpCookie c = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            c = Request.Cookies.Get("active_user_uid");
            SiteMaster.Check_Authority(ref c);
            if (c != null || Session["Admin"] != null)
            {
                Response.Redirect("~/AccountPage.aspx");
            }
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
                    string q = "SELECT user_details.user_uid, users.admin FROM (user_details LEFT OUTER JOIN users ON user_details.user_uid = users.user_uid) WHERE (LOWER(user_details.username) = LOWER(@user) AND password = @password) OR (LOWER(email) = LOWER(@user) AND password = @password)";
                    try
                    {
                        SqlCommand cmd = new SqlCommand(q, conn);
                        cmd.Parameters.AddWithValue("@user", TxtbxIdentifier.Text.Trim());
                        cmd.Parameters.AddWithValue("@password", FormsAuthentication.HashPasswordForStoringInConfigFile(TxtbxPassword.Text.Trim(), "SHA256"));
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
                            if (sdr["admin"].ToString() == "True")
                            {
                                if (c != null)
                                {
                                    c.Expires = DateTime.Now.AddDays(-1);
                                }
                                Session["Admin"] = sdr["user_uid"].ToString();
                            }
                            else if (c == null || !(c.Value == sdr["user_uid"].ToString()))
                            {
                                HttpCookie nc = new HttpCookie("active_user_uid");
                                nc.Value = sdr["user_uid"].ToString();
                                Response.Cookies.Add(nc);
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