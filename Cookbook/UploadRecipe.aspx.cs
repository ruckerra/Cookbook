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
    public partial class WebForm1 : System.Web.UI.Page
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

                cmd.CommandText = "SELECT recipe_id, recipe_name, ingredients, total_time FROM recipes ORDER BY recipe_id DESC";
                cmd.Connection = conn;
                sda.SelectCommand = cmd;

                conn.Open();
                sda.Fill(dt);

                gvDisplayRecipes.DataSource = dt;
                gvDisplayRecipes.DataBind();


            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    SqlCommand cmd = new SqlCommand();

                    int gf = 0;
                    int vegetarian = 0;

                    if (chkGlutenFree.Checked)
                    {
                        gf = 1;
                    }
                    if (chkVegetarian.Checked)
                    {
                        vegetarian = 1;
                    }

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.CommandText = "INSERT INTO recipes VALUES('" + txtRecipeName.Text + "', '" + txtPrepTime.Text + "', '" + txtTotalTime.Text +"', " + vegetarian +", " + gf + ", '" + ddType.SelectedValue.ToString() + "', '" + txtNotes.Text + "', '', '" + txtIngredients.Text + "', '" + txtDirections.Text + "')";

                    cmd.ExecuteNonQuery();

                    lblFeedback.Text = "The recipe " + txtRecipeName.Text + " was added.";
                    lblFeedback.Visible = true;

                    conn.Close();
                }

                txtRecipeName.Text = "";
                txtDirections.Text = "";
                txtIngredients.Text = "";
                txtNotes.Text = "";
                txtPrepTime.Text = "";
                txtTotalTime.Text = "";
                ddType.SelectedIndex = 0;
                chkGlutenFree.Checked = false;
                chkVegetarian.Checked = false;

                BindRecipeList();
            }
        }
    }
}