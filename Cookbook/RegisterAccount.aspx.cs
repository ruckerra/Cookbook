using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;

namespace Cookbook
{
    public partial class RegisterAccount : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Login.aspx");
        }

        protected void BtnCreateAccount_Click(object sender, EventArgs e)
        {
            
            using (SqlConnection conn = new SqlConnection()) {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd;
                string qry = null;
                bool[] rtrn = Solicitation(conn, TxtbxRegUsername.Text, TxtbxRegEmail.Text);
                usernameReject.Visible = false;
                emailReject.Visible = false;
                if (rtrn[0] || rtrn[1])
                {
                    if (rtrn[0])
                    {
                        usernameReject.Visible = true;
                    }
                    if (rtrn[1])
                    {
                        emailReject.Visible = true;
                    }
                    Console.WriteLine("No action was taken");
                    return;
                }//if
                else
                {
                    try
                    {
                        qry = "INSERT INTO users(user_uid, first_name, last_name, username, date_reg) VALUES (NEWID(), @first_name, @last_name, @username, (SELECT CONVERT(DATE, GETDATE())))";
                        cmd = new SqlCommand(qry, conn);
                        cmd.Parameters.AddWithValue("@first_name","Tmp_First_Name");
                        cmd.Parameters.AddWithValue("@last_name", "Tmp_Last_Name");
                        cmd.Parameters.AddWithValue("@username", TxtbxRegUsername.Text);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                        cmd.Dispose();

                        
                        qry = "INSERT INTO user_details(user_uid, username, email, password) VALUES((SELECT user_uid FROM users WHERE username = @username),@username,@email,@password)";
                        cmd = new SqlCommand(qry, conn);
                        cmd.Parameters.AddWithValue("@username", TxtbxRegUsername.Text);
                        cmd.Parameters.AddWithValue("@email", TxtbxRegEmail.Text);
                        cmd.Parameters.AddWithValue("@password", TxtbxRegPassword.Text);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Failure to open connection.");
                        throw ex;
                    }
                }//else
            }//using

            //TODO: Insert then redirect to login

            Response.Redirect("~/Login.aspx");

        }//Button Create Account Click


        protected bool[] Solicitation(SqlConnection conn, string solicit_username, string solicit_email) {
            string qry = "SELECT username FROM user_details WHERE username = @username";
            string qry2 = "SELECT email FROM user_details WHERE email = @email";
            SqlCommand cmd = new SqlCommand(qry, conn);
            SqlCommand cmd2 = new SqlCommand(qry2, conn);
            cmd.Parameters.AddWithValue("@username", solicit_username);
            cmd2.Parameters.AddWithValue("@email", solicit_email);
            try
            {
                conn.Open();
                object objUsr = cmd.ExecuteScalar();
                object objEml = cmd2.ExecuteScalar();
                conn.Close();

                bool[] rtrn = new bool[] {
                    objUsr != null ? objUsr.ToString() == solicit_username : false,
                    objEml != null ? objEml.ToString() == solicit_email : false
                };

                return rtrn;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failure to open connection");
                throw ex;
            }
        }//Check Existance

    }//Class

}//Namespace