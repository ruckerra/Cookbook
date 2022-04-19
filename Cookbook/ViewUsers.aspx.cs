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
        HttpCookie c = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            c = Request.Cookies.Get("active_user_uid");
            SiteMaster.Check_Authority(c);
            if (Session["Admin"] != null)
            {
                if (!Page.IsPostBack)
                {
                    BindRecipeList();
                }
            } else
            {
                Response.Redirect("~/LandingPage.aspx");
            }
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
                Button modUser = e.Row.FindControl("btnMod") as Button;
                
                //Check if cookies are null, and disable delete button for the active user themselves
                if (Session["Admin"] == null || (gvDisplayUsers.DataKeys[e.Row.RowIndex].Value).ToString() == Session["Admin"].ToString())
                {
                    deleteButton.Enabled = false;
                    modUser.Enabled = false;
                    modUser.Visible = false;
                } else
                {
                    //Disable delete button assigned to mods
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        string q = "SELECT admin, owner FROM users WHERE user_uid = @uuid AND admin = 1";
                        SqlCommand cmd = new SqlCommand(q, conn);
                        cmd.Parameters.AddWithValue("@uuid", gvDisplayUsers.DataKeys[e.Row.RowIndex].Value.ToString());
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            sdr.Read();
                            if (sdr["admin"].ToString() == "True")
                            {
                                deleteButton.Enabled = false;
                            }
                        }
                        conn.Close();
                    }

                    //Check if user is owner, if so give ability to mod users and ability to delete even mods.
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        string is_admin = "SELECT user_uid FROM users WHERE owner = 1";
                        SqlCommand cmd = new SqlCommand(is_admin, conn);
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            if (sdr.Read())
                            {
                                if (sdr["user_uid"].ToString() == Session["Admin"].ToString())
                                {
                                    modUser.Visible = true;
                                    deleteButton.Enabled = true;
                                }
                            }
                        } else
                        {
                            modUser.Visible = false;
                        }
                        conn.Close();
                    }

                    //Change text if user is already mod
                    using(SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand("SELECT admin FROM users WHERE user_uid = @uuid",conn);
                        cmd.Parameters.AddWithValue("@uuid", gvDisplayUsers.DataKeys[e.Row.RowIndex].Value.ToString());
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            modUser.Text = sdr.Read() && sdr["admin"].ToString() == "True" ? "Remove Admin" : modUser.Text;
                        }
                    }
                }
                deleteButton.CommandArgument = e.Row.Cells[0].Text;
                modUser.CommandArgument = e.Row.Cells[0].Text;
            }
        }

        protected void gvDisplayUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReqUserDel")
            {
                string uuid = e.CommandArgument.ToString();
                if (Session["Admin"] != null && !(Session["Admin"].ToString() == uuid))
                {
                    DeleteUser(uuid);
                }
                Response.Redirect("~/ViewUsers.aspx");
            }
            if(e.CommandName == "GiveAdmin")
            {
                string uuid = e.CommandArgument.ToString();
                string owner_uid = null;
                //Double check if active user is owner, and prevent owner from unmodding themself
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    SqlCommand cmd = new SqlCommand("SELECT user_uid FROM users WHERE owner = 1", conn);
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (sdr.HasRows)
                    {
                        if (sdr.Read())
                        {
                            owner_uid = sdr["user_uid"].ToString();
                        }
                    }
                    conn.Close();
                }
                if (Session["Admin"] != null && owner_uid != null && Session["Admin"].ToString() == owner_uid && Session["Admin"].ToString() != uuid)
                {
                    ModUser(uuid);
                }
            }
        }

        private void DeleteUser(string uuid)
        {
            Check_Authority();
            if(Session["Admin"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd1 = new SqlCommand("DELETE FROM user_recipes WHERE username = (SELECT username FROM users WHERE user_uid = @uuid)", conn);
                SqlCommand cmd2 = new SqlCommand("DELETE FROM users_favorites WHERE user_uid = @uuid", conn);
                SqlCommand cmd3 = new SqlCommand("DELETE FROM user_details WHERE user_uid = @uuid", conn);
                SqlCommand cmd4 = new SqlCommand("DELETE FROM users WHERE user_uid = @uuid", conn);
                cmd1.Parameters.AddWithValue("@uuid", uuid);
                cmd2.Parameters.AddWithValue("@uuid", uuid);
                cmd3.Parameters.AddWithValue("@uuid", uuid);
                cmd4.Parameters.AddWithValue("@uuid", uuid);
                conn.Open();
                cmd1.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                cmd4.ExecuteNonQuery();
                conn.Close();
                BindRecipeList();
            }

        }

        private void ModUser(string uuid)
        {
            //Give/remove admin
            using(SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                string q = "SELECT admin FROM users WHERE user_uid = @uuid";
                string updt = "UPDATE users SET admin = {0} WHERE user_uid = @uuid";
                SqlCommand cmd = new SqlCommand(q, conn);
                cmd.Parameters.AddWithValue("@uuid", uuid);
                conn.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        updt = String.Format(updt, sdr["admin"].ToString() == "True" ? "0" : "1");
                    }
                    else
                    {
                        conn.Close();
                        return;
                    }
                }
                else
                {
                    conn.Close();
                    return;
                }
                conn.Close();
                cmd.Dispose();
                cmd = new SqlCommand(updt,conn);
                cmd.Parameters.AddWithValue("@uuid", uuid);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindRecipeList();
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
