using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace KnetPayment
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            //Response.TrySkipIisCustomErrors = true;
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            var app = sender as HttpApplication;
            if (app != null && app.Context != null)
            {
               // app.Context.Response.Headers.Remove("Server");
            }
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            
        }

        protected void Application_Error(object sender, EventArgs e)
        {

            String s = Response.StatusCode.ToString();
            if (s != "200")
            {
                Response.Redirect("/genericError.html");
            }

            
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }


        protected void Application_PreSendRequestHeaders()
        {
            Response.Headers.Remove("Server");
            ////HttpContext.Current.Response.Headers.Set("Server", "guess what !!"); 
            Response.Headers.Remove("X-AspNet-Version");
            //HttpContext.Current.Response.Headers.Set("Server", "");
            Response.AddHeader("Pragma", "no-cache");
            Response.AddHeader("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate");
        }

    }
}