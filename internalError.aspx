<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="internalError.aspx.cs"
    Inherits="KnetPayment.internalError" %>

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
    <style type="text/css">
        table, th, td {
            margin-left: auto;
            margin-right: auto;
            border: 1px solid black;
            border-collapse: collapse;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
        }

        th, td {
            padding: 5px;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function close_window() {
            '<% clearAllSessions(); %>'
            if (confirm("Close Window?")) {
                window.top.close();
            }
        }

    </script>
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
            document.getElementById('footer').style.display = 'none';
            window.print();
            document.body.innerHTML = oldstr;
            return false;
        }
        function hidediv() {
            document.getElementById('footer').style.display = 'none';
        }
    </script>
</head>
<body dir="<% =Resources.Resource.dir %>" onload="hidediv();">
    <form id="form1" runat="server" method="post">
        <%
            String PaymentID = String.Empty;
            String result = String.Empty;
            String postdate = String.Empty;
            String tranid = String.Empty;
            String auth = String.Empty;
            String trackid = String.Empty;
            String refr = String.Empty;
            String Amount = String.Empty;
            String TempDecNo = String.Empty;
            String checkId = String.Empty;
            String declarationId = String.Empty;
            String ReferenceNumber = String.Empty;
            String BrPaymentTransactionId = String.Empty;
            String ReferenceId = String.Empty;
            String receiptNo = String.Empty;
            String PaymentType = String.Empty;
            String ReferenceType = String.Empty;
            String PaidByPrefixed = String.Empty;
            String ReceiptId = String.Empty;
            String PayID = String.Empty;
            String CustomsDuty = String.Empty;
            String HandlingCharges = String.Empty;
            String Storage = String.Empty;
            String Penalties = String.Empty;
            String Others = String.Empty;
            String Certificates = String.Empty;
            String Printing = String.Empty;
            String Guarantees = String.Empty;
            String OLTransId = String.Empty;
            String PrintedBy = String.Empty;

            KnetPayment.logging log = new KnetPayment.logging();
            log.SaveLog("InternalError", "Internal Error Page", System.Diagnostics.EventLogEntryType.Information);

            KnetPayment.PayReq Pq = new KnetPayment.PayReq();
            KnetPayment.Activity<KnetPayment.InternalError> activity = new KnetPayment.Activity<KnetPayment.InternalError>()
            {
                ActivityType = KnetPayment.ActivityType.Other,
            };
            KnetPayment.ActivityHandler AH = new KnetPayment.ActivityHandler();


            PaymentID = Request["paymentId"]; //' Reads the value of the Payment ID passed by GET request by the user.
            //result = Resources.Resource.cancelledOperation; //"Payment Successful";//Request["Result"]; //' Reads the value of the Result passed by GET request by the user.
            result = Request["Result"]; //"Payment Successful";//Request["Result"]; //' Reads the value of the Result passed by GET request by the user.
            postdate = DateTime.Now.ToString();//Request["PostDate"]; //' Reads the value of the PostDate passed by GET request by the user.
            tranid = Request["tranid"]; //' Reads the value of the TranID passed by GET request by the user.
                                        //auth = Request["auth"]; //' Reads the value of the Auth passed by GET request by the user.
            refr = Request["ref"]; //' Reads the value of the Ref passed by GET request by the user.
            trackid = Request["trackid"]; // ' Reads the value of the TrackID passed by GET request by the user.
            checkId = Request["trackid"];
            Amount = Request["udf1"]; ;
            ReferenceNumber = Request["udf2"];
            //declarationId = Request["udf3"];
            String tkId =string.IsNullOrEmpty(Request["udf3"] ) ? "0" :Request["udf3"]  ; 
            //receiptNo = Request["udf4"];
            TempDecNo = Request["udf2"];
            string KNETPayID = Request.QueryString["PaymentID"];
            string ErrorCode = Request.QueryString["ErrorCode"];
            KnetPayment.InternalError IErr = new KnetPayment.InternalError()
            {
                KNETPayID = KNETPayID,
                ErrorCode = ErrorCode,
                TokenId = tkId,
                Amount = Amount,
                checkId = checkId,
                postdate = postdate,
                ReferenceNumber = ReferenceNumber,
                refr = refr,
                result = result,
                TempDecNo = TempDecNo,
                //tkId = tkId,
                trackid = trackid,
                tranid = tranid
            };
            activity.TokenId = tkId;

            try
            {
                if (!String.IsNullOrEmpty(PaymentID) & !String.IsNullOrEmpty(tkId) & tkId !="0")
                {
                    System.Data.DataSet paymentDataSet = new System.Data.DataSet();

                    paymentDataSet = log.getPaymentDetails(tkId);//.Replace("_", "+").Replace(".", "/"));

                    log.SaveLog("InternalError", paymentDataSet.Tables.Count.ToString(), System.Diagnostics.EventLogEntryType.Information);

                    if (paymentDataSet.Tables.Count > 0)
                    {

                        Amount = paymentDataSet.Tables[0].Rows[0]["Amount"].ToString();

                        checkId = paymentDataSet.Tables[0].Rows[0]["CheckId"].ToString();
                        PaymentType = paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString();
                        TempDecNo = paymentDataSet.Tables[0].Rows[0]["TempDeclNumber"].ToString();
                        declarationId = paymentDataSet.Tables[0].Rows[0]["DeclarationId"].ToString();
                        OLTransId = paymentDataSet.Tables[0].Rows[0]["OLTransId"].ToString();

                        /*   BrPaymentTransactionId = paymentDataSet.Tables[0].Rows[0]["BrPaymentTransactionId"].ToString();                
                                     ReferenceType = paymentDataSet.Tables[0].Rows[0]["ReferenceType"].ToString();
                                     ReferenceNumber = paymentDataSet.Tables[0].Rows[0]["ReferenceNumber"].ToString();
                                     ReferenceId = paymentDataSet.Tables[0].Rows[0]["ReferenceId"].ToString();
                                     PaymentType = paymentDataSet.Tables[0].Rows[0]["PaymentFor"].ToString();                

                        OLTransId = paymentDataSet.Tables[0].Rows[0]["OLTransId"].ToString();

                                     PrintedBy = paymentDataSet.Tables[0].Rows[0]["UserId"].ToString();

                                     paidby = paymentDataSet.Tables[0].Rows[0]["PaidByType"].ToString();
                                     PaidByPrefixed = paymentDataSet.Tables[0].Rows[0]["UserId"].ToString();
                                     PrintedBy = paymentDataSet.Tables[0].Rows[0]["UserId"].ToString();
                                     ReceiptId = paymentDataSet.Tables[0].Rows[0]["ReceiptId"].ToString();
                                     redirectUrl = paymentDataSet.Tables[0].Rows[0]["RedirectURL"].ToString();
                                    */
                    }
                    else
                    {

                        log.SaveLog("InternalError", "No data from the received KNET Token", System.Diagnostics.EventLogEntryType.Information);
                        //KnetPayment.InternalError IErr = new KnetPayment.InternalError()
                        //{
                        //    KNETPayID = KNETPayID,
                        //    ErrorCode = ErrorCode,
                        //    TokenId = tkId
                        //};
                        AH.LoggerCall<KnetPayment.InternalError>(activity, KnetPayment.LogLevel.Error, null, tkId, "No data from the received KNET Token", KnetPayment.ErrorAt.Other, IErr);

                        Response.Redirect("genericError.html",false);//, true);
                    }
                }

                else
                {
                    log.SaveLog("InternalError", "Payment ID or TokenID(default=0) is null or Empty", System.Diagnostics.EventLogEntryType.Information);

                    //KnetPayment.InternalError IErr = new KnetPayment.InternalError()
                    //{
                    //    KNETPayID = KNETPayID,
                    //    ErrorCode = ErrorCode,
                    //    TokenId = tkId
                    //};
                    AH.LoggerCall<KnetPayment.InternalError>(activity, KnetPayment.LogLevel.Error, null, tkId, "Payment ID or TokenID(default=0) is null or Empty", KnetPayment.ErrorAt.Other, IErr);

                    Response.Redirect("genericError.html",false);//, true);
                }
            }
            catch (Exception ex)
            {
                log.SaveLog("InternalError", "Error in Internal Error Page"+ex.Message, System.Diagnostics.EventLogEntryType.Error);

                //KnetPayment.InternalError IErr = new KnetPayment.InternalError()
                //{
                //    KNETPayID = KNETPayID,
                //    ErrorCode = ErrorCode,
                //    TokenId = tkId
                //};
                AH.LoggerCall<KnetPayment.InternalError>(activity, KnetPayment.LogLevel.Error, ex, tkId, "Error in Internal Error Page", KnetPayment.ErrorAt.Other, IErr);

            }

            if (!String.IsNullOrEmpty(PaymentType))
            {
                if (PaymentType == "1")
                {
                    PaymentType = Resources.Resource.CustomsDuty;
                }
                else if (PaymentType == "2")
                {
                    PaymentType = Resources.Resource.deposits;
                }
            }

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
                            <img src="Images/Logo.png" alt="KGAC" style="width: 100px;" />
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
                                <% =Resources.Resource.HeaderMessage %>
                            </p>
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
                            <%=ReferenceNumber %>
                        </td>
                    </tr>
                    <tr>
                        <th class="hBordered">
                            <% =Resources.Resource.Result%>
                        </th>
                        <td class="Bordered">
                            <span style="color: Red; font-weight: bold;">
                                <%=result%></span>
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
                            <% =Resources.Resource.PaymentId %>
                        </th>
                        <td class="Bordered">
                            <%=PaymentID%>
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
                    <%-- <tr>
                    <th class="hBordered">
                        <%=Resources.Resource.OLTransId%>
                    </th>
                    <td class="Bordered">
                        <%=OLTransId%>
                    </td>
                </tr>--%>
                    <tr>
                        <th class="hBordered">
                            <%=Resources.Resource.PaidFor%>
                        </th>
                        <td class="Bordered">
                            <%=PaymentType%>
                        </td>
                    </tr>
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
                    <input type="reset" value="<%=Resources.Resource.OK%>" onclick="close_window(); return false;"
                        class="button" id="resetBtn" />

                    <%--<asp:Button id="cancelBtn" Text="cancel New" onclick="close_window();return false;" runat="server" />--%>

                    <input type="button" id="PrintBtn" value="<%=Resources.Resource.Print%>" onclick="printdiv('print_div')"
                        class="button" />

                    <asp:Button ID="btnResetServer" runat="server" Text="" OnClick="redirectTo" />
                </center>
            </div>
        </div>
    </form>
    <script type="text/javascript">

        function close_window() {
            var paidby = document.getElementById('paidby').value;

            if (paidby == 'O') // etrade call
            {
                //window.location.assign(redirectTo);
                document.getElementById('<%= btnResetServer.ClientID %>').click();
            }
            else {
                if (confirm("Close Window?")) {
                    window.top.close(); // Broker - Microclear call
                }
            }
        }
    </script>





</body>
</html>
