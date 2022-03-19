//+------------------------------------------------------------------+
//|                                              Candle stick EA.mq5 |
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
#property strict
//includes
#include <YM\Utilities\Utilities.mqh>
#include <YM\EXecute\EXecute.mqh>
#include <YM\Position\Position.mqh>
#include  <TradeState.mqh>
//Enumirations
enum Mode
  {
   Aggressive,
   Regular,
   Conservative,
  };
enum LotMode
  {
   LOTPrecentage,
   LOTfixed,
  };
enum stoplossType
  {
   boundary,
   SLPrecentage,
   SLPips,
  };
enum BufferType
  {
   Pips,
   Precentage,
  };
enum TRADE_DAY_TIME
  {
   DAYS,
   NIGHTS,
   DAYS_AND_NIGHTS,
  };
enum trilingType
  {
   TrailingPips, //Pips
   TrailingPrecentage,//Precentage
  };

//Inputs
input Mode EntryType=Aggressive;

input BufferType Buffer_type=Precentage;
input double bufferPrecentage=0.1;
input double bufferInPips=50;
input bool Multi_timeframe_entry=true;
input ENUM_TIMEFRAMES Confirmation_Candle=PERIOD_H1;
input ENUM_TIMEFRAMES Trade_Candle=PERIOD_M5;
// Trading
sinput string TradingSettings="==============Order Entry Settings===========";
input long MagicNumber=2020;
input LotMode LotType=LOTfixed;
input bool increasedLot=true;
input double FixedLot=0.1;
input double LotInPrecentage=1;
// stoploss an tackeProfit
input stoplossType SLTP_Type=SLPrecentage;
sinput string SLTP_Hint="==============if SLTP_Type=Precentage ==============";
input double SLinPrecentage=10;
input double TPinPrecentage=10;
sinput string SLTP_Hint1="============== if SLTP_Type=Pips============== ";
input double SLinPips=20;
input double TPinPips=20;
sinput string SLTP_Hint2="==============if SLTP_Type=boundary ==============";
input double TPinPipsForBoundary=20; // TakeProfit in pips
//Trailing
sinput string TrilingOptions="==============Trailing stopLoss Settings==============";
input bool Use_BreakEven=false;
input int BreakEventPoint=20;
input bool Use_Trailing=false;
input trilingType TrailingType=TrailingPrecentage;
input double TrailingStopPrecentage=0.01;
input int TrailingStopPoint=20;

//closing
input bool UseClose=false;
input double ProfitCloseUsd=200;
input string EndTime="23:00";

//filtter
input bool UseTimeFilter=false;
input string StartH="01:00";
input string EndH  ="23:00";
input double MaxSpread=50;
input TRADE_DAY_TIME TimetoTrade = DAYS_AND_NIGHTS; //Time of Trade
input  bool       InpSaturday        = true;
input  bool       InpMonday          = true;
input  bool       InpTuesday         = true;
input  bool       InpWednesday       = true;
input  bool       InpThursday        = true;
input  bool       InpFriday          = true;
input  bool       InpSunday          = false;
input int MaxOrdersPerDay=3;
input double Max_DD_USD=500;

//variables
int nd,orders;
double CCH2,CCL2,PCCH,CCH,TCC,PCCL,CCL;
datetime CCHT,CCLT,TCCT;
double Lot;
double DTRD11,DTRU11;
bool Pass=false;
color N=clrNONE;
input color ObjectColor=clrLime;
input color ProfitColor=clrLime;
input color LoseColor=clrRed;
color ColorPS,ColorPB,ColorAccountP,ColorSymbolP;
int DTR_Handle=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotB=0,LotS=0,MAXP=0,MAXD=0,Prof;
color CLR;
bool    change=false;
//Objects
CUtilities tool;
CExecute trade(Symbol(),MagicNumber);
CPosition Pos(Symbol(),MagicNumber,GROUP_POSITIONS_ALL);
CPosition BuyPos(Symbol(),MagicNumber,GROUP_POSITIONS_BUYS);
CPosition SellPos(Symbol(),MagicNumber,GROUP_POSITIONS_SELLS);
CTradeState TradeState(TRADE_BUY_AND_SELL);  // Set the default mode to Buy And Sell
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(TimetoTrade == NIGHTS)
     {
      TradeState.SetTradeState(D'22:00:05', D'05:00:00', ALL_DAYS_OF_WEEK, TRADE_NO_NEW_ENTRY);
     }
   if(TimetoTrade == DAYS)
     {
      TradeState.SetTradeState(D'05:00:01', D'22:00:00', ALL_DAYS_OF_WEEK, TRADE_NO_NEW_ENTRY);
     }
   if(!InpFriday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', FRIDAY, TRADE_NO_NEW_ENTRY);
     }
   if(!InpSaturday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', SATURDAY, TRADE_NO_NEW_ENTRY);
     }
   if(!InpSunday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', SUNDAY, TRADE_NO_NEW_ENTRY);
     }
   if(!InpMonday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', MONDAY, TRADE_NO_NEW_ENTRY);
     }
   if(!InpTuesday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', TUESDAY, TRADE_NO_NEW_ENTRY);
     }
   if(!InpWednesday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', WEDNESDAY, TRADE_NO_NEW_ENTRY);
     }
   if(!InpThursday)
     {
      TradeState.SetTradeState(D'00:00:01', D'23:53:00', THURSDAY, TRADE_NO_NEW_ENTRY);
     }

   if(SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN)<0.1)
     {
      nd=2;
     }
   else
      if(SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN)>0.1)
        {
         nd=0;
        }
      else
        {
         nd=1;
        }
   DTR_Handle=iCustom(Symbol(),PERIOD_CURRENT,"DTR");
   CalcLot();

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   long Spread=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);

   double DTRU[1],DTRU1[1],DTRD[1],DTRD1[1];
   CopyBuffer(DTR_Handle,0,0,1,DTRU);
   CopyBuffer(DTR_Handle,1,0,1,DTRU1);
   CopyBuffer(DTR_Handle,2,0,1,DTRD);
   CopyBuffer(DTR_Handle,3,0,1,DTRD1);

//
   if(increasedLot)
      CalcLot();
   Prof=AccountInfoDouble(ACCOUNT_PROFIT);
   if(Prof<0 && Prof<MAXD)
     {
      MAXD=Prof;
     }
   if(Prof>0&&Prof>MAXD)
     {
      MAXP=Prof;
     }

   if(tool.IsNewBar(PERIOD_D1))
     {
      orders=0;
      MAXD=0;
     }
   if(orders<=MaxOrdersPerDay&&(MAXD*-1)<Max_DD_USD)
     {
      if(TradeState.GetTradeState() == TRADE_BUY_AND_SELL)
        {
         if(Spread<=MaxSpread)
           {
            if((TimeFilter(StartH,EndH)&&UseTimeFilter)||!UseTimeFilter)
              {
               if(EntryType==Aggressive)
                 {
                  double Buyentry=Buffer_type==Pips?DTRU[0]+bufferInPips*tool.Pip():DTRU[0]*(1.00+(bufferPrecentage/10));
                  double Sellentry=Buffer_type==Pips?DTRD[0]-bufferInPips*tool.Pip():DTRD[0]*(1.00-(bufferPrecentage/10));
                  if(tool.Ask()<DTRU[0]&&tool.Bid()>DTRD[0]&&!change)
                    {
                     change=true;
                    }

                  if(tool.Bid()>Buyentry&&BuyPos.GroupTotal()==0&&change)
                    {

                     double SL=SLTP_Type==SLPips?SLinPips:SLTP_Type==SLPrecentage?SLinPrecentage:DTRD[0];
                     double TP=SLTP_Type==SLPips?TPinPips:SLTP_Type==SLPrecentage?TPinPrecentage:tool.Ask()+TPinPipsForBoundary*tool.Pip();
                     ENUM_SLTP_TYPE SLTYPE=SLTP_Type==SLPips?SLTP_PIPS:SLTP_Type==SLPrecentage?SLTP_PERCENTAGE:SLTP_PRICE;
                     trade.Position(TYPE_POSITION_BUY,Lot,SL,TP,SLTYPE,30);
                     change=false;
                     orders++;
                    }
                  else
                     if(tool.Bid()<Sellentry&&SellPos.GroupTotal()==0&&change)
                       {
                        double SL=SLTP_Type==SLPips?SLinPips:SLTP_Type==SLPrecentage?SLinPrecentage:DTRU[0];
                        double TP=SLTP_Type==SLPips?TPinPips:SLTP_Type==SLPrecentage?TPinPrecentage:tool.Bid()-TPinPipsForBoundary*tool.Pip();
                        ENUM_SLTP_TYPE SLTYPE=SLTP_Type==SLPips?SLTP_PIPS:SLTP_Type==SLPrecentage?SLTP_PERCENTAGE:SLTP_PRICE;
                        trade.Position(TYPE_POSITION_SELL,Lot,SL,TP,SLTYPE,30);
                        change=false;
                        orders++;
                       }
                 }
               if(EntryType==Regular)
                 {
                  double Buyentry=Buffer_type==Pips?DTRU[0]+bufferInPips*tool.Pip():DTRU[0]*(1.00+(bufferPrecentage/10));
                  double Sellentry=Buffer_type==Pips?DTRD[0]-bufferInPips*tool.Pip():DTRD[0]*(1.00-(bufferPrecentage/10));
                  ENUM_TIMEFRAMES CC=Multi_timeframe_entry?Confirmation_Candle:PERIOD_CURRENT;
                  ENUM_TIMEFRAMES TC=Multi_timeframe_entry?Trade_Candle:PERIOD_CURRENT;
                  if(Multi_timeframe_entry)
                    {
                     CCH=iHigh(Symbol(),CC,0);
                     PCCH=iHigh(Symbol(),CC,1);
                     TCC=iClose(Symbol(),TC,0);
                     TCCT=iTime(Symbol(),TC,0);
                    }
                  else
                    {
                     CCH=iHigh(Symbol(),CC,1);
                     PCCH=iHigh(Symbol(),CC,2);
                     TCC=iClose(Symbol(),TC,0);
                     TCCT=iTime(Symbol(),TC,0);
                    }

                  if(DTRU[0]>iClose(Symbol(),CC,1))
                    {
                     change=true;
                    }

                  if(PCCH<Buyentry&&CCH>Buyentry&&CCHT!=iTime(Symbol(),CC,0)&&CCH!=CCH2&&change)
                    {
                     CCH2=CCH;
                     CCHT=iTime(Symbol(),CC,0);
                     Pass=true;
                     change=false;
                     Info("info100",0,75,20,"DTRU&&BUFFER ",10,"",clrLime);
                     Info("info120",0,75,200,DoubleToString(Buyentry,Digits()),10,"",clrLime);
                     Info("info111",0,125,20,"Confirmation High: ",10,"",clrLime);
                     Info("info112",0,125,200,DoubleToString(CCH2,Digits()),10,"",clrLime);
                    }


                  if(TCC>CCH2&&TCC>Buyentry&&CCH2>Buyentry&&Pass&&BuyPos.GroupTotal()==0)
                    {
                     Info("info113",0,150,20,"Trade High : ",10,"",clrLime);
                     Info("info114",0,150,200,DoubleToString(TCC,Digits()),10,"",clrLime);
                     double SL=SLTP_Type==SLPips?SLinPips:SLTP_Type==SLPrecentage?SLinPrecentage:DTRD[0];
                     double TP=SLTP_Type==SLPips?TPinPips:SLTP_Type==SLPrecentage?TPinPrecentage:tool.Ask()+TPinPipsForBoundary*tool.Pip();
                     ENUM_SLTP_TYPE SLTYPE=SLTP_Type==SLPips?SLTP_PIPS:SLTP_Type==SLPrecentage?SLTP_PERCENTAGE:SLTP_PRICE;
                     trade.Position(TYPE_POSITION_BUY,Lot,SL,TP,SLTYPE,30);
                     Pass=false;
                     orders++;
                    }
                  if(Multi_timeframe_entry)
                    {
                     CCL=iLow(Symbol(),CC,0);
                     PCCL=iLow(Symbol(),CC,1);
                     TCC=iClose(Symbol(),TC,0);
                     TCCT=iTime(Symbol(),TC,0);
                    }
                  else
                    {
                     CCL=iLow(Symbol(),CC,1);
                     PCCL=iLow(Symbol(),CC,2);
                     TCC=iClose(Symbol(),TC,0);
                     TCCT=iTime(Symbol(),TC,0);
                    }
                  if(DTRD[0]<iClose(Symbol(),CC,1))
                    {
                     change=true;
                    }

                  if(PCCL>Sellentry&&CCL<Sellentry&&CCLT!=iTime(Symbol(),CC,0)&&CCL!=CCL2&&change)
                    {
                     CCL2=CCL;
                     CCLT=iTime(Symbol(),CC,0);
                     change=false;
                     Pass=true;
                     Info("info110",0,100,20,"DTRD&&BUFFER ",10,"",clrLime);
                     Info("info130",0,100,200,DoubleToString(Sellentry,Digits()),10,"",clrLime);
                     Info("info111",0,125,20,"Confirmation Low: ",10,"",clrLime);
                     Info("info112",0,125,200,DoubleToString(CCL2,Digits()),10,"",clrLime);
                    }


                  if(TCC<CCL2&&TCC<Sellentry&&CCL2<Sellentry&&CCLT<TCCT&&Pass&&SellPos.GroupTotal()==0)
                    {
                     Info("info113",0,150,20,"Trade Low : ",10,"",clrLime);
                     Info("info114",0,150,200,DoubleToString(TCC,Digits()),10,"",clrLime);
                     double SL=SLTP_Type==SLPips?SLinPips:SLTP_Type==SLPrecentage?SLinPrecentage:DTRU[0];
                     double TP=SLTP_Type==SLPips?TPinPips:SLTP_Type==SLPrecentage?TPinPrecentage:tool.Bid()-TPinPipsForBoundary*tool.Pip();
                     ENUM_SLTP_TYPE SLTYPE=SLTP_Type==SLPips?SLTP_PIPS:SLTP_Type==SLPrecentage?SLTP_PERCENTAGE:SLTP_PRICE;
                     trade.Position(TYPE_POSITION_SELL,Lot,SL,TP,SLTYPE,30);
                     Pass=false;
                     orders++;
                    }
                 }

               if(EntryType==Conservative)
                 {
                  double Buyentry=Buffer_type==Pips?DTRU[0]+bufferInPips*tool.Pip():DTRU[0]*(1.00+(bufferPrecentage/10));
                  double Sellentry=Buffer_type==Pips?DTRD[0]-bufferInPips*tool.Pip():DTRD[0]*(1.00-(bufferPrecentage/10));
                  ENUM_TIMEFRAMES CC=Multi_timeframe_entry?Confirmation_Candle:PERIOD_CURRENT;
                  ENUM_TIMEFRAMES TC=Multi_timeframe_entry?Trade_Candle:PERIOD_CURRENT;
                  CCH=iHigh(Symbol(),CC,0);
                  PCCH=iHigh(Symbol(),CC,1);
                  TCC=iClose(Symbol(),TC,1);
                  TCCT=iTime(Symbol(),TC,1);

                  if(DTRU[0]>iClose(Symbol(),CC,1))
                    {
                     change=true;
                    }

                  if(PCCH<Buyentry&&CCH>Buyentry&&CCH!=CCH2&&CCHT!=iTime(Symbol(),CC,0)&&change)
                    {
                     CCH2=CCH;
                     CCHT=iTime(Symbol(),CC,0);
                     Pass=true;
                     change=false;
                     Info("info100",0,75,20,"DTRU&&BUFFER ",10,"",clrLime);
                     Info("info120",0,75,200,DoubleToString(Buyentry,Digits()),10,"",clrLime);
                     Info("info111",0,125,20,"Confirmation High: ",10,"",clrLime);
                     Info("info112",0,125,200,DoubleToString(CCH2,Digits()),10,"",clrLime);
                    }


                  if(TCC>CCH2&&TCC>Buyentry&&CCH2>Buyentry&&Pass&&BuyPos.GroupTotal()==0)
                    {
                     Info("info113",0,150,20,"Trade High : ",10,"",clrLime);
                     Info("info114",0,150,200,DoubleToString(TCC,Digits()),10,"",clrLime);
                     double SL=SLTP_Type==SLPips?SLinPips:SLTP_Type==SLPrecentage?SLinPrecentage:DTRD[0];
                     double TP=SLTP_Type==SLPips?TPinPips:SLTP_Type==SLPrecentage?TPinPrecentage:tool.Ask()+TPinPipsForBoundary*tool.Pip();
                     ENUM_SLTP_TYPE SLTYPE=SLTP_Type==SLPips?SLTP_PIPS:SLTP_Type==SLPrecentage?SLTP_PERCENTAGE:SLTP_PRICE;
                     trade.Position(TYPE_POSITION_BUY,Lot,SL,TP,SLTYPE,30);
                     Pass=false;
                     orders++;
                    }

                  CCL=iLow(Symbol(),CC,0);
                  PCCL=iLow(Symbol(),CC,1);
                  TCC=iClose(Symbol(),TC,1);
                  TCCT=iTime(Symbol(),TC,1);
                  if(DTRD[0]<iClose(Symbol(),CC,1))
                    {
                     change=true;
                    }

                  if(PCCL>Sellentry&&CCL<Sellentry&&CCLT!=iTime(Symbol(),CC,0)&&CCL2!=CCL&&change)
                    {
                     CCL2=CCL;
                     CCLT=iTime(Symbol(),CC,0);
                     Pass=true;
                     change=false;
                     Info("info111",0,125,20,"Confirmation Low: ",10,"",clrLime);
                     Info("info112",0,125,200,DoubleToString(CCL2,Digits()),10,"",clrLime);
                     Info("info110",0,100,20,"DTRD&&BUFFER ",10,"",clrLime);
                     Info("info130",0,100,200,DoubleToString(Sellentry,Digits()),10,"",clrLime);
                    }


                  if(TCC<CCL2&&TCC<Sellentry&&CCL2<Sellentry&&CCLT<TCCT&&Pass&&SellPos.GroupTotal()==0)
                    {
                     Info("info113",0,150,20,"Trade Low : ",10,"",clrLime);
                     Info("info114",0,150,200,DoubleToString(TCC,Digits()),10,"",clrLime);
                     double SL=SLTP_Type==SLPips?SLinPips:SLTP_Type==SLPrecentage?SLinPrecentage:DTRU[0];
                     double TP=SLTP_Type==SLPips?TPinPips:SLTP_Type==SLPrecentage?TPinPrecentage:tool.Bid()-TPinPipsForBoundary*tool.Pip();
                     ENUM_SLTP_TYPE SLTYPE=SLTP_Type==SLPips?SLTP_PIPS:SLTP_Type==SLPrecentage?SLTP_PERCENTAGE:SLTP_PRICE;
                     trade.Position(TYPE_POSITION_SELL,Lot,SL,TP,SLTYPE,30);
                     Pass=false;
                     orders++;
                    }
                 }
              }
           }
        }
     }
   dashboard();
   Traliling();
   if(UseClose&&ClosingTimeFilter(EndTime)==true)
     {
      Pos.GroupCloseAll(30);
     }
   if(UseClose&&Pos.GroupTotalProfit()>=ProfitCloseUsd&&ProfitCloseUsd>0)
     {
      Pos.GroupCloseAll(20);
     }

  }
//+------------------------------------------------------------------+
void CalcLot()
  {

   if(LotType==LOTPrecentage)
     {
      double sl=SLinPips;
      double slp,tpp;
      if(SLTP_Type==SLPrecentage)
        {
         tool.SltpConvert(SLTP_PERCENTAGE,ORDER_TYPE_BUY,tool.Ask(),SLinPrecentage,SLinPrecentage,slp,tpp);
         sl=(tool.Ask()-slp)/tool.Pip();
        }
      Lot=NormalizeDouble((AccountInfoDouble(ACCOUNT_EQUITY)*LotInPrecentage/1000)/sl,nd);
      if(Lot<SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN))
         Lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
      if(Lot>SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX))
         Lot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
     }
   else
     {
      Lot=FixedLot;
     }
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Traliling()
  {
   int buy_total = BuyPos.GroupTotal();
   double sl=TrailingStopPoint;
   double slp,tpp;
   if(TrailingType==TrailingPrecentage)
     {
      tool.SltpConvert(SLTP_PERCENTAGE,ORDER_TYPE_BUY,tool.Ask(),TrailingStopPrecentage,TrailingStopPrecentage,slp,tpp);
      sl=(tool.Ask()-slp)/tool.Pip();
     }
   if(Use_Trailing || Use_BreakEven)
     {

      for(int i = 0; i < buy_total; i++)
        {
         if(BuyPos.SelectByIndex(i))
           {

            if(Use_BreakEven)
              {
               if((BuyPos.GetStopLoss() < BuyPos.GetPriceOpen() || BuyPos.GetStopLoss() == 0)
                  && tool.Bid() >= (BuyPos.GetPriceOpen() + BreakEventPoint * tool.Pip()))
                 {
                  BuyPos.Modify(BuyPos.GetPriceOpen(), BuyPos.GetTakeProfit(), SLTP_PRICE);
                 }
              }

            if(Use_Trailing)
              {
               if(tool.Bid() - BuyPos.GetPriceOpen() > tool.Pip() * sl)
                 {
                  if(BuyPos.GetStopLoss() < tool.Bid() - tool.Pip() * sl)
                    {
                     double ModfiedSl = tool.Bid() - (tool.Pip() * sl);
                     BuyPos.Modify(ModfiedSl, BuyPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }

           }
        }
     }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
   int sell_total = SellPos.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < sell_total; i++)
        {
         if(SellPos.SelectByIndex(i))
           {

            if(Use_BreakEven)
              {
               if((SellPos.GetStopLoss() > SellPos.GetPriceOpen() || SellPos.GetStopLoss() == 0)
                  && tool.Ask() <= (SellPos.GetPriceOpen() - BreakEventPoint * tool.Pip()))
                 {
                  SellPos.Modify(SellPos.GetPriceOpen(), SellPos.GetTakeProfit(), SLTP_PRICE);
                 }
              }

            if(Use_Trailing)
              {
               if(SellPos.GetPriceOpen() - tool.Ask() > tool.Pip() * sl)
                 {
                  if(SellPos.GetStopLoss() > tool.Ask() + tool.Pip() * sl)
                    {
                     double ModfiedSl = tool.Ask() + tool.Pip() * sl;
                     SellPos.Modify(ModfiedSl, SellPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
void dashboard()
  {
   if(AccountInfoDouble(ACCOUNT_PROFIT)>=0)
     {
      ColorAccountP=ProfitColor;
     }
   else
     {
      ColorAccountP=LoseColor;
     }
   if(Pos.GroupTotalProfit()>=0)
     {
      ColorSymbolP=ProfitColor;
     }
   else
     {
      ColorSymbolP=LoseColor;
     }
   if(SellPos.GroupTotalProfit()>=0)
     {
      ColorPS=ProfitColor;
     }
   else
     {
      ColorPS=LoseColor;
     }
   if(BuyPos.GroupTotalProfit()>=0)
     {
      ColorPB=ProfitColor;
     }
   else
     {
      ColorPB=LoseColor;
     }


   Info("info1",1,25,100,"Account Balance : ",10,"",clrLime);
   Info("info11",1,25,21,DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2),10,"",clrLime);
   Info("info2",1,50,100,"Account Equity : ",10,"",clrLime);
   Info("info22",1,50,21,DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2),10,"",clrLime);
   Info("info3",1,75,100,"Account Profit : ",10,"",clrLime);
   Info("info33",1,75,21,DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT),2),10,"",ColorAccountP);
   Info("info4",1,100,100,"Symbol Profit : ",10,"",clrLime);
   Info("info44",1,100,21,DoubleToString(Pos.GroupTotalProfit(),2),10,"",ColorSymbolP);
   Info("info5",1,125,100,"Sell Profit : ",10,"",clrLime);
   Info("info55",1,125,21,DoubleToString(SellPos.GroupTotalProfit(),2),10,"",ColorPS);
   Info("info6",1,150,100,"Buy Profit : ",10,"",clrLime);
   Info("info66",1,150,21,DoubleToString(BuyPos.GroupTotalVolume(),2),10,"",ColorPB);
   Info("info7",1,175,100," Spread : ",10,"",clrLime);
   Info("info77",1,175,21,IntegerToString(SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)),10,"",clrLime);
   Info("info8",1,200,100," Number of Buy : ",10,"",clrLime);
   Info("info88",1,200,21,IntegerToString(BuyPos.GroupTotal()),10,"",clrLime);
   Info("info9",1,225,100,"  Number of Sell : ",10,"",clrLime);
   Info("info99",1,225,21,IntegerToString(SellPos.GroupTotal()),10,"",clrLime);


   Info("info09",0,25,20,"Max Account DrawDown : ",10,"",clrLime);
   Info("info00",0,25,200,DoubleToString(MAXD,2),10,"",clrLime);
   Info("infoP",0,50,20,"Max Account Profit : ",10,"",clrLime);
   Info("infoP1",0,50,200,DoubleToString(MAXP,2),10,"",clrLime);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Info(string NAME,int CORNER,int Y,int X,string TEXT,int FONTSIZE,string FONT,color FONTCOLOR)
  {
   ObjectCreate(0,NAME,OBJ_LABEL,0,0,0);
   ObjectSetString(0,NAME,OBJPROP_TEXT,TEXT);
   ObjectSetInteger(0,NAME,OBJPROP_FONTSIZE,FONTSIZE);
   ObjectSetInteger(0,NAME,OBJPROP_COLOR,FONTCOLOR);
   ObjectSetString(0,NAME,OBJPROP_FONT,FONT);
   ObjectSetInteger(0,NAME,OBJPROP_CORNER,CORNER);
   ObjectSetInteger(0,NAME,OBJPROP_XDISTANCE,X);
   ObjectSetInteger(0,NAME,OBJPROP_YDISTANCE,Y);

  }
//+------------------------------------------------------------------+
bool TimeFilter(string Sh,string Eh)
  {
   datetime Strat=StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" " +Sh);
   datetime End  =StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+ Eh);

   if(!(iTime(Symbol(),PERIOD_CURRENT,0)>=Strat &&iTime(Symbol(),PERIOD_CURRENT,0)<=End))
     {
      return(false);
     }
   return(true);

  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Time Filter                                                                 |
//+------------------------------------------------------------------+
bool ClosingTimeFilter(string ET)
  {

   datetime End   =StringToTime(TimeToString(TimeCurrent(),TIME_DATE)+" "+ET);

   if((iTime(Symbol(),PERIOD_CURRENT,0)<=End))
     {
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
