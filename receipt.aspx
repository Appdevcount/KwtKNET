<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="receiptUP.aspx.cs" Inherits="KnetPayment.receipt" %>

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
    <meta http-equiv="pragma" content="no-cache" />
    
    <script type="text/javascript">

        function PrintPanel() {
            var panel = document.getElementById("print_div");

            var printWindow = window.open('', '', 'height=1000,width=1000');
            printWindow.document.write('<html><head><title>DIV Contents</title>');
            printWindow.document.write('</head><body >');
            printWindow.document.write(panel.innerHTML);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            setTimeout(function () {
                printWindow.print();
            }, 500);
            return false;
        }

        function printdiv(printpage) {
            var headstr = "<html><head><title></title></head><body>";
            var footstr = "</body>";
            var newstr = document.all.item(printpage).innerHTML;
            var oldstr = document.body.innerHTML;
            document.body.innerHTML = headstr + newstr + footstr;
            document.getElementById('header').style.display = 'none';
            document.getElementById('footer').style.display = '';
            window.print();
            document.body.innerHTML = oldstr;
            return false;
        }
        function hidediv() {
            document.getElementById('footer').style.display = 'none';
        }
function close_window() {
                if (confirm("Close Window?")) {
                    window.top.close(); // Broker - Microclear call
                }
		}	
    </script>
</head>
<body dir="<% =Resources.Resource.dir %>" onload="hidediv();">



    <form id="form1" runat="server">
    <%


        String PaymentID = String.Empty;
        String result = String.Empty;
        String postdate = String.Empty;
        String tranid = String.Empty;
        String auth = String.Empty;
        String trackid = String.Empty;
        String refr = String.Empty;
        String Amount = String.Empty;
        String ReferenceNumber = String.Empty;
        String ReferenceType = String.Empty;
        String ReferenceId = String.Empty;
        String BrPaymentTransactionId = String.Empty;
        String receiptNo = String.Empty;
        String PaymentType = String.Empty;
        String ReceiptId = String.Empty;
        String OLTransId = String.Empty;
        String PaidByPrefixed = String.Empty;
        String PrintedBy = String.Empty;
        String ReceiptNumber = String.Empty;

        KnetPayment.logging log = new KnetPayment.logging();

        PaymentID = Request["paymentId"]; //' Reads the value of the Payment ID passed by GET request by the user.
        result = Resources.Resource.PaymentDone; //"Payment Successful";//Request["Result"]; //' Reads the value of the Result passed by GET request by the user.
                                                 // postdate = DateTime.Now.ToString();//Request["PostDate"]; //' Reads the value of the PostDate passed by GET request by the user.
        tranid = Request["tranid"]; //' Reads the value of the TranID passed by GET request by the user.
        auth = Request["auth"]; //' Reads the value of the Auth passed by GET request by the user.
        refr = Request["ref"]; //' Reads the value of the Ref passed by GET request by the user.
        trackid = Request["trackid"]; // ' Reads the value of the TrackID passed by GET request by the user.
        //checkId = Request["trackid"];
        Amount = Request["udf1"]; ;
        ReferenceNumber = Request["udf2"];
        //declarationId = Request["udf3"];
        String tkId = Request["udf3"];

        receiptNo = Request["udf4"];

        //System.Data.DataSet dsPaymentBreakDown = log.getPaymentBreakDown(PaymentID);
        //if (dsPaymentBreakDown.Tables.Count > 0)
        //{
        //    // .Tables[0].Rows[0]["Amount"].ToString()
        //    PayID = dsPaymentBreakDown.Tables[0].Rows[0]["PayID"].ToString();
        //    CustomsDuty = dsPaymentBreakDown.Tables[0].Rows[0]["CustomsDuty"].ToString();
        //    HandlingCharges = dsPaymentBreakDown.Tables[0].Rows[0]["HandlingCharges"].ToString();
        //    Storage = dsPaymentBreakDown.Tables[0].Rows[0]["Storage"].ToString();
        //    Penalties = dsPaymentBreakDown.Tables[0].Rows[0]["Penalties"].ToString();
        //    Others = dsPaymentBreakDown.Tables[0].Rows[0]["Others"].ToString();
        //    Certificates = dsPaymentBreakDown.Tables[0].Rows[0]["Certificates"].ToString();
        //    Printing = dsPaymentBreakDown.Tables[0].Rows[0]["Printing"].ToString();
        //    Guarantees = dsPaymentBreakDown.Tables[0].Rows[0]["Guarantees"].ToString();
        //}
        //else
        //{
        //    log.SaveLog("Break Down Details....", "Error while retrieving the Break Down Details for Payment Id  = " + PaymentID, System.Diagnostics.EventLogEntryType.Error);
        //    Response.Redirect("genericError.html", true);
        //}

        //TempDecNo = "12.gfh.MGH17"; // For testing 

        //TempDecNo = String.IsNullOrEmpty(TempDecNo) ? " " : TempDecNo.Replace(".", @"/");

        try
        {


            System.Data.DataSet paymentDataSet = new System.Data.DataSet();

            String sTokenId = tkId.Replace("_", "+").Replace(".", "/");
            if (log.VerifyOnlinePaymentDetailsGCSReceiptsKnet(sTokenId, PaymentID, Amount))
            {
                paymentDataSet = log.getPaymentDetails(sTokenId);//.Replace("_", "+").Replace(".", "/"));

                //log.SaveLog("ReceiptGCS", paymentDataSet.Tables.Count.ToString(), System.Diagnostics.EventLogEntryType.Information);

                if (paymentDataSet.Tables.Count > 0)
                {

                    Amount = paymentDataSet.Tables[0].Rows[0]["Amount"].ToString();
                    BrPaymentTransactionId = paymentDataSet.Tables[0].Rows[0]["BrPaymentTransactionId"].ToString();
                    PaymentType = paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString();
                    ReferenceNumber = paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"].ToString();
                    ReceiptNumber = paymentDataSet.Tables[0].Rows[0]["ReceiptNumber"].ToString();
                    ReferenceType = paymentDataSet.Tables[0].Rows[0]["ReferenceType"].ToString();
                    ReferenceId = paymentDataSet.Tables[0].Rows[0]["ReferenceId"].ToString();
                    OLTransId = paymentDataSet.Tables[0].Rows[0]["OLTransId"].ToString();
                    String PaidBy = paymentDataSet.Tables[0].Rows[0]["PaidByType"].ToString();
                    //if (Request["PostDate"] != null)
                    //{
                    //    postdate = Request["PostDate"].ToString();
                    //}
                    //else
                    //{
                    //    if (paymentDataSet.Tables[0].Columns.Contains("PostDate"))
                    //    {
                    postdate = paymentDataSet.Tables[0].Rows[0]["PostDate"].ToString();
                    //    }
                    //    else

                    //        postdate = System.DateTime.Now.ToString();
                    //}

                    PaidByPrefixed = (PaidBy == "O") ? Resources.Resource.Trader + " / " : Resources.Resource.Broker + " / ";
                    ReceiptId = paymentDataSet.Tables[0].Rows[0]["ReceiptId"].ToString();

                    //paidby = paymentDataSet.Tables[0].Rows[0]["PaidByType"].ToString();
                    // redirectUrl = paymentDataSet.Tables[0].Rows[0]["RedirectURL"].ToString();
                    //PaidByPrefixed = (PaidBy == "O") ? Resources.Resource.Trader + " / " : Resources.Resource.Broker + " / ";
                    PaidByPrefixed = paymentDataSet.Tables[0].Rows[0]["UserId"].ToString();
                    /*      if (Resources.Resource.dir == "ara")
                              PaidByPrefixed += paymentDataSet.Tables[0].Rows[0]["OrgNameAra"].ToString();
                          else
                              PaidByPrefixed += paymentDataSet.Tables[0].Rows[0]["OrgName"].ToString();
      */
                    PrintedBy = paymentDataSet.Tables[0].Rows[0]["UserId"].ToString();

                    //log.SaveLog("ReceiptGCS", OLTransId, System.Diagnostics.EventLogEntryType.Information);
                    log.SaveLog("ReceiptGCS", "Before calling Update PD with Post Date : " + postdate.ToString(), System.Diagnostics.EventLogEntryType.Information);

                    //      receiptNo = log.UpdatePaymentDetails
                    //(PaymentID, "", "", "Success", BrPaymentTransactionId,
                    // Int64.Parse(ReferenceId), tranid,
                    // DateTime.Now, "Success", DateTime.Now.ToString(),
                    // auth, refr, ReferenceNumber, ReferenceType, ReceiptId, PaymentType);
                }
                else
                {
                    Response.Redirect("genericError.html", true);
                }


                if (!String.IsNullOrEmpty(PaymentType))
                {

                    if (PaymentType == "1")
                    {
                        PaymentType = Resources.Resource.CustomsDuty;
                        //log.SaveLog("Test", PaymentFor, System.Diagnostics.EventLogEntryType.Information);
                    }
                    else if (PaymentType == "2")
                    {
                        PaymentType = Resources.Resource.deposits;
                        //log.SaveLog("Test1", PaymentFor, System.Diagnostics.EventLogEntryType.Information);
                    }
                    else if (PaymentType == "3")
                    {
                        PaymentType = Resources.Resource.GCS;
                        //log.SaveLog("Test1", PaymentFor, System.Diagnostics.EventLogEntryType.Information);
                    }
                }
            }
            else
            {
                 Response.Redirect("genericError.html", true);
            }

        }
        catch (Exception ex)
        {
            log.SaveLog("ReceiptGCS", "Error UpdatePaymentDetails  -" + ex.Source.ToString() + "=>" + ex.ToString(), System.Diagnostics.EventLogEntryType.Error);
            Response.Redirect("genericError.html", true);
        }

    %>
    <%--<img src="Images/<% =Resources.Resource.dir %>.gif" alt="" width="100%" />--%>
    <div style="position: relative;">
        <div id="print_div">
        <input type="hidden" name="paidby" id="paidby" value="<% =paidby%>" />
            <input type="hidden" name="clsMsg" id="clsMsg" value="<% =Resources.Resource.Close%>" />
            <!-- Page Header starts here -->
            <table width="50%" dir="<% =Resources.Resource.dir %>" align="center" style="margin-top: 5px;">
                <tr>
                    <td>
                        <span class="heading">
                            <% =Resources.Resource.GCS %>
                            <br />
                            <% =Resources.Resource.Country %>
                        </span>
                    </td>
                    <td align="left">
                        <img src="Images/gcslogo.png" alt="GCS" style="width: 150px;" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <hr />
                    </td>
                </tr>
                <tr>
                    <td align="center" width="100%" class="subheading" colspan="2">
                        <p style="font-weight: bold; width:100%" >
                            <% =Resources.Resource.HeaderMessage%></p>
                    </td>
                </tr>
            </table>
            <!-- Page Header ends here -->
            <table width="40%" border="0" align="center">
                <tr>
                    <td>
                        <img src="Images/Success.png" alt="Success" style="width: 20px; padding-bottom: 6px;" />
                    </td>
                    <td align="center" class="success">
                        <% =Resources.Resource.PaymentDone%>
                        <%--<hr style="width: 25%;" />
                        <% =Resources.Resource.ThanksMsg %>--%>
                    </td>
                </tr>
            </table>
            <table width="50%" border="0" align="center">
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <% =Resources.Resource.CustomerCopy%>
                        <br />
                        <% =Resources.Resource.DeclarationRcptMsg%>
                    </td>
                </tr>
            </table>
            <table width="40%" align="center" class="Bordered">
                <tr>
                    <td colspan="2" class="text">
                        <% =Resources.Resource.ReceiptTitle%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.PaymentType%>
                    </th>
                    <td class="Bordered">
                        <%=Resources.Resource.OnlinePayment%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.TempDeclarationNo%>
                    </th>
                    <td class="Bordered">
                        <%--<%=ReferenceNumber%>--%>
                 <%--       <%=ReferenceNumber%>--%>

                            <%=ReceiptNumber%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <% =Resources.Resource.Result%>
                    </th>
                    <td class="Bordered">
                        <%=result%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.PaymentMethod%>
                    </th>
                    <td class="Bordered">
                        <%=Resources.Resource.Knet%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.Amount%>
                    </th>
                    <td class="Bordered">
                        <%=Amount%>
                        &nbsp;
                        <%=Resources.Resource.kd%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <% =Resources.Resource.PaymentId%>
                    </th>
                    <td class="Bordered">
                        <%=PaymentID%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.OnlineReceiptNo%>
                    </th>
                    <td class="Bordered">
                     <%--   <%=ReceiptNumber%>--%>
                      <%=ReferenceNumber%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.PaidBy%>
                    </th>
                    <td class="Bordered">
                        <%=PaidByPrefixed%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.Date_Time%>
                    </th>
                    <td class="Bordered">
                        <%=postdate%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.BanckAuthenNo%>
                    </th>
                    <td class="Bordered">
                        <%=auth%>
                    </td>
                </tr>
                <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.OLTransId%>
                    </th>
                    <td class="Bordered">
                        <%--  <%=OLTransId%>--%>
                        <%=tranid%>
                    </td>
                </tr>
                <%--<tr>
                    <th class="hBordered">
                        <%=Resources.Resource.PaidFor%>
                    </th>
                    <td class="Bordered">
                        <%=PaymentType%>
                    </td>
                </tr>--%>
            </table>
            <br />
            <div id="header" style="background-color: White;">
            </div>
            <div id="footer" style="background-color: White; display: none;">
                <span style="position: relative; left: 30px;">Printed by
                    <%=PrintedBy%>
                </span><span style="position: relative; left: 300px">Printed at
                    <%=DateTime.Now.ToString("dd/MM/yyyy h:mm tt")%></span>
            </div>
        </div>
        <div>
            <center>
                <input type="reset" value="<%=Resources.Resource.OK%>" onclick="close_window();return false;"
                    class="button" />
                <input type="button" id="PrintBtn" value="<%=Resources.Resource.Print%>" onclick="printdiv('print_div')"
                    class="button" />

                    <asp:Button ID="btnResetServer" runat="server" Text="" OnClick="redirectTo"   />
            </center>
        </div>
    </div>
    </form>

<script type="text/javascript">

    function close_window() {
        var clsMsg = document.getElementById('clsMsg').value; 
         //   if (confirm("Close Window?")) {
        if (confirm(clsMsg)) {
        window.top.close(); // Broker - Microclear call
            }
        
    }
    </script>

</body>
</html>
