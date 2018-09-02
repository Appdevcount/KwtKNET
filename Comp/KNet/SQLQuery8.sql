  
alter PROC [dbo].[VerifyOnlinePaymentDetailsGCSReceiptsKnet] (
@TokenId BIGINT=0,
@PaymentId Bigint=0,
@Amount varchar(max)=0

--,@RefNum varchar(max),
--@TrackId varchar(max),
--@TempDeclNo varchar(max)
 ,@Valid bit out)  
AS  
BEGIN  
 DECLARE @Delimit CHAR(1)  
  
 SET @Valid = 0
  
  select * from OnlinePaymentDetailsGCSReceiptsKnet where Tokenid=@TokenId and 
  OLPaymentId=@PaymentId and Amount=@Amount
  
  IF EXISTS (
			SELECT TOP 1 1
			from OnlinePaymentDetailsGCSReceiptsKnet where Tokenid=@TokenId and 
			OLPaymentId=@PaymentId and Amount=@Amount
			)
	BEGIN
		SET @Valid = 1
	END
END



===\

CREATE PROCEDURE [dbo].[UpdatePaymentDetailsGCSReceiptsKnet] @TranStatus VARCHAR(20) = ''  
 ,@TranStpDateTime DATETIME = NULL  
 ,@PaymentId BIGINT = 0  
 ,@error VARCHAR(200) = ''  
 ,@response VARCHAR(200) = ''  
 ,@TransId BIGINT = 0  
 ,@ReferenceId BIGINT = 0  
 ,@result VARCHAR(50) = ''  
 ,@PostDate DATETIME = NULL  
 ,@AuthByBank VARCHAR(200) = ''  
 ,@RefByBank VARCHAR(200) = ''  
 ,@PaymentFor CHAR(1) = 0  
 ,@ReceiptId VARCHAR(50) = ''  
 ,@BrPaymentTransactionId VARCHAR(50) = ''  
 ,@RcptNum VARCHAR(50) = '' OUTPUT  
 ,@ETokenId BIGINT = 0  
AS  
BEGIN  
 DECLARE @Amount DECIMAL(18, 3)  
  ,@ownerLocid INT  
  ,@UserId VARCHAR(50)  
  ,@PaidBy CHAR(1)  
  ,@PayFor CHAR(1)  
 DECLARE @OwnOrgId VARCHAR(15)  
  
 /* Start - Broker Transaction Details*/  
 IF (  
   @PaymentFor IN (  
    3  
    ,4  
    )  
   )  
 BEGIN  
  PRINT '1'  
  
  DECLARE @PortSites INT  
  
  SELECT @PortSites = OwnerLocId  
  FROM Receipts  
  WHERE ReceiptId = @ReceiptId  
  
  UPDATE dbo.OnlinePaymentDetailsGCSReceiptsKnet  
  SET OLPaymentId = @PaymentId  
   ,error = @error  
   ,response = @response  
   ,StateId = @TranStatus  
   ,TranStpDateTime = @TranStpDateTime  
   ,TransId = @TransId  
   ,result = @result  
   ,PostDate = @PostDate  
   ,AuthByBank = @AuthByBank  
   ,RefByBank = @RefByBank  
   ,DateModified = GETDATE()  
   ,TokenId = @ETokenId  
  WHERE ReceiptId = @ReceiptId  
   AND BrPaymentTransactionId = @BrPaymentTransactionId  
   AND ReferenceId = @ReferenceId  
  
  -- audit trails by azhar    
  INSERT INTO dbo.[$OnlinePaymentDetailsGCSReceiptsKnet] (  
   [$AuditTrailId]  
   ,[$UserId]  
   ,[$Operation]  
   ,[$DateTime]  
   ,[$DataProfileClassId]  
   ,OPDetailId  
   ,TransId  
   ,ReferenceId  
   ,StateId  
   ,TranSttDateTime  
   ,ClientIPAddress  
   ,SessionId  
   ,PortalLoginId  
   ,Amount  
   ,OrganizationId  
   ,PaymentFor  
   ,ReferenceNumber  
   ,ReferenceType  
   ,PaidByType  
   ,LogInPortId  
   ,error  
   ,response  
   ,result  
   ,PostDate  
   ,AuthByBank  
   ,DateModified  
   ,RefByBank  
   ,ReceiptId  
   ,DateCreated  
   ,CreatedBy  
   ,OLPaymentId  
   ,BrPaymentTransactionId -- added on 17th Jan 18 to show as                     
   ,OwnerOrgId  
   ,OwnerLocId  
   ,TrackId  
   ,TokenId  
   ) --Output Inserted.OPDetailId                            
  -- PaymentTransactionId will contain the merchant Track id.                    
  SELECT NEWID()  
   ,PortalLoginId  
   ,'1'  
   ,GETDATE()  
   ,'OnlinePaymentDetailsGCSReceiptsKnet'  
   ,OPDetailId  
   ,@TransId  
   ,ReferenceId  
   ,@TranStatus  
   ,@TranStpDateTime  
   ,ClientIPAddress  
   ,SessionId  
   ,PortalLoginId  
   ,Amount  
   ,OrganizationId  
   ,PaymentFor  
   ,ReferenceNumber  
   ,ReferenceType  
   ,PaidByType  
   ,LogInPortId  
   ,@error  
   ,@response  
   ,@result  
   ,@PostDate  
   ,@AuthByBank  
   ,GETDATE()  
   ,@RefByBank  
   ,ReceiptId  
   ,DateCreated  
   ,CreatedBy  
   ,@PaymentId  
   ,BrPaymentTransactionId -- added on 17th Jan 18 to show as                     
   ,OwnerOrgId  
   ,OwnerLocId  
   ,TrackId  
   ,TokenId  
  FROM OnlinePaymentDetailsGCSReceiptsKnet  
  WHERE ReceiptId = @ReceiptId  
   AND BrPaymentTransactionId = @BrPaymentTransactionId  
   AND ReferenceId = @ReferenceId  
  
  PRINT 'OnlinePaymentDetailsGCSReceiptsKnet are updated !!!!'  
  PRINT '2'  
  
  SELECT @ownerLocid = LogInPortId  
   ,@UserId = PortalLoginId  
   ,@OwnOrgId = OrganizationId  
   ,@Amount = Amount  
  FROM OnlinePaymentDetailsGCSReceiptsKnet  
  WHERE ReceiptId = @ReceiptId  
   AND BrPaymentTransactionId = @BrPaymentTransactionId  
   AND ReferenceId = @ReferenceId  
  
  PRINT @Amount  
  
  DECLARE @RcptNo1 VARCHAR(50)  
   ,@OwnerLCode VARCHAR(5)  
  
  SELECT @RcptNo1 = isnull(ReferenceNumber, '')  
  FROM BrPaymentTransactions  
  WHERE ReceiptId = @ReceiptId  
   AND BrPaymentTransactionId = @BrPaymentTransactionId  
  
  SELECT @OwnerLCode = locationcode  
  FROM Locations  
  WHERE Locationid = @ownerLocid  
  
  IF (  
    (  
     @RcptNo1 IS NULL  
     OR @RcptNo1 = ''  
     )  
    AND @TranStatus = 'Success'  
    ) -- Upon Successfull payment of KNet by Broker                                                        
  BEGIN  
   -- Generating the Receipt Number                                                        
   DECLARE @CounterName1 VARCHAR(100)  
    ,@PaymentNo1 VARCHAR(20)  
  
   SET @CounterName1 = @OwnerLCode + 'GCSReceiptsKnetRcptNo'  
  
   EXEC [dbo].[usp_MCCounters] @Counter = @CounterName1  
    ,@CounterValue = @PaymentNo1 OUTPUT  
  
   SET @RcptNo1 = 'GR/' + CONVERT(VARCHAR, @PaymentNo1) + '/' + RIGHT(@OwnerLCode, 3) + RIGHT(DATEPART(year, GETDATE()), 2)  
  
   PRINT 'New Receipt No : ' + @RcptNo1  
   PRINT '3'  
  
   DECLARE @ActualAmount DECIMAL(18, 3)  
  
   SET @ActualAmount = (cast(@Amount AS DECIMAL(18, 3)) - (cast(dbo.KWConstantfn('GBL_Types.Charges.KNET') AS DECIMAL(18, 3)) + cast(dbo.KWConstantfn('GBL_Types.Charges.Online') AS DECIMAL(18, 3))))  
  
   PRINT @ActualAmount  
   PRINT '4'  
  
   --alter table [$BrPaymentTransactions] alter column paymentid bigint     
   INSERT INTO [BrPaymentTransactions] (  
    BrPaymentTransactionId  
    ,ReceiptId  
    ,PaymentID  
    ,PaymentType  
    ,AccountId  
    ,KNETServiceCharge  
    ,OnlineServiceCharge  
    ,ReferenceNumber  
    ,TotalAmount  
    ,DateCreated  
    ,CreatedBy  
    ,DateModified  
    ,ModifiedBy  
    ,StateId  
    ,OwnerOrgId  
    ,OwnerLocId  
    ,ReferenceId  
    ,Amount  
    ,KGACAmount  
    ,GCSAmount  
    ,PaymentAccountType  
    )  
   VALUES (  
    cast(@BrPaymentTransactionId AS INT)  
    ,@ReceiptId  
    ,@PaymentId  
    ,dbo.KWConstantfn('GBL_PaymentTypes.BANKINTEGRATION')  
    ,1275  
    ,cast(dbo.KWConstantfn('GBL_Types.Charges.KNET') AS DECIMAL(18, 3))  
    ,cast(dbo.KWConstantfn('GBL_Types.Charges.Online') AS DECIMAL(18, 3))  
    ,@RcptNo1  
    ,@Amount  
    ,GetDate()  
    ,@UserId  
    ,GetDate()  
    ,@UserId  
    ,'BrPaymentTransactionsCreatedState'  
    ,@OwnOrgId  
    ,@ownerLocid  
    ,@ReferenceId  
    ,@ActualAmount  
    ,CASE   
     WHEN @PaymentFor = '4'  
      --THEN @ActualAmount          
      THEN @Amount  
     ELSE NULL  
     END  
    ,CASE   
     WHEN @PaymentFor = '3'  
      --THEN @ActualAmount          
      THEN @Amount  
     ELSE NULL  
     END  
    ,CASE   
     WHEN @PaymentFor = '3'  
      THEN dbo.KWConstantfn('GBL_Types.AccountTypes.GCS')  
     ELSE dbo.KWConstantfn('GBL_Types.AccountTypes.KGAC')  
     END  
    )  
  
   PRINT 'BrPayment Transaction is created...'  
  
   INSERT INTO [$BrPaymentTransactions] (  
    [$UserId]  
    ,[$Operation]  
    ,[$SessionId]  
    ,[$IPId]  
    ,[$DateTime]  
    ,[$DataProfileClassId]  
    ,BrPaymentTransactionId  
    ,ReceiptId  
    ,PaymentID  
    ,PaymentType  
    ,AccountId  
    ,KNETServiceCharge  
    ,OnlineServiceCharge  
    ,ReferenceNumber  
    ,TotalAmount  
    ,DateCreated  
    ,CreatedBy  
    ,StateId  
    ,OwnerOrgId  
    ,OwnerLocId  
    ,ReferenceId  
    ,Amount  
    ,KGACAmount  
    ,GCSAmount  
    ,PaymentAccountType  
    ,[$ActionDescription]  
    )  
   SELECT 'system'  
    ,0  
    ,NULL  
    ,NULL  
    ,GETDATE()  
    ,'BrPaymentTransactions'  
    ,br.BrPaymentTransactionId  
    ,Br.ReceiptId  
    ,BR.PaymentID  
    ,Br.PaymentType  
    ,BR.AccountId  
    ,BR.KNETServiceCharge  
    ,Br.OnlineServiceCharge  
    ,Br.ReferenceNumber  
    ,BR.TotalAmount  
    ,BR.DateCreated  
    ,BR.CreatedBy  
    ,BR.StateId  
    ,BR.OwnerOrgId  
    ,BR.OwnerLocId  
    ,BR.ReferenceId  
    ,Br.Amount  
    ,BR.KGACAmount  
    ,BR.GCSAmount  
    ,BR.PaymentAccountType  
    ,NULL  
   FROM BrPaymentTransactions br  
   WHERE br.BrPaymentTransactionId = @BrPaymentTransactionId  
  
   DECLARE @sTransId VARCHAR(150)  
  
   SELECT @sTransId = COALESCE(@sTransId + ',', '') + CONVERT(VARCHAR, TransId)  
   FROM OnlinePaymentDetailsGCSReceiptsKnet  
   WHERE ReceiptId = @ReceiptId  
    AND BrPaymentTransactionId = @BrPaymentTransactionId  
    AND ReferenceId = @ReferenceId  
  
   UPDATE R  
   SET Balance = Balance - @ActualAmount  
    ,ChqNo = @sTransId  
    ,PaymentMethod = dbo.KWConstantfn('GBL_PaymentTypes.BANKINTEGRATION')  
    ,KGACAmount = CASE   
     WHEN @PaymentFor = 4  
      --THEN (ISNULL(KGACAmount, 0.000) + ISNULL(@ActualAmount, 0.000))          
      THEN (ISNULL(KGACAmount, 0.000) + ISNULL(@Amount, 0.000))  
     ELSE R.KGACAmount  
     END  
    ,GCSAmount = CASE   
     WHEN @PaymentFor = 3  
      --THEN (ISNULL(GCSAmount, 0.000) + ISNULL(@ActualAmount, 0.000))          
      THEN (ISNULL(GCSAmount, 0.000) + ISNULL(@Amount, 0.000))  
     ELSE R.GCSAmount  
     END  
    ,Amount = @Amount  
   FROM Receipts R  
   WHERE R.ReceiptId = @ReceiptId  
  
   DECLARE @ReferenceType CHAR(1)  
   DECLARE @ReferenceNo VARCHAR(20)  
   DECLARE @ReceiptFor INT  
  
   SELECT @ReferenceType = RefType  
    ,@ReferenceNo = ReferenceNumber  
    ,@ReceiptFor = ReceiptFor  
    ,@PortSites = PortSites  
   FROM Receipts  
   WHERE ReceiptId = @ReceiptId  
  
   EXEC usp_AutoInsertKNETPaymentServices @ReferenceId  
    ,@ReceiptId  
    ,@PortSites  
    ,@ReferenceType  
    ,@ReferenceNo  
    ,@ReceiptFor  
  
   /*        
  
  
  
    
  
  
  
   DECLARE @CounterValueStart BIGINT          
  
  
  
    
  
  
  
    ,@CounterValueEnd BIGINT          
  
  
  
    
  
  
  
    ,@CounterName VARCHAR(50)          
  
  
  
    
  
  
  
    ,@Suffix VARCHAR(30)          
  
  
  
    
  
  
  
    ,@ReceiptNoCounterValue INT          
  
  
  
    
  
  
  
    ,@PrefixCode VARCHAR(30)          
  
  
  
    
  
  
  
          
  
  
  
    
  
  
  
   SELECT @PrefixCode = locationcode          
  
  
  
    
  
  
  
   FROM Locations          
  
  
  
    
  
  
  
   WHERE Locationid = @PortSites          
  
  
  
    
  
  
  
          
  
  
  
    
  
  
  
   SET @CounterName = LTRIM(RTRIM(@PrefixCode)) + 'ReceiptCount'          
  
  
  
    
  
  
  
   SET @ReceiptNoCounterValue = 0          
  
  
  
    
  
  
  
          
  
  
  
    
  
  
  
   EXEC usp_MCCounters @Counter = @CounterName          
  
  
  
    
  
  
  
    ,@CounterValue = @ReceiptNoCounterValue OUTPUT          
  
  
  
    
  
  
  
          
  
  
  
    
  
  
  
   DECLARE @ReceiptNo VARCHAR(20)          
  
  
  
    
  
  
  
          
  
  
  
    
  
  
  
--IF @ReceiptFor = '30'            
  
  
  
    
  
  
  
   -- begin            
  
  
  
    
  
  
  
   --  SET @ReceiptNo= 'ERC' + @CounterValueStart + '/e' + RIGHT(@OwnerLCode, 3) + RIGHT(DATEPART(year, GETDATE()), 2)            
  
  
  
    
  
  
  
   -- end            
  
  
  
    
  
  
  
   --ELSE IF @ReceiptFor = '31'            
  
  
  
    
  
  
  
   -- begin            
  
  
  
    
  
  
  
   SET @ReceiptNo = 'IRC/' + Cast(@ReceiptNoCounterValue AS VARCHAR(20)) + '/e' + RIGHT(@OwnerLCode, 3) + RIGHT(DATEPART(year, GETDATE()), 2)          
  
  
  
    
  
  
  
          
  
  
  
    
  
  
  
   --end            
  
  
  
    
  
  
  
   UPDATE Receipts          
  
  
  
    
  
  
  
   SET StateId = 'ReceiptSubmittedState'          
  
  
  
    
  
  
  
    ,ReceiptNumber = @ReceiptNo          
  
  
  
    
  
  
  
   WHERE ReceiptId = @ReceiptId          
  
  
  
    
  
  
  
  */  
   INSERT INTO [$REceipts] (  
    [$UserId]  
    ,[$Operation]  
    ,[$DateTime]  
    ,[$DataProfileClassId]  
    ,ReceiptId  
    ,ReceiptNumber  
    ,ReceiptDate  
    ,OrganizationId  
    ,LocationId  
    ,Amount  
    ,Remarks  
    ,CreatedBy  
    ,DateCreated  
    ,ModifiedBy  
    ,DateModified  
    ,OwnerLocId  
    ,StateId  
    ,OwnerOrgId  
    ,ChqNo  
    ,ChqDate  
    ,BankId  
    ,ReceivedFrom  
    ,PayeeType  
    ,PayeeTypeId  
    ,ReceiptFor  
    ,PortSites  
    ,ReceiptCreatedDate  
    ,PrintCount  
    ,RePrintReasonId  
    ,PaymentMethod  
    ,CurrencyId  
    ,ExchangeRate  
    ,AmountInKD  
    ,[$IPId]  
    ,[$SessionId]  
    ,SubmittedDate  
    ,ReferenceId  
    ,Balance  
    ,KGACAmount  
    ,GCSAmount  
    ,TempReceiptNumber  
    ,RefType  
    ,ReferenceNumber  
    )  
   SELECT 'system'  
    ,'1'  
    ,getdate()  
    ,'BrReceipts'  
    ,R.ReceiptId  
    ,R.ReceiptNumber  
    ,R.ReceiptDate  
    ,R.OrganizationId  
    ,R.LocationId  
    ,R.Amount  
    ,R.Remarks  
    ,R.CreatedBy  
    ,R.DateCreated  
    ,R.ModifiedBy  
    ,R.DateModified  
    ,R.OwnerLocId  
    ,R.StateId  
    ,R.OwnerOrgId  
    ,R.ChqNo  
    ,R.ChqDate  
    ,R.BankId  
    ,R.ReceivedFrom  
    ,R.PayeeType  
    ,R.PayeeTypeId  
    ,R.ReceiptFor  
    ,R.PortSites  
    ,R.ReceiptCreatedDate  
    ,R.PrintCount  
    ,R.RePrintReasonId  
    ,R.PaymentMethod  
    ,R.CurrencyId  
    ,R.ExchangeRate  
    ,R.AmountInKD  
    ,'127.0.0.1'  
    ,NULL  
    ,R.SubmittedDate  
    ,R.ReferenceId  
    ,R.Balance  
    ,R.KGACAmount  
    ,R.GCSAmount  
    ,R.TempReceiptNumber  
    ,R.RefType  
    ,R.ReferenceNumber  
   FROM Receipts R  
   WHERE ReceiptId = @ReceiptId  
  
   PRINT 'Receipt No ' + @RcptNo1 + ' generated successfully !!!'  
  
   SET @RcptNum = @RcptNo1  
  
   DECLARE @ToEmailId VARCHAR(500)  
  
   SET @ToEmailId = 'mkaliappan@agility.com, jprincily@agility.com, shahmad@agility.com, welbastawisi@agility.com'  
  
   /*SELECT @ToEmailId = email  
  
   FROM Contacts  
  
   WHERE parentid = (  
  
     SELECT personalid  
  
     FROM Users  
  
     WHERE Userid = @UserId  
  
     )*/  
   IF (@ToEmailId LIKE '%@%')  
   BEGIN  
    INSERT INTO [KGACEmailOutSyncQueue] (  
     [Sync]  
     ,[MsgType]  
     ,[UserId]  
     ,[TOEmailAddress]  
     ,[CCEmailAddress]  
     ,[BCCEmailAddress]  
     ,[SampleRequestNo]  
     ,[DateCreated]  
     ,[DateModified]  
     ,[Status]  
     ,[MailPriority]  
     )  
    VALUES (  
     0  
     ,'GCSPaymentSuccess'  
     ,@UserId  
     ,@ToEmailId  
     ,''  
     ,''  
     ,@BrPaymentTransactionId  
     ,GETDATE()  
     ,GETDATE()  
     ,'Created'  
     ,'Normal'  
     )  
   END  
  
   RETURN;  
  END  
 END  
   /* End - Broker Transaction Details*/  
END  