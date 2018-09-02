<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="KnetPayment.Error" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="pragma" content="no-cache" />
    <% if (language.Contains("ar"))
       { %>
    <link href="css/stAra.css" rel="stylesheet" type="text/css" />
    <% }
       else
       { %>
    <link href="css/st.css" rel="stylesheet" type="text/css" />
    <% } %>
    <title>
        <%=Resources.Resource.ReceiptTitle%>
    </title>
    
</head>
<body dir="<% =Resources.Resource.dir %>">
    <form id="form1" runat="server" method="post">
    <%
        String PaymentID = String.Empty;
        //String result = String.Empty;
        //String postdate = String.Empty;
        //String tranid = String.Empty;
        //String auth = String.Empty;
        //String trackid = String.Empty;
        //String refr = String.Empty;
        //String Amount = String.Empty;
        //String TempDecNo = String.Empty;
        //String checkId = String.Empty;
        //String declarationId = String.Empty;
        //String receiptNo = String.Empty;
        //String PaymentType = String.Empty;
        //String PayID = String.Empty;
        //String CustomsDuty = String.Empty;
        //String HandlingCharges = String.Empty;
        //String Storage = String.Empty;
        //String Penalties = String.Empty;
        //String Others = String.Empty;
        //String Certificates = String.Empty;
        //String Printing = String.Empty;
        //String Guarantees = String.Empty;


        KnetPayment.logging log = new KnetPayment.logging();

        PaymentID = Request["paymentID"]; //' Reads the value of the Payment ID passed by GET request by the user.
        //result = Resources.Resource.cancelledOperation; //"Payment Successful";//Request["Result"]; //' Reads the value of the Result passed by GET request by the user.
        //postdate = DateTime.Now.ToString();//Request["PostDate"]; //' Reads the value of the PostDate passed by GET request by the user.
        //tranid = Request["tranid"]; //' Reads the value of the TranID passed by GET request by the user.
        ////auth = Request["auth"]; //' Reads the value of the Auth passed by GET request by the user.
        //refr = Request["ref"]; //' Reads the value of the Ref passed by GET request by the user.
        //trackid = Request["trackid"]; // ' Reads the value of the TrackID passed by GET request by the user.
        //checkId = Request["trackid"];
       // Amount = Request["udf1"]; ;
        //TempDecNo = Request["udf2"];
        //declarationId = Request["udf3"];
        String tkId = Request["udf3"];
        //String OLTransId = String.Empty;
       /// String PrintedBy = String.Empty;
        //receiptNo = Request["udf4"];


        //log.SaveLog("failed", "before IF", System.Diagnostics.EventLogEntryType.Information);

        if (PaymentID != null && !String.IsNullOrEmpty(PaymentID))
        {
            System.Data.DataSet paymentDataSet = new System.Data.DataSet();

            //String decodedToken = Server.UrlDecode(tkId);
            paymentDataSet = log.getPaymentDetails(tkId.Replace("_", "+").Replace(".", "/"));

            //log.SaveLog("failed", paymentDataSet.Tables.Count.ToString(), System.Diagnostics.EventLogEntryType.Information);

            if (paymentDataSet.Tables.Count > 0)
            {

                //Amount = paymentDataSet.Tables[0].Rows[0]["Amount"].ToString();
                //checkId = paymentDataSet.Tables[0].Rows[0]["CheckId"].ToString();
                //PaymentType = paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString();
                //TempDecNo = paymentDataSet.Tables[0].Rows[0]["TempDeclNumber"].ToString();
                //declarationId = paymentDataSet.Tables[0].Rows[0]["DeclarationId"].ToString();
                //OLTransId = paymentDataSet.Tables[0].Rows[0]["OLTransId"].ToString();

                //PrintedBy = paymentDataSet.Tables[0].Rows[0]["UserId"].ToString();



                paidby = paymentDataSet.Tables[0].Rows[0]["PaidByType"].ToString();
                redirectUrl = paymentDataSet.Tables[0].Rows[0]["RedirectURL"].ToString();

                //log.SaveLog("failed", paidby + " " + redirectUrl, System.Diagnostics.EventLogEntryType.Information);

            }
        }
        //    else
        //    {
        //        Response.Redirect("genericError.html", true);
        //    }
        //}

        
       
    %>



   
    <div style="position: relative;">
    
        <div id="print_div">
            <input type="hidden" name="paidby" id="paidby" value="<% =paidby%>" />
            <!-- Page Header starts here -->
            <table width="50%" dir="<% =Resources.Resource.dir %>" align="center" style="margin-top: 5px;">
                <tr>
                    <td>
                        <span class="heading">
                            <% =Resources.Resource.KGAC %>
                            <br />
                            <% =Resources.Resource.Country %>
                        </span>
                    </td>
                    <td align="left">
                        <img src="Images/Logo.png" alt="KGAC" style="width: 60px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <hr />
                    </td>
                </tr>
                <tr>
                    <td align="center" width="100%" class="subheading" colspan="2">
                        <p style="font-weight: bold;">
                            <% =Resources.Resource.HeaderMessage %></p>
                    </td>
                </tr>
            </table>
            <!-- Page Header ends here -->
            <table width="20%" border="0" align="center">
                <tr>
                    <td>
                        <img src="Images/Failed.png" alt="Failed" style="width: 20px; padding-bottom: 6px;" />
                    </td>
                    <td class="failed" style="text-align: center;">
                        <% =Resources.Resource.cancelledOperation%>
                        <br />
                        <hr style="width: 25%;" />
                        <% =Resources.Resource.ErrorMsg%>
                    </td>
                </tr>
            </table>
            
          
            
            
        </div>
        <div>
            <center >
                <input type="reset" value="<%=Resources.Resource.OK%>" onclick="close_window();return false;"
                    class="button" id="resetBtn"/>

                

               

                    <asp:Button ID="btnResetServer" runat="server" Text="" OnClick="redirectTo"   />
            </center>
        </div>
    </div>
    </form>
    <script type="text/javascript">

        function close_window() 
        {
            var paidby = document.getElementById('paidby').value;

            if (paidby == 'O') // etrade call
            {
                //window.location.assign(redirectTo);
                document.getElementById('<%= btnResetServer.ClientID %>').click();
            }
            else 
            {
                if (confirm("Close Window?")) 
                {
                    window.top.close(); // Broker - Microclear call
                }
            }
        }
    </script>


    


</body>
</html>

