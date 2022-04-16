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
            if (!Page.IsPostBack)
            {
                if (Request.QueryString["recipe_id"] != null)
                {
                    int recipe_id = int.Parse(Request.QueryString["recipe_id"]);

                    using (SqlConnection conn = new SqlConnection())
                    {
                        conn.ConnectionString = WebConfigurationManager.ConnectionStrings["CookbookConnectionString"].ConnectionString;
                        SqlCommand cmd = new SqlCommand();

                        cmd.CommandText = "SELECT * FROM Recipes WHERE recipe_id = " + recipe_id;
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

                            lblRecipeName.Text += sdr["recipe_name"].ToString();
                            lblPrepTime.Text += sdr["prep_time"].ToString();
                            lblTotalTime.Text += sdr["total_time"].ToString();
                            lblVegetarian.Text += veggie;
                            lblGlutenFree.Text += gluten;
                            lblDenomination.Text += sdr["denomination"].ToString();
                            lblNotes.Text += sdr["notes"].ToString();
                            lblIngredients.Text += sdr["ingredients"].ToString();
                            lblDirections.Text += sdr["directions"].ToString();
                            imgRecipe.ImageUrl = "/Content/Catalog/Images/" + sdr["recipe_image_path"].ToString();
                        }
                    }
                }
            }
        }
    }
}