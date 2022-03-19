//+------------------------------------------------------------------+
//|                                   Copyright 2022, Yousuf Mesalm. |
//|                                    https://www.Yousuf-mesalm.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Yousuf Mesalm."
#property link      "https://www.Yousuf-mesalm.com"
#property link      "https://www.mql5.com/en/users/20163440"
#property description      "Developed by Yousuf Mesalm"
#property description      "https://www.Yousuf-mesalm.com"
#property description      "https://www.mql5.com/en/users/20163440"
#property version   "1.00"

#include "../../Error/Error.mqh"

//+------------------------------------------------------------------+
//|                     CValidationCheckBase         
//+------------------------------------------------------------------+
class CValidationCheckBase
{
public: 
   CError                     Error;
   virtual bool               CheckMoneyForTrade(string symbolPar,double volumePar,ENUM_ORDER_TYPE typePar){return false;}       
   virtual bool               CheckStopLossTakeprofit(string symbolPar,ENUM_ORDER_TYPE typePar, double openPricePar,double stopLossPar,double takeProfitPar){return false;}
   virtual bool               CheckPendingFreezeLevel(string symbolPar, int typePar, double openPricePar){return false;}
   virtual bool               CheckModifyLevels(long ticketPar,double pricePar, double stopLossPar,double takeProfitPar,int typePar = 0){return false;}
   virtual bool               CheckMaxNumberPendingOrders(){return false;}
   virtual bool               CheckMaxVolume(string symbolPar, ulong typePar, double volumePar){return false;}
   virtual bool               CheckFillingType(string symbolPar,int fillingTypePar){return false;}
   bool                       CheckVolumeValue(string symbolPar, double volumePar);
};



//+------------------------------------------------------------------+
//|                        CheckVolumeValue                          |
//+------------------------------------------------------------------+
bool CValidationCheckBase::CheckVolumeValue(string symbolPar, double volumePar)
{
   //-- get information from the symbol
   double minVolume = SymbolInfoDouble(symbolPar,SYMBOL_VOLUME_MIN);
   double maxVolume = SymbolInfoDouble(symbolPar,SYMBOL_VOLUME_MAX);
   double volumeStep = SymbolInfoDouble(symbolPar,SYMBOL_VOLUME_STEP);
   //-- check if any error occurs
   if(this.Error.CheckLastError(true,__FUNCTION__))return false;
   //-- minimum allowed volume for trade operations
   if(volumePar < minVolume)
     {
      string msgTemp = "Volume("+(string)volumePar+") is less than the minimum allowed("+(string)minVolume+")";
      return this.Error.CreateErrorCustom(msgTemp);
     }

//--- maximum allowed volume of trade operations   
   if(volumePar > maxVolume)
     {
      string msgTemp = "Volume("+(string)volumePar+") is greater than the maximum allowed("+(string)maxVolume+")";
      return this.Error.CreateErrorCustom(msgTemp);
     }

//--- get minimal step of volume changing 
   int ratio = (int)MathRound((volumePar - minVolume)/volumeStep);
   double closestValue = ratio * volumeStep + minVolume;
   if(MathAbs(closestValue - volumePar)>0.000000005)
     {
      string msgTemp = "Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP = "+(string)volumeStep+", the closest correct volume is "+(string)(closestValue);
      return this.Error.CreateErrorCustom(msgTemp);
     }
   return(true);
}
  
  


