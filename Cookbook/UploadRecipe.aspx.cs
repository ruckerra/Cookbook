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

        protected void gvDisplayRecipes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType == DataControlRowType.DataRow)
            {
                Button editButton = e.Row.FindControl("btnEdit") as Button;
                Button deleteButton = e.Row.FindControl("btnDelete") as Button;

                editButton.CommandArgument = e.Row.Cells[0].Text;
                deleteButton.CommandArgument = e.Row.Cells[0].Text;
            }
        }

        protected void gvDisplayRecipes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if(e.CommandName == "EditRecipe")
            {
                int recipeid = int.Parse(e.CommandArgument.ToString());
                lblRecipeId.Text = e.CommandArgument.ToString();
                EditRecipeById(recipeid);
            }

            else if (e.CommandName == "DeleteRecipe")
            {
                int recipeid = int.Parse(e.CommandArgument.ToString());
                DeleteRecipeById(recipeid);
            }
        }

        private void DeleteRecipeById(int recipeid)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand();

                cmd.CommandText = "DELETE FROM recipes WHERE recipe_id = " + recipeid;
                cmd.Connection = conn;
                conn.Open();
                cmd.ExecuteNonQuery();
                
                BindRecipeList();
            }
        }

        private void EditRecipeById(int recipeid)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "SELECT * FROM recipes WHERE recipe_id = " + recipeid;
                cmd.Connection = conn;
                conn.Open();

                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.Read())
                {
                    txtRecipeName.Text = sdr["recipe_name"].ToString();
                    txtDirections.Text = sdr["directions"].ToString();
                    txtIngredients.Text = sdr["ingredients"].ToString();
                    txtNotes.Text = sdr["ingredients"].ToString();
                    txtPrepTime.Text = sdr["prep_time"].ToString();
                    txtTotalTime.Text = sdr["total_time"].ToString();

                    if (int.Parse(sdr["gluten_free"].ToString()) == 1)
                    {
                        chkGlutenFree.Checked = true;
                    }

                    if (int.Parse(sdr["vegetarian"].ToString()) == 1)
                    {
                        chkVegetarian.Checked = true;
                    }

                    ddType.SelectedValue = sdr["denomination"].ToString();

                    btnUpdate.Visible = true;
                    btnSave.Visible = false;
                    btnCancel.Visible = true;
                    pnlDisplayRecipes.Visible = false;

                }


            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int recipeid = int.Parse(lblRecipeId.Text);
            UpdateRecipeById(recipeid);
        }

        private void UpdateRecipeById(int recipeid)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand();

                int gluten = 0;
                int veggie = 0;
                if (chkGlutenFree.Checked)
                {
                    gluten = 1;
                }
                if (chkVegetarian.Checked)
                {
                    veggie = 1;
                }

                cmd.CommandText = "UPDATE recipes SET recipe_name = '" + txtRecipeName.Text + "', directions = '" + txtDirections.Text + "', ingredients = '" + txtIngredients.Text + "', notes = '" + txtNotes.Text + "', total_time = '" +
                     txtTotalTime.Text + "', prep_time = '" + txtPrepTime.Text + "', gluten_free = " + gluten + ", vegetarian = " + veggie + ", denomination = '" + ddType.SelectedValue.ToString() + "' WHERE recipe_id = " + recipeid;
                cmd.Connection = conn;
                conn.Open();
                cmd.ExecuteNonQuery();

                btnCancel.Visible = false;
                btnUpdate.Visible = false;
                pnlDisplayRecipes.Visible = true;
                btnSave.Visible = true;

                BindRecipeList();

                txtRecipeName.Text = "";
                txtDirections.Text = "";
                txtIngredients.Text = "";
                txtNotes.Text = "";
                txtPrepTime.Text = "";
                txtTotalTime.Text = "";
                chkGlutenFree.Checked = false;
                chkVegetarian.Checked = false;
                ddType.SelectedIndex = 0;


            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            btnCancel.Visible = false;
            btnUpdate.Visible = false;
            pnlDisplayRecipes.Visible = true;
            btnSave.Visible = true;

            txtRecipeName.Text = "";
            txtDirections.Text = "";
            txtIngredients.Text = "";
            txtNotes.Text = "";
            txtPrepTime.Text = "";
            txtTotalTime.Text = "";
            chkGlutenFree.Checked = false;
            chkVegetarian.Checked = false;
            ddType.SelectedIndex = 0;
        }
    }
}