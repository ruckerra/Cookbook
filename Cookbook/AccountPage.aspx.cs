using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Configuration;
using System.Text;
using System.IO;

namespace Cookbook
{
    public partial class AccountPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if(Request.Cookies.Get("active_user_uid") == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            
            string img_path = null;
            bool admin = false;
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                string q = "SELECT * FROM users INNER JOIN user_details ON users.user_uid = user_details.user_uid WHERE users.user_uid = @uuid";
                SqlCommand cmd = new SqlCommand(q, conn);
                cmd.Parameters.AddWithValue("@uuid",Request.Cookies.Get("active_user_uid").Value);
                conn.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read()) { 
                        img_path = sdr["user_image_path"].ToString();
                    }
                }
                admin = sdr["verified"].ToString() == "True";
                StringBuilder sb = new StringBuilder();
                sb.Append("<img class=\"float-left\" src ='/Content/Images/");
                img_path = img_path == null || img_path == "" ? "Default/" + "avatar.png" : "Avatars/"  + img_path;
                sb.Append(img_path);
                sb.Append("' style=\"vertical-align:middle;border-radius:50%;width:300px;height:300px;position:relative;overflow:hidden;margin-left:-25%\">");
                user_img.Text = sb.ToString();

                sb.Clear();

                sb.Append("<h1>");
                sb.Append(sdr["username"]);
                sb.Append("</h1>");
                if(Request.Cookies.Get("active_user_uid") != null && Request.Cookies.Get("active_user_uid").Value == sdr["user_uid"].ToString())
                {
                    sb.Append("<h3>");
                    sb.Append(sdr["email"].ToString());
                    sb.Append("</h3>");
                }
                user_info.Text = sb.ToString();
                conn.Close();
            }//using
            if (Request.Cookies.Get("active_user_uid") != null)
            {
                btnSignOut.Visible = true;
                btnOp.Visible = admin;
            }
            else
            {
                btnSignOut.Visible = false;
                btnOp.Visible = false;
            }
        }//page_load

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            if (Request.Cookies.Get("active_user_uid") != null)
            {
                Response.Cookies.Get("active_user_uid").Expires = DateTime.Now.AddDays(-1);
                btnSignOut.Visible = false;
                Response.Redirect("~/Login.aspx");
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string img_path = null;
            if (fuUserImage.HasFile)
            {
                img_path = fuUserImage.FileName;
                string[] ch_ext = img_path.Split('.');
                string s = ch_ext[ch_ext.Length - 1];
                s = s.ToLower();
                string username = null;
                FileInfo prev_img = null;
                if (s == "png" || s == "gif" || s == "jpg" || s == "jpeg" || s == "webp" || s == "svg")
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand("SELECT username, user_image_path FROM users WHERE user_uid = @uuid", conn);
                        cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        sdr.Read();
                        username = sdr["username"].ToString();
                        prev_img = new FileInfo(Server.MapPath(Request.ApplicationPath) + "/Content/Images/Avatars/" + sdr["user_image_path"].ToString());
                        conn.Close();
                    }
                    img_path = username + "." + s;
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand("UPDATE users SET user_image_path = @img WHERE user_uid = @uuid", conn);
                        cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                        cmd.Parameters.AddWithValue("@img", img_path);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                    if (prev_img.Exists)
                    {
                        prev_img.Delete();
                    }
                    fuUserImage.SaveAs(Server.MapPath(Request.ApplicationPath) + "Content/Images/Avatars/" + img_path);
                }
            }
            Response.Redirect("~/AccountPage.aspx");
        }

        protected void btnOp_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ViewUsers.aspx");
        }
    }//class
}//namespace