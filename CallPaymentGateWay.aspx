<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CallPaymentGateWay.aspx.cs"
    Inherits="KnetPayment.CallPaymentGateWay" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="css/st.css" rel="stylesheet" type="text/css" />
    <base target="_self" />
    <meta http-equiv="pragma" content="no-cache" />
    <title></title>
    <script type="text/javascript">

        function hMouseClick(e) 
        {
            if (e.button == 2) 
            {
                alert('...غير مسموح / ...Not allowed');
                e.preventDefault();
                return false;
            }
        }

        document.addEventListener('contextmenu', hMouseClick);
        //document.addEventListener('mouseup', hMouseClick);

    </script>
</head>
<body dir="<% =Resources.Resource.dir %>">

   <input type="hidden" name="clsMsg" id="clsMsg" value="<% =Resources.Resource.Close%>" />
    <%--<img src="Images/<% =Resources.Resource.dir %>.gif" alt="" width="100%" />--%>
    <input type="hidden" name="paidby" id="paidby" value="<% =paidby%>" />
    <!-- Page Header starts here -->
    <table width="60%" dir="<% =Resources.Resource.dir %>" align="center" style="margin-top: 5px;">
        <tr>
            <td style="padding-left: 25px;" align="left">
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
                <p>
                    <% =Resources.Resource.HeaderMessage %></p>
            </td>
        </tr>
    </table>
    <!-- Page Header ends here -->
    <table width="100%" border="0" cellpadding="1" cellspacing="1">
        <tr>
            <td align="center">
                <table width="85%" border="0">
                    <tr>
                        <td align="center" width="100%" class="subheading1">
                            <% =Resources.Resource.WarningMessage1 %>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" width="100%" class="heading21">
                            <% =Resources.Resource.WarningMessage2 %>
                            <br />
                            <% =Resources.Resource.WarningMessage21 %>

                        </td>
                    </tr>
                    <tr>
                        <td align="center" width="100%" class="subheading1">
                            <% =Resources.Resource.WarningMessage3 %>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="tdwhite" colspan="3" align="center">
                <p class="utext">
                    <% =Resources.Resource.brokerMsg%></p>
            </td>
        </tr>
        <tr>
            <td class="subheading" colspan="3" align="center">
                <% =Resources.Resource.BrokerMailId%>                <% =PayeeMailId%>
            </td>
        </tr>
        <tr>
            <td class="tdwhite" colspan="3" align="center">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tdwhite">
                <table width="50%" align="center" cellpadding="0" cellspacing="1" border="1">
                    <tr>
                        <th class="tdfixed">
                            <%--Declaration Number--%>                              <%--     <% =Resources.Resource.DeclarationNumber %> --%>						                          <%--   <% =Resources.Resource.TempDeclarationNo %>	 --%>								                      <% =Resources.Resource.ReferenceNumber %>				
													 
													 
                        </th>
                        <th class="tdfixed">
                            <%--Amount--%>                            <% =Resources.Resource.Amount %>
                        </th>
                    </tr>
                    <tr>
                        <td class="tdwhite">
                            <%--<%= ReferenceNumber%>--%>                            <%= ReceiptNumber%>

                        </td>
                        <td class="tdwhite">
                            <%=amount%>&nbsp;
                            <%=Resources.Resource.kd%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="tdwhite">
                <form id="Form1" runat="server" target="_parent">
                <input type="hidden" name="declarationId" value="<%=ReferenceNumber%>" />
                <input type="hidden" name="amount" value="<%= amount %>" />
                <table width="70%" border="0" align="center" cellpadding="0" cellspacing="1">
                    <tr>
                        <td class="tdwhite" colspan="3">
                        </td>
                    </tr>
                    <tr>
                        <td class="tdwhite" colspan="3" align="center">
                            <br />
                            <span>
                                <asp:Button ID="ProceedtoKnet" runat="server" class="button" OnClick="ProceedtoKnet_Click" /></span>
                            <%--<input type="submit" value="<%=Resources.Resource.Proceed%>" onclick="<% CallKnetPage(); %>" />--%>
                            <span>
                                <input type="reset" value="<%=Resources.Resource.Cancel%>" onclick="close_window();return false;"
                                    class="button" /></span>
                            <asp:Button ID="btnResetServer" runat="server" Text="" OnClick="redirectTo" />
                        </td>
                    </tr>
                </table>
                </form>
            </td>
        </tr>
    </table>
    <script type="text/javascript">

        function close_window() {
            var paidby = document.getElementById('paidby').value;
            var clsMsg = document.getElementById('clsMsg').value; 

            if (paidby == 'O') // etrade call
            {
                //window.location.assign(redirectTo);
                document.getElementById('<%= btnResetServer.ClientID %>').click();
            }
            else {
             //   if (confirm("Close Window?")) {
                if (confirm(clsMsg)) {
                    window.top.close(); // Broker - Microclear call
                }
            }
        }
    </script>
    <%--<asp:Button ID="ToggleCommunicationTest" runat="server" OnClick="ToggleCommunicationTest_Click" Text="Toggle Communication Test" />--%>
</body>
</html>
