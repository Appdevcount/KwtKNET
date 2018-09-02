<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="errorPage.aspx.cs" Inherits="KnetPayment.errorPage" %>

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
       
        KnetPayment.logging log = new KnetPayment.logging();

        PaymentID = Request["paymentID"]; //' Reads the value of the Payment ID passed by GET request by the user.
        
        String Tranid = Request["TranID"];
        String Amount = Request["Amount"];
       


        // log.SaveLog("failed", "before IF", System.Diagnostics.EventLogEntryType.Information);

        //if (PaymentID != null && !String.IsNullOrEmpty(PaymentID))
        {
         //   System.Data.DataSet paymentDataSet = new System.Data.DataSet();

            //String decodedToken = Server.UrlDecode(tkId);
            //paymentDataSet = log.getPaymentDetails(tkId.Replace("_", "+").Replace(".", "/"));

            // log.SaveLog("failed", paymentDataSet.Tables.Count.ToString(), System.Diagnostics.EventLogEntryType.Information);

            //if (paymentDataSet.Tables.Count > 0)
            {
            //    paidby = paymentDataSet.Tables[0].Rows[0]["PaidByType"].ToString();
                //redirectUrl = paymentDataSet.Tables[0].Rows[0]["RedirectURL"].ToString();

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
                            <% =Resources.Resource.GCS %>
                            <br />
                            <% =Resources.Resource.Country %>
                        </span>
                    </td>
                    <td align="left">
                        <img src="Images/Logo.png" alt="KGAC" style="width: 120px;" />
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
            <table width="30%"  align="center" border="0">
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
            <table width="50%"  align="center" class="Bordered">
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
                        <% =Resources.Resource.Result %>
                    </th>
                    <td class="Bordered;">
                        <span style="color: Red; font-weight: bold;">
                            <%=Resources.Resource.cancelledOperation%></span>
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
                        <% =Resources.Resource.PaymentId %>
                    </th>
                    <td class="Bordered">
                        <%=PaymentID%>
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

            </table>
            
          
            
            
        </div>
        <div>
            <center style="padding-top:3px">
                <input type="reset" value="<%=Resources.Resource.OK%>" onclick="close_window();return false;"
                    class="button" id="resetBtn"/>

                

               

                    <asp:Button ID="btnResetServer" runat="server" Text="" OnClick="redirectTo"   />
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
