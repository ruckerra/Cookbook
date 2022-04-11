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
        #region Temp_Cookie
        public static string session_uid = null;
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            #region Temp_Cookie
            if (SiteMaster.session_uid != null)
            {
                active_user_uid.Text = SiteMaster.session_uid;
            }
            else
            {
                active_user_uid.Text = "[NULL]";
            }
            #endregion
        }
    }
}