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
#property strict

//includes
#include  <YM\Execute\Execute.mqh>
#include  <YM\Position\Position.mqh>
// inputs
input long         magic_Number=2020;
input string       Order_Comment="MegaFx";
input bool         close_ON_Opposite_Signal=true;
input double       Lot_Size=0.1;
input bool         take_Profit=true;
input double       tp=100;
input bool         stop_Loss=true;
input double       sl=100;
input bool         Use_BreakEven = true;
int input          BreakEventPoint = 35;
input bool         Use_Trailing = true;
int input          TrailingStopPoint = 50;

input bool         closeAll_In_Usd_profit_loss=true;
input double       Profit_TO_Close=100;
input double       Loss_TO_Close=100;
input string       Time_SetUP = "------< Time_SetUP >------";
input bool         UseTimeFilter=false;
input string       TimeStart="12:00";
input string       TimeStop="14:00";
extern string      Trade_Day_SetUP                    = "------< Trade_Day_SetUP >------";

extern bool         Trade_sunday                       = true;
extern bool         Trade_monday                       = true;
extern bool         Trade_tuseday                      = true;
extern bool         Trade_wednisday                    = true;
extern bool         Trade_Thursday                     = true;
extern bool         Trade_friday                       = true;

//variables
int AsiaSignal=0;
int MegaSignal=0;
datetime lastEntry=0,lastSignal=0,lastMega=0;;
//Objects
CExecute trade;
CPosition Positions(Symbol(),magic_Number,GROUP_POSITIONS_ALL);
CPosition BuyPos(Symbol(),magic_Number,GROUP_POSITIONS_BUYS);
CPosition SellPos(Symbol(),magic_Number,GROUP_POSITIONS_SELLS);
CUtilities tools;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   trade.SetMagicNumber(magic_Number);
   trade.SetSymbol(Symbol());
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   bool TradeAlow=(sTimeFilter(TimeStart,TimeStop)&&UseTimeFilter)||!UseTimeFilter;

   for(int i=0; i<Bars(Symbol(),PERIOD_CURRENT); i++)
     {
      double AsiaBuy=iCustom(Symbol(),PERIOD_CURRENT,"Asia",0,i);
      double AsiaSell=iCustom(Symbol(),PERIOD_CURRENT,"Asia",1,i);

      if(iTime(Symbol(),PERIOD_CURRENT,i)<lastSignal)
         break;
      if(AsiaBuy>0&&AsiaBuy<10000)
        {
         if(AsiaSignal!=1)
           {
            if(close_ON_Opposite_Signal)
              {
               int total=Positions.GroupTotal();
               if(total>0&&AsiaSignal==0)
                  Positions.GroupCloseAll(20);
              }
            AsiaSignal=1;
            MegaSignal=0;
            lastSignal=iTime(Symbol(),PERIOD_CURRENT,i);
           }
         break;
        }
      if(AsiaSell>0&&AsiaSell<10000)
        {
         if(AsiaSignal!=-1)
           {
            if(close_ON_Opposite_Signal)
              {
               int total=Positions.GroupTotal();
               if(total>0&&AsiaSignal==0)
                  Positions.GroupCloseAll(20);
              }
            AsiaSignal=-1;
            MegaSignal=0;
            lastSignal=iTime(Symbol(),PERIOD_CURRENT,i);
           }
         break;
        }
     }
   for(int x=0; x<Bars(Symbol(),PERIOD_CURRENT); x++)
     {
      double MegaBuy=iCustom(Symbol(),PERIOD_CURRENT,"asia mega",4,x);
      double MegaSell=iCustom(Symbol(),PERIOD_CURRENT,"asia mega",5,x);
      if(iTime(Symbol(),PERIOD_CURRENT,x)<lastMega)
         break;
      if(MegaBuy>0&&MegaBuy<10000&&AsiaSignal!=0)
        {
         if(MegaSignal!=1)
           {
            MegaSignal=1;
            lastMega=iTime(Symbol(),PERIOD_CURRENT,x);
           }
         break;
        }
      if(MegaSell<0&&AsiaSignal!=0)
        {
         if(MegaSignal!=-1)
           {
            MegaSignal=-1;
            lastMega=iTime(Symbol(),PERIOD_CURRENT,x);
           }
         break;
        }
     }
   if(AsiaSignal==1&&MegaSignal==-1)
     {
      AsiaSignal=0;
      MegaSignal=0;
      lastSignal=iTime(Symbol(),PERIOD_CURRENT,0);
      lastMega=iTime(Symbol(),PERIOD_CURRENT,0);

     }
   if(AsiaSignal==-1&&MegaSignal==1)
     {
      AsiaSignal=0;
      MegaSignal=0;
      lastSignal=iTime(Symbol(),PERIOD_CURRENT,0);
      lastMega=iTime(Symbol(),PERIOD_CURRENT,0);

     }
   Comment("\n"+"MegaSignal : "+MegaSignal+"\n"+"AsiaSignal : "+AsiaSignal);
//---
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//---

   if(day_trade()==true&&TradeAlow==true)
     {
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      if(AsiaSignal==1&&MegaSignal==1&&iTime(Symbol(),PERIOD_CURRENT,0)>lastEntry)
        {
         if(close_ON_Opposite_Signal)
           {

            int total=Positions.GroupTotal();
            if(total>0)
               Positions.GroupCloseAll(20);
           }
         trade.Position(TYPE_POSITION_BUY,Lot_Size,stop_Loss?sl:0,take_Profit?tp:0,SLTP_PIPS,30,Order_Comment);
         MegaSignal=0;
         AsiaSignal=0;
         lastEntry=iTime(Symbol(),PERIOD_CURRENT,0);
         lastSignal=iTime(Symbol(),PERIOD_CURRENT,0);
         lastMega=iTime(Symbol(),PERIOD_CURRENT,0);

        }
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      if(AsiaSignal==-1&&MegaSignal==-1&&iTime(Symbol(),PERIOD_CURRENT,0)>lastEntry)
        {
         if(close_ON_Opposite_Signal)
           {

            int total=Positions.GroupTotal();
            if(total>0)
               Positions.GroupCloseAll(20);
           }
         trade.Position(TYPE_POSITION_SELL,Lot_Size,stop_Loss?sl:0,take_Profit?tp:0,SLTP_PIPS,30,Order_Comment);
         MegaSignal=0;
         AsiaSignal=0;
         lastEntry=iTime(Symbol(),PERIOD_CURRENT,0);
         lastSignal=iTime(Symbol(),PERIOD_CURRENT,0);
         lastMega=iTime(Symbol(),PERIOD_CURRENT,0);

        }
     }
   Trailing();
   if(closeAll_In_Usd_profit_loss)
      Closing();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sTimeFilter(string inStart,string inEnd,string inString=":")
  {
   bool Result=true;
   int TimeHourStart,TimeMinuteStart,TimeHourEnd,TimeMinuteEnd;
   static datetime TimeStarts,TimeEnd;
//---
   sInputTimeConvert(TimeHourStart,TimeMinuteStart,inStart,inString);
   sInputTimeConvert(TimeHourEnd,TimeMinuteEnd,inEnd,inString);
   TimeStarts=StringToTime(IntegerToString(TimeHourStart)+":"+IntegerToString(TimeMinuteStart));
   TimeEnd=StringToTime(IntegerToString(TimeHourEnd)+":"+IntegerToString(TimeMinuteEnd));
//---
   if((TimeStarts<=TimeEnd) && ((TimeCurrent()<TimeStarts) || (TimeCurrent()>TimeEnd)))
      Result=false;
   if((TimeStarts>TimeEnd) && (TimeCurrent()<TimeStarts) && (TimeCurrent()>TimeEnd))
      Result=false;
//---
   return(Result);
  }
//+------------------------------------------------------------------+
//| sInputTimeConvert                                                |
//+------------------------------------------------------------------+
int sInputTimeConvert(int &inHour,int &inMinute,string inInput,string inString=":")
  {
   int PS;
//---
   PS=StringFind(inInput,inString,0);
   inMinute=(int)StringToDouble(StringSubstr(inInput,PS+1,StringLen(inInput)-PS));
   inHour=(int)StringToDouble(StringSubstr(inInput,0,PS));
//---
   return(PS);
  }
//+------------------------------------------------------------------+
bool day_trade()
  {
   if(Trade_sunday == true&& DayOfWeek() ==0)
      return (true);
   if(Trade_monday  == true&& DayOfWeek() ==1)
      return (true);
   if(Trade_tuseday  == true&& DayOfWeek() ==2)
      return (true);
   if(Trade_wednisday  == true&& DayOfWeek() ==3)
      return (true);
   if(Trade_Thursday  == true&& DayOfWeek() ==4)
      return (true);
   if(Trade_friday  == true&& DayOfWeek() ==5)
      return (true);

   if(Trade_sunday == false&& DayOfWeek() ==0)
      return (false);
   if(Trade_monday  == false&& DayOfWeek() ==1)
      return (false);
   if(Trade_tuseday  == false&& DayOfWeek() ==2)
      return (false);
   if(Trade_wednisday  == false&& DayOfWeek() ==3)
      return (false);
   if(Trade_Thursday  == false&& DayOfWeek() ==4)
      return (false);
   if(Trade_friday  == false&& DayOfWeek() ==5)
      return (false);

   return(false);
  }
//+------------------------------------------------------------------+
void Trailing()
  {
   int sell_total = SellPos.GroupTotal();

   int buy_total = BuyPos.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < buy_total; i++)
        {
         if(BuyPos.SelectByIndex(i))
           {

            if(Use_BreakEven)
              {
               if((BuyPos.GetStopLoss() < BuyPos.GetPriceOpen() || BuyPos.GetStopLoss() == 0)
                  && tools.Bid() >= (BuyPos.GetPriceOpen() + BreakEventPoint * tools.Pip()))
                 {
                  BuyPos.Modify(BuyPos.GetPriceOpen(), BuyPos.GetTakeProfit(), SLTP_PRICE);
                 }
              }

            if(Use_Trailing&&sell_total==0)
              {
               if(tools.Bid() - BuyPos.GetPriceOpen() > tools.Pip() * TrailingStopPoint)
                 {
                  if(BuyPos.GetStopLoss() < tools.Bid() - tools.Pip() * TrailingStopPoint)
                    {
                     double ModfiedSl = tools.Bid() - (tools.Pip() * TrailingStopPoint);
                     BuyPos.Modify(ModfiedSl, BuyPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }

           }
        }
     }
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < sell_total; i++)
        {
         if(SellPos.SelectByIndex(i))
           {

            if(Use_BreakEven)
              {
               if((SellPos.GetStopLoss() > SellPos.GetPriceOpen() || SellPos.GetStopLoss() == 0)
                  && tools.Ask() <= (SellPos.GetPriceOpen() - BreakEventPoint * tools.Pip()))
                 {
                  SellPos.Modify(SellPos.GetPriceOpen(), SellPos.GetTakeProfit(), SLTP_PRICE);
                 }
              }

            if(Use_Trailing&&buy_total==0)
              {
               if(SellPos.GetPriceOpen() - tools.Ask() > tools.Pip() * TrailingStopPoint)
                 {
                  if(SellPos.GetStopLoss() > tools.Ask() + tools.Pip() * TrailingStopPoint)
                    {
                     double ModfiedSl = tools.Ask() + tools.Pip() * TrailingStopPoint;
                     SellPos.Modify(ModfiedSl, SellPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }
           }

        }
     }
  }
//+------------------------------------------------------------------+
void Closing()
  {
   double totalProfit=Positions.GroupTotalProfit();
   if(totalProfit>0)
      if(totalProfit>=Profit_TO_Close)
         Positions.GroupCloseAll(30);
   if(totalProfit<0)
     {
      double t=MathAbs(totalProfit);
      if(t>=Loss_TO_Close)
         Positions.GroupCloseAll(30);
     }
  }
//+------------------------------------------------------------------+
