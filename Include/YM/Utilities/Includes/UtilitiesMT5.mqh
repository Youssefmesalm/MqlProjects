//+------------------------------------------------------------------+
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
#include "UtilitiesBase.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtilities : public CUtilitiesBase
  {
private:

public:
                     CUtilities(string symbolPar = NULL);
                    ~CUtilities();
   ENUM_ORDER_TYPE_FILLING FillingOrder();                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUtilities::CUtilities(string symbolPar = NULL) : CUtilitiesBase(symbolPar)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUtilities::~CUtilities()
  {
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                       fixFillingOrder                            |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_FILLING CUtilities::FillingOrder()
{   
   //-- Find the filling mode
   uint fillingTemp=(uint)SymbolInfoInteger(this.Symbol,SYMBOL_FILLING_MODE);
   //-- check if any error occurs
   if(this.Error.CheckLastError(true,__FUNCTION__))return WRONG_VALUE;
   //-- ORDER_FILLING_FOK
   if((fillingTemp&SYMBOL_FILLING_FOK)==SYMBOL_FILLING_FOK){
      return ORDER_FILLING_FOK;
   }//-- ORDER_FILLING_IOC
   else if((fillingTemp&SYMBOL_FILLING_IOC)==SYMBOL_FILLING_IOC){
      return ORDER_FILLING_IOC;
   }else return ORDER_FILLING_RETURN;
}
