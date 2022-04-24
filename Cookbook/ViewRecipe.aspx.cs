using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cookbook
{
    public partial class ViewRecipe : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["recipe_id"] == null)
            {
                if(Request.Cookies.Get("last_viewed_recipe") != null)
                {
                    Response.Redirect("~/ViewRecipe?recipe_id=" + Request.Cookies.Get("last_viewed_recipe").Value);
                }
            }
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["recipe_id"] != null)
                {
                    HttpCookie c = new HttpCookie("last_viewed_recipe");
                    c.Value = Request.QueryString["recipe_id"].ToString();
                    Response.Cookies.Add(c);
                    int recipe_id = -1;
                    try
                    {
                        recipe_id = int.Parse(Request.QueryString["recipe_id"]);
                    } catch(Exception ex)
                    {
                        Response.Redirect("~/LandingPage.aspx");
                    }

                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand();

                        cmd.CommandText = "SELECT * FROM Recipes WHERE recipe_id = @recipe_id";
                        cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                        cmd.Connection = conn;

                        conn.Open();

                        SqlDataReader sdr = cmd.ExecuteReader();

                        if (sdr.HasRows)
                        {
                            sdr.Read();

                            string veggie = "No";
                            if(sdr["vegetarian"].ToString() == "1")
                            {
                                veggie = "Yes";
                            }

                            string gluten = "No";
                            if(sdr["gluten_free"].ToString() == "1")
                            {
                                gluten = "Yes";
                            }

                            lblRecipeId.Text = sdr["recipe_id"].ToString();
                            lblRecipeName.Text += sdr["recipe_name"].ToString();
                            lblPrepTime.Text += sdr["prep_time"].ToString();
                            lblTotalTime.Text += sdr["total_time"].ToString();
                            lblVegetarian.Text += veggie;
                            lblGlutenFree.Text += gluten;
                            lblDenomination.Text += sdr["denomination"].ToString();
                            lblNotes.Text += sdr["notes"].ToString();
                            lblIngredients.Text += sdr["ingredients"].ToString();
                            lblDirections.Text += sdr["directions"].ToString();
                            string img_path = sdr["recipe_image_path"].ToString();
                            img_path = ("/Content/Images/" + (img_path == "" ? "Default/" + "recipe.png" : "Recipes/" + img_path));
                            imgRecipe.ImageUrl = img_path;
                        }
                    }

                    using(SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand();

                        cmd.CommandText = "SELECT * FROM nutrition WHERE recipe_id = @recipe_id";
                        cmd.Parameters.AddWithValue("@recipe_id", recipe_id);
                        cmd.Connection = conn;

                        conn.Open();

                        SqlDataReader sdr = cmd.ExecuteReader();

                        if (sdr.HasRows)
                        {
                            btnShowNutrition.Visible = true;
                        }
                    }
                } else
                {
                    Response.Redirect("LandingPage.aspx");
                }
            }
        }

        protected void btnReturn_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnShowNutrition_Click(object sender, EventArgs e)
        {
            pnlNutritionInfo.Visible = true;
            btnShowNutrition.Visible = false;
            using(SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                SqlCommand cmd = new SqlCommand();

                int recipe_id = int.Parse(lblRecipeId.Text);

                cmd.CommandText = "SELECT * FROM nutrition WHERE recipe_id = " + recipe_id;
                cmd.Connection = conn;

                conn.Open();

                SqlDataReader sdr = cmd.ExecuteReader();

                if (sdr.HasRows)
                {
                    sdr.Read();

                    lblCalories.Text += sdr["calories"].ToString();
                    lblFat.Text += sdr["fat"].ToString();
                    lblCarbs.Text += sdr["carbs"].ToString();
                    lblFiber.Text += sdr["fiber"].ToString();
                    lblProtein.Text += sdr["protein"].ToString();
                    lblServings.Text += sdr["servings"].ToString();
                    lblNutritionNotes.Text += sdr["notes"].ToString();
                }
            }
        }
    }
}