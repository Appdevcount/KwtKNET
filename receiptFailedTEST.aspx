<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="receiptFailedTEST.aspx.cs"
    Inherits="KnetPayment.receiptFailed" %>

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
    </script>
</head>
<body dir="<% =Resources.Resource.dir %>" onload="hidediv();">

Failure or cancel

    <script type="text/javascript">

        function close_window() {

            var paidby = document.getElementById('paidby').value;

            if (paidby == 'O') // etrade call
            {
                //window.location.assign(redirectTo);
            }
            else {
                if (confirm("Close Window?")) {
                    window.top.close(); // Broker - Microclear call
                }
            }
           //     if (confirm("Close Window?")) {
              //      window.top.close(); // Broker - Microclear call
              //  }
            
        }
    </script>

</body>
</html>
