using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KnetPayment
{
    public partial class NewResponse : System.Web.UI.Page
    {
        KnetPayment.PayResp Pr = new KnetPayment.PayResp();
        //KNETPayReq KNETPq = new KNETPayReq();
        KnetPayment.Activity<KnetPayment.PayResp> activity = new KnetPayment.Activity<KnetPayment.PayResp>()
        {
            ActivityType = KnetPayment.ActivityType.RespLog,
        };
        KnetPayment.ActivityHandler AH = new KnetPayment.ActivityHandler();

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
            //System.Web.Security.FormsAuthentication.SetAuthCookie("", false);
            String paymentID, udfAmount, tkId, result, postdate, tranid, auth, trackid, refr;//, RefId, BrTranId;
            String udfTempDecNo = String.Empty;
            String udfDeclaraTionId = String.Empty;
            String udfPaymentType = String.Empty; //,  udf5 

            paymentID = string.IsNullOrEmpty(Request.Form["paymentID"]) ? "0" : Request.Form["paymentID"];
            result = Request.Form["result"];
            postdate = Request.Form["postdate"];
            tranid = Request.Form["tranid"];
            auth = Request.Form["auth"];
            refr = Request.Form["ref"];
            trackid = Request.Form["trackid"];
            udfTempDecNo = Request.Form["udf2"];
            tkId = string.IsNullOrEmpty(Request.Form["udf3"]) ? "0" : Request.Form["udf3"] ;
            udfPaymentType = Request.Form["udf4"];
            udfAmount = string.IsNullOrEmpty(Request.Form["udf1"]) ? "0" : Request.Form["udf1"];
            
            //string data = paymentID + ":paymentID   |||||     " +
            //result + ":result   |||||     " +
            //postdate + ":postdate   |||||     " +
            //tranid + ":tranid   |||||     " +
            //auth + ":auth   |||||     " +
            //refr + ":refr   |||||     " +
            //trackid + ":trackid   |||||     " +
            //udfTempDecNo + ":udfTempDecNo   |||||     " +
            //tkId + ":tkId   |||||     " +
            //udfPaymentType + ":udfPaymentType   |||||     udfAmount:" +
            //udfAmount;

            logging log = new logging();

            //log.SaveLog("NewResponse BeforeVerification", "Data =" + data, System.Diagnostics.EventLogEntryType.Information);


            if (!log.VerifyOnlinePaymentDetailsGCSReceiptsKnet(tkId, paymentID, udfAmount))
            {
                KnetPayment.PayResp Pr = new KnetPayment.PayResp()
                {
                    paymentID = paymentID,
                    result = result,
                    postdate = postdate,
                    tranid = tranid,
                    auth = auth,
                    refn = refr,
                    trackid = trackid,
                    udf1 = udfAmount,
                    udf3 = tkId,
                    udf2 = udfTempDecNo,
                    udf4 = udfPaymentType

                };
                AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Warn, null, tkId, "False Response - VerifyOnlinePaymentDetailsGCSReceiptsKnet", KnetPayment.ErrorAt.PaymentResp, Pr);
                Response.StatusCode = 404;
                Response.End();

            }
        }

    }
}