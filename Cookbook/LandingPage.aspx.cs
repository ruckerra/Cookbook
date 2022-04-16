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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) // when the page is initally loaded
            {
                BindRecipeList();
            }
        }

        private void BindRecipeList()
        {

            txtRecipeName.Text = txtRecipeName.Text.Trim();
            StringBuilder sb = new StringBuilder("SELECT recipe_name, denomination, total_time, vegetarian, gluten_free FROM recipes");
            if (txtRecipeName.Text != "")
            {
                sb.Append(" WHERE recipe_name = '" + txtRecipeName.Text + "'");
                if (dlRecipeType.Text != "")
                {
                    sb.Append(" AND denomination = '" + dlRecipeType.Text + "'");
                }
                if (chkGlutenFree.Checked)
                {
                    sb.Append(" AND gluten_free = 1");
                }
                if (chkVegetarian.Checked)
                {
                    sb.Append(" AND vegetarian = 1");
                }
            }
            else if (dlRecipeType.Text != "")
            {
                sb.Append(" WHERE denomination = '" + dlRecipeType.Text + "'");
                if (chkGlutenFree.Checked)
                {
                    sb.Append(" AND gluten_free = 1");
                }
                if (chkVegetarian.Checked)
                {
                    sb.Append(" AND vegetarian = 1");
                }
            }
            else if (chkGlutenFree.Checked)
            {
                sb.Append(" WHERE gluten_free = 1");
                if (chkVegetarian.Checked)
                {
                    sb.Append(" AND vegetarian = 1");
                }
            }
            else if (chkVegetarian.Checked)
            {
                sb.Append(" WHERE vegetarian = 1");
            }

            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;

            SqlDataAdapter sda = new SqlDataAdapter();
            DataTable dt = new DataTable();

            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = sb.ToString();
            cmd.Connection = conn;

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
            BindRecipeList();
        }

        protected void gvRecipeList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Button fav = e.Row.FindControl("btnFavRecipe") as Button;
                fav.CommandArgument = e.Row.Cells[0].Text;
                if (Request.Cookies.Get("active_user_uid") == null)
                {
                    fav.Enabled = false;
                } else
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        string q = "SELECT *  FROM users_favorites WHERE user_uid = @uuid AND recipe_id = (SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name)";
                        SqlCommand cmd = new SqlCommand(q, conn);
                        cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
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
                e.Row.Cells[3].ForeColor = e.Row.Cells[3].Text == "True" ? Color.SeaGreen : Color.Red;
                e.Row.Cells[4].Text = e.Row.Cells[4].Text == "1" ? "True" : "False";
                e.Row.Cells[4].ForeColor = e.Row.Cells[4].Text == "True" ? Color.SeaGreen : Color.Red;
                
            }
        }

        protected void gvRecipeList_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "FavRecipe")
            {
                string recipe_name = e.CommandArgument.ToString();
                FavoriteRecipe(recipe_name);
            }

        }

        protected void FavoriteRecipe(string recipe_name)
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
                cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                conn.Open();
                sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    conn.Close();

                    cmd = new SqlCommand("DELETE FROM users_favorites WHERE recipe_id = @recipe_id AND user_uid = @uuid", conn);
                    cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                    cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                    BindRecipeList();
                    return;
                }
                conn.Close();
                cmd.Dispose();

                cmd = new SqlCommand("INSERT INTO users_favorites(user_uid, recipe_id) VALUES(@uuid, @recipe_id)", conn);
                cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

            }
            BindRecipeList();
        }
    }
}
