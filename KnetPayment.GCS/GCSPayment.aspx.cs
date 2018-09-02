using KnetPayment;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KnetPayment
{
    public partial class GCSPayment : BasePage
    {
        protected override void InitializeCulture()
        {
            string language = "en-us";
            Session["lang"] = "en-US";
            //base.InitializeCulture();
            Thread.CurrentThread.CurrentCulture = new CultureInfo(language);
        }
        PayReq Pq = new PayReq();

        Activity<PayReq> activity = new Activity<PayReq>()
        {
            ActivityType = ActivityType.ExtPay,
        };
        ActivityHandler AH = new ActivityHandler();

        logging log = new logging();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [System.Web.Services.WebMethod]
        public static ReceiptAction IsReceiptValid(string ReceiptNumber, string Mobile, string Email, string SecurityCode)
        {
            ReceiptAction ra = new ReceiptAction();

            Activity<ExternalPay> activity = new Activity<ExternalPay>()
            {
                ActivityType = ActivityType.ExtPay,
            };
            ExternalPay ep = new ExternalPay() { TempReceiptNumber = ReceiptNumber, Mobile = Mobile, Email = Email, SecurityCode = SecurityCode };
            activity.ActivityToLog = ep;
            ActivityHandler AH = new ActivityHandler();
            try
            {
                logging Lvws = new logging();
                VerifyReceiptDetailsforGCSSite Vrfr = Lvws.VerifyReceiptDetailsforGCSSite(ReceiptNumber, Mobile, Email, SecurityCode);


                ra.VerifyReceiptDetailsforGCSSite = Vrfr;

                ReceiptDetailsMinified rd = null;
                string TokenId = "0";
                if (Vrfr.Proceed)
                {
                    System.Data.DataSet ds = new System.Data.DataSet();

                    ds = Lvws.GetPaymentDetailsforGCSSite(ReceiptNumber, Mobile, Email, false);
                    //to retain decimal value as string (18, 3)..Normal decimal property round off it and removes unneccesary trailing zeroes
                    ds.Tables[0].Rows[0]["Amount"] = Convert.ToDecimal(ds.Tables[0].Rows[0]["Amount"]) + Convert.ToDecimal(0.210);
                    GCSPayment GP = new GCSPayment();
                    rd = GP.BindData<ReceiptDetailsMinified>(ds.Tables[0]);

                    TokenId = Lvws.ExplicitDecryptTokenCall(rd.TokenId);

                    //RandomStringGenerator4DotNet is installed to get random text -- To inject false string in token
                    RandomStringGenerator.StringGenerator RSG = new RandomStringGenerator.StringGenerator() { MinNumericChars = 1, MinLowerCaseChars = 2, MinUpperCaseChars = 1 };
                    string randstr = RSG.GenerateString(4);
                    rd.TokenId = rd.TokenId.Insert(3, randstr);

                    activity.TokenId = TokenId;
                }
                ra.ReceiptDetailsMinified = rd;


                AH.LoggerCall<ExternalPay>(activity, LogLevel.Info, null, TokenId, "Receipt Lookup", ErrorAt.None, ep);

                return ra;
            }
            catch (Exception ex)
            {
                AH.LoggerCall<ExternalPay>(activity, LogLevel.Error, ex, "0", "Receipt Lookup", ErrorAt.ReceiptLookup, ep);

                VerifyReceiptDetailsforGCSSite VerifyReceiptDetailsforGCSSite = new VerifyReceiptDetailsforGCSSite() { Proceed = false, Message = "Some error has occured . Please Contact IT Team" };

                ra.VerifyReceiptDetailsforGCSSite = VerifyReceiptDetailsforGCSSite;
                return ra;
            }

        }

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
        protected void PayButton_Click(object sender, ImageClickEventArgs e)
        {
            //if(!AgreeToPay.Checked)
            //{
            //    PaymentVerifierOnStart.InnerHtml = "<div class='alert alert-danger text-center'> Please agree to the T&C to Proceed </div>";
            //    return;
            //}

            //PaymentVerifierOnStart.InnerHtml = "";
            string TIRCNumber_txt = TIRCNumber.Value;

            VerifyReceiptDetailsforGCSSite VD = null;
            ReceiptDetails rd = null;
            try
            {
                VD = log.VerifyReceiptDetailsforGCSSite(TIRCNumber_txt, Mobile.Value, Email.Value, SecurityCode.Value);
                //System.Data.DataSet dsz = new System.Data.DataSet();
                //Commented below as it will create new Token again within SP and insert in table
                //dsz = log.GetPaymentDetailsforGCSSite(TIRCNumber_txt, Mobile.Value, Email.Value, true);
                ////Adding 0.210 fills as per discussion with Shan as an E-payment fee
                ////to retain decimal value as string (18, 3)..Normal decimal property round off it and removes unneccesary trailing zeroes
                //dsz.Tables[0].Rows[0]["Amount"] = (Convert.ToDecimal(dsz.Tables[0].Rows[0]["Amount"]) + Convert.ToDecimal(0.210));
                //rd = BindData<ReceiptDetails>(dsz.Tables[0]);
            }
            catch (Exception ex)
            {
                Activity<ExternalPay> activity = new Activity<ExternalPay>()
                {
                    ActivityType = ActivityType.ExtPay,
                    LogDestination = LogDestination.Database,
                    NotifyingMethod = LogNotifyingMode.None
                };
                ExternalPay ep = new ExternalPay() { TempReceiptNumber = TIRCNumber_txt, Mobile = Mobile.Value, Email = Email.Value, SecurityCode = SecurityCode.Value };
                AH.LoggerCall<ExternalPay>(activity, LogLevel.Error, ex, "0", " Receipt Lookup before Payment ", ErrorAt.ReceiptLookup, ep);
                PaymentVerifierOnStartScriptCall(" Some momentary issue in Receipt Lookup before Payment  ! . Please contact IT Team or Try again Later ");// + ex.Message);
                return;
            }
            //if (rd==null & VD==null)
            //{
            //    return;
            //}

            GCSPayReq gpq = new GCSPayReq()
            {
                ReceiptNumber = TIRCNumber_txt,// rd.ReceiptNumber,
                //ReceiptId = rd.ReceiptId.ToString(),
                //ReferenceId = rd.ReferenceId.ToString(),
                //ReferenceNumber = rd.ReferenceNumber.ToString(),
                //Amount = rd.Amount.ToString(),
                //BrPaymentTransactionId = rd.BrPaymentTransactionId.ToString(),
                //KNETAccType = rd.KNETAccType,
                //lang = rd.lang,
                //LogInPortId = rd.LogInPortId.ToString(),
                //OLPaymentId = rd.OLPaymentId.ToString(),
                //OLTransId = rd.OLTransId.ToString(),
                //OrganizationId = rd.OrganizationId.ToString(),
                //PaidByName = rd.PaidByName,
                //PaidByType = rd.PaidByType,
                //PayeeMailId = rd.PayeeMailId,
                //PayeeOrgMailId = rd.PayeeOrgMailId,
                //PaymentFor = rd.PaymentFor,
                //PortalLoginId = rd.PortalLoginId,
                //PostDate = rd.PostDate.ToString(),
                //ReferenceType = rd.ReferenceType,
                //TrackId = rd.TrackId.ToString(),
                //TranStopDateTime = rd.TranStopDateTime.ToString(),
                //UserId = rd.UserId
            };

            Pq.GCSPayReq = gpq;


            string EToeknId = SEAT.Value.Remove(3, 4);//Remove injected string from token
            string TokenId = log.ExplicitDecryptTokenCall(EToeknId);

            Boolean IsInteger = false;
            short transVal = new short();
            String ErrorMsg = String.Empty;
            String response = String.Empty;
            String PaymentId = String.Empty;
            String paymentPage = String.Empty;

            String sParamSent = "";
            String FormattedRefNumber = "";

            if (VD.Proceed)
            {
                DataSet ds = new DataSet();
                //ds = log.GetPaymentDetailsforGCSSite(TIRCNumber_txt, true);
                try
                {
                    ds = log.getPaymentDetails(EToeknId);
                }
                catch (Exception ex)
                {
                    AH.LoggerCall<PayReq>(activity, LogLevel.Error, ex, TokenId, "Issue during fetching details using Token ", ErrorAt.PaymentReq, Pq);
                    PaymentVerifierOnStartScriptCall("Some momentary issue in Payment Token validation , Please try again .");
                    return;
                }
                if (ds.Tables.Count > 0)
                {
                    try
                    {



                        String siteUrl = ConfigurationManager.AppSettings["siteUrl"].ToString();
                        String ErrorUrl = ConfigurationManager.AppSettings["errorUrl"].ToString();
                        
                        String ResponseUrlLive = ConfigurationManager.AppSettings["responseUrl"].ToString();
                        String ResponseUrlTEST = ConfigurationManager.AppSettings["responseUrlTEST"].ToString();
                        bool ConnectivityTEST = Convert.ToBoolean(ConfigurationManager.AppSettings["ConnectivityTEST"].ToString());
                        string ResponseUrl = ConnectivityTEST ? ResponseUrlTEST : ResponseUrlLive;


                        String transactionStatus = String.Empty;

                        //Adding 0.210 fills as per discussion with Shan as an E-payment fee
                        string Amount = (Convert.ToDecimal(ds.Tables[0].Rows[0]["Amount"]) + Convert.ToDecimal(0.210)).ToString();

                        String clientIPAddress = this.Context.Request.ServerVariables["remote_addr"];
                        String paymentFor = EmptyNull(ds.Tables[0].Rows[0]["PaymentFor"]);
                        String paidByType = EmptyNull(ds.Tables[0].Rows[0]["PaidByType"]);
                        string ReferenceNumber = EmptyNull(ds.Tables[0].Rows[0]["ReferenceNumber"]);
                        string ReferenceType = EmptyNull(ds.Tables[0].Rows[0]["ReferenceType"]);
                        String userLogId = EmptyNull(ds.Tables[0].Rows[0]["PortalLoginId"]);
                        String portId = EmptyNull(ds.Tables[0].Rows[0]["LogInPortId"]);
                        String declarationId = EmptyNull(ds.Tables[0].Rows[0]["ReferenceId"]);
                        String organizationId = EmptyNull(ds.Tables[0].Rows[0]["OrganizationId"]);
                        String ReceiptId = EmptyNull(ds.Tables[0].Rows[0]["ReceiptId"]);
                        String BrPaymentTransactionId = EmptyNull(ds.Tables[0].Rows[0]["BrPaymentTransactionId"]);
                        String ReferenceId = EmptyNull(ds.Tables[0].Rows[0]["ReferenceId"]);
                        String PaymentFor = EmptyNull(ds.Tables[0].Rows[0]["PaymentFor"]);
                        String userLoginId = EmptyNull(ds.Tables[0].Rows[0]["UserId"]);

                        String DeclarationId = ReferenceId;


                        //*************MISMATCHED TRACKID*****************************
                        String trackId = EmptyNull(ds.Tables[0].Rows[0]["OLTransId"]);
                        String ReceiptNumber = EmptyNull(ds.Tables[0].Rows[0]["ReceiptNumber"]);

                        String clientIpAddress = this.Context.Request.ServerVariables["remote_addr"];
                        String sessionId = Session.SessionID;
                        string alias = ConfigurationManager.AppSettings["GCSReceiptsAlias"].ToString();
                        string resourcePath = ConfigurationManager.AppSettings["GCSReceiptsResourcePath"].ToString();


                        e24PaymentPipeLib.e24PaymentPipeCtlClass paymentGatway;

                        paymentGatway = new e24PaymentPipeLib.e24PaymentPipeCtlClass();
                        paymentGatway.Action = "1";
                        paymentGatway.Currency = "414";
                        paymentGatway.Language = "USA";// Resources.Resource.KnetInterfaceLanguage;//"USA";  or  //ARA      

                        sParamSent += " Axn=1, Curr=" + paymentGatway.Currency + ", Lang=" + paymentGatway.Language;

                        paymentGatway.Amt = Amount;

                        paymentGatway.ResponseUrl = ResponseUrl;
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
                        String FormattedtokenId = TokenId;// EToeknId;

                        paymentGatway.Udf1 = Amount;
                        paymentGatway.Udf2 = FormattedRefNumber;
                        paymentGatway.Udf3 = FormattedtokenId;//DeclarationId;
                        paymentGatway.Udf4 = PaymentFor;
                        paymentGatway.Udf5 = ReferenceNumber.Replace(@"/", "."); // Actual Reference No like SMRNo, MRNo, Bayan No.

                        sParamSent += ", Udf1=" + paymentGatway.Udf1 + ", Udf2=" + paymentGatway.Udf2;
                        sParamSent += ", Udf3=" + paymentGatway.Udf3 + ", Udf4=" + paymentGatway.Udf4 + ", UDf5=" + paymentGatway.Udf5;

                        trackId = trackId == "0" ? Math.Abs(new Random().Next(1000000, 9999999)).ToString() : trackId;

                        paymentGatway.TrackId = trackId;
                        //paymentGatway.TransId = ; // Merchant track id possibly.

                        sParamSent += ", TrackId=" + paymentGatway.TrackId; // + ", Udf4=" + paymentGatway.Udf4;

                        transVal = paymentGatway.PerformInitTransaction();

                        PaymentId = paymentGatway.PaymentId;
                        paymentPage = paymentGatway.PaymentPage;

                        ErrorMsg = paymentGatway.ErrorMsg;
                        response = paymentGatway.RawResponse;

                        //log.SaveLog("Call Payment Gate Way GCS", "Parameter ValueSet = " + sParamSent, System.Diagnostics.EventLogEntryType.Information);

                        KNETPayReq KNETPayReq = new KNETPayReq();

                        KNETPayReq.Alias = alias;
                        KNETPayReq.Amt = Amount;
                        KNETPayReq.Auth = "";
                        KNETPayReq.Avr = "";
                        KNETPayReq.Currency = "414";
                        KNETPayReq.Date = "";
                        KNETPayReq.ErrorMsg = paymentGatway.ErrorMsg;// "0";// paymentGatway.ErrorMsg;// "0";// 
                        KNETPayReq.ErrorUrl = ErrorUrl;
                        KNETPayReq.KAction = "1";
                        KNETPayReq.Language = Resources.Resource.KnetInterfaceLanguage;
                        KNETPayReq.PaymentId = paymentGatway.PaymentId;//"0";// paymentGatway.PaymentId;//"0";// 
                        KNETPayReq.PaymentPage = paymentGatway.PaymentPage;// "0";// paymentGatway.PaymentPage;// "0";// 
                        KNETPayReq.RawResponse = paymentGatway.RawResponse;//"0";// paymentGatway.RawResponse;//"0";//
                        KNETPayReq.Ref = "";
                        KNETPayReq.ResourcePath = @resourcePath;
                        KNETPayReq.ResponseUrl = ResponseUrl;
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
                        //AH.LoggerCall<PayReq>(activity, LogLevel.Error, null, TokenId, "BEFORE LOG ", ErrorAt.PaymentReq, Pq);

                        //if (paidByType == "B")
                        //{
                        log.InitializePaymentDetails(DeclarationId, "Started", DateTime.Now, clientIpAddress,
                                         sessionId, userLoginId, portId, Amount, organizationId,
                                         PaymentFor, ReferenceNumber, ReferenceType, BrPaymentTransactionId, Convert.ToChar(paidByType),
                                         ErrorMsg, response, ReceiptId, PaymentId, trackId, TokenId, Mobile.Value, Email.Value);
                        // }\


                        Int64 PaymentIdCheck = 0;

                        IsInteger = Int64.TryParse(PaymentId, out PaymentIdCheck);
                    }

                    catch (Exception ex)
                    {
                        //log.SaveLog("RedirectToKnetGCS", "Error => " + ex.ToString() + "\nKnet Response => " + response + " Error=> " + ErrorMsg + "  PaymentId =>" + PaymentId, System.Diagnostics.EventLogEntryType.Error);
                       

                        AH.LoggerCall<PayReq>(activity, LogLevel.Error, ex, TokenId, "Issue during Payment Component processing or while making First payment entry in DB ", ErrorAt.PaymentReq, Pq);
                        ////****************HOW TO PROCEED IF ITS COMPONENT ISSUE ***********************

                        //Response.Redirect("../genericError.html", true);
                        //PaymentVerifierOnStart.InnerHtml = "<div class='alert alert-danger text-center'> Currently there are some issues ! . Please contact IT Team " + ex.Message + "</div>";
                        PaymentVerifierOnStartScriptCall(" Some momentary issue in accepting Payment  ! . Please contact IT Team or Try again Later ");// + ex.Message);
                        return;
                    }

                    if (transVal != 0 || !IsInteger)
                    {
                        // log ErrorMsg and response
                        //log.SaveLog("RedirectToKnetGCS", "Knet Response => " + response + " Error=> " + ErrorMsg + "  PaymentId =>" + PaymentId, System.Diagnostics.EventLogEntryType.Error);
                        //Response.Redirect("Error.aspx");
                        AH.LoggerCall<PayReq>(activity, LogLevel.Info, null, TokenId, "(transVal(" + transVal + ") != 0 || PaymentId(" + PaymentId + ")= not an integer) so Payment process discontinued ", ErrorAt.None, Pq);

                        //Response.Redirect("../genericError.html", true);

                        //PaymentVerifierOnStart.InnerHtml = "<div class='alert alert-danger text-center'> Currently there are some issues at KNET side ! . Please contact IT Team transval</div>";
                        PaymentVerifierOnStartScriptCall(" Some momentary issue during Payment Initialization ! . Please contact IT Team  or Try again Later");
                        return;
                    }
                    else
                    {
                        //string redirurl =  paymentPage + "?tokenId=" + tokenId + "&amount=" + Amount + "&paymentId=" + PaymentId; // +"&ReceiptNumber=" + FormattedRefNumber;
                        string redirurl = paymentPage + "?PaymentID=" + PaymentId;

                        try
                        {
                            //String ntokenId = tokenId.Replace("+", "____").Replace("/", "....");
                            //log.SaveLog("RedirectToKnetGCS", "with PaymentId=" + PaymentId + ", Token Id=" + ntokenId, System.Diagnostics.EventLogEntryType.Information);
                            //ReceiptNumber added by azhar on discuss with mohan and shan 

                            AH.LoggerCall<PayReq>(activity, LogLevel.Info, null, TokenId, "Redirecting to KNET => " + redirurl, ErrorAt.None, Pq);

                            //Response.Redirect(paymentPage + "?PaymentID=" + PaymentId);

                          
                            Response.Redirect(redirurl, false);//paymentPage + "?tokenId=" + tokenId + "&amount=" + Amount + "&paymentId=" + PaymentId); //+ "&PayID=" + PayID); // Redirects user to KNET Payment Page with parameter PaymentID
                        }
                        catch (Exception ex)
                        {
                            //    log.SaveLog("RedirectToKnetGCS", "Error calling, " + ecall.Source + "\n" + ecall.Message + "\n" + ecall.StackTrace + "\n " + redirurl, System.Diagnostics.EventLogEntryType.Error);
                            AH.LoggerCall<PayReq>(activity, LogLevel.Error, ex, TokenId, "Issue during Redirecting to KNET => " + redirurl, ErrorAt.PaymentReq, Pq);


                            ////****************HOW TO PROCEED IF ITS COMPONENT ISSUE ***********************
                            //Response.Redirect("../genericError.html", true);

                            //PaymentVerifierOnStart.InnerHtml = "<div class='alert alert-danger text-center'> Currently there are some issues in reaching KNET  ! . Please contact IT Team  " + ex.Message + "</div>";
                            PaymentVerifierOnStartScriptCall(" Some momentary issue in reaching KNET site  ! . Please contact IT Team or Try again Later ");// + ex.Message);
                            return;
                        }
                    }
                }
                else
                {
                    PaymentVerifierOnStartScriptCall("Payment Token expired or is an Invalid Token, Please try again .");
                    return;
                }
            }
            //else if(rd.TokenExpTime<DateTime.Now)
            //{
            //    PaymentVerifierOnStartScriptCall(VD.Message);
            //}
            else
            {
                //PaymentVerifierOnStartScriptCall("FROM CODE BEHIND");
                //PaymentVerifierOnStart.InnerHtml = "<div class='alert alert-danger text-center'> " + VD.Message + " ! </div>";
                PaymentVerifierOnStartScriptCall(VD.Message);
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
        public void PaymentVerifierOnStartScriptCall(string msg)
        {
            string script = "window.onload = function() { PaymentVerifierOnStart('" + msg + "'); };";
            ClientScript.RegisterStartupScript(this.GetType(), "PaymentVerifierOnStart", script, true);
        }

        //Using reflection to construct C# object from datatable
        public T BindData<T>(DataTable dt)
        {
            DataRow dr = dt.Rows[0];

            List<string> columns = new List<string>();
            foreach (DataColumn dc in dt.Columns)
            {
                columns.Add(dc.ColumnName);
            }

            var ob = Activator.CreateInstance<T>();

            var fields = typeof(T).GetFields();
            foreach (var fieldInfo in fields)
            {
                if (columns.Contains(fieldInfo.Name))
                {
                    fieldInfo.SetValue(ob, dr[fieldInfo.Name]);
                }
            }

            var properties = typeof(T).GetProperties();
            foreach (var propertyInfo in properties)
            {
                if (columns.Contains(propertyInfo.Name))
                {
                    // Fill the data into the property
                    //Below line is to avoid exception for case - 'Object of type 'System.DBNull' cannot be converted to type 'System.Nullable`1[System.Decimal]'.'

                    var propval = dr[propertyInfo.Name] == DBNull.Value ? null : dr[propertyInfo.Name];
                    logging LWS = new logging();
                    //Encrypting the the Token(bigint) from dataset and assigning the encrypted string to TokenId property
                    propval = propertyInfo.Name == "TokenId" ? LWS.Encrypt(propval.ToString()) : propval;
                    //if(propertyInfo.Name == "Amount")
                    //{
                    //    Convert.ToDecimal(propval) + 0.210
                    //}
                    //Below line to retain decimal value as string (18,3).. Normal decimal property round off it and removes unneccesary trailing zeroes
                    propval = propertyInfo.Name == "Amount" ? propval.ToString() : propval;
                    propertyInfo.SetValue(ob, propval, null);
                }
            }

            return ob;
        }



    }
}

