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
            if (!Page.IsPostBack)
            {
                BindRecipeList();
            }
        }
        private void BindRecipeList()
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;

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

                deleteButton.CommandArgument = e.Row.Cells[0].Text;
            }
        }

        protected void gvDisplayUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "ReqUserDel")
            {
                string uuid = e.CommandArgument.ToString();
                DeleteUser(uuid);
                if (SiteMaster.session_uid == uuid)
                {
                    SiteMaster.session_uid = null;
                    Response.Redirect("~/ViewUsers.aspx");
                }
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