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
#include <Indicators\Trend.mqh>
#include <Indicators\TimeSeries.mqh>
#include  <YM\Execute\Execute.mqh>
#include  <YM\Position\Position.mqh>
#include  <TradeState.mqh>
#include  "Dashboard.mqh"

enum TRADE_DAY_TIME
  {
   DAYS,
   NIGHTS,
   DAYS_AND_NIGHTS,
  };

//--- input parameters


input  bool       InpSaturday        = true;
input  bool       InpMonday          = true;
input  bool       InpTuesday         = true;
input  bool       InpWednesday       = true;
input  bool       InpThursday        = true;
input  bool       InpFriday          = true;
input  bool       InpSunday          = false;
input bool M1 = true;  //trade on M1 timeFrame
input bool M5 = true;//trade on M5 timeFrame
input bool M15 = true;//trade on M15 timeFrame
input bool M30 = true;//trade on M30 timeFrame
input bool H1 = true;//trade on H1 timeFrame
input bool H4 = true;//trade on H4 timeFrame
input bool D1 = true;//trade on D1 timeFrame
input bool W1 = true;//trade on W1 timeFrame
input bool MN = true;//trade on MN timeFrame
input int RetracePoint = 50;
input TRADE_DAY_TIME TimetoTrade = DAYS_AND_NIGHTS; //Time of Trade
input int Period1 = 100;   //First Ma Period
input ENUM_MA_METHOD Method1 = MODE_SMA;//First Ma Method
input ENUM_APPLIED_PRICE Apply1 = PRICE_LOW;//First Ma Applied
input int Period2 = 100;//seconed Ma Period
input ENUM_MA_METHOD Method2 = MODE_SMA;//seconed Ma Method
input ENUM_APPLIED_PRICE Apply2 = PRICE_HIGH;//seconed Ma Applied
input bool Use_Trailing = true;
input bool Use_BreakEven = true;
input bool sellOnly = false;
input bool buyonly = false;
input bool buyAndSell = true;
input bool EmailNotify = true;
input bool AlertNotify = true;
input bool PhoneNotify = true;
input string AlertBuyContent = " Buy Signal";
input string AlertSellContent = " Sell Signal";
input int TrailingStop = 10;
input int BreakEvent = 5;
input double lot1 = 0.01;
input double tp1 = 50, sl1 = 50;
input double lot2 = 0.02;
input double tp2 = 80, sl2 = 80;
input double lot3 = 0.03;
input double tp3 = 90, sl3 = 90;






//

long magicM1 = 1, magicM5 = 5, magicM15 = 15, magicM30 = 30, magicH1 = 60, magicH4 = 240, magicD1 = 2026, magicW1 = 2027, magicMN = 2028;
datetime  lastBuyM1 = TimeCurrent(), lastSellM1 = TimeCurrent(),
          lastBuyM5 = TimeCurrent(), lastSellM5 = TimeCurrent(),
          lastBuyM15 = TimeCurrent(), lastSellM15 = TimeCurrent(),
          lastBuyM30 = TimeCurrent(), lastSellM30 = TimeCurrent(),
          lastBuyH1 = TimeCurrent(), lastSellH1 = TimeCurrent(),
          lastBuyH4 = TimeCurrent(), lastSellH4 = TimeCurrent(),
          lastBuyD1 = TimeCurrent(), lastSellD1 = TimeCurrent(),
          lastBuyW1 = TimeCurrent(), lastSellW1 = TimeCurrent(),
          lastBuyMN = TimeCurrent(), lastSellMN = TimeCurrent();
bool lastEditFlagBM1 = false, lastEditFlagBM5 = false, lastEditFlagBM15 = false, lastEditFlagBM30 = false, lastEditFlagBH1 = false, lastEditFlagBH4 = false, lastEditFlagBD1 = false, lastEditFlagBW1 = false, lastEditFlagBMN = false;
bool lastEditFlagSM1 = false, lastEditFlagSM5 = false, lastEditFlagSM15 = false, lastEditFlagSM30 = false, lastEditFlagSH1 = false, lastEditFlagSH4 = false, lastEditFlagSD1 = false, lastEditFlagSW1 = false, lastEditFlagSMN = false;
double RetOpenPriceM1, RetOpenPriceM5, RetOpenPriceM15, RetOpenPriceM30, RetOpenPriceH1, RetOpenPriceH4, RetOpenPriceD1, RetOpenPriceW1, RetOpenPriceMN;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTradeState TradeState(TRADE_BUY_AND_SELL);  // Set the default mode to Buy And Sell
CExecute trade;
CUtilities tools;
CiMA Ma1M1;
CiMA Ma2M1;
CiMA Ma1M5;
CiMA Ma2M5;
CiMA Ma1M15;
CiMA Ma2M15;
CiMA Ma1M30;
CiMA Ma2M30;
CiMA Ma1H1;
CiMA Ma2H1;
CiMA Ma1H4;
CiMA Ma2H4;
CiMA Ma1D1;
CiMA Ma2D1;
CiMA Ma1W1;
CiMA Ma2W1;
CiMA Ma1MN;
CiMA Ma2MN;
CiOpen open;
CiClose close;
CiHigh high;
CiLow low;
CPosition BuyPosition(Symbol(), WRONG_VALUE, GROUP_POSITIONS_BUYS);
CPosition SellPosition(Symbol(), WRONG_VALUE, GROUP_POSITIONS_SELLS);
CPosition BuyM1(Symbol(), magicM1, GROUP_POSITIONS_BUYS);
CPosition SellM1(Symbol(), magicM1, GROUP_POSITIONS_SELLS);
CPosition BuyM5(Symbol(), magicM5, GROUP_POSITIONS_BUYS);
CPosition SellM5(Symbol(), magicM5, GROUP_POSITIONS_SELLS);
CPosition BuyM15(Symbol(), magicM15, GROUP_POSITIONS_BUYS);
CPosition SellM15(Symbol(), magicM15, GROUP_POSITIONS_SELLS);
CPosition BuyM30(Symbol(), magicM30, GROUP_POSITIONS_BUYS);
CPosition SellM30(Symbol(), magicM30, GROUP_POSITIONS_SELLS);
CPosition BuyH1(Symbol(), magicH1, GROUP_POSITIONS_BUYS);
CPosition SellH1(Symbol(), magicH1, GROUP_POSITIONS_SELLS);
CPosition BuyH4(Symbol(), magicH4, GROUP_POSITIONS_BUYS);
CPosition SellH4(Symbol(), magicH4, GROUP_POSITIONS_SELLS);
CPosition BuyD1(Symbol(), magicD1, GROUP_POSITIONS_BUYS);
CPosition SellD1(Symbol(), magicD1, GROUP_POSITIONS_SELLS);
CPosition BuyW1(Symbol(), magicW1, GROUP_POSITIONS_BUYS);
CPosition SellW1(Symbol(), magicW1, GROUP_POSITIONS_SELLS);
CPosition BuyMN(Symbol(), magicMN, GROUP_POSITIONS_BUYS);
CPosition SellMN(Symbol(), magicMN, GROUP_POSITIONS_SELLS);

CDashboard dash;
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
//---
//--- create application dialog
   if(!dash.Create(0, "IyKdavis", 0, 50, 50, 300, 400))
      return (INIT_FAILED);
//--- run application
   if(!dash.Run())
      return (INIT_FAILED);
//--- ok
   if(M1)
     {
      Ma1M1.Create(Symbol(), PERIOD_M1, Period1, 0, Method1, Apply1);
      Ma1M1.AddToChart(0, 0);
      Ma2M1.Create(Symbol(), PERIOD_M1, Period2, 0, Method2, Apply2);
      Ma2M1.AddToChart(0, 0);
     }
   if(M5)
     {
      Ma1M5.Create(Symbol(), PERIOD_M5, Period1, 0, Method1, Apply1);
      Ma1M5.AddToChart(0, 0);
      Ma2M5.Create(Symbol(), PERIOD_M5, Period2, 0, Method2, Apply2);
      Ma2M5.AddToChart(0, 0);
     }
   if(M15)
     {
      Ma1M15.Create(Symbol(), PERIOD_M15, Period1, 0, Method1, Apply1);
      Ma1M15.AddToChart(0, 0);
      Ma2M15.Create(Symbol(), PERIOD_M15, Period2, 0, Method2, Apply2);
      Ma2M15.AddToChart(0, 0);
     }
   if(M30)
     {
      Ma1M30.Create(Symbol(), PERIOD_M30, Period1, 0, Method1, Apply1);
      Ma1M30.AddToChart(0, 0);
      Ma2M30.Create(Symbol(), PERIOD_M30, Period2, 0, Method2, Apply2);
      Ma2M30.AddToChart(0, 0);
     }
   if(H1)
     {
      Ma1H1.Create(Symbol(), PERIOD_H1, Period1, 0, Method1, Apply1);
      Ma1H1.AddToChart(0, 0);
      Ma2H1.Create(Symbol(), PERIOD_H1, Period2, 0, Method2, Apply2);
      Ma2H1.AddToChart(0, 0);
     }
   if(H4)
     {
      Ma1H4.Create(Symbol(), PERIOD_H4, Period1, 0, Method1, Apply1);
      Ma1H4.AddToChart(0, 0);
      Ma2H4.Create(Symbol(), PERIOD_H4, Period2, 0, Method2, Apply2);
      Ma2H4.AddToChart(0, 0);
     }
   if(D1)
     {
      Ma1D1.Create(Symbol(), PERIOD_D1, Period1, 0, Method1, Apply1);
      Ma1D1.AddToChart(0, 0);
      Ma2D1.Create(Symbol(), PERIOD_D1, Period2, 0, Method2, Apply2);
      Ma2D1.AddToChart(0, 0);
     }
   if(W1)
     {
      Ma1W1.Create(Symbol(), PERIOD_W1, Period1, 0, Method1, Apply1);
      Ma1W1.AddToChart(0, 0);
      Ma2W1.Create(Symbol(), PERIOD_W1, Period2, 0, Method2, Apply2);
      Ma2W1.AddToChart(0, 0);
     }
   if(MN)
     {
      Ma1MN.Create(Symbol(), PERIOD_MN1, Period1, 0, Method1, Apply1);
      Ma1MN.AddToChart(0, 0);
      Ma2MN.Create(Symbol(), PERIOD_MN1, Period2, 0, Method2, Apply2);
      Ma2MN.AddToChart(0, 0);
     }
   high.Create(Symbol(), 0);
   low.Create(Symbol(), 0);
   open.Create(Symbol(), 0);
   close.Create(Symbol(), 0);
   trade.SetSymbol(Symbol());
//---
   return (INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   dash.Destroy(reason);
   Ma1M1.DeleteFromChart(0, 0);
   Ma2M1.DeleteFromChart(0, 0);
   ObjectsDeleteAll(0);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
      open.Refresh(-1);
      close.Refresh(-1);
      high.Refresh(-1);
      low.Refresh(-1);
      if(M1)
        {
         Ma1M1.Refresh(-1);
         Ma2M1.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1M1.Main(2) && open.GetData(1) > Ma1M1.Main(1)
            && close.GetData(2) > Ma1M1.Main(2) && close.GetData(1) > Ma1M1.Main(1)
            && low.GetData(2) > Ma1M1.Main(2) && low.GetData(1) > Ma1M1.Main(1)
            && open.GetData(2) > Ma2M1.Main(2) && open.GetData(1) > Ma2M1.Main(1)
            && close.GetData(2) > Ma2M1.Main(2) && close.GetData(1) > Ma2M1.Main(1)
            && low.GetData(2) > Ma2M1.Main(2) && low.GetData(1) < Ma2M1.Main(1))
           {
            CheckBuy(BuyM1, SellM1, lastBuyM1, lastSellM1, lastEditFlagBM1,lastEditFlagSM1, RetOpenPriceM1);
            dash.Set_M1_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma1M1.Main(2) && open.GetData(1) < Ma1M1.Main(1)
            && close.GetData(2) < Ma1M1.Main(2) && close.GetData(1) < Ma1M1.Main(1)
            && high.GetData(2) < Ma1M1.Main(2) && high.GetData(1) < Ma1M1.Main(1)
            && open.GetData(2) < Ma2M1.Main(2) && open.GetData(1) < Ma2M1.Main(1)
            && close.GetData(2) < Ma2M1.Main(2) && close.GetData(1) < Ma2M1.Main(1)
            && high.GetData(2) < Ma2M1.Main(2) && high.GetData(1) < Ma2M1.Main(1))
           {
            CheckSell(BuyM1, SellM1, lastBuyM1, lastSellM1,lastEditFlagBM1, lastEditFlagSM1, RetOpenPriceM1);
            dash.Set_M1_Signal("Sell");
           }
        }
      if(M5)
        {
         Ma1M5.Refresh(-1);
         Ma2M5.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1M5.Main(2) && open.GetData(1) > Ma1M5.Main(1)
            && close.GetData(2) > Ma1M5.Main(2) && close.GetData(1) > Ma1M5.Main(1)
            && low.GetData(2) > Ma1M5.Main(2) && low.GetData(1) > Ma1M5.Main(1)
            && open.GetData(2) > Ma2M5.Main(2) && open.GetData(1) > Ma2M5.Main(1)
            && close.GetData(2) > Ma2M5.Main(2) && close.GetData(1) > Ma2M5.Main(1)
            && low.GetData(2) > Ma2M5.Main(2) && low.GetData(1) > Ma2M5.Main(1))
           {
            CheckBuy(BuyM5, SellM5, lastBuyM5, lastSellM5, lastEditFlagBM5,lastEditFlagSM5, RetOpenPriceM5);
            dash.Set_M5_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma1M5.Main(2) && open.GetData(1) < Ma1M5.Main(1)
            && close.GetData(2) < Ma1M5.Main(2) && close.GetData(1) < Ma1M5.Main(1)
            && high.GetData(2) < Ma1M5.Main(2) && high.GetData(1) < Ma1M5.Main(1)
            && open.GetData(2) < Ma2M5.Main(2) && open.GetData(1) < Ma2M5.Main(1)
            && close.GetData(2) < Ma2M5.Main(2) && close.GetData(1) < Ma2M5.Main(1)
            && high.GetData(2) < Ma2M5.Main(2) && high.GetData(1) < Ma2M5.Main(1))
           {
            CheckSell(BuyM5, SellM5, lastBuyM5, lastSellM5,lastEditFlagBM5, lastEditFlagSM5, RetOpenPriceM5);
            dash.Set_M5_Signal("Sell");
           }
        }
      //
      if(M15)
        {
         Ma1M15.Refresh(-1);
         Ma2M15.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1M15.Main(2) && open.GetData(1) > Ma1M15.Main(1)
            && close.GetData(2) > Ma1M15.Main(2) && close.GetData(1) > Ma1M15.Main(1)
            && low.GetData(2) > Ma1M15.Main(2) && low.GetData(1) > Ma1M15.Main(1)
            && open.GetData(2) > Ma2M15.Main(2) && open.GetData(1) > Ma2M15.Main(1)
            && close.GetData(2) > Ma2M15.Main(2) && close.GetData(1) > Ma2M15.Main(1)
            && low.GetData(2) > Ma2M15.Main(2) && low.GetData(1) > Ma2M15.Main(1))
           {
            CheckBuy(BuyM15, SellM15, lastBuyM15, lastSellM15, lastEditFlagBM15,lastEditFlagSM15, RetOpenPriceM15);
            dash.Set_M15_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2M15.Main(2) && open.GetData(1) < Ma2M15.Main(1)
            && close.GetData(2) < Ma2M15.Main(2) && close.GetData(1) < Ma2M15.Main(1)
            && high.GetData(2) < Ma2M15.Main(2) && high.GetData(1) < Ma2M15.Main(1)
            && open.GetData(2) < Ma1M15.Main(2) && open.GetData(1) < Ma1M15.Main(1)
            && close.GetData(2) < Ma1M15.Main(2) && close.GetData(1) < Ma1M15.Main(1)
            && high.GetData(2) < Ma1M15.Main(2) && high.GetData(1) < Ma1M15.Main(1)
           )
           {
            CheckSell(BuyM15, SellM15, lastBuyM15, lastSellM15, lastEditFlagBM15,lastEditFlagSM15, RetOpenPriceM15);
            dash.Set_M15_Signal("Sell");
           }
        }
      //
      if(M30)
        {
         Ma1M30.Refresh(-1);
         Ma2M30.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1M30.Main(2) && open.GetData(1) > Ma1M30.Main(1)
            && close.GetData(2) > Ma1M30.Main(2) && close.GetData(1) > Ma1M30.Main(1)
            && low.GetData(2) > Ma1M30.Main(2) && low.GetData(1) > Ma1M30.Main(1)
            && open.GetData(2) > Ma2M30.Main(2) && open.GetData(1) > Ma2M30.Main(1)
            && close.GetData(2) > Ma2M30.Main(2) && close.GetData(1) > Ma2M30.Main(1)
            && low.GetData(2) > Ma2M30.Main(2) && low.GetData(1) > Ma2M30.Main(1))
           {
            CheckBuy(BuyM30, SellM30, lastBuyM30, lastSellM30, lastEditFlagBM30,lastEditFlagSM30, RetOpenPriceM30);
            dash.Set_M30_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2M30.Main(2) && open.GetData(1) < Ma2M30.Main(1)
            && close.GetData(2) < Ma2M30.Main(2) && close.GetData(1) < Ma2M30.Main(1)
            && high.GetData(2) < Ma2M30.Main(2) && high.GetData(1) < Ma2M30.Main(1)
            && open.GetData(2) < Ma1M30.Main(2) && open.GetData(1) < Ma1M30.Main(1)
            && close.GetData(2) < Ma1M30.Main(2) && close.GetData(1) < Ma1M30.Main(1)
            && high.GetData(2) < Ma1M30.Main(2) && high.GetData(1) < Ma1M30.Main(1))
           {
            CheckSell(BuyM30, SellM30, lastBuyM30, lastSellM30,lastEditFlagBM30, lastEditFlagSM30, RetOpenPriceM30);
            dash.Set_M30_Signal("Sell");
           }
        }
      //
      if(H1)
        {
         Ma1H1.Refresh(-1);
         Ma2H1.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1H1.Main(2) && open.GetData(1) > Ma1H1.Main(1)
            && close.GetData(2) > Ma1H1.Main(2) && close.GetData(1) > Ma1H1.Main(1)
            && low.GetData(2) > Ma1H1.Main(2) && low.GetData(1) > Ma1H1.Main(1)
            && open.GetData(2) > Ma2H1.Main(2) && open.GetData(1) > Ma2H1.Main(1)
            && close.GetData(2) > Ma2H1.Main(2) && close.GetData(1) > Ma2H1.Main(1)
            && low.GetData(2) > Ma2H1.Main(2) && low.GetData(1) > Ma2H1.Main(1))
           {
            CheckBuy(BuyH1, SellH1, lastBuyH1, lastSellH1, lastEditFlagBH1,lastEditFlagSH1, RetOpenPriceH1);
            dash.Set_H1_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2H1.Main(2) && open.GetData(1) < Ma2H1.Main(1)
            && close.GetData(2) < Ma2H1.Main(2) && close.GetData(1) < Ma2H1.Main(1)
            && high.GetData(2) < Ma2H1.Main(2) && high.GetData(1) < Ma2H1.Main(1)
            && open.GetData(2) < Ma1H1.Main(2) && open.GetData(1) < Ma1H1.Main(1)
            && close.GetData(2) < Ma1H1.Main(2) && close.GetData(1) < Ma1H1.Main(1)
            && high.GetData(2) < Ma1H1.Main(2) && high.GetData(1) < Ma1H1.Main(1))
           {
            CheckSell(BuyH1, SellH1, lastBuyH1, lastSellH1,lastEditFlagBH1, lastEditFlagSH1, RetOpenPriceH1);
            dash.Set_H1_Signal("Sell");
           }
        }
      //
      if(H4)
        {
         Ma1H4.Refresh(-1);
         Ma2H4.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1H4.Main(2) && open.GetData(1) > Ma1H4.Main(1)
            && close.GetData(2) > Ma1H4.Main(2) && close.GetData(1) > Ma1H4.Main(1)
            && low.GetData(2) > Ma1H4.Main(2) && low.GetData(1) > Ma1H4.Main(1)
            && open.GetData(2) > Ma2H4.Main(2) && open.GetData(1) > Ma2H4.Main(1)
            && close.GetData(2) > Ma2H4.Main(2) && close.GetData(1) > Ma2H4.Main(1)
            && low.GetData(2) > Ma2H4.Main(2) && low.GetData(1) > Ma2H4.Main(1))
           {
            CheckBuy(BuyH4, SellH4, lastBuyH4, lastSellH4, lastEditFlagBH4, lastEditFlagSH4,RetOpenPriceH4);
            dash.Set_H4_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2H4.Main(2) && open.GetData(1) < Ma2H4.Main(1)
            && close.GetData(2) < Ma2H4.Main(2) && close.GetData(1) < Ma2H4.Main(1)
            && high.GetData(2) < Ma2H4.Main(2) && high.GetData(1) < Ma2H4.Main(1)
            && open.GetData(2) < Ma1H4.Main(2) && open.GetData(1) < Ma1H4.Main(1)
            && close.GetData(2) < Ma1H4.Main(2) && close.GetData(1) < Ma1H4.Main(1)
            && high.GetData(2) < Ma1H4.Main(2) && high.GetData(1) < Ma1H4.Main(1))
           {
            CheckSell(BuyH4, SellH4, lastBuyH4, lastSellH4,lastEditFlagBH4, lastEditFlagSH4, RetOpenPriceH4);
            dash.Set_H4_Signal("Sell");
           }
        }
      //
      if(D1)
        {
         Ma1D1.Refresh(-1);
         Ma2D1.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1D1.Main(2) && open.GetData(1) > Ma1D1.Main(1)
            && close.GetData(2) > Ma1D1.Main(2) && close.GetData(1) > Ma1D1.Main(1)
            && low.GetData(2) > Ma1D1.Main(2) && low.GetData(1) > Ma1D1.Main(1)
            && open.GetData(2) > Ma2D1.Main(2) && open.GetData(1) > Ma2D1.Main(1)
            && close.GetData(2) > Ma2D1.Main(2) && close.GetData(1) > Ma2D1.Main(1)
            && low.GetData(2) > Ma2D1.Main(2) && low.GetData(1) > Ma2D1.Main(1))
           {
            CheckBuy(BuyD1, SellD1, lastBuyD1, lastSellD1, lastEditFlagBD1,lastEditFlagSD1, RetOpenPriceD1);
            dash.Set_D1_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2D1.Main(2) && open.GetData(1) < Ma2D1.Main(1)
            && close.GetData(2) < Ma2D1.Main(2) && close.GetData(1) < Ma2D1.Main(1)
            && high.GetData(2) < Ma2D1.Main(2) && high.GetData(1) < Ma2D1.Main(1)
            && open.GetData(2) < Ma1D1.Main(2) && open.GetData(1) < Ma1D1.Main(1)
            && close.GetData(2) < Ma1D1.Main(2) && close.GetData(1) < Ma1D1.Main(1)
            && high.GetData(2) < Ma1D1.Main(2) && high.GetData(1) < Ma1D1.Main(1))
           {
            CheckSell(BuyD1, SellD1, lastBuyD1, lastSellD1,lastEditFlagBD1, lastEditFlagSD1, RetOpenPriceD1);
            dash.Set_D1_Signal("Sell");
           }
        }
      //
      if(W1)
        {
         Ma1W1.Refresh(-1);
         Ma2W1.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1W1.Main(2) && open.GetData(1) > Ma1W1.Main(1)
            && close.GetData(2) > Ma1W1.Main(2) && close.GetData(1) > Ma1W1.Main(1)
            && low.GetData(2) > Ma1W1.Main(2) && low.GetData(1) > Ma1W1.Main(1)
            && open.GetData(2) > Ma2W1.Main(2) && open.GetData(1) > Ma2W1.Main(1)
            && close.GetData(2) > Ma2W1.Main(2) && close.GetData(1) > Ma2W1.Main(1)
            && low.GetData(2) > Ma2W1.Main(2) && low.GetData(1) > Ma2W1.Main(1))
           {
            CheckBuy(BuyW1, SellW1, lastBuyW1, lastSellW1, lastEditFlagBW1,lastEditFlagSW1, RetOpenPriceW1);
            dash.Set_W1_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2W1.Main(2) && open.GetData(1) < Ma2W1.Main(1)
            && close.GetData(2) < Ma2W1.Main(2) && close.GetData(1) < Ma2W1.Main(1)
            && high.GetData(2) < Ma2W1.Main(2) && high.GetData(1) < Ma2W1.Main(1)
            && open.GetData(2) < Ma1W1.Main(2) && open.GetData(1) < Ma1W1.Main(1)
            && close.GetData(2) < Ma1W1.Main(2) && close.GetData(1) < Ma1W1.Main(1)
            && high.GetData(2) < Ma1W1.Main(2) && high.GetData(1) < Ma1W1.Main(1))
           {
            CheckSell(BuyW1, SellW1, lastBuyW1, lastSellW1,lastEditFlagBW1, lastEditFlagSW1, RetOpenPriceW1);
            dash.Set_W1_Signal("Sell");
           }
        }
      //
      if(MN)
        {
         Ma1MN.Refresh(-1);
         Ma2MN.Refresh(-1);
         // Buy
         if(open.GetData(2) > Ma1MN.Main(2) && open.GetData(1) > Ma1MN.Main(1)
            && close.GetData(2) > Ma1MN.Main(2) && close.GetData(1) > Ma1MN.Main(1)
            && low.GetData(2) > Ma1MN.Main(2) && low.GetData(1) > Ma1MN.Main(1)
            && open.GetData(2) > Ma2MN.Main(2) && open.GetData(1) > Ma2MN.Main(1)
            && close.GetData(2) > Ma2MN.Main(2) && close.GetData(1) > Ma2MN.Main(1)
            && low.GetData(2) > Ma2MN.Main(2) && low.GetData(1) > Ma2MN.Main(1))
           {
            CheckBuy(BuyMN, SellMN, lastBuyMN, lastSellMN, lastEditFlagBMN,lastEditFlagSMN, RetOpenPriceMN);
            dash.Set_MN_Signal("Buy");
           }
         // sell
         if(open.GetData(2) < Ma2MN.Main(2) && open.GetData(1) < Ma2MN.Main(1)
            && close.GetData(2) < Ma2MN.Main(2) && close.GetData(1) < Ma2MN.Main(1)
            && high.GetData(2) < Ma2MN.Main(2) && high.GetData(1) < Ma2MN.Main(1)
            && open.GetData(2) < Ma1MN.Main(2) && open.GetData(1) < Ma1MN.Main(1)
            && close.GetData(2) < Ma1MN.Main(2) && close.GetData(1) < Ma1MN.Main(1)
            && high.GetData(2) < Ma1MN.Main(2) && high.GetData(1) < Ma1MN.Main(1))
           {
            CheckSell(BuyMN, SellMN, lastBuyMN, lastSellMN,lastEditFlagBMN, lastEditFlagSMN, RetOpenPriceMN);
            dash.Set_MN_Signal("Sell");
           }
        }
      Trade();
     
   dash.Set_M1_buyTotal((string) BuyM1.GroupTotal());
   dash.Set_M5_buyTotal((string) BuyM5.GroupTotal());
   dash.Set_M15_buyTotal((string) BuyM15.GroupTotal());
   dash.Set_M30_buyTotal((string) BuyM30.GroupTotal());
   dash.Set_H1_buyTotal((string) BuyH1.GroupTotal());
   dash.Set_H4_buyTotal((string) BuyH4.GroupTotal());
   dash.Set_D1_buyTotal((string) BuyD1.GroupTotal());
   dash.Set_W1_buyTotal((string) BuyW1.GroupTotal());
   dash.Set_MN_buyTotal((string) BuyMN.GroupTotal());
   dash.Set_M1_sellTotal((string) SellM1.GroupTotal());
   dash.Set_M5_sellTotal((string) SellM5.GroupTotal());
   dash.Set_M15_sellTotal((string) SellM15.GroupTotal());
   dash.Set_M30_sellTotal((string) SellM30.GroupTotal());
   dash.Set_H1_sellTotal((string) SellH1.GroupTotal());
   dash.Set_H4_sellTotal((string) SellH4.GroupTotal());
   dash.Set_D1_sellTotal((string) SellD1.GroupTotal());
   dash.Set_W1_sellTotal((string) SellW1.GroupTotal());
   dash.Set_MN_sellTotal((string) SellMN.GroupTotal());
// trailing
   int buy_total = BuyPosition.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < buy_total; i++)
        {
         if(BuyPosition.SelectByIndex(i))
           {
            if(Use_BreakEven)
              {
               if((BuyPosition.GetStopLoss() < BuyPosition.GetPriceOpen() || BuyPosition.GetStopLoss() == 0)
                  && tools.Bid() >= (BuyPosition.GetPriceOpen() + BreakEvent * tools.Pip()))
                 {
                  BuyPosition.Modify(BuyPosition.GetPriceOpen(), BuyPosition.GetTakeProfit(), SLTP_PRICE);
                 }
              }
            if(Use_Trailing)
              {
               if(tools.Bid() - BuyPosition.GetPriceOpen() > tools.Pip() * TrailingStop)
                 {
                  if(BuyPosition.GetStopLoss() < tools.Bid() - tools.Pip() * TrailingStop)
                    {
                     double ModfiedSl = tools.Bid() - (tools.Pip() * TrailingStop);
                     BuyPosition.Modify(ModfiedSl, BuyPosition.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   int sell_total = SellPosition.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < sell_total; i++)
        {
         if(SellPosition.SelectByIndex(i))
           {
            if(Use_BreakEven)
              {
               if((SellPosition.GetStopLoss() > SellPosition.GetPriceOpen() || SellPosition.GetStopLoss() == 0)
                  && tools.Ask() <= (SellPosition.GetPriceOpen() - BreakEvent * tools.Pip()))
                 {
                  SellPosition.Modify(SellPosition.GetPriceOpen(), SellPosition.GetTakeProfit(), SLTP_PRICE);
                 }
              }
            if(Use_Trailing)
              {
               if(SellPosition.GetPriceOpen() - tools.Ask() > tools.Pip() * TrailingStop)
                 {
                  if(SellPosition.GetStopLoss() > tools.Ask() + tools.Pip() * TrailingStop)
                    {
                     double ModfiedSl = tools.Ask() + tools.Pip() * TrailingStop;
                     SellPosition.Modify(ModfiedSl, SellPosition.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool CheckSell(CPosition & posBuy, CPosition & posSell, datetime & lastBuyConditionTime,
               datetime & lastSellConditionTime,  bool & lastEditBFlag,bool & lastEditSFlag, double & openPrice)
  {
   if(posBuy.GroupTotal() < 1 && posSell.GroupTotal() == 0)
     {
      if(lastBuyConditionTime >= lastSellConditionTime)
        {
         if(!lastEditSFlag)
           {
            double lastclose = close.GetData(1);
            openPrice = lastclose + RetracePoint * tools.Pip();
            lastEditBFlag = false;
            lastEditSFlag = true;
            lastSellConditionTime=TimeCurrent();
            return true;
           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Sell(long magic, CPosition & posBuy, CPosition & posSell,  bool & lastEditFlag, double & openPrice)
  {
   if(posBuy.GroupTotal() < 1 && posSell.GroupTotal() == 0)
     {
      if(lastEditFlag && tools.Bid() == openPrice)
        {
         if(buyAndSell || sellOnly)
           {
            trade.SetMagicNumber(magic);
            trade.Position(TYPE_POSITION_SELL, lot1, sl1, tp1, SLTP_PIPS, 15, (string)magic);
            trade.Position(TYPE_POSITION_SELL, lot2, sl2, tp2, SLTP_PIPS, 15, (string)magic);
            trade.Position(TYPE_POSITION_SELL, lot3, sl3, tp3, SLTP_PIPS, 15, (string)magic);
            if(AlertNotify)
              {
               Alert(AlertSellContent);
              };
            if(EmailNotify)
              {
               SendMail("Iykdavis Updates", AlertSellContent);
              };
            if(PhoneNotify)
              {
               SendNotification(AlertSellContent);
              };
           }
         lastEditFlag = false;
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckBuy(CPosition & posBuy, CPosition & posSell, datetime & lastBuyConditionTime,
              datetime & lastSellConditionTime, bool & lastEditBFlag,bool & lastEditSFlag ,double & openPrice)
  {
   if(posBuy.GroupTotal() == 0 && posSell.GroupTotal() == 0)
     {
      if(lastBuyConditionTime <= lastSellConditionTime)
        {
         if(!lastEditBFlag)
           {
            double lastclose = close.GetData(1);
            openPrice = lastclose - RetracePoint * tools.Pip();
            lastEditBFlag = true;
            lastEditSFlag=false;
            lastBuyConditionTime=TimeCurrent();
            return true;
           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool Buy(long magic, CPosition & posBuy, CPosition & posSell,
         bool & lastEditFlag, double & openPrice)
  {
   if(posBuy.GroupTotal() == 0 && posSell.GroupTotal() == 0)
     {
      if(lastEditFlag && tools.Bid() <= openPrice)
        {
         if(buyAndSell || buyonly)
           {
            trade.SetMagicNumber(magic);
            trade.Position(TYPE_POSITION_BUY, lot1, sl1, tp1, SLTP_PIPS, 15, (string)magic);
            trade.Position(TYPE_POSITION_BUY, lot2, sl2, tp2, SLTP_PIPS, 15, (string)magic);
            trade.Position(TYPE_POSITION_BUY, lot3, sl3, tp3, SLTP_PIPS, 15, (string)magic);
            if(AlertNotify)
              {
               Alert(AlertBuyContent);
              };
            if(EmailNotify)
              {
               SendMail("Iykdavis Updates", AlertBuyContent);
              };
            if(PhoneNotify)
              {
               SendNotification(AlertBuyContent);
              };
           }
         lastEditFlag = false;
         return true;
        }
     }
   return true;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void Trade()
  {
   Buy(magicM1, BuyM1, SellM1, lastEditFlagBM1, RetOpenPriceM1);
   Sell(magicM1, BuyM1, SellM1, lastEditFlagSM1, RetOpenPriceM1);
   Buy(magicM5, BuyM5, SellM5, lastEditFlagBM5, RetOpenPriceM5);
   Sell(magicM5, BuyM5, SellM5, lastEditFlagSM5, RetOpenPriceM5);
   Buy(magicM15, BuyM15, SellM15, lastEditFlagBM15, RetOpenPriceM15);
   Sell(magicM15, BuyM15, SellM15, lastEditFlagSM15, RetOpenPriceM15);
   Buy(magicM30, BuyM30, SellM30, lastEditFlagBM30, RetOpenPriceM30);
   Sell(magicM30, BuyM30, SellM30, lastEditFlagSM30, RetOpenPriceM30);
   Buy(magicH1, BuyH1, SellH1, lastEditFlagBH1, RetOpenPriceH1);
   Sell(magicH1, BuyH1, SellH1, lastEditFlagSH1, RetOpenPriceH1);
   Buy(magicH4, BuyH4, SellH4, lastEditFlagBH4, RetOpenPriceH4);
   Sell(magicH4, BuyH4, SellH4, lastEditFlagSH4, RetOpenPriceH4);
   Buy(magicD1, BuyD1, SellD1, lastEditFlagBD1, RetOpenPriceD1);
   Sell(magicD1, BuyD1, SellD1, lastEditFlagSD1, RetOpenPriceD1);
   Buy(magicW1, BuyW1, SellW1, lastEditFlagBW1, RetOpenPriceW1);
   Sell(magicW1, BuyW1, SellW1, lastEditFlagSW1, RetOpenPriceW1);
   Buy(magicMN, BuyMN, SellMN, lastEditFlagBMN, RetOpenPriceMN);
   Sell(magicMN, BuyMN, SellMN, lastEditFlagSMN, RetOpenPriceMN);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
