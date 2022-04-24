using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Data;
using System.IO;

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
            bool admin = false;
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand("SELECT admin FROM users WHERE user_uid = @uuid AND admin = 1", conn);
                cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                conn.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    admin = sdr.Read();
                }
                conn.Close();
            }
            lblHeader.Text = String.Format("<h2>{0} Recipes:</h2>", admin ? "User" : "Your");
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

                cmd.CommandText = "SELECT recipe_id, recipe_name, ingredients, total_time FROM recipes WHERE (SELECT admin FROM users WHERE user_uid = @uuid) = 1 OR  (SELECT recipe_id FROM user_recipes WHERE username = (SELECT username FROM users WHERE user_uid = @uuid) AND user_recipes.recipe_id = recipes.recipe_id) = recipes.recipe_id ORDER BY recipe_id DESC";
                cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);

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
                    SqlCommand cmd = new SqlCommand("SELECT * FROM recipes WHERE recipe_name = @recipe_name", conn);
                    cmd.Parameters.AddWithValue("@recipe_name", rn);
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

                    SqlCommand cmd = new SqlCommand("INSERT INTO recipes VALUES(@recipe_name, @prep_time, @total_time, @vegetarian, @gluten_free, @denomination, @notes, @img_path, @ingredients, @directions)", conn);
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

                    cmd = new SqlCommand("INSERT INTO user_recipes(username, recipe_id) VALUES((SELECT username FROM users WHERE user_uid = @uuid), (SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name))", conn);
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
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Button editButton = e.Row.FindControl("btnEdit") as Button;
                Button deleteButton = e.Row.FindControl("btnDelete") as Button;

                editButton.CommandArgument = e.Row.Cells[0].Text;
                deleteButton.CommandArgument = e.Row.Cells[0].Text;
            }
        }

        protected void gvDisplayRecipes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRecipe")
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
            if (!Authority(recipeid))
            {
                Response.Redirect("~/UploadRecipe.aspx");
                return;
            }

            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand("DELETE FROM recipes WHERE recipe_id = @recipe_id", conn);
                SqlCommand cmd2 = new SqlCommand("DELETE FROM user_recipes WHERE recipe_id = @recipe_id", conn);
                cmd.Parameters.AddWithValue("@recipe_id", recipeid);
                cmd2.Parameters.AddWithValue("@recipe_id", recipeid);
                conn.Open();
                cmd2.ExecuteNonQuery();
                cmd.ExecuteNonQuery();
                BindRecipeList();
            }
        }

        private void EditRecipeById(int recipeid)
        {
            if (!Authority(recipeid))
            {
                Response.Redirect("~/UploadRecipe.aspx");
                return;
            }

            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "SELECT * FROM recipes WHERE recipe_id = @recipe_id";
                cmd.Parameters.AddWithValue("@recipe_id", recipeid);
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
                    string img_path = sdr["recipe_image_path"].ToString();
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
                    recipeImg.Visible = true;
                    fuRecipeImage.Visible = true;
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

            if (!Authority(recipeid))
            {
                Response.Redirect("~/UploadRecipe.aspx");
                return;
            }

            string img_path = null;
            if (fuRecipeImage.HasFile)
            {
                img_path = fuRecipeImage.FileName;
                string[] ch_ext = img_path.Split('.');
                string s = ch_ext[ch_ext.Length - 1];
                s = s.ToLower();
                FileInfo prev_img = null;
                if (s == "png" || s == "gif" || s == "jpg" || s == "jpeg" || s == "webp" || s == "svg")
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand("SELECT recipe_id, recipe_image_path FROM recipes WHERE recipe_id = @recipe_id", conn);
                        cmd.Parameters.AddWithValue("@recipe_id", recipeid);
                        conn.Open();
                        SqlDataReader sdr = cmd.ExecuteReader();
                        if (sdr.HasRows)
                        {
                            sdr.Read();
                            prev_img = new FileInfo(Server.MapPath(Request.ApplicationPath) + "/Content/Images/Recipes/" + sdr["recipe_image_path"].ToString());
                        }
                        conn.Close();
                    }
                    img_path = recipeid.ToString() + "." + s;
                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand("UPDATE recipes SET recipe_image_path = @img WHERE recipe_id = @recipe_id", conn);
                        cmd.Parameters.AddWithValue("@recipe_id", recipeid);
                        cmd.Parameters.AddWithValue("@img", img_path);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                    if (prev_img.Exists)
                    {
                        prev_img.Delete();
                    }
                    fuRecipeImage.SaveAs(Server.MapPath(Request.ApplicationPath) + "Content/Images/Recipes/" + img_path);
                }
            }

            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand("SELECT recipe_id FROM recipes WHERE recipe_name = @recipe_name ", conn);
                cmd.Parameters.AddWithValue("@recipe_name", txtRecipeName.Text.Trim());
                conn.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    sdr.Read();
                    if(int.Parse(sdr["recipe_id"].ToString()) != recipeid)
                    {
                        conn.Close();
                        lblInvalid.Visible = true;
                        return;
                    }
                }
                conn.Close();
                lblInvalid.Visible = false;
            }

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

                cmd.CommandText = "UPDATE recipes SET recipe_name = @recipe_name, directions = @directions, ingredients = @ingredients, notes = @notes, total_time = @total_time, prep_time = @prep_time, gluten_free = @gluten_free, vegetarian = @vegetarian, denomination = @denomination WHERE recipe_id = @recipe_id";
                cmd.Parameters.AddWithValue("@recipe_name", txtRecipeName.Text.Trim());
                cmd.Parameters.AddWithValue("@directions", txtDirections.Text);
                cmd.Parameters.AddWithValue("@ingredients", txtIngredients.Text);
                cmd.Parameters.AddWithValue("@notes", txtNotes.Text);
                cmd.Parameters.AddWithValue("@total_time", txtTotalTime.Text);
                cmd.Parameters.AddWithValue("@prep_time", txtPrepTime.Text);
                cmd.Parameters.AddWithValue("@gluten_free", gluten);
                cmd.Parameters.AddWithValue("@vegetarian", veggie);
                cmd.Parameters.AddWithValue("@denomination", ddType.SelectedValue.ToString());
                cmd.Parameters.AddWithValue("@recipe_id", recipeid);
                cmd.Connection = conn;
                conn.Open();
                cmd.ExecuteNonQuery();

                btnCancel.Visible = false;
                btnUpdate.Visible = false;
                recipeImg.Visible = false;
                fuRecipeImage.Visible = false;
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
            recipeImg.Visible = false;
            fuRecipeImage.Visible = false;
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

        protected bool Authority(int recipeid)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand("SELECT * FROM recipes WHERE (SELECT admin FROM users WHERE user_uid = @uuid) = 1 OR (SELECT recipe_id FROM user_recipes WHERE username = (SELECT username FROM users WHERE user_uid = @uuid) AND recipe_id = @recipe_id) = @recipe_id", conn);
                cmd.Parameters.AddWithValue("@uuid", Request.Cookies.Get("active_user_uid").Value);
                cmd.Parameters.AddWithValue("@recipe_id", recipeid);
                conn.Open();
                SqlDataReader sdr = cmd.ExecuteReader();
                if (!sdr.HasRows)
                {
                    return false;
                }
                else
                {
                    if (!sdr.Read())
                    {
                        return false;
                    }
                }
            }
            return true;
        }

    }
}