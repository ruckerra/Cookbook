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
            reject.Visible = false;
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                string qry = "SELECT user_uid FROM user_details WHERE {0} = {1} AND password = @password" ;
                try
                {
                    SqlCommand cmd = new SqlCommand(String.Format(qry, "username", "@username"), conn);
                    cmd.Parameters.AddWithValue("@username", TxtbxIdentifier.Text);
                    cmd.Parameters.AddWithValue("@password", TxtbxPassword.Text);
                    conn.Open();
                    object objUsr = cmd.ExecuteScalar();
                    conn.Close();
                    if (objUsr == null)
                    {
                        cmd.Dispose();
                        cmd = new SqlCommand(String.Format(qry, "email", "@email"), conn);
                        cmd.Parameters.AddWithValue("@email", TxtbxIdentifier.Text.ToLower());
                        cmd.Parameters.AddWithValue("@password", TxtbxPassword.Text);
                        conn.Open();
                        objUsr = cmd.ExecuteScalar();
                        conn.Close();
                    }
                    if (objUsr != null)
                    {
                        #region Temp_Cookie
                        SiteMaster.session_uid = objUsr.ToString();
                        #endregion
                        Response.Redirect("~/LandingPage.aspx", true);
                    } else {
                        reject.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Failure to open connection");
                    throw ex;
                }
            }
            //Manual refresh to update master user_uid
        }//submit
    }//class
}//namespace