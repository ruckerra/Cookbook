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
            if (Request.Cookies.Get("active_user_uid") == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            lblInvalid.Visible = false;
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
                string rn = txtRecipeName.Text.Trim();
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                    SqlCommand cmd = new SqlCommand("SELECT * FROM recipes WHERE recipe_name = @recipe_name",conn);
                    cmd.Parameters.AddWithValue("@recipe_name",rn);
                    conn.Open();
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if (sdr.HasRows)
                    {

                        if (sdr.Read())
                        { 
                            lblInvalid.Visible = true;
                            conn.Close();
                            return;
                        }
                        else
                        {
                            lblInvalid.Visible = false;
                        }
                    }
                    else
                    {
                        lblInvalid.Visible = false;
                    }
                }

                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;

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

                    SqlCommand cmd = new SqlCommand("INSERT INTO recipes VALUES(@recipe_name, @prep_time, @total_time, @vegetarian, @gluten_free, @denomination, @notes, @img_path, @ingredients, @directions)",conn);
                    cmd.Parameters.AddWithValue("@recipe_name", rn);
                    cmd.Parameters.AddWithValue("@prep_time", txtPrepTime.Text);
                    cmd.Parameters.AddWithValue("@total_time", txtTotalTime.Text);
                    cmd.Parameters.AddWithValue("@vegetarian", vegetarian);
                    cmd.Parameters.AddWithValue("@gluten_free", gf);
                    cmd.Parameters.AddWithValue("@denomination", ddType.SelectedValue.ToString());
                    cmd.Parameters.AddWithValue("@notes", txtNotes.Text);
                    cmd.Parameters.AddWithValue("@img_path", "");
                    cmd.Parameters.AddWithValue("@ingredients", txtIngredients.Text);
                    cmd.Parameters.AddWithValue("@directions", txtDirections.Text);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    lblFeedback.Text = "The recipe " + rn + " was added.";
                    lblFeedback.Visible = true;
                    
                    cmd.Dispose();

                    cmd = new SqlCommand("INSERT INTO user_recipes(username, recipe_id) VALUES((SELECT username FROM users WHERE user_uid = @uuid), (SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name))",conn);
                    cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                    cmd.Parameters.AddWithValue("@recipe_name", rn);
                    conn.Open();
                    cmd.ExecuteNonQuery();
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
                SqlCommand cmd = new SqlCommand("DELETE FROM recipes WHERE recipe_id = @recipe_id", conn);
                SqlCommand cmd2 = new SqlCommand("DELETE FROM user_recipes WHERE recipe_id = @recipe_id", conn);
                cmd.Parameters.AddWithValue("@recipe_id",recipeid);
                cmd2.Parameters.AddWithValue("@recipe_id", recipeid);
                conn.Open();
                cmd2.ExecuteNonQuery();
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