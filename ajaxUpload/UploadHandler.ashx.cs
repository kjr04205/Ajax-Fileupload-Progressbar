using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using DMSCommonLib;

namespace DMSTransPC.SubForm
{
    /// <summary>
    /// UploadHandler의 요약 설명입니다.
    /// </summary>
    public class UploadHandler : IHttpHandler
    {
        public DBServicePCLib.Service1Client dbService = null;
        /// <summary>
        /// UploadHandler UploadPage.aspx Fileupload 처리 부분
        /// </summary>
        public void ProcessRequest(HttpContext context)
        {
            dbService = new DBServicePCLib.Service1Client(ProxyHelper.GetBinding(), new System.ServiceModel.EndpointAddress(ConfigurationManager.AppSettings["client.endpoint"]));
            string folderName = context.Request["folderName"];
            string folderValue = context.Request["folderValue"];

            HttpFileCollection files = context.Request.Files;
            string fileName = "";

            DirectoryInfo di = new DirectoryInfo(Configuration.Instance.uploadfolder + "\\" + folderName + "\\");

            if (di.Exists == false)
            {
                di.Create();
            }

            foreach (string key in files)
            {
                HttpPostedFile file = files[key];
                fileName = file.FileName;
                
                string onlyFileName = "";
                onlyFileName = fileName;

                string fullName = di + onlyFileName;

                file.SaveAs(fullName);

                dbService.Insert_PCFileTransUpload(folderValue, folderName, fullName);
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write("success");
        }
       
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

    }
}