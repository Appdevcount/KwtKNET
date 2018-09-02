using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading;
using System.Globalization;
using KnetPayment;
using System.Diagnostics;
using System.Reflection;

namespace KnetPayment
{
    public partial class receiptTEST :  System.Web.UI.Page//BasePage
    {
        //public KnetVariables ClonedObj;
        public String language = "ar-KW"; // "en-us";
        public String paidby = String.Empty;
        public String redirectUrl = String.Empty;

       

        protected override void OnInit(EventArgs e)
        {
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.AddHeader("pragma", "no-cache");
            Response.AddHeader("Cache-Control", "no-cache");
            Response.CacheControl = "no-cache";
            Response.Expires = -1;
            Response.ExpiresAbsolute = DateTime.Now.AddSeconds(-1);
            Response.Cache.SetNoStore();
            Response.Cache.SetAllowResponseInBrowserHistory(false);
        }


        protected void Page_Load(object sender, EventArgs e)
        {

            //btnResetServer.Attributes.Add("style", "visibility :hidden");

            if (Session["lang"] != null)
            {
                language = Session["lang"].ToString();
            }

            if (language.Contains("ar") || language.Contains("Ar"))
            {
                language = "ar-KW";
                Session["lang"] = "ar-KW";
            }
            else if (language.Contains("en") || language.Contains("En"))
            {
                language = "en-us";
                Session["lang"] = "en-US";
            }


            Thread.CurrentThread.CurrentCulture = new CultureInfo(language);
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(language);


            


            //bool authorizedSession = (Session["AuthToken"] != null
            //               &&
            //               Request.Cookies["AuthToken"] != null)
            //               &&
            //                   (Session["AuthToken"].ToString().Equals(
            //                      Request.Cookies["AuthToken"].Value)
            //                      );


            //if (!authorizedSession)
            //{
            //    Response.Redirect("genericError.html", true);
            //}

        }



        public void redirectTo(object sender, EventArgs e)
        {

            if (Session["PaidBy"] != null)
            {
                paidby = Session["PaidBy"].ToString();
                if (paidby == "O")
                {
                    if (Session["redirectToUrl"] != null)
                    {
                        redirectUrl = Session["redirectToUrl"].ToString();
                        Response.Redirect(redirectUrl, true);
                    }
                }
            }
        }


        public void clearAllSessions()
        {

            //if (paidby == "O") // etrade call
            //    //history.back();
            //    Response.Redirect(redirectUrl, true);


            Session.Clear();
            Session.RemoveAll();
            Session.Abandon();


            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            if (Request.Cookies["AuthToken"] != null)
            {
                Response.Cookies["AuthToken"].Value = string.Empty;
                Response.Cookies["AuthToken"].Expires = DateTime.Now.AddMonths(-20);
            }  

        }


    }
}