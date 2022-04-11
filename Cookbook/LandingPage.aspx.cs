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
    }
}