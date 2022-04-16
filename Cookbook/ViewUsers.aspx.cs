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
    public partial class ViewUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.Cookies.Get("active_user_uid") != null)
            {
                using(SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    //TODO: Get user_uid WHERE verified = 1
                    string q = "SELECT verified FROM users WHERE user_uid = @uuid";
                    SqlCommand cmd = new SqlCommand(q,conn);
                    cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (sdr.HasRows)
                    {
                        if (sdr.Read())
                        {
                            if (sdr["verified"].ToString() == "True")
                            {
                                if (!Page.IsPostBack)
                                {
                                    BindRecipeList();
                                }
                                return;
                            }
                        }
                    }
                    conn.Close();
                }
            }
            Response.Redirect("~/LandingPage.aspx");
        }
        private void BindRecipeList()
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;

                SqlDataAdapter sda = new SqlDataAdapter();
                DataTable dt = new DataTable();
                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "SELECT users.user_uid, users.username, user_details.email, users.date_reg FROM (users INNER JOIN user_details ON users.user_uid = user_details.user_uid) ORDER BY date_reg DESC";
                cmd.Connection = conn;
                sda.SelectCommand = cmd;

                conn.Open();
                sda.Fill(dt);

                gvDisplayUsers.DataSource = dt;
                gvDisplayUsers.DataBind();


            }
        }

        protected void gvDisplayUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Button deleteButton = e.Row.FindControl("btnDelete") as Button;
                if (Request.Cookies.Get("active_user_uid") == null || (gvDisplayUsers.DataKeys[e.Row.RowIndex].Value).ToString() == Request.Cookies.Get("active_user_uid").Value)
                {
                    deleteButton.Enabled = false;
                    
                } else
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        string q = "SELECT verified FROM users WHERE user_uid = @uuid AND verified = 1";
                        SqlCommand cmd = new SqlCommand(q, conn);
                        cmd.Parameters.AddWithValue("@uuid", gvDisplayUsers.DataKeys[e.Row.RowIndex].Value.ToString());
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            deleteButton.Enabled = !sdr.Read();
                        }
                        conn.Close();
                    }
                }
                deleteButton.CommandArgument = e.Row.Cells[0].Text;
            }
        }

        protected void gvDisplayUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReqUserDel")
            {
                string uuid = e.CommandArgument.ToString();
                if (Request.Cookies.Get("active_user_uid") == null || !(Request.Cookies.Get("active_user_uid").Value == uuid))
                {
                    DeleteUser(uuid);
                }
                Response.Redirect("~/ViewUsers.aspx");
            }
        }

        private void DeleteUser(string uuid)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd1 = new SqlCommand("DELETE FROM user_details WHERE user_uid = @uuid", conn);
                SqlCommand cmd2 = new SqlCommand("DELETE FROM users WHERE user_uid = @uuid", conn);
                cmd1.Parameters.AddWithValue("@uuid", uuid);
                cmd2.Parameters.AddWithValue("@uuid", uuid);


                conn.Open();
                cmd1.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
                conn.Close();
                BindRecipeList();
            }

        }
    }
}