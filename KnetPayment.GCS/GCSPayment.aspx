<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GCSPayment.aspx.cs" Inherits="KnetPayment.GCSPayment" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <link rel="apple-touch-icon" sizes="76x76" href="../assets/img/apple-icon.png" />
    <link rel="icon" type="image/png" href="../assets/img/favicon.png" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>E-Payment</title>

    <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
    <meta name="viewport" content="width=device-width" />

    <!--     Fonts and icons     -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
    <%--"http://netdna.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.css"--%>

    <%--<link href="../css/font-awesome.css" rel="stylesheet" />--%>
    <!-- CSS Files -->
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet" />
    <%--<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" rel="stylesheet" />--%>
    <link href="../assets/css/gsdk-bootstrap-wizard.css" rel="stylesheet" />

    <!-- CSS Just for demo purpose, don't include it in your project -->
    <link href="../assets/css/demo.css" rel="stylesheet" />




    <!--   Core JS Files   -->
    <script src="../assets/js/jquery-2.2.4.min.js" type="text/javascript"></script>
    <script src="../assets/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../assets/js/jquery.bootstrap.wizard.js" type="text/javascript"></script>

    <!--  Plugin for the Wizard -->
    <script src="../assets/js/gsdk-bootstrap-wizard.js"></script>

    <!--  More information about jquery.validate here: http://jqueryvalidation.org/	 -->
    <script src="../assets/js/jquery.validate.min.js"></script>
    <script src="../Scripts/jquery.unobtrusive-ajax.min.js"></script>
    <script src="../Scripts/jquery.blockUI.js"></script>
</head>

<body style="background-color: #9ea9f917;">
    <%--    <div class="image-container set-full-height" style="background-image: url('assets/img/bggcs.png')">--%>
    <!--   Creative Tim Branding   -->
    <%--<a href="http://creative-tim.com">
            <div class="logo-container">
                <div class="logo">
                    <img src="../assets/img/new_logo.png">
                </div>
                <div class="brand">
                    Creative Tim
                </div>
            </div>
        </a>--%>

    <!--  Made With Get Shit Done Kit  -->
    <%--<a href="http://demos.creative-tim.com/get-shit-done/index.html?ref=get-shit-done-bootstrap-wizard" class="made-with-mk">
            <div class="brand">PWC</div>
            <div class="made-with">Made with <strong>PWC</strong></div>
        </a>--%>

    <style>
        .col-xs-2 {
            width: 31.666667%;
            min-height: 54px;
        }

        p {
            font-size: xx-small;
        }

        .fa-input {
            font-family: FontAwesome, 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }

        .cardauthr {
            padding-left: 5px;
            padding-right: 5px;
        }

        .form-group {
            margin-bottom: 1px;
        }

        .spacer {
            margin-top: 10px
        }

        .wizard-card .info-text {
            margin: 0px 0 10px;
        }

        .wizard-card {
            background-color: #FFFFFF;
            /*#FFFFFF;*/
            box-shadow: 0 0 15px rgb(0, 0, 0), 0 0 1px 1px rgba(0, 0, 0, 0.18);
            border-radius: 15px;
        }

        .alert {
            padding: 10px;
            margin-bottom: -7px;
            margin-top: 10px;
            MARGIN-LEFT: 35px;
            margin-right: 35px;
            border: 1px solid transparent;
            border-radius: 50px;
        }

        .well {
            min-height: 20px;
            padding: 15px;
            /* margin-bottom: 20px; */
            margin: 7px;
            background-color: #0a090903;
            border: 1px solid #08080821;
            border-radius: 44px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
            box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
        }

        .wizard-card[data-color="blue"] .moving-tab {
            /*font-size: 10px;*/
            text-transform: none;
            font-size: 17px;
            bottom: 0px;
        }

        .nav-pills > li > a {
            font-size: 14px;
            text-transform: none;
        }

        .nav-pills > li > a {
            /*Commneted this in main css file -   /*border: 1 !important;*/
            border-left: 1px solid #47494a73;
            border-right: 1px solid #47494a73;
            border-top: 1px solid #999999;
            border-bottom: 1px solid #999999;
        }

        .table-condensed > tbody > tr > td, .table-condensed > tbody > tr > th, .table-condensed > tfoot > tr > td, .table-condensed > tfoot > tr > th, .table-condensed > thead > tr > td, .table-condensed > thead > tr > th {
            padding: 3px;
            padding-left: 10px;
            padding-right: 10px;
        }

        .wizard-card .tab-content {
            min-height: 300px;
            padding: 5px 0px;
        }

        .table-bordered > tbody > tr > td, .table-bordered > tbody > tr > th, .table-bordered > tfoot > tr > td, .table-bordered > tfoot > tr > th, .table-bordered > thead > tr > td, .table-bordered > thead > tr > th {
            border: 7px solid #ddd;
        }
        /*.vertical-align {
    display: flex;
    align-items: center;
}*/
        /*.bordershdw {
             border-radius: 44px;
             box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
        }*/
        .table-bordered {
            border: 9px solid #ddd;
        }
        /*@media screen and (max-width: 767px) {
            .table-responsive > .table-bordered {
                border: -1px;
            }
        }*/
        /*jqueryvalidation error block*/
        .help-block {
            display: block;
            margin-top: 5px;
            margin-bottom: 10px;
            color: #fb0d0dc7;
            /* border-color: red; */
            font-size: 11px;
        }
        /*form fonticon validation symbol placement*/
        .form-control + .form-control-feedback {
            border-radius: 6px;
            font-size: 19px;
            padding: 0 12px 0 0;
            position: absolute;
            right: 12px;
            top: 5px;
            vertical-align: middle;
            background-color: white;
            width: 1px;
        }
        /*Converted with online tool from CSSLESS stop CSS*/
        /*https://codepen.io/bencull/pen/CHqwn*/
        /*http://www.webtoolkitonline.com/less-to-css.html*/
    </style>

    <!--   Big container   -->
    <div class="container">
        <div class="row">
            <div class="col-xs-2">
                <img src="../assets/img/GCS.jpg" class="img-responsive" />
            </div>
            <div class="col-xs-4">
                <%--<img src="../assets/img/GCS.jpg" class="img-responsive"  />--%>
            </div>
            <div class="col-xs-offset-4  col-xs-2">
                <img src="../assets/img/Card.jpg" class="img-responsive" style="float: right" />
            </div>
        </div>
        <div class="row">
            <div class="col-lg-offset-2 col-lg-8 col-lg-offset-2 ">

                <!--      Wizard container        -->
                <div class="wizard-container" style="padding-top: 3px">

                    <div class="card wizard-card" data-color="blue" id="wizardProfile">
                        <form runat="server" action="" method="">
                            <!--        You can switch ' data-color="orange" '  with one of the next bright colors: "blue", "green", "orange", "red"          -->

                            <div class="wizard-header">
                                <h3>
                                    <b>Pay your Invoice </b>
                                    <br />
                                    <small>Fill in the form for instant E-Payment</small>

                                </h3>
                                <div class="row">

                                    <div class="col-xs-offset-3 col-xs-6 col-xs-offset-3   text-center">
                                        <i class="fa fa-cc-visa fa-2x"></i>
                                        <i class="fa fa-cc-mastercard fa-2x"></i>
                                        <i class="fa fa-cc-amex fa-2x"></i>
                                        <i class="fa fa-cc-discover fa-2x"></i>
                                    </div>

                                </div>

                            </div>


                            <div class="wizard-navigation">

                                <ul class="nav nav-pills nav-wizard">
                                    <li><a href="#Receipt" data-toggle="tab">Receipt to  Pay  &raquo;&raquo;</a></li>
                                    <li><a href="#Details" data-toggle="tab">Payment Details &raquo;&raquo;</a></li>
                                    <li><a href="#ProceedToPay" data-toggle="tab">Proceed To Pay</a></li>
                                </ul>

                            </div>

                            <div class="tab-content">
                                <div class="tab-pane" id="Receipt">
                                    <div class="row well" style="padding-left: 10px; padding-right: 10px">
                                        <h4 class="info-text "><b>Enter your Receipt Details</b></h4>
                                        <%-- <div class="col-sm-offset-2 col-sm-8 col-sm-offset-2">
                                            <div class="form-group">

                                                <label><strong>TIRC Number </strong><small>(required)</small></label>
                                                <input name="PaymentDetails_TIRCNumber" id="PaymentDetails_TIRCNumber" type="text" class="form-control input-sm" placeholder="TIRC Number..." />
                                            </div>
                                            <div class="form-group">
                                                <label><strong>Security Code...</strong><small>(required)</small></label>

                                                <input name="PaymentDetails_SecurityCode" id="PaymentDetails_SecurityCode" type="text" class="form-control input-sm" placeholder="Security Code..." />
                                            </div>
                                            <div class="form-group">
                                                <label><strong>Mobile...</strong><small>(required)</small></label>

                                                <input name="PaymentDetails_Mobile" id="PaymentDetails_Mobile" type="text" class="form-control input-sm" placeholder="Mobile..." />
                                            </div>


                                            <div class="form-group">
                                                <label><strong>Email </strong><small>(required)</small></label>
                                                <input name="PaymentDetails_Email" type="email" id="PaymentDetails_Email" class="form-control input-sm" placeholder="Email(TestUser@GCS.com)" />
                                            </div>

                                            <div class="form-group">
                                                <input type="button" onclick="ReceiptValidatorCall()" value="&#xf0a4; &nbsp; Validate" id="ReceiptValidator" class="spacer btn  btn-fill btn-info btn-wd btn-sm fa-input" style="margin-left: 40%; margin-right: 40%" />
                                              
                                            </div>
                                            <div id="ReceiptValidatorStatus" class="form-group">
                                            </div>
                                        </div>--%>
                                        <div class="col-xs-6 ">
                                            <div class="form-group">

                                                <label><strong>TIRC Number </strong><small>(required)</small></label>
                                                <div class="IP">
                                                    <input name="TIRCNumber" runat="server" id="TIRCNumber" type="text" class="form-control input-sm" placeholder="TIRC Number..." />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label><strong>Security Code </strong><small>(required)</small></label>
                                                <div class="IP">
                                                    <input name="SecurityCode" runat="server" id="SecurityCode" type="text" class="form-control input-sm" placeholder="Security Code..." />
                                                </div>
                                            </div>

                                        </div>
                                        <div class="col-xs-6 ">

                                            <div class="form-group">
                                                <label><strong>Mobile </strong><small>(required)</small></label>
                                                <div class="IP">
                                                    <input name="Mobile" runat="server" id="Mobile" type="text" class="form-control input-sm" placeholder="Mobile..." />
                                                </div>
                                            </div>


                                            <div class="form-group">
                                                <label><strong>Email </strong><small>(required)</small></label>
                                                <div class="IP">
                                                    <input name="Email" runat="server" type="text" id="Email" class="form-control input-sm" placeholder="Email(TestUser@GCS.com)" />
                                                </div>
                                            </div>

                                        </div>

                                        <%--   <div class="form-group">

                                            <label><strong>TIRC Number </strong><small>(required)</small></label>
                                            <div class="col-xs-6 ">
                                                <input name="TIRCNumber" runat="server" id="Text1" type="text" class="form-control input-sm" placeholder="TIRC Number..." />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label><strong>Security Code...</strong><small>(required)</small></label>
                                            <div class="col-xs-6 ">
                                                <input name="SecurityCode" runat="server" id="Text2" type="text" class="form-control input-sm" placeholder="Security Code..." />
                                            </div>
                                        </div>

                                      
                                            <div class="form-group">
                                                <label><strong>Mobile...</strong><small>(required)</small></label>
                                                <div class="col-xs-6 ">
                                                    <input name="Mobile" runat="server" id="Text3" type="text" class="form-control input-sm" placeholder="Mobile..." />
                                                </div>
                                            </div>


                                            <div class="form-group">
                                                <label><strong>Email </strong><small>(required)</small></label>
                                                <div class="col-xs-6 ">
                                                    <input name="Email" runat="server" type="text" id="Text4" class="form-control input-sm" placeholder="Email(TestUser@GCS.com)" />
                                                </div>
                                            </div>--%>


                                        <%--                   <div class="col-lg-12 ">
                                           

                                            <div class="form-group">
                                                <input type="button" onclick="ReceiptValidatorCall()" value="&#xf0a4; &nbsp; Validate" id="ReceiptValidator" class="spacer btn  btn-fill btn-info btn-wd btn-sm fa-input" style=" margin:0px auto;"/>
                                               
                                            </div>
                                            <div id="ReceiptValidatorStatus" class="form-group">
                                            </div>
                                        </div>--%>
                                        <%--<div class="col-lg-offset-5 col-lg-2 col-lg-offset-5">


                                            <div class="form-group">
                                                <input type="button" onclick="ReceiptValidatorCall()" value="&#xf0a4; &nbsp; Validate" id="ReceiptValidator" class="spacer btn  btn-fill btn-info btn-wd btn-sm btn-block fa-input" />

                                            </div>

                                        </div>--%>
                                        <div id="ReceiptValidatorStatus" class="col-xs-12">
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="Details">
                                    <h4 class="info-text" style="padding-top: 12px; padding-bottom: 12px;">Verify and Confirm</h4>
                                    <div class="row">
                                        <%--       <div class="col-sm-offset-2 col-sm-8 col-sm-offset-2">
                                            <table class="table table-bordered table-condensed table-responsive table-hover ">
                                                <tr>
                                                    <td><strong>PD_TIRCNumber</small></strong></td>
                                                    <td runat="server" id="PD_TIRCNumber"></td>
                                                </tr>
                                                <tr>
                                                    <td><strong>A</small></strong></td>
                                                    <td id="BD"></td>
                                                </tr>
                                                <tr>
                                                    <td><strong>A</small></strong></td>
                                                    <td id="CD"></td>
                                                </tr>
                                                <tr>
                                                    <td><strong>A</small></strong></td>
                                                    <td id="DD">@mdo</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>A</small></strong></td>
                                                    <td id="ED">@fat</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>A</small></strong></td>
                                                    <td id="FD">@twitter</td>
                                                </tr>
                                            </table>--%>

                                        <div class="col-sm-offset-2 col-sm-8 col-sm-offset-2  table-responsive  ">
                                            <table class="table table-bordered table-condensed table-hover table-sm ">
                                                <thead>
                                                    <tr>
                                                        <td colspan="2" class="text-center bg-primary"><strong>Receipt Lookup</strong></td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>Reference Number</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReferenceNumber" class="text-primary" runat="server"></td>
                                                    </tr>

                                                    <tr>
                                                        <td style="width: 50%"><strong><small>Amount</small></strong></td>
                                                        <td style="width: 50%" id="PD_Amount" class="text-primary" runat="server"></td>
                                                    </tr>

                                                    <tr>
                                                        <td style="width: 50%"><strong><small>Payee Name</small></strong></td>
                                                        <td style="width: 50%" id="PD_PayeeName" class="text-primary" runat="server"></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>Customer Mobile No.</small></strong></td>
                                                        <td style="width: 50%" id="PD_Mobile" class="text-primary" runat="server"></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>Email</small></strong></td>
                                                        <td style="width: 50%" id="PD_Email" class="text-primary" runat="server"></td>
                                                    </tr>
                                                </tbody>

                                            </table>

                                            <asp:HiddenField ID="SEAT" runat="server" />

                                        </div>

                                        <%--                                        <div class="col-sm-offset-1 col-sm-10 col-sm-offset-1  table-responsive">
                                            <table class="table table-bordered table-condensed table-striped table-hover table-sm ">
                                                <thead>
                                                    <tr>
                                                        <td colspan="4" class="text-center bg-primary"><strong>Entered Deatils</strong></td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td style="width: 25%" class="text-center"><strong><small>TIRCNumber</small></strong></td>
                                                        <td style="width: 25%" class="text-center"><strong><small>Security Code</small></strong></td>
                                                        <td style="width: 25%" class="text-center"><strong><small>Mobile</small></strong></td>
                                                        <td style="width: 25%" class="text-center"><strong><small>Email</small></strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 25%" class="text-center text-info" runat="server" id="PD_TIRCNumber"></td>
                                                        <td style="width: 25%" class="text-center text-info" runat="server"  id="PD_SecurityCode"></td>
                                                        <td style="width: 25%" class="text-center text-info"  runat="server" id="PD_Mobile"></td>
                                                        <td style="width: 25%" class="text-center text-info"  runat="server" id="PD_Email"></td>
                                                    </tr>
                                                </tbody>

                                            </table>
                                        </div>
                                        <div class="col-sm-offset-1 col-sm-10 col-sm-offset-1  table-responsive">
                                            <table class="table table-bordered table-condensed table-hover table-sm ">
                                                <thead>
                                                    <tr>
                                                        <td colspan="2" class="text-center bg-primary"><strong>Receipt Lookup</strong></td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>ReferenceNumber</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReferenceNumber" class="text-info" runat="server"></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>ReferenceType</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReferenceType" class="text-info" runat="server"></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>Amount</small></strong></td>
                                                        <td style="width: 50%" id="PD_Amount" class="text-info" runat="server"></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>ReceiptId</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReceiptId" class="text-info" runat="server">@mdo</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>ReceiptNumber</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReceiptNumber" class="text-info" runat="server">@fat</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>ReceiptDate</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReceiptDate" class="text-info" runat="server">@twitter</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>TempReceiptNumber</small></strong></td>
                                                        <td style="width: 50%" id="PD_TempReceiptNumber" class="text-info" runat="server">@twitter</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 50%"><strong><small>ReferenceId</small></strong></td>
                                                        <td style="width: 50%" id="PD_ReferenceId" class="text-info" runat="server">@twitter</td>
                                                    </tr>
                                                </tbody>

                                            </table>
                                            
                                            <asp:HiddenField ID="SEAT" runat="server" />
                                          
                                        </div>--%>
                                        <%-- <div class="form-group">
                                                    <label>TIRC Number </label>
                                                    <input name="firstname" disabled="disabled" id="PaymentConfirmation_TIRCNumber" type="text" class="form-control input-sm" placeholder="TIRC Number...">
                                                </div>
                                                <div class="form-group">
                                                    <label>Consignee Name </label>
                                                    <input name="lastname" disabled="disabled" id="PaymentConfirmation_ConsigneeName" type="text" class="form-control input-sm" placeholder="ConsigneeName...">
                                                </div>
                                                <div class="form-group">
                                                    <label>Mobile </label>
                                                    <input name="number" disabled="disabled" type="text" class="form-control input-sm" id="PaymentConfirmation_Mobile" placeholder="Mobile...">
                                                </div>
                                                <div class="form-group">
                                                    <label>Email </label>
                                                    <input name="email" disabled="disabled" type="email" class="form-control input-sm" id="PaymentConfirmation_Email" placeholder="Email(TestUser@GCS.com)">
                                                </div>
                                                <div class="form-group">
                                                    <label>Amount </label>
                                                    <input name="Amount" value="24.54" disabled="disabled" type="text" class="form-control input-sm" placeholder="Amount...">
                                                </div>--%>
                                    </div>
                                </div>
                                <div class="tab-pane" id="ProceedToPay">
                                    <h4 class="info-text" style="padding-top: 30px">Agree to E-Payment</h4>
                                    <div class="row">
                                        <%--                     <div class="col-lg-12 img-responsive">
                                            <div style="border: 3px solid #e5e5e5; height: 83px; overflow: auto; padding: 8px; margin: -5px 16px -9px 16px;">
                                                <p>Lorem ipsum dolor sit amet, veniam numquam has te. No suas nonumes recusabo mea, est ut graeci definitiones. His ne melius vituperata scriptorem, cum paulo copiosae conclusionemque at. Facer inermis ius in, ad brute nominati referrentur vis. Dicat erant sit ex. Phaedrum imperdiet scribentur vix no, ad latine similique forensibus vel.</p>
                                                <p>Dolore populo vivendum vis eu, mei quaestio liberavisse ex. Electram necessitatibus ut vel, quo at probatus oportere, molestie conclusionemque pri cu. Brute augue tincidunt vim id, ne munere fierent rationibus mei. Ut pro volutpat praesent qualisque, an iisque scripta intellegebat eam.</p>
                                                <p>Mea ea nonumy labores lobortis, duo quaestio antiopam inimicus et. Ea natum solet iisque quo, prodesset mnesarchum ne vim. Sonet detraxit temporibus no has. Omnium blandit in vim, mea at omnium oblique.</p>
                                                <p>Eum ea quidam oportere imperdiet, facer oportere vituperatoribus eu vix, mea ei iisque legendos hendrerit. Blandit comprehensam eu his, ad eros veniam ridens eum. Id odio lobortis elaboraret pro. Vix te fabulas partiendo.</p>
                                                <p>Natum oportere et qui, vis graeco tincidunt instructior an, autem elitr noster per et. Mea eu mundi qualisque. Quo nemore nusquam vituperata et, mea ut abhorreant deseruisse, cu nostrud postulant dissentias qui. Postea tincidunt vel eu.</p>
                                                <p>Ad eos alia inermis nominavi, eum nibh docendi definitionem no. Ius eu stet mucius nonumes, no mea facilis philosophia necessitatibus. Te eam vidit iisque legendos, vero meliore deserunt ius ea. An qui inimicus inciderint.</p>
                                            </div>
                                        </div>
                                        <div class="col-xs-offset-2 col-xs-8 col-xs-offset-2" style="margin-top: 10px;">

                                            <label style="padding-left: 29%; padding-right: 0%;">
                                                <input runat="server" id="AgreeToPay" type="checkbox" name="agree" value="agree" />
                                                Agree with the terms and conditions
                                            </label>

                                        </div>--%>
                                        <div class="col-xs-offset-4 col-xs-4 col-xs-offset-4 img-responsive">
                                            <div class="choice" data-toggle="wizard-checkbox">
                                                <%--<input type="checkbox" name="jobb" value="Code" />--%>
                                                <%--<asp:Image ID="PayIButton"  runat="server"  />--%>
                                                <%--<button type="button" ID="PayButton" title=" إرفاق"   runat="server" OnClick="PayButton_Click"  > <img src="../assets/img/Pay.png" style="height: 105px;" /> </button>--%>
                                                <asp:ImageButton ID="PayButton" OnClick="PayButton_Click" OnClientClick="AgreeTC()" Style="height: 140px;" ImageUrl="../assets/img/Pay.png" runat="server" />
                                                <%--<asp:Image ID="Image1" runat="server" />--%>
                                                <%--<asp:Image ID="Pay" runat="server" on />--%>
                                                <%--<asp:img id="Pady" runat="server" src="../assets/img/Pay.png" style="height: 105px;" />--%>
                                            </div>
                                        </div>
                                        <div id="PaymentVerifierOnStart" runat="server" class="col-xs-12 text-center img-responsive">
                                        </div>

                                    </div>
                                </div>

                                <%--                                    <div class="tab-pane" id="PaymentStatus">
                                        <h4 class="info-text">Payment Status </h4>
                                        <div class="row">
                                            <div class="col-sm-offset-2 col-sm-8 col-sm-offset-2">
                                                <div class="form-group">
                                                    <label>TIRC Number </label>
                                                    <input name="firstname" disabled="disabled" id="PaymentResult_TIRCNumber" type="text" class="form-control input-sm" placeholder="TIRC Number...">
                                                </div>
                                                <div class="form-group">
                                                    <label>Consignee Name </label>
                                                    <input name="lastname" disabled="disabled" id="PaymentResult_ConsigneeName" type="text" class="form-control input-sm" placeholder="ConsigneeName...">
                                                </div>
                                                <div class="form-group">
                                                    <label>Mobile </label>
                                                    <input name="number" disabled="disabled" type="text" class="form-control input-sm" id="PaymentResult_Mobile" placeholder="Mobile...">
                                                </div>
                                                <div class="form-group">
                                                    <label>Email </label>
                                                    <input name="email" disabled="disabled" type="email" class="form-control input-sm" id="PaymentResult_Email" placeholder="Email(TestUser@GCS.com)">
                                                </div>
                                                <div class="form-group">
                                                    <label>Amount </label>
                                                    <input name="Amount" value="24.54" disabled="disabled" id="PaymentResult_Amount" type="text" class="form-control input-sm" placeholder="Amount...">
                                                </div>
                                            </div>

                                        </div>
                                    </div>--%>
                            </div>
                            <div class="wizard-footer height-wizard">
                                <div class="pull-right">
                                    <input type='button' id="Next" class='btn btn-next btn-fill btn-info btn-wd btn-sm fa-input' name='next' value='&#xf0a9; &nbsp;   Next' />
                                    <%--<input type='button' id="Next" class='btn btn-next btn-fill btn-info btn-wd btn-sm fa-input' name='next' value='&raquo;&raquo;   Next' />--%>
                                    <%--<input type='button' id="Next" class='btn btn-next btn-fill btn-info btn-wd btn-sm fa-input' disabled="disabled" name='next' value='&#xf0a9; &nbsp;   Next' />--%>

                                    <%--<button id="Next"  class="btn btn-next btn-fill btn-info btn-wd btn-sm" ><i class="fa fa-arrow-circle-right"></i>&nbsp; Next</button>--%>
                                    <%--<input type='button' class='btn btn-finish btn-fill btn-info btn-wd btn-sm' name='finish' value='Finish' />--%>
                                    <%--<button class="btn btn-finish btn-fill btn-info btn-wd btn-sm" ><i class="fa fa-"></i> vzvadf</button>--%>
                                    <%--    <div class="pull-right input-group">
                                        <span class="input-group-addon"><i class="fa fa-arrow-circle-right"></i></span>
                                       <input type='button' id="Next" class='btn btn-next btn-fill btn-info btn-wd btn-sm' disabled="disabled" name='next' value='Next' />
                                    </div>--%>
                                </div>
                                <div class="pull-left">
                                    <input type='button' id="Previous" class='btn btn-previous btn-fill btn-info btn-wd btn-sm fa-input' name='previous' value='&#xf0a8; &nbsp;  Previous' />
                                    <%--<input type='button' id="Previous" class='btn btn-previous btn-fill btn-info btn-wd btn-sm fa-input' name='previous' value='&laquo;&laquo;  Previous' />--%>
                                    <%--<button id="Previous" class="btn btn-previous btn-fill btn-info btn-wd btn-sm"  ><i class="fa fa-arrow-circle-left"></i>&nbsp; Previous</button>--%>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                        </form>
                    </div>
                </div>
                <!-- wizard container -->
            </div>
        </div>
        <!-- end row -->
        <%--</div>--%>
        <!--  big container -->

        <%-- <div class="footer">
        <div class="container">
            Made with <i class="fa fa-heart heart"></i>by <a href="">PWC</a>
        </div>
    </div>--%>
        <%--    <div class="footer">
        <div class="container" style="color: black; font-size: xx-small">--%>
   <%--     <div class="row">
            <div class="col-xs-2">
                <img src="../assets/img/GCS.jpg" class="img-responsive" />
            </div>
            <div class="col-xs-4">
            </div>
            <div class="col-xs-offset-4  col-xs-2">
                <p>
                    Welcome to GCS. Global Clearinghouse Systems
                </p>
                <p>Address: P.O. Box 202- Farwaniya 81013- Kuwait.</p>
                <p>
                    Telephone: +965 1809222 Ext: 1160
                </p>
                <p>
                    Fax: +965 24981490
                </p>
            </div>
        </div>--%>
        <div class="row">
            <%-- 
                <div class="col-xs-6 ">

                    <img class="img-responsive" src="../assets/img/logo.jpg" />
                </div>
                <div class="col-xs-6 " style="color: black; font-size: xx-small">

                    <p>
                        Welcome to GCS. Global Clearinghouse Systems
                    </p>
                    <p>Address: P.O. Box 202- Farwaniya 81013- Kuwait.</p>
                    <p>
                        Telephone: +965 1809222 Ext: 1160
                    </p>
                    <p>
                        Fax: +965 24981490
                    </p>

                </div>--%>
            <%--</div>--%>
          
            <div class="col-xs-12 text-center" style="padding-top:15px">
                <%--<img src="../assets/img/GCS.jpg" class="img-responsive"  />--%>
                <p>
                    Welcome to GCS. Global Clearinghouse Systems
                </p>
                <p>Address: P.O. Box 202- Farwaniya 81013- Kuwait.</p>
                <p>
                    Telephone: +965 1809222 Ext: 1160
                </p>
                <p>
                    Fax: +965 24981490
                </p>
            </div>
           
        </div>
        <%--</div>--%>
    </div>
    <%--    </div>--%>
    <script type="text/javascript">
        //$(document).ajaxStop($.unblockUI);

        function PaymentVerifierOnStart(msg) {
            //console.log("POSTBACK : " + msg);
            //$('#rootwizard').bootstrapWizard({
            //    'onInit': function (tab, navigation, index) {

            //        setTimeout(function () {
            //            $('#rootwizard').bootstrapWizard('show', 2);
            //        }, 1);
            //    }
            //});
            <%--$("#<%=PaymentVerifierOnStart.ClientID%>").empty();
            $("#<%=PaymentVerifierOnStart.ClientID%>").html("<div class='alert alert-danger text-center'>" + msg + " </div>");--%>

                $("#ReceiptValidatorStatus").empty();
                $("#ReceiptValidatorStatus").html("<div class='alert alert-danger text-center'>" + msg + "</div>");

            //$('#rootwizard').bootstrapWizard('show',3);
           <%-- $("#<%=PaymentVerifierOnStart.ClientID%>").innerHTML = "";
            $("#<%=PaymentVerifierOnStart.ClientID%>").innerHTML = msg;--%>
        }
        $("<%=PayButton.ClientID%>").click(function () { return false; }
        );
     <%--  $("<%=PayButton.ClientID%>").click(--%>
       <%-- function AgreeTC(event) {
            console.log("AGREEEEE");
            if ($("#AgreeToPay").prop('checked')) {
                console.log("checkpanita");
                return true;
            }
            else {
                console.log("checkpanla")
                $("#<%=PaymentVerifierOnStart.ClientID%>").empty();
                $("#<%=PaymentVerifierOnStart.ClientID%>").html("<div class='alert alert-danger text-center'>Please agree to T & C for the payment to proceed </div>");
                event.preventDefault();
                return false;
            }
        }--%>
        //);

        var ProceedConfirmation = false;

        function ReceiptValidatorCall() {

            //$.blockUI({ message: '<h1>  <img src="../Scripts/BrokenCircleGIF.gif" /> Fetching details...</h1>' });

            $("#ReceiptValidatorStatus").empty();

            //var param = { ReceiptNumber: $("#TIRCNumber").val(), Mobile: $("#Mobile").val(), SecurityCode: $("#SecurityCode").val(), Email: $("#Email").val() };
            var param = { ReceiptNumber: $("#<%=TIRCNumber.ClientID%>").val(), Mobile: $("#<%=Mobile.ClientID%>").val(), SecurityCode: $("#<%=SecurityCode.ClientID%>").val(), Email: $("#<%=Email.ClientID%>").val() };
            //console.log($("#TIRCNumber").val());
            //console.log(param);
            $.ajax({
                type: "POST",
                url: "GCSPayment.aspx/IsReceiptValid",
                data: JSON.stringify(param),// '{ReceiptNumber: "' + $("#PaymentDetails_TIRCNumber").val() + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                cache: false,
                timeout: 3000,
                success: OnSuccess,
                failure: OnFailure
            });
            //console.log("MAIN= " + ProceedConfirmation);
            //$('#rootwizard').bootstrapWizard('display', $("#ProceedToPay").val());
            //$('#rootwizard').bootstrapWizard('show', 2);
            return ProceedConfirmation;
        }
        function OnSuccess(response) {
            //console.log("ReceiptValidatorStatus");
            //console.log(response.d);
            var ReceiptAction = response.d;
            $(ReceiptAction).each(function () {

                if (ReceiptAction.VerifyReceiptDetailsforGCSSite.Proceed)// (Verifier.Proceed)// (response.d == true) 
                {  //alert("inga")
                    //console.log("TRUE==>" + ReceiptAction);
                    //console.log("TRUE==>" + ReceiptAction.VerifyReceiptDetailsforGCSSite);
                    //console.log("TRUE==>" + ReceiptAction.ReceiptDetailsMinified);
                    //console.log("TRUE==>" + ReceiptAction.VerifyReceiptDetailsforGCSSite.Proceed);
                    //console.log("TRUE==>" + ReceiptAction.ReceiptDetailsMinified.PayeeName);
                    $("#ReceiptValidatorStatus").empty();
                    $("#ReceiptValidatorStatus").html("<div class='alert alert-success text-center'>" + ReceiptAction.VerifyReceiptDetailsforGCSSite.Message + " </div>");
                    //$("#Next").prop('disabled', false);
                    //GetReceiptDetails();
                    //console.log(det.ReferenceId);

                    //$("#PD_TIRCNumber").html($("#TIRCNumber").val());
                    //$("#PD_SecurityCode").html($("#SecurityCode").val());
                    $("#PD_PayeeName").html(ReceiptAction.ReceiptDetailsMinified.PayeeName);
                    $("#PD_Mobile").html(ReceiptAction.ReceiptDetailsMinified.Mobile);
                    $("#PD_Email").html(ReceiptAction.ReceiptDetailsMinified.CustEmail);
                    $("#PD_ReferenceNumber").html(ReceiptAction.ReceiptDetailsMinified.ReferenceNumber);
                    //$("#PD_ReferenceType").html(ReceiptAction.ReceiptDetailsMinified.ReferenceType);
                    $("#PD_Amount").html(ReceiptAction.ReceiptDetailsMinified.Amount);
                    //$("#PD_ReceiptId").html(ReceiptAction.ReceiptDetailsMinified.ReceiptId);
                    //$("#PD_ReceiptNumber").html(ReceiptAction.ReceiptDetailsMinified.ReceiptNumber);
                    //$("#PD_ReceiptDate").html(ReceiptAction.ReceiptDetailsMinified.ReceiptDate);
                    //$("#PD_TempReceiptNumber").html(ReceiptAction.ReceiptDetailsMinified.TempReceiptNumber);
                    //$("#PD_ReferenceId").html(ReceiptAction.ReceiptDetailsMinified.ReferenceId);
                    $("#<%=SEAT.ClientID%>").val(ReceiptAction.ReceiptDetailsMinified.TokenId);

                    ProceedConfirmation = true;
                    //console.log("MAIN S= " + ProceedConfirmation);

                }
                else {
                    //alert("anga")
                    $("#ReceiptValidatorStatus").empty();
                    $("#ReceiptValidatorStatus").html("<div class='alert alert-danger text-center'>" + ReceiptAction.VerifyReceiptDetailsforGCSSite.Message + "</div>");
                    //$("#Next").prop('disabled', true);
                    ProceedConfirmation = false;
                    //console.log("MAIN SE= " + ProceedConfirmation);
                }
            });
        }
        function OnFailure(response) {
            //console.log("failure");
            //console.log(response.d);
            var Verifier = response.d;
            $("#ReceiptValidatorStatus").empty();
            $("#ReceiptValidatorStatus").html("<div class='alert alert-danger text-center'>" + Verifier.Message + " </div>");
            //$("#Next").prop('disabled', true);

            ProceedConfirmation = false;
            //console.log("MAIN/SUB E= " + ProceedConfirmation);
        }


        $().ready(function () {
            $("#TIRCNumber").focus(function () {
                $("#ReceiptValidatorStatus").empty();
            });
          <%--  $("#Next,#Previous").click(function () {
                $("#ReceiptValidatorStatus").empty();
                $("#<%=PaymentVerifierOnStart.ClientID%>").empty();
            });--%>
        });


    </script>
</body>



</html>


