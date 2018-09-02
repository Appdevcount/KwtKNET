using System;
using System.Collections.Generic;
using System.Web;
using System.Threading;
using System.Globalization;
using System.Data;

namespace KnetPayment
{
    public class BasePage : System.Web.UI.Page
    {

        logging log = new logging();

        protected override void InitializeCulture()
        {
            String language = "ar-KW"; // "en-us";
            logging log = new logging();
            String tokenId = String.Empty;
            DataSet paymentDataSet = new DataSet();

            try
            {
                if (Request.QueryString["TokenId"] != null)
                {
                    tokenId = Request.QueryString["TokenId"].ToString();

                    paymentDataSet = log.getPaymentDetails(tokenId);

                    if (paymentDataSet.Tables.Count > 0)
                    {
                        Session["lang"] = paymentDataSet.Tables[0].Rows[0]["lang"].ToString();
                        if (Session["lang"] != null)
                        {
                            language = Session["lang"].ToString();
                        }
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
                }

                //Set the Culture.
                Thread.CurrentThread.CurrentCulture = new CultureInfo(language);
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(language);
            }
            catch (Exception)
            {
                Thread.CurrentThread.CurrentCulture = new CultureInfo(language);
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(language);
            }
        }

    }
}