using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;
using System.Text;
using System.Drawing;

namespace Cookbook
{
    public partial class LandingPage : System.Web.UI.Page
    {
        HttpCookie c = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            c = Request.Cookies.Get("active_user_uid");
            SiteMaster.Check_Authority(ref c);
            if (c != null || Session["Admin"] != null)
            {
                chkFavorites.Visible = true;
            }
            if (!Page.IsPostBack) // when the page is initally loaded
            {
                BindRecipeList();
            }
        }

        private void BindRecipeList()
        {
            StringBuilder sb = new StringBuilder("SELECT recipe_name, denomination, total_time, vegetarian, gluten_free FROM {0}recipes{1}");
            int l = sb.Length;

            if (txtRecipeName.Text != "")
            {
                StringBuilder str = new StringBuilder((sb.Length == l ? " WHERE" : " AND") + " LOWER(recipe_name) LIKE LOWER(");
                string[] st = txtRecipeName.Text.Split();
                if (st.Length > 0)
                {
                    str.Append("'%");
                    foreach (string s in st)
                    {
                        str.Append(s + "%");
                    }
                    str.Append("'");
                }
                else
                {
                    str.Append("@recipe_name");
                }
                str.Append(")");
                sb.Append(str.ToString());
            }

            if (dlRecipeType.Text != "")
            {
                sb.Append((sb.Length == l ? " WHERE" : " AND") + " denomination = @denom");
            }

            if (chkGlutenFree.Checked)
            {
                sb.Append((sb.Length == l ? " WHERE" : " AND") + " gluten_free = 1");
            }

            if (chkVegetarian.Checked)
            {
                sb.Append((sb.Length == l ? " WHERE" : " AND") + " vegetarian = 1");
            }
            SqlConnection conn;
            SqlCommand cmd;
            string fmt = "";
            if (chkFavorites.Checked && (c != null || Session["Admin"] != null))
            {
                fmt = " FULL OUTER JOIN users_favorites ON recipes.recipe_id = users_favorites.recipe_id)";
                sb.Append((sb.Length == l ? " WHERE" : " AND") + " user_uid = @uuid");
            }

            conn = new SqlConnection();
            conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;

            SqlDataAdapter sda = new SqlDataAdapter();
            DataTable dt = new DataTable();

            cmd = new SqlCommand(String.Format(sb.ToString(), fmt == "" ? "" : "(", fmt == "" ? "" : fmt), conn);
            if (c != null || Session["Admin"] != null)
            {
                try
                {
                    cmd.Parameters.AddWithValue("@uuid", Session["Admin"] == null ? c.Value : Session["Admin"].ToString());
                }
                catch (Exception e) { }
            }
            try
            {
                cmd.Parameters.AddWithValue("@recipe_name", txtRecipeName.Text);
            }
            catch (Exception e) { }

            try
            {
                cmd.Parameters.AddWithValue("@denom", dlRecipeType.Text);
            }
            catch (Exception e) { }

            sda.SelectCommand = cmd;

            sda.Fill(dt);

            gvRecipeList.DataSource = dt;
            gvRecipeList.DataBind();
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindRecipeList();

        }

        protected void btnCancelSearch_Click(object sender, EventArgs e)
        {
            txtRecipeName.Text = "";
            dlRecipeType.Text = "";
            chkGlutenFree.Checked = false;
            chkVegetarian.Checked = false;
            chkFavorites.Checked = false;
            BindRecipeList();
        }

        protected void gvRecipeList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Button fav = e.Row.FindControl("btnFavRecipe") as Button;
                fav.CommandArgument = e.Row.Cells[0].Text;
                Button view = e.Row.FindControl("btnViewRecipe") as Button;
                view.CommandArgument = e.Row.Cells[0].Text;
                if (!(c == null ^ Session["Admin"] == null))
                {
                    fav.Enabled = false;
                }
                else
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        string q = "SELECT *  FROM users_favorites WHERE user_uid = @uuid AND recipe_id = (SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name)";
                        SqlCommand cmd = new SqlCommand(q, conn);
                        cmd.Parameters.AddWithValue("@uuid", Session["Admin"] == null ? c.Value : Session["Admin"].ToString());
                        cmd.Parameters.AddWithValue("@recipe_name", (gvRecipeList.DataKeys[e.Row.RowIndex].Value).ToString());
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            fav.Text = "Unfavorite";
                        }
                        conn.Close();
                    }
                }
                e.Row.Cells[3].Text = e.Row.Cells[3].Text == "1" ? "True" : "False";
                e.Row.Cells[3].ForeColor = e.Row.Cells[3].Text == "True" ? Color.FromArgb(0, 141, 62) : Color.Red;
                e.Row.Cells[4].Text = e.Row.Cells[4].Text == "1" ? "True" : "False";
                e.Row.Cells[4].ForeColor = e.Row.Cells[4].Text == "True" ? Color.FromArgb(0, 141, 62) : Color.Red;
            }
        }

        protected void gvRecipeList_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "FavRecipe")
            {
                string recipe_name = e.CommandArgument.ToString();
                FavoriteRecipe(recipe_name);
            }

            else if(e.CommandName == "ViewRecipe")
            {
                string recipe_name = e.CommandArgument.ToString();
                ViewRecipe(recipe_name);
            }

        }

        private void ViewRecipe(string recipe_name)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand("SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name", conn);
                cmd.Parameters.AddWithValue("@recipe_name", recipe_name);
                string recipe_id = null;
                conn.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                if (!sdr.HasRows)
                {
                    Response.Redirect("~/LandingPage.aspx");
                }
                sdr.Read();
                recipe_id = sdr["recipe_id"].ToString();
                conn.Close();
                cmd.Dispose();

                Response.Redirect("ViewRecipe.aspx?recipe_id=" + recipe_id);
            }
        }

        protected void FavoriteRecipe(string recipe_name)
        {
            SiteMaster.Check_Authority(ref c);
            if (Page.IsValid)
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    SqlCommand cmd = new SqlCommand("SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name", conn);
                    cmd.Parameters.AddWithValue("@recipe_name", recipe_name);
                    string recipe_id = null;
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    sdr.Read();
                    recipe_id = sdr["recipe_id"].ToString();
                    conn.Close();
                    cmd.Dispose();

                    cmd = new SqlCommand("SELECT * FROM users_favorites WHERE recipe_id = @recipe_id AND user_uid = @uuid", conn);
                    cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                    cmd.Parameters.AddWithValue("@uuid", Session["Admin"] == null ? c.Value : Session["Admin"].ToString());
                    conn.Open();
                    sdr = cmd.ExecuteReader();
                    if (sdr.HasRows)
                    {
                        conn.Close();

                        cmd = new SqlCommand("DELETE FROM users_favorites WHERE recipe_id = @recipe_id AND user_uid = @uuid", conn);
                        cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                        cmd.Parameters.AddWithValue("@uuid", Session["Admin"] == null ? c.Value : Session["Admin"].ToString());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                        BindRecipeList();
                        return;
                    }
                    conn.Close();
                    cmd.Dispose();

                    cmd = new SqlCommand("INSERT INTO users_favorites(user_uid, recipe_id) VALUES(@uuid, @recipe_id)", conn);
                    cmd.Parameters.AddWithValue("@uuid", Session["Admin"] == null ? c.Value : Session["Admin"].ToString());
                    cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                }
            }
            BindRecipeList();
        }
    }
}
