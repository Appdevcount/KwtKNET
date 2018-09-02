using System;

using System.Data;
using System.Configuration;
using System.Security.Cryptography;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using System.Threading;
using System.Globalization;
using System.Web;
using System.Web.SessionState;
using System.Diagnostics;
using System.Reflection;
using System.Web.Configuration;

namespace KnetPayment
{
    public partial class CallPaymentGateWay : BasePage//System.Web.UI.Page
    {
        logging log = new logging();
        DataSet paymentDataSet = new DataSet();

        String tokenId = String.Empty;
        String accountName = String.Empty;
        public String amount = String.Empty;
        public String ReferenceNumber = String.Empty;
		public String ReferenceType = String.Empty;
        public String PayeeMailId = String.Empty;
        public String ReceiptNumber = String.Empty;

        public String paidby = String.Empty;
        public String redirectUrl = String.Empty;
        string EToeknId = "0";

        PayReq Pq = new PayReq();
        Activity<PayReq> activity = new Activity<PayReq>()
        {
            ActivityType = ActivityType.ReqLog,
        };
        ActivityHandler AH = new ActivityHandler();

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
            //Configuration webConfigApp = WebConfigurationManager.OpenWebConfiguration("~");
            //bool HELP = Convert.ToBoolean(webConfigApp.AppSettings.Settings["HELP"].Value);
            //ToggleCommunicationTest.Visible = HELP;

            //bool CommunicationTest = Convert.ToBoolean(webConfigApp.AppSettings.Settings["ConnectivityTEST"].Value);
            //ToggleCommunicationTest.ForeColor = CommunicationTest ? System.Drawing.Color.Green : System.Drawing.Color.Red;


            ProceedtoKnet.Text = Resources.Resource.Proceed;
            btnResetServer.Attributes.Add("style", "visibility :hidden");
             EToeknId = Request.QueryString["TokenId"] != null ? log.ExplicitDecryptTokenCall(Request.QueryString["TokenId"]) : "0";
            try
            {
                if (!string.IsNullOrEmpty( Request.QueryString["TokenId"])) //&& Request.QueryString["accountName"] != null)
                {
                    //accountName = Request.QueryString["accountName"].ToString();
                    tokenId = Request.QueryString["TokenId"].ToString();
                    String decodedToken = tokenId;//Server.UrlDecode(tokenId);
               
					Session["tokenid"] = decodedToken;
                    paymentDataSet = log.getPaymentDetails(decodedToken);//(tokenId);//(Server.UrlDecode( tokenId));

                    if (paymentDataSet.Tables.Count > 0)
                    {
                        if (!String.IsNullOrEmpty(paymentDataSet.Tables[0].Rows[0]["Amount"].ToString()) &&
                            !String.IsNullOrEmpty(paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"].ToString()))
                        {
                            amount = paymentDataSet.Tables[0].Rows[0]["Amount"].ToString();
                            ReferenceNumber = paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"].ToString();
							ReferenceType = paymentDataSet.Tables[0].Rows[0]["ReferenceType"].ToString();
                            ReceiptNumber = paymentDataSet.Tables[0].Rows[0]["ReceiptNumber"].ToString();
                            PayeeMailId = paymentDataSet.Tables[0].Rows[0]["PayeeMailId"].ToString();
                            //Session["lang"] = paymentDataSet.Tables[0].Rows[0]["lang"].ToString();

                           
                            paidby = paymentDataSet.Tables[0].Rows[0]["PaidByType"].ToString();
                    

                            if (!String.IsNullOrEmpty(redirectUrl))
                            {
                                Session["redirectToUrl"] = redirectUrl;
                                Session["PaidBy"] = paidby;
                            }
                        }
                        else
                        {
                            log.SaveLog("CallPaymentGateWayGCS", "Amount or Temp Declaration Number Received as Null or Empty", System.Diagnostics.EventLogEntryType.Error);
                             AH.LoggerCall<PayReq>(activity, LogLevel.Warn,null, EToeknId, "Amount or Temp Declaration Number Received as Null or Empty ", ErrorAt.None, null);

                        }
                    }
                    else
                    {
                        log.SaveLog("CallPaymentGateWayGCS", "paymentDataSet Tables Count is Zero !", System.Diagnostics.EventLogEntryType.Error);
                        AH.LoggerCall<PayReq>(activity,LogLevel.Info, null, EToeknId, "No data for the received Token ", ErrorAt.None, null);
                        //******************BELOW LINE IS ENABLED********************************SO THAT NO MORE PROCEEDINGS FOR THIS CASE
                        Response.Redirect("genericError.html", true);
                    }
                }
                else
                {
                    log.SaveLog("CallPaymentGateWayGCS", "token Id Received as Null or Empty => Token Id= " + tokenId, System.Diagnostics.EventLogEntryType.Error);
                     AH.LoggerCall<PayReq>(activity,LogLevel.Warn, null, EToeknId, "Token Id Received as Null or Empty ", ErrorAt.None, null);

                    Response.Redirect("genericError.html", true);
                    
                }
            }
            catch (Exception ex)
            {
                log.SaveLog("CallPaymentGateWayGCS", "Error in Call Payment GateWay-" + ex.Source.ToString() + "=>" + ex.ToString(), System.Diagnostics.EventLogEntryType.Error);
                AH.LoggerCall<PayReq>(activity,LogLevel.Error, ex, EToeknId, "Invalid Token or Database level failure or Redirection issue ", ErrorAt.PaymentReq, null);
                //******************BELOW LINE IS ENABLED********************************SO THAT NO MORE PROCEEDINGS FOR THIS CASE
                Response.Redirect("genericError.html", true);
            }
        }

        private void initializePaymentByAccountName(String accountName)
        {
            String Alias = String.Empty;
            String ResourcePath = String.Empty;
            switch (accountName)
            {
                //case "1": // Ex: Duties
                //    Alias = ConfigurationManager.AppSettings["dutiesAlias"].ToString();
                //    ResourcePath = ConfigurationManager.AppSettings["dutiesResourcePath"].ToString();
                //    initializePayment(Alias, ResourcePath);
                //    break;
                //case "2": // Ex: Deposits
                //    Alias = ConfigurationManager.AppSettings["depositsAlias"].ToString();
                //    ResourcePath = ConfigurationManager.AppSettings["depositsResourcePath"].ToString();
                //    initializePayment(Alias, ResourcePath);
                //    break;
                case "3": // Ex: GCS Receipts
                    Alias = ConfigurationManager.AppSettings["GCSReceiptsAlias"].ToString();
                    ResourcePath = ConfigurationManager.AppSettings["GCSReceiptsResourcePath"].ToString();
                    initializePayment(Alias, ResourcePath);
                    break;
                case "??g?": // Ex: GCS
                    Alias = ConfigurationManager.AppSettings[""].ToString();
                    ResourcePath = ConfigurationManager.AppSettings[""].ToString();
                    initializePayment(Alias, ResourcePath);
                    break;
                // we can add new accounts here and write 
                default:
                    break;
            }
        }

        private void initializePayment(String Alias, String ResourcePath)
        {
            if (paymentDataSet.Tables.Count > 0 && paymentDataSet.Tables[0].Rows.Count > 0)
            {
                String siteUrl = ConfigurationManager.AppSettings["siteUrl"].ToString();
                 String ErrorUrl = ConfigurationManager.AppSettings["errorUrl"].ToString();

                String ResponseUrlLive = ConfigurationManager.AppSettings["responseUrl"].ToString();
                String ResponseUrlTEST = ConfigurationManager.AppSettings["responseUrlTEST"].ToString();
                bool ConnectivityTEST=Convert.ToBoolean( ConfigurationManager.AppSettings["ConnectivityTEST"].ToString());
                string ResponseUrl = ConnectivityTEST ? ResponseUrlTEST : ResponseUrlLive;

                String transactionStatus = String.Empty;
                String sessionId = Session.SessionID;
                String transactionStartDateTime = DateTime.Now.ToString();
                amount = EmptyNull(paymentDataSet.Tables[0].Rows[0]["Amount"]);
                String clientIPAddress = this.Context.Request.ServerVariables["remote_addr"];
                String paymentFor = EmptyNull(paymentDataSet.Tables[0].Rows[0]["PaymentFor"]);
                String paidByType = EmptyNull(paymentDataSet.Tables[0].Rows[0]["PaidByType"]);
                ReferenceNumber = EmptyNull(paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"]);
				ReferenceType = EmptyNull(paymentDataSet.Tables[0].Rows[0]["ReferenceType"]);
                String userLogId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["PortalLoginId"]);
                String portId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["LogInPortId"]);
                String declarationId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["ReferenceId"]);
                String organizationId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["OrganizationId"]);
                String ReceiptId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["ReceiptId"]);
                String BrPaymentTransactionId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["BrPaymentTransactionId"]);

               
                //*************MISMATCHED TRACKID*****************************
                String trackId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["OLTransId"]);
                String ReceiptNumber = EmptyNull(paymentDataSet.Tables[0].Rows[0]["ReceiptNumber"]);

                //if (trackId == "0" || trackId == null )  // checking if it not generated, generate and send
                {
                    trackId = Math.Abs(new Random().Next(1000000,9999999)).ToString();
                }

                 GCSPayReq GCSPayReq = new GCSPayReq();
                GCSPayReq.Amount = amount;
                GCSPayReq.BrPaymentTransactionId = BrPaymentTransactionId;
                GCSPayReq.KNETAccType = EmptyNull(paymentDataSet.Tables[0].Rows[0]["KNETAccType"]);
                GCSPayReq.lang = EmptyNull(paymentDataSet.Tables[0].Rows[0]["lang"]);
                GCSPayReq.LogInPortId = portId;
                GCSPayReq.OLPaymentId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["OLPaymentId"]);
                GCSPayReq.OrganizationId = organizationId;
                GCSPayReq.PaidByName = EmptyNull(paymentDataSet.Tables[0].Rows[0]["PaidByName"]);
                GCSPayReq.PaidByType = paidByType;
                GCSPayReq.PayeeMailId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["PayeeMailId"]);
                GCSPayReq.PaymentFor = paymentFor;
                GCSPayReq.PortalLoginId = userLogId;
                GCSPayReq.PostDate = EmptyNull(paymentDataSet.Tables[0].Rows[0]["PostDate"]);
                GCSPayReq.ReceiptId = ReceiptId;
                GCSPayReq.ReceiptNumber = ReceiptNumber;
                GCSPayReq.ReferenceType = ReferenceType;
                GCSPayReq.TrackId = trackId;
                GCSPayReq.TranStopDateTime = EmptyNull(paymentDataSet.Tables[0].Rows[0]["TranStopDateTime"]);
                GCSPayReq.OLTransId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["OLTransId"]);
                GCSPayReq.UserId = EmptyNull(paymentDataSet.Tables[0].Rows[0]["UserId"]);

                Pq.GCSPayReq = GCSPayReq;

                RedirectToKnet(ResourcePath, Alias, ReferenceNumber,ReferenceType, amount,
                              declarationId, paymentFor, BrPaymentTransactionId, ResponseUrl,
                              ErrorUrl, clientIPAddress, sessionId, organizationId,
                              userLogId, portId, paidByType, trackId, ReceiptId, ReceiptNumber);

            }
            else
            {
                log.SaveLog("CallFromMicroClear-paymentGatwayGCS", "No Data Returned from Database ", System.Diagnostics.EventLogEntryType.Error);
                AH.LoggerCall<PayReq>(activity,LogLevel.Warn, null, EToeknId, "No data found at the time of Payment initialization", ErrorAt.None, null);

            }
        }

        private void RedirectToKnet(String resourcePath, String alias, String ReferenceNumber, String ReferenceType,
                                    String Amount, String DeclarationId, String PaymentFor,
                                    String BrPaymentTransactionId, String responseUrl, String ErrorUrl,
                                    String clientIpAddress, String sessionId, String organizationId,
                                    String userLoginId, String portId, String paidByType, String trackId, String ReceiptId, String ReceiptNumber)
        {
            Boolean IsInteger = false;
            short transVal = new short();
            String ErrorMsg = String.Empty;
            String response = String.Empty;
            String PaymentId = String.Empty;
            String paymentPage = String.Empty;

            String sParamSent = "";
            String FormattedRefNumber = "";

            //string EToeknId = log.ExplicitDecryptTokenCall(tokenId);
            
            try
            {
                e24PaymentPipeLib.e24PaymentPipeCtlClass paymentGatway;

                paymentGatway = new e24PaymentPipeLib.e24PaymentPipeCtlClass();
                paymentGatway.Action = "1";
                paymentGatway.Currency = "414";
                paymentGatway.Language = Resources.Resource.KnetInterfaceLanguage;//"USA";  or  //ARA      

                sParamSent += " Axn=1, Curr=" + paymentGatway.Currency + ", Lang=" + paymentGatway.Language;

                paymentGatway.Amt = Amount;

                paymentGatway.ResponseUrl = responseUrl;
                paymentGatway.ErrorUrl = ErrorUrl;

                sParamSent += ", Amt=" + paymentGatway.Amt + ", RspUrl=" + paymentGatway.ResponseUrl;

                paymentGatway.ResourcePath = @resourcePath;
                paymentGatway.Alias = alias;

                sParamSent += ", ErrUrl=" + paymentGatway.ErrorUrl + ", Alias=" + alias;
                sParamSent += ", RsrcPath=" + @resourcePath;

                //FormattedRefNumber = ReferenceNumber.Replace(@"/", ".");
                FormattedRefNumber = ReceiptNumber.Replace(@"/", ".");

                //String FormattedtokenId = tokenId.Replace("+", "_").Replace("/", "."); 
                //String FormattedtokenId = tokenId.Replace("+", "____").Replace("/", "...."); 
                String FormattedtokenId = EToeknId;

                paymentGatway.Udf1 = Amount;
                paymentGatway.Udf2 = FormattedRefNumber;
                paymentGatway.Udf3 = FormattedtokenId;//DeclarationId;
                paymentGatway.Udf4 = PaymentFor;
                paymentGatway.Udf5 = ReferenceNumber.Replace(@"/", "."); // Actual Reference No like SMRNo, MRNo, Bayan No.

                sParamSent += ", Udf1=" + paymentGatway.Udf1 + ", Udf2=" + paymentGatway.Udf2;
                sParamSent += ", Udf3=" + paymentGatway.Udf3 + ", Udf4=" + paymentGatway.Udf4 + ", UDf5=" + paymentGatway.Udf5;

                paymentGatway.TrackId = trackId;
                //paymentGatway.TransId = ; // Merchant track id possibly.

                sParamSent += ", TrackId=" + paymentGatway.TrackId; // + ", Udf4=" + paymentGatway.Udf4;

                transVal = paymentGatway.PerformInitTransaction();

                PaymentId = paymentGatway.PaymentId;
                paymentPage = paymentGatway.PaymentPage;

                ErrorMsg = paymentGatway.ErrorMsg;
                response = paymentGatway.RawResponse;

                log.SaveLog("Call Payment Gate Way GCS", "Parameter ValueSet = " + sParamSent, System.Diagnostics.EventLogEntryType.Information);

                KNETPayReq KNETPayReq = new KNETPayReq();

                KNETPayReq.Alias = alias;
                KNETPayReq.Amt = Amount;
                KNETPayReq.Auth = "";
                KNETPayReq.Avr = "";
                KNETPayReq.Currency = "414";
                KNETPayReq.Date = "";
                KNETPayReq.ErrorMsg = paymentGatway.ErrorMsg;
                KNETPayReq.ErrorUrl = ErrorUrl;
                KNETPayReq.KAction = "1";
                KNETPayReq.Language = Resources.Resource.KnetInterfaceLanguage;
                KNETPayReq.PaymentId = paymentGatway.PaymentId;
                KNETPayReq.PaymentPage = paymentGatway.PaymentPage;
                KNETPayReq.RawResponse = paymentGatway.RawResponse;
                KNETPayReq.Ref = "";
                KNETPayReq.ResourcePath = @resourcePath;
                KNETPayReq.ResponseUrl = responseUrl;
                KNETPayReq.Result = "";
                KNETPayReq.Timeout = "";
                KNETPayReq.TrackId = trackId;
                KNETPayReq.TransId = "";
                KNETPayReq.Udf1 = Amount;
                KNETPayReq.Udf2 = FormattedRefNumber;
                KNETPayReq.Udf3 = FormattedtokenId;
                KNETPayReq.Udf4 = PaymentFor;
                KNETPayReq.Udf5 = "";

                Pq.KNETPayReq = KNETPayReq;

                //if (paidByType == "B")
                //{
                log.InitializePaymentDetails(DeclarationId, "Started", DateTime.Now, clientIpAddress,
                                     sessionId, userLoginId, portId, Amount, organizationId,
                                     PaymentFor, ReferenceNumber, ReferenceType,BrPaymentTransactionId, Convert.ToChar(paidByType),
                                     ErrorMsg, response, ReceiptId, PaymentId, trackId, EToeknId,"Mobile","Email");
                // }


                Int64 PaymentIdCheck = 0;

                IsInteger = Int64.TryParse(PaymentId, out PaymentIdCheck);
            }

            catch (Exception ex)
            {
                log.SaveLog("RedirectToKnetGCS", "Error => " + ex.ToString() + "\nKnet Response => " + response + " Error=> " + ErrorMsg + "  PaymentId =>" + PaymentId, System.Diagnostics.EventLogEntryType.Error);
                AH.LoggerCall<PayReq>(activity,LogLevel.Error, ex, EToeknId, "Issue during Payment Component processing or while making First payment entry in DB ", ErrorAt.PaymentReq, Pq);
                ////****************HOW TO PROCEED IF ITS COMPONENT ISSUE ***********************
               
                Response.Redirect("genericError.html", true);
            }

            if (transVal != 0 || !IsInteger)
            {
                // log ErrorMsg and response
                log.SaveLog("RedirectToKnetGCS", "Knet Response => " + response + " Error=> " + ErrorMsg + "  PaymentId =>" + PaymentId, System.Diagnostics.EventLogEntryType.Error);
                //Response.Redirect("Error.aspx");
                 AH.LoggerCall<PayReq>(activity,LogLevel.Info, null, EToeknId, "(transVal(" + transVal + ") != 0 || PaymentId(" + PaymentId + ")= not an integer) so Payment process discontinued ", ErrorAt.None, Pq);

                Response.Redirect("genericError.html", true);
            }
            else
            {
                //string redirurl =  paymentPage + "?tokenId=" + tokenId + "&amount=" + Amount + "&paymentId=" + PaymentId; // +"&ReceiptNumber=" + FormattedRefNumber;
                string redirurl = paymentPage + "?PaymentID=" + PaymentId;

                try
                {
                    String ntokenId = tokenId.Replace("+", "____").Replace("/", "....");
                    log.SaveLog("RedirectToKnetGCS", "with PaymentId=" + PaymentId + ", Token Id=" + ntokenId, System.Diagnostics.EventLogEntryType.Information);
                    //ReceiptNumber added by azhar on discuss with mohan and shan 

                    AH.LoggerCall<PayReq>(activity,LogLevel.Info, null, EToeknId, "Redirecting to KNET => " + redirurl, ErrorAt.None, Pq);

                    //Response.Redirect(paymentPage + "?PaymentID=" + PaymentId);

                    Response.Redirect(redirurl,false);//paymentPage + "?tokenId=" + tokenId + "&amount=" + Amount + "&paymentId=" + PaymentId); //+ "&PayID=" + PayID); // Redirects user to KNET Payment Page with parameter PaymentID
                }
                catch (Exception ex)
                {
                    //    log.SaveLog("RedirectToKnetGCS", "Error calling, " + ecall.Source + "\n" + ecall.Message + "\n" + ecall.StackTrace + "\n " + redirurl, System.Diagnostics.EventLogEntryType.Error);
                    AH.LoggerCall<PayReq>(activity,LogLevel.Error, ex, EToeknId, "Issue during Redirecting to KNET => " + redirurl, ErrorAt.PaymentReq, Pq);


                    ////****************HOW TO PROCEED IF ITS COMPONENT ISSUE ***********************
                    Response.Redirect("genericError.html", true);
                }
            }
        }


        private String EmptyNull(object pValue)
        {
            if (pValue != null)
            {
                return pValue.ToString();
            }
            else
            {
                return "";
            }
            //if (pValue is string && pValue != null) return pValue.ToString();

            //else return "";r
        }

        protected void ProceedtoKnet_Click(object sender, EventArgs e)
        {

            if (IsPostBack)
            {

                SessionIDManager manager = new SessionIDManager();

                string newID = manager.CreateSessionID(Context);

                //if (Session["AuthToken"] != null)
                //{
                //    log.SaveLog("RedirectToKnet", " Redirect to Knet without Auth Token ", System.Diagnostics.EventLogEntryType.Information);
                //    Response.Redirect("genericError.html", true);
                //}
                //else
                //{
                    Session["AuthToken"] = newID;
                    // now create a new cookie with this ID value
                    Response.Cookies.Add(new HttpCookie("AuthToken", newID));
                    // Check if the same Token is being called through multiple session ?????????
                //}
            }
            //string EToeknId =log.ExplicitDecryptTokenCall(tokenId) ;
           
            if (paymentDataSet.Tables.Count > 0)
            {
                string sRefNo = paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"].ToString();
                string sRecId = paymentDataSet.Tables[0].Rows[0]["ReceiptId"].ToString();

                if (sRefNo != null && sRefNo != "")
                {
                    int iCheckValue = -1;

                    String conString = ConfigurationManager.ConnectionStrings["conStr"].ConnectionString;
                    SqlConnection CheckReceiptconnection = new SqlConnection(conString);

                    SqlCommand CheckReceiptcommand = new SqlCommand("usp_CheckForGCSKNetPaymentExpiryValidation", CheckReceiptconnection);
                    CheckReceiptcommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter paramRefId = CheckReceiptcommand.Parameters.Add("@ReferenceNo", SqlDbType.VarChar, 30);
                    paramRefId.Value = sRefNo;

                    SqlParameter paramRecId = CheckReceiptcommand.Parameters.Add("@ReceiptId", SqlDbType.BigInt);
                    paramRecId.Value = sRecId;

                    SqlParameter paramCheck = CheckReceiptcommand.Parameters.Add("@Check", SqlDbType.Int);
                    paramCheck.Direction = ParameterDirection.Output;
                    paramCheck.Value = iCheckValue;

                    CheckReceiptconnection.Open();
                    CheckReceiptcommand.ExecuteNonQuery();

                    int iCheck = (int)(CheckReceiptcommand.Parameters["@Check"].Value);
                    CheckReceiptconnection.Close();

                    if (iCheck == 1)
                    {
                        log.SaveLog("CallPaymentGateWayGCS", "Payment Already Initiated:" + sRefNo, System.Diagnostics.EventLogEntryType.Error);
                        AH.LoggerCall<PayReq>(activity, LogLevel.Info, null, EToeknId, "Payment Already Initiated", ErrorAt.None, null);

                        Response.Redirect("genericPaymentError.html", true);
                    }
                }
                if (!String.IsNullOrEmpty(paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString()))
                {
                    accountName = paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString();
                    initializePaymentByAccountName(accountName);
                }
            }

        }


        //protected override void InitializeCulture()
        //{

        //    if (Session["lang"] != null)
        //    {
        //        if (Session["lang"].ToString().ToLower().Contains("ar"))
        //        {
        //            Thread.CurrentThread.CurrentCulture = new CultureInfo("ar-KW");
        //            Thread.CurrentThread.CurrentUICulture = new CultureInfo("ar-KW");
        //        }
        //        else
        //        {
        //            Thread.CurrentThread.CurrentCulture = new CultureInfo("en-US");
        //            Thread.CurrentThread.CurrentUICulture = new CultureInfo("en-US");
        //        }
        //    }
        //    base.InitializeCulture();
        //}

        public void clearAllSessions()
        {
            //Session.Clear();
            //Session.RemoveAll();
            //Session.Abandon();


            //if (Request.Cookies["ASP.NET_SessionId"] != null)
            //{
            //    Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
            //    Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            //}

            //if (Request.Cookies["AuthToken"] != null)
            //{
            //    Response.Cookies["AuthToken"].Value = string.Empty;
            //    Response.Cookies["AuthToken"].Expires = DateTime.Now.AddMonths(-20);
            //}


              
                //alert(redirectToUrl);

           // if (PaidBy == "O") // etrade call
                //history.back();
              //  Response.Redirect(redirectURL, true);
            //else
                
                //ClientScript.RegisterClientScriptBlock(Page.GetType(), "script", "window.top.close();", true); // Broker - Microclear call

                //Page.ClientScript.RegisterStartupScript(this.GetType(), "close", "<script language=javascript>window.top.close();</script>");


                //window.top.close();
                // window.parent.document.forms['   DeclarationEPaymentFr'].cWindow.value = 'closed';
                //window.parWindow.refreshUpOnEPayment();
                //OnCloseCall();

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
    

        //protected void ToggleCommunicationTest_Click(object sender, EventArgs e)
        //{
            
        //    //Helps to open the Root level web.config file.
        //    Configuration webConfigApp = WebConfigurationManager.OpenWebConfiguration("~");
        //    bool CommunicationTest = Convert.ToBoolean(webConfigApp.AppSettings.Settings["ConnectivityTEST"].Value);
        //    webConfigApp.AppSettings.Settings["ConnectivityTEST"].Value = CommunicationTest ? "false" : "true";
        //    webConfigApp.Save();

        //    ToggleCommunicationTest.ForeColor = CommunicationTest ? System.Drawing.Color.Red : System.Drawing.Color.Green;
        //}
    }
}