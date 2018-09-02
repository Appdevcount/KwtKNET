using System;
using System.Collections.Generic;
using System.Web;

namespace KnetPayment
{
    public class KgacGateway //: e24PaymentPipeLib//.e24PaymentPipeCtlClass
    {
        ///// <summary>
        ///// Default : Action 1: Purchase, Currency: 414, Language: USA
        ///// </summary>
        //public KgacGateway()
        //{
        //    Action = "1";
        //    Currency = "414";
        //    Language = "USA"; // ARA
        //    ResponseUrl = "https://csinternal.kgac.gov.kw/KNetPayment/NewResponse.aspx";  //"http://cspayments.kgac.gov.kw/KNetPayment/responsePage.aspx";
        //    ErrorUrl = "https://csinternal.kgac.gov.kw/KNetPayment/Error.aspx";
        //    ResourcePath = @"C:\KnetDLL\Kgac2Resource\";//@"C:\KnetDLL\";
        //    Alias = "kgac";
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="responseUrl">this Url will be the Url will be Called from Knet, and Receive Response from Knet</param>
        /// <param name="errorUrl">this Url will be the Url will be Called from Knet, in case error ocurred in Payment</param>
        /// <param name="resourcePath">Physical Path of Knet Resource File : Ex. C:\FolderName\</param>
        /// <param name="alias">this will be given by Knet</param>
        public KgacGateway(String responseUrl, String errorUrl, String resourcePath, String alias)
        {
            //Action = "1";
            //Currency = "414";
            //Language = "USA"; // ARA
            //ResponseUrl = responseUrl;
            //ErrorUrl = errorUrl;
            //ResourcePath = "@" + resourcePath;
            //Alias = alias;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="action">Use 1 for Purchase</param>
        /// <param name="currency">Use 414 for Kuwait Dinars</param>
        /// <param name="language">Use ARA for Arabic, USA for English</param>
        /// <param name="responseUrl">this Url will be the Url will be Called from Knet, and Receive Response from Knet</param>
        /// <param name="errorUrl">this Url will be the Url will be Called from Knet, in case error ocurred in Payment</param>
        /// <param name="resourcePath">Physical Path of Knet Resource File : Ex. C:\FolderName\</param>
        /// <param name="alias">this will be given by Knet</param>
        public KgacGateway(String action, String currency, String language,
                           String responseUrl, String errorUrl, String resourcePath, String alias)
        {
            //Action = action;
            //Currency = currency;
            //Language = language;
            //ResponseUrl = responseUrl;
            //ErrorUrl = errorUrl;
            //ResourcePath = "@"+ resourcePath;
            //Alias = alias;
        }

    }
}