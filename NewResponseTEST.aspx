<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewResponseTEST.aspx.cs" Inherits="KnetPayment.NewResponseTEST" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title></title>
</head>

<body style="color: White; background-color: White;">
</body>
</html>

<%

    String siteUrlT = ConfigurationManager.AppSettings["siteUrl"].ToString();
    String receiptUrlT = siteUrlT + "receiptTEST.aspx";
    Response.Write("REDIRECT=" + receiptUrlT);//udfPaymentType);
 
    //}
%>
