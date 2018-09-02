CREATE TABLE [dbo].[ActivityLogger] (
ID bigint identity PRIMARY KEY, 
 App  [nvarchar](50)  NULL,
 TokenId bigint  NULL, 
 ReqLog [nvarchar](max) NULL, 
 RespLog [nvarchar](max) NULL, 
 Other [nvarchar](max) NULL, 
 ErrorAt [nvarchar](max) NULL, 
 ReqTime [nvarchar](max) NULL, 
 RespTime [nvarchar](max) NULL, 
 Logger [nvarchar](250) NULL,
 ErrLevel [nvarchar](max) NULL,  
 URL [nvarchar](max) NULL, 
 ServerAddress [nvarchar](max) NULL, 
 RemoteAddress [nvarchar](max) NULL, 
 Callsite [nvarchar](max) NULL, 
 ExceptionType [nvarchar](max) NULL, 
 ExceptionMessage [nvarchar](max) NULL, 
 StackTrace [nvarchar](max) NULL, 
 InnerExceptionDetail [nvarchar](max) null, 
 ExceptionDetails [nvarchar](max) NULL,
 AdditionalInfo [nvarchar](max) NULL
 )
--drop table [ActivityLogger]

  alter procedure [dbo].[LogActivity] 
(
@App  [nvarchar](50) ,
 @TokenId bigint  , 
 @ReqLog [nvarchar](max) , 
 @RespLog [nvarchar](max) , 
 @Other [nvarchar](max) , 
 @ErrorAt [nvarchar](max) , 
 @ReqTime [nvarchar](max) , 
 @RespTime [nvarchar](max) , 
 @Logger [nvarchar](250) ,
 @ErrLevel [nvarchar](max) ,  
 @URL [nvarchar](max) , 
 @ServerAddress [nvarchar](max) , 
 @RemoteAddress [nvarchar](max) , 
 @Callsite [nvarchar](max) , 
 @ExceptionType [nvarchar](max) , 
 @ExceptionMessage [nvarchar](max) , 
 @StackTrace [nvarchar](max) , 
 @InnerExceptionDetail [nvarchar](max) , 
 @ExceptionDetails [nvarchar](max) ,
 @AdditionalInfo [nvarchar](max) 
	)
as
begin
insert into [ActivityLogger]
(
	App   ,
 TokenId   , 
 ReqLog  , 
 RespLog  , 
 Other  , 
 ErrorAt  , 
 ReqTime  , 
 RespTime  , 
 Logger  ,
 ErrLevel  ,  
 URL  , 
 ServerAddress  , 
 RemoteAddress  , 
 Callsite  , 
 ExceptionType  , 
 ExceptionMessage,
 StackTrace  , 
 InnerExceptionDetail,
 ExceptionDetails  ,
 AdditionalInfo  
)
values
(
	@App   ,
 @TokenId   , 
 @ReqLog  , 
 @RespLog  , 
 @Other  , 
 @ErrorAt  , 
 @ReqTime  , 
 @RespTime  , 
 @Logger  ,
 @ErrLevel  ,  
 @URL  , 
 @ServerAddress  , 
 @RemoteAddress  , 
 @Callsite  , 
 @ExceptionType  , 
 @ExceptionMessage,
 @StackTrace  , 
 @InnerExceptionDetail,
 @ExceptionDetails  ,
 @AdditionalInfo  
)
end

exec [dbo].[LogActivity] @ErrLevel=N'Info',@Callsite=N'KnetPayment.CallPaymentGateWay.Page_Load',@ExceptionType=N'',@StackTrace=N'',@InnerExceptionDetails=N'',@ReqTime=N'2018/07/09 11:34:31.987',@RespTime=N'2018/07/09 11:34:31.987',@ServerAddress=N'::1',@RemoteAddress=N'::1:16858',@URL=N'/CallPaymentGateWay.aspx?TokenId=JRjl6MWBu3NrGZkzdVt7DqaO5h8yb2TTxr2Iwl%2fsyFFhTQLvotLDDjosIKu2wxXz',@AdditionalInfo=N'TEST ',@Logger=N'DatabaseLogger',@App=N'New Value',@ReqLog=N'New Value',@RespLog=N'New Value',@Other=N'New Value',@ErrorAt=N'New Value',@ExceptionDetails=N'New Value',@AdditionalInfo=N'New Value'

exec [dbo].[LogActivity] 
@TokenId=N'myvalue',@ErrLevel=N'Info',
@Callsite=N'KnetPayment.CallPaymentGateWay.Page_Load',@ExceptionType=N'',
@StackTrace=N'',@InnerExceptionDetails=N'',@ReqTime=N'2018/07/09 11:36:21.777',
@RespTime=N'2018/07/09 11:36:21.777',@ServerAddress=N'::1',@RemoteAddress=N'::1:16882',
@URL=N'/CallPaymentGateWay.aspx?TokenId=JRjl6MWBu3NrGZkzdVt7DqaO5h8yb2TTxr2Iwl%2fsyFFhTQLvotLDDjosIKu2wxXz',
@AdditionalInfo=N'TEST ',@Logger=N'DatabaseLogger',@App=N'New Value',@ReqLog=N'New Value',
@RespLog=N'New Value',@Other=N'New Value',@ErrorAt=N'New Value',@ExceptionDetails=N'New Value',
@AdditionalInfo=N'New Value'



exec [dbo].[LogActivity] @TokenId=N'myvalue',@ErrLevel=N'Info',
@Callsite=N'KnetPayment.CallPaymentGateWay.Page_Load',@ExceptionType=N'',
@StackTrace=N'',@InnerExceptionDetails=N'',@ReqTime=N'2018/07/09 11:41:20.969',
@RespTime=N'2018/07/09 11:41:20.969',@ServerAddress=N'::1',@RemoteAddress=N'::1:16980',
@URL=N'/CallPaymentGateWay.aspx?TokenId=JRjl6MWBu3NrGZkzdVt7DqaO5h8yb2TTxr2Iwl%2fsyFFhTQLvotLDDjosIKu2wxXz',
@Logger=N'DatabaseLogger',@App=N'New Value',@ReqLog=N'New Value',@RespLog=N'New Value',
@Other=N'New Value',@ErrorAt=N'New Value',@ExceptionDetails=N'New Value',@AdditionalInfo=N'New Value'

"4456503841892254819"

SELECT 
TokenId,Reqlog,Resplog,other,ReqTime,URL,ServerAddress,
ExceptionMessage,AdditionalInfo 
FROM [ActivityLogger] order by id desc

Redirecting to KNET => https://www.knetpaytest.com.kw:443/CGW302/hppaction?formAction=com.aciworldwide.commerce.gateway.payment.action.HostedPaymentPageAction&?PaymentID=569605551681920
Issue during Redirecting to KNET => https://www.knetpaytest.com.kw:443/CGW302/hppaction?formAction=com.aciworldwide.commerce.gateway.payment.action.HostedPaymentPageAction&?tokenId=U03LTJrHykqZxD43XcvaXMmQSUfB/iBiiVirLIUfZmXqTc7cshrw95oue79EqQ6o&amount=67.710&paymentId=5730351061381920
Redirecting to KNET => https://www.knetpaytest.com.kw:443/CGW302/hppaction?formAction=com.aciworldwide.commerce.gateway.payment.action.HostedPaymentPageAction&?tokenId=U03LTJrHykqZxD43XcvaXMmQSUfB/iBiiVirLIUfZmXqTc7cshrw95oue79EqQ6o&amount=67.710&paymentId=5730351061381920
(transVal(-1) != 0 || PaymentId()= not an integer) so Payment process discontinued 
Retrieving the COM class factory for component with CLSID {78EEF9EE-38E9-11D5-9B13-00E0B8184571} failed due to the following error: 80040154 Class not registered (Exception from HRESULT: 0x80040154 (REGDB_E_CLASSNOTREG)).  at KnetPayment ,   Type : COMException ,   Trace:    at KnetPayment.CallPaymentGateWay.RedirectToKnet(String resourcePath, String alias, String ReferenceNumber, String ReferenceType, String Amount, String DeclarationId, String PaymentFor, String BrPaymentTransactionId, String responseUrl, String ErrorUrl, String clientIpAddress, String sessionId, String organizationId, String userLoginId, String portId, String paidByType, String trackId, String ReceiptId) in C:\Users\sn.ruknudeen\source\repos\ConcArc\GCSKnetPayTestPP\CallPaymentGateWay.aspx.cs:line 364  

Object reference not set to an instance of an object. at KnetPayment , 
Type : NullReferenceException , 
Trace:    at KnetPayment.CallPaymentGateWay.RedirectToKnet(String resourcePath, String alias, String ReferenceNumber, String ReferenceType, String Amount, String DeclarationId, String PaymentFor, String BrPaymentTransactionId, String responseUrl, String ErrorUrl, String clientIpAddress, String sessionId, String organizationId, String userLoginId, String portId, String paidByType, String trackId, String ReceiptId) in C:\Users\sn.ruknudeen\source\repos\ConcArc\GCSKnetPayTestPP\CallPaymentGateWay.aspx.cs:line 409  

Issue during Payment Component processing or while making First payment entry in DB 
Thread was being aborted.  at mscorlib ,   Type : ThreadAbortException ,   Trace:    at System.Threading.Thread.AbortInternal()     at System.Threading.Thread.Abort(Object stateInfo)     at System.Web.HttpResponse.AbortCurrentThread()     at System.Web.HttpResponse.End()     at System.Web.HttpResponse.Redirect(String url, Boolean endResponse, Boolean permanent)     at System.Web.HttpResponse.Redirect(String url, Boolean endResponse)     at KnetPayment.CallPaymentGateWay.Page_Load(Object sender, EventArgs e) in C:\Users\sn.ruknudeen\source\repos\ConcArc\GCSKNET Prod Nlogger Implemented\GCSKNET\CallPaymentGateWay.aspx.cs:line 109  