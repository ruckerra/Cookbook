using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cookbook
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie c = Request.Cookies.Get("active_user_uid");
            if (c != null)
            {
                active_user_uid.Text = c.Value;
            }
            else
            {
                active_user_uid.Text = "[NULL]";
            }
        }
    }
}