using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMSTransPC.SubForm
{
    public partial class UploadPage : System.Web.UI.Page
    {
        public DBServicePCLib.Service1Client dbService = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            dbService = new DBServicePCLib.Service1Client(ProxyHelper.GetBinding(), new System.ServiceModel.EndpointAddress(ConfigurationManager.AppSettings["client.endpoint"]));

            if (!Page.IsPostBack)
            {
                Configuration.Instance.uploadfolder = ConfigurationManager.AppSettings["uploadfolder"];
                DBServicePCLib.PCFileGroupData[] list = dbService.Search_PCFileGroup_LIST_ISENABLE(1);

                this.cmbFileGroup.DataSource = list;
                this.cmbFileGroup.DataValueField = "pfg_id";
                this.cmbFileGroup.DataTextField = "pfn_name";
                this.cmbFileGroup.DataBind();
            }

        }
        
        protected void Button1_Click(object sender, EventArgs e)
        {
            
        }

        protected void cmbFileGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }
        
    }
}