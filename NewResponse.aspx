<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewResponseUP.aspx.cs" Inherits="KnetPayment.NewResponse" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title></title>
</head>

<body style="color: White; background-color: White;">
</body>
</html>

<%

    KnetPayment.logging log = new KnetPayment.logging();
    //log.SaveLog("NewResponse", "Start", System.Diagnostics.EventLogEntryType.Information);

    String TempDecNo = String.Empty;
    String checkId = String.Empty;
    String declarationId = "0";
    String receiptNo = String.Empty;
    String PaymentType = String.Empty;
    String PayID = String.Empty;


    String paymentID, result, postdate, tranid, auth, trackid, refr, RefId, BrTranId;
    String udfAmount = String.Empty;
    String udfTempDecNo = String.Empty;
    String udfDeclaraTionId = String.Empty;
    String udfPaymentType = String.Empty; //,  udf5 
    String tkId = String.Empty;

    string EToeknId = "0";
    KnetPayment.ActivityHandler AH = new KnetPayment.ActivityHandler();
    KnetPayment.Activity<KnetPayment.PayResp> activity = new KnetPayment.Activity<KnetPayment.PayResp>()
    {
        ActivityType = KnetPayment.ActivityType.RespLog,
    };


    // Reads the parameters passed via POST request by the PG
    paymentID = Request.Form["paymentID"];
    result = Request.Form["result"];
    postdate = Request.Form["postdate"];
    tranid = Request.Form["tranid"];
    auth = Request.Form["auth"];
    refr = Request.Form["ref"];
    trackid = Request.Form["trackid"];

    // KnetPayment.logging l = new KnetPayment.logging();
    KnetPayment.PayResp Pr = new KnetPayment.PayResp()
    {
        paymentID = paymentID,
        result = result,
        postdate = postdate,
        tranid = tranid,
        auth = auth,
        refn = refr,
        trackid = trackid,

    };


    //Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
    //Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
    //Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
    //Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;


    //AH.LoggerCall<KnetPayment.PayResp>(activity,KnetPayment.LogLevel.Error, null, EToeknId, "Just before 0==1", KnetPayment.ErrorAt.PaymentResp, Pr);
    //if (1 == 1)
    //{
    //Response.StatusCode = 404;
    //}
    //if (0 == 1)
    //{
    //KnetPayment.NewResponse NR = new KnetPayment.NewResponse();
    log.SaveLog("NewResponseGCS", "REACHED", System.Diagnostics.EventLogEntryType.Information);

    String siteUrl = ConfigurationManager.AppSettings["siteUrl"].ToString();
    String receiptUrl = siteUrl + "receipt.aspx?";

    bool ErrorAlert =Convert.ToBoolean( ConfigurationManager.AppSettings["ErrorAlert"].ToString());

    try
    {
        udfAmount = Request.Form["udf1"];
        udfTempDecNo = Request.Form["udf2"];
        //udfDeclaraTionId = Request.Form["udf3"];
        tkId = Request.Form["udf3"];//??"0";
        // checkId = Request.Form["trackid"];
        udfPaymentType = Request.Form["udf4"];
        EToeknId = tkId;
        // log.SaveLog("NewResponseGCS", "Result : " + result + " for Token Id=" + tkId, System.Diagnostics.EventLogEntryType.Information);

        //System.Data.DataSet dsPaymentBreakDown = log.getPaymentBreakDown(paymentID);
        //if (dsPaymentBreakDown.Tables.Count > 0)
        //{
        //    // .Tables[0].Rows[0]["Amount"].ToString()

        //    PayID = dsPaymentBreakDown.Tables[0].Rows[0]["PayID"].ToString();

        //}
        //else
        //{
        //    log.SaveLog("Break Down Details....", "Error while retrieving the Break Down Details for Payment Id  = " + paymentID, System.Diagnostics.EventLogEntryType.Error);
        //    Response.Redirect("genericError.html", true);
        //}
        log.SaveLog("NewResponseGCS", "REACHED READING udfAmount=" + udfAmount + " , udfTempDecNo=" + udfTempDecNo + " , tkId=" + tkId ?? "0", System.Diagnostics.EventLogEntryType.Information);

    }
    catch (Exception d)
    {
        log.SaveLog("NewResponseGCS", "Error : " + d.Source.ToString() + "=>" + d.ToString() + " u1=" + udfAmount + " u2=" + udfTempDecNo + " u3=" + udfDeclaraTionId + " u4" + udfPaymentType, System.Diagnostics.EventLogEntryType.Error);//+ " u4" + udf4, System.Diagnostics.EventLogEntryType.Error);

        Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
        Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
        Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
        Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;


        AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Error, d, EToeknId, "Form value reading error", KnetPayment.ErrorAt.PaymentResp, Pr);

        //Added redirection newly
        string Alertmsg = ErrorAlert ? "?Alertmsg="+"Form value reading error" : "";
        String errorUrl = siteUrl + "genericError.html"+Alertmsg;
        Response.Write("REDIRECT=" + errorUrl);
        //Response.Redirect(errorUrl);
    }


    //log.SaveLog("NewResponse", result, System.Diagnostics.EventLogEntryType.Error);


    System.Data.DataSet paymentDataSet = new System.Data.DataSet();

    if (!String.IsNullOrEmpty(tkId) | !String.IsNullOrEmpty(paymentID))
    {
        String decodedtokenId = tkId; //.Replace("_", "+").Replace(".", "/");
                                      //if ( result == "CAPTURED" )
                                      //decodedtokenId = tkId.Replace("____", "+").Replace("....", "/");

        //log.SaveLog("NewResponseGCS", "Result : " + result + " for formatted Token Id=" + decodedtokenId, System.Diagnostics.EventLogEntryType.Information);
        try
        {
            //string EToeknId = tkId;//!string.IsNullOrEmpty(tkId) ? log.ExplicitDecryptTokenCall(tkId) : "0";

            if (log.VerifyOnlinePaymentDetailsGCSReceiptsKnet(tkId, paymentID, udfAmount))
            {
                paymentDataSet = log.getPaymentDetails(decodedtokenId);//.Replace(".", @"/"));

                if (paymentDataSet.Tables.Count > 0)
                {
                    // checkId = paymentDataSet.Tables[0].Rows[0]["CheckId"].ToString();
                    PaymentType = paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString();
                    // TempDecNo = paymentDataSet.Tables[0].Rows[0]["TempDeclNumber"].ToString();
                    RefId = paymentDataSet.Tables[0].Rows[0]["ReferenceId"].ToString();

                    // added the below block to fix the PayID value not being passed issue. - 06-apr-2018 - gh.mani
                    PayID = paymentDataSet.Tables[0].Rows[0]["OLPaymentId"].ToString();

                    BrTranId = paymentDataSet.Tables[0].Rows[0]["BrPaymentTransactionId"].ToString();

                    String ReceiptId = paymentDataSet.Tables[0].Rows[0]["ReceiptId"].ToString();
                    String RefNumber = paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"].ToString();
                    String RefType = paymentDataSet.Tables[0].Rows[0]["ReferenceType"].ToString();
                    //String PayType = paymentDataSet.Tables[0].Rows[0]["PaymentType"].ToString();

                    //String FormattedtokenId = "";
                    //if (tkId != "")
                    //   FormattedtokenId = log.ExplicitDecryptTokenCall(tkId);

                    log.SaveLog("NewResponseGCS", "Token Id = " + tkId + ", formatted Token id=" + EToeknId + "PaymentStatus = " + result, System.Diagnostics.EventLogEntryType.Information);

                    Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
                    Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
                    Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
                    Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;


                    AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Warn, null, tkId, "PaymentStatus = " + result, KnetPayment.ErrorAt.None, Pr);


                    if (result == "CAPTURED")
                    {

                        receiptNo = log.UpdatePaymentDetails
                         (PayID, "", result, "Success", BrTranId,
                          Int64.Parse(RefId), tranid,               //  Passing ReferenceId thru DeclId
                          DateTime.Now, "Success", postdate,        // save PostDate from KNet
                          auth, refr, RefNumber, RefType,
                          // PayID, CustomsDuty,HandlingCharges, Storage, Penalties, Others,Certificates, Printing, Guarantees,
                          ReceiptId, PaymentType, EToeknId);

                        //      Certificates, Printing, Guarantees, ReceiptId, BrTranId, PaymentFor);


                        //log.SaveLog("NewResponse.Update Success", "For " + TempDecNo + " u1" + udfAmount + " u2" + udfTempDecNo + " u3" + udfDeclaraTionId + " u4" + udfPaymentType, System.Diagnostics.EventLogEntryType.Information );//+ " u4" + udf4, System.Diagnostics.EventLogEntryType.Error);


                        //Response.Redirect(receiptUrl + "PaymentID=" + paymentID + "&Result=" + result + "&PostDate=" + postdate + "&TranID=" + tranid + "&Auth=" + auth + "&Ref=" + refr + "&TrackID=" + trackid + "&UDF1=" + udfAmount + "&UDF2=" + udfTempDecNo + "&UDF3=" + udfDeclaraTionId + "&UDF4=" + udfPaymentType); 
                        Response.Write("REDIRECT=" + receiptUrl + "PaymentID=" + paymentID + "&Result=" + result + "&PostDate=" + postdate + "&TranID=" + tranid + "&Auth=" + auth + "&Ref=" + refr + "&TrackID=" + trackid + "&UDF1=" + udfAmount + "&UDF2=" + udfTempDecNo + "&UDF3=" + tkId + "&UDF4=" + receiptNo);//udfPaymentType);
                    }
                    else if (result == "CANCELED")
                    {
                        // ASK Mohammad, Gopinath
                        String canceledUrl = siteUrl + "errorPage.aspx?Amount=" + udfAmount + "&PaymentID=" + paymentID; //"internalError.aspx?";

                        log.UpdatePaymentDetailsCanceledOrFailed(
                       paymentID, "", result, "Cancelled", BrTranId,
                                            Int64.Parse(RefId), tranid,
                                            DateTime.Now, "Cancelled", postdate,
                                            auth, refr, RefNumber, RefType,
                                                 // PayID, CustomsDuty,HandlingCharges, Storage, Penalties, Others,Certificates, Printing, Guarantees,
                                                 ReceiptId, PaymentType, EToeknId
                                                 );


                        //log.SaveLog("NewResponseGCS", "Update Cancelled For " + TempDecNo + " u1" + udfAmount + " u2" + udfTempDecNo + " u3" + udfDeclaraTionId + " u4" + udfPaymentType, System.Diagnostics.EventLogEntryType.Information);//+ " u4" + udf4, System.Diagnostics.EventLogEntryType.Error);

                        //canceledUrl = siteUrl + "Error.aspx"; // "InternalError.aspx?";
                        //Response.Write(canceledUrl); //("REDIRECT=https://csinternal.kgac.gov.kw/KNetPayment/InternalError.aspx");
                        //Response.Write("REDIRECT=" + canceledUrl + "PaymentID=" + paymentID + "&Result=" + result + "&PostDate=" + postdate + "&TranID=" + tranid + "&Auth=" + auth + "&Ref=" + refr + "&TrackID=" + trackid + "&UDF1=" + udfAmount + "&UDF2=" + udfTempDecNo + "&UDF3=" + tkId + "&UDF4=" + String.Empty);//udfPaymentType);

                        Response.Write("REDIRECT=" + canceledUrl);//udfPaymentType);

                    }


                    else
                    {
                        //Response.Write("REDIRECT=https://csinternal.kgac.gov.kw/KNetPayment/Error.aspx");
                        String receiptFailedUrl = siteUrl + "receiptFailed.aspx?";

                        //AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Warn, null, tkId, paymentID+"  |  "+ "Payment Failed"+"  |  "+ result+"  |  "+ "Failed"+"  |  "+ BrTranId+"  |  "+
                        //                    Int64.Parse(RefId)+"  |  "+ tranid+"  |  "+
                        //                    DateTime.Now+"  |  "+ "Failed"+"  |  "+ postdate+"  |  "+
                        //                    auth+"  |  "+ refr+"  |  "+ RefNumber+"  |  "+ RefType+"  |  "+

                        //                         ReceiptId+"  |  "+ PaymentType+"  |  "+ EToeknId, KnetPayment.ErrorAt.None, Pr);

                        log.UpdatePaymentDetailsCanceledOrFailed
                                            (paymentID, "Payment Failed", result, "Failed", BrTranId,
                                             Int64.Parse(RefId), tranid,
                                             DateTime.Now, "Failed", postdate,
                                             auth, refr, RefNumber, RefType,
                                                  // PayID, CustomsDuty,HandlingCharges, Storage, Penalties, Others,Certificates, Printing, Guarantees,
                                                  ReceiptId, PaymentType, EToeknId
                                                  );

                        //log.SaveLog("NewResponse", result, System.Diagnostics.EventLogEntryType.Information);

                        //log.SaveLog("NewResponseGCS", "Update Failed For " + TempDecNo + " u1" + udfAmount + " u2" + udfTempDecNo + " u3" + udfDeclaraTionId + " u4" + udfPaymentType + " Token = " + tkId, System.Diagnostics.EventLogEntryType.Information);//+ " u4" + udf4, System.Diagnostics.EventLogEntryType.Error);

                        //Response.Write("REDIRECT=" + receiptFailedUrl + "PaymentID=" + paymentID + "&Result=" + result + "&PostDate=" + postdate + "&TranID=" + tranid + "&Auth=" + auth + "&Ref=" + refr + "&TrackID=" + trackid + "&UDF1=" + udfAmount + "&UDF2=" + udfTempDecNo + "&UDF3=" + tkId + "&UDF4=" + receiptNo);// udfPaymentType); // + "&UDF4=" + udf4);
                        Response.Write("REDIRECT=" + receiptFailedUrl + "PaymentID=" + paymentID + "&Result=" + result + "&PostDate=" + postdate + "&TranID=" + tranid + "&Auth=" + auth + "&Ref=" + refr + "&TrackID=" + trackid + "&UDF1=" + udfAmount + "&UDF2=" + udfTempDecNo + "&UDF3=" + tkId + "&UDF4=" + String.Empty);//udfPaymentType);
                    }



                }

                else
                {
                    Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
                    Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
                    Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
                    Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;

                    AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Warn, null, tkId, "Token Expired or No active Payment details available for the received Token", KnetPayment.ErrorAt.None, Pr);


                    string Alertmsg = ErrorAlert ? "?Alertmsg="+"Token Expired or No active Payment details available for the received Token" : "";
                    String errorUrl = siteUrl + "genericError.html"+Alertmsg;
                    //Response.Write("REDIRECT=" + errorUrl);
                    Response.Redirect(errorUrl);
                }
            }
            else
            {
                log.SaveLog("NewResponseGCS", " False - VerifyOnlinePaymentDetailsGCSReceiptsKnet - ", System.Diagnostics.EventLogEntryType.Information);

                Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
                Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
                Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
                Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;

                AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Warn, null, tkId, "Response not matching any valid requests", KnetPayment.ErrorAt.None, Pr);


                string Alertmsg = ErrorAlert ? "?Alertmsg="+"Response not matching any valid requests" : "";
                String errorUrl = siteUrl + "genericError.html"+Alertmsg;
                //Response.Write("REDIRECT=" + errorUrl);
                Response.Redirect(errorUrl);
            }

        }
        catch (Exception e)
        {
            log.SaveLog("NewResponseGCS", "Issue occured during Payment Status update or redirection to confirmation page", System.Diagnostics.EventLogEntryType.Information);

            Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
            Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
            Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
            Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;



            AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Error, e, tkId, "Issue occured during Payment Status update or redirection to confirmation page", KnetPayment.ErrorAt.PaymentResp, Pr);

            string Alertmsg = ErrorAlert ? "?Alertmsg="+"Issue occured during Payment Status update or redirection to confirmation page" : "";
            String errorUrl = siteUrl + "genericError.html"+Alertmsg;
            //Response.Write("REDIRECT=" + errorUrl);
            Response.Redirect(errorUrl);
        }


    }
    else
    {
        Pr.udf1 = string.IsNullOrEmpty(udfAmount) ? null : udfAmount;
        Pr.udf2 = string.IsNullOrEmpty(udfTempDecNo) ? null : udfTempDecNo;
        Pr.udf3 = string.IsNullOrEmpty(tkId) ? null : tkId;
        Pr.udf4 = string.IsNullOrEmpty(udfPaymentType) ? null : udfPaymentType;


        log.SaveLog("NewResponseGCS", "KNET PaymentID or Token ID received as null or empty", System.Diagnostics.EventLogEntryType.Information);

        AH.LoggerCall<KnetPayment.PayResp>(activity, KnetPayment.LogLevel.Error, null, tkId, "KNET PaymentID or Token ID received as null or empty", KnetPayment.ErrorAt.PaymentResp, Pr);

        string Alertmsg = ErrorAlert ? "?Alertmsg="+"KNET PaymentID or Token ID received as null or empty" : "";
        String errorUrl = siteUrl + "genericError.html"+Alertmsg;
        Response.Write("REDIRECT=" + errorUrl);
        //Response.Redirect(errorUrl);
    }

    //}
%>
