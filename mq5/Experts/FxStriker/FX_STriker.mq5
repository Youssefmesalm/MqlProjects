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
#include <YM\Position\Position.mqh>
#include <YM\Utilities\Utilities.mqh>
#include <YM\Execute\Execute.mqh>
#include <Trade\TerminalInfo.mqh>
#include <Trade\AccountInfo.mqh>
#include <Indicators\Trend.mqh>
#include <Charts\Chart.mqh>
#include <Indicators\TimeSeries.mqh>
#define R3_NAME "Daily R3"
#define R2_NAME "Daily R2"
#define R1_NAME "Daily R1"
#define PIVOT_NAME "Daily PP"
#define S1_NAME "Daily S1"
#define S2_NAME "Daily S2"
#define S3_NAME "Daily S3"
enum tpmode
  {
   TPMode1,//Res/Sup1
   TPMode2,//Res/Sup2
   TPMode3,//Res/Sup3
   FixTP//Fix Take Profit
  };
enum sellsl
  {
   SPointSL,//Fix Stop Loss
   ResLevel1,//Resistance1
   ResLevel2,//Resistance2
   ResLevel3//Resistance3
  };
enum buysl
  {
   BPointSL,//Fix Stop Loss
   SupLevel1,//Support1
   SupLevel2,//Support2
   SupLevel3//Support3
  };
enum lpmode
  {
   Strategy1,
   Strategy2,
   Strategy3
  };


input string Set0 = "-------General Setting------";//General Setting
input bool   Allow_Multi_Trade = false;//Allow Multiple Trade
input buysl  Buy_SL_Mode  = SupLevel3;//Buy SL Mode
input sellsl Sell_SL_Mode = ResLevel3;//Sell SL Mode
input int    StopLoss   = 0;//Fix Stop Loss(0 means disable)
input int    TakeProfit = 100;//Fix Take Profit(0 means disable)
input lpmode StrategyType    = Strategy3;//Strategy Type
input double LotSize1 = 0.01;//1st Trade Lot Size
input tpmode TakeProfitMode1 = TPMode1;//1st Trade Take Profit
//...
input double LotSize2 = 0.01;//2nd Trade Lot Size
input tpmode TakeProfitMode2 = TPMode2;//2nd Trade Take Profit
//...
input double LotSize3 = 0.01;//3th Trade Lot Size
input tpmode TakeProfitMode3 = TPMode3;//3th Trade Take Profit
//...
input bool   TrailEnable     = true;//Trail Base On Levels
input int    TrailPercent    = 70;//Trail % For 3th level
input int    MagicNumber = 123;//Magic Number
input bool   Close_By_Reverse_Signal = false;//Close By Reverse Signal
input string MSet = "-----Moving Setting------";
input int    MAPeriod1             = 8;//Moving Period1
input ENUM_APPLIED_PRICE MAPrice1  = PRICE_CLOSE;//Applied Price1
input ENUM_MA_METHOD     MAMethod1 = MODE_SMA;//MA Method1
//...
input int    MAPeriod2             = 39;//Moving Period2
input ENUM_APPLIED_PRICE MAPrice2  = PRICE_CLOSE;//Applied Price2
input ENUM_MA_METHOD     MAMethod2 = MODE_SMA;//MA Method2

//
input string FSet = "-----New Features-----";
input bool Use_50Day_MA = true;
input bool UseBuyRetracment = false;
input bool UseSellRetracment = false;
input int    MAPeriod3             = 50;//Moving Period3
input ENUM_APPLIED_PRICE MAPrice3  = PRICE_CLOSE;//Applied Price3
input ENUM_MA_METHOD     MAMethod3 = MODE_SMA;//MA Method3


input int    MAPeriod4             = 50;//Moving Period4
input ENUM_APPLIED_PRICE MAPrice4  = PRICE_CLOSE;//Applied Price4
input ENUM_MA_METHOD     MAMethod4 = MODE_SMA;//MA Method4
input ENUM_TIMEFRAMES Timeframe = PERIOD_H1;
// Alerts
input bool Email = true;
input bool MobileNotification = true;
input string EmailSubject = "New Order Entry";
//
input string PSet = "-----Pivot Setting------";
input int ShiftHrs = 5;   // Pivot day shift
input bool  ShowLine        = true;
input bool  ShowText        = true;
input int   FontSize        = 8;
input color SupportColor    = clrGreen;//Support Level Color
input color ResistanceColor = clrRed;//Resistance Level Color
input color PivotColor      = clrGray;//Pivot Level Color
input color FontColor       = clrGray;
enum ptype {BUYSTOP, BUYLIMIT, SELLSTOP, SELLLIMIT};
string Dash_Set         = "GUI Setting";//GUI Setting
int    Graphic_HPos     = 20;//Graphic Horizental Position
int    Graphic_VPos     = 20;//Graphic Vertical Position
int    Graphic_HSize    = 200;//Graphic Horizental Size
int    Graphic_VSize    = 170;//Graphic Vertical Size
color  DDBGColor        = clrWhiteSmoke;//Drop Down BG Color
string Font             = "Arial Bold";//Font
color  PanelBGColor     = clrLavender;//Panel BG Color
int    row              = 25;//Row Distance
string   datainfo[5];
double FirstTP = 0;
int MA4PriceRelation = 0;
int handle1;
//+----------------------Local variable------------------------------+
//Hello this is new change
datetime LastTime;
int      Trend = 2;
//+------------------------------------------------------------------+
// Input(s)
// positive value moves pivot day earlier

// Buffers for levels
double Res3[], Res2[], Res1[], Pivot[], Sup1[], Sup2[], Sup3[];

double PDayHigh, PDayLow;
string ThisSymbol;
datetime BarTime, PivotDayStartTime;
int VisibleBars, DayStartBar, LeftMostBar, RightMostBar;
double BuyFirstTP  = 0;
double BuySecondTP = 0;
double BuyThirdTP  = 0;
//...
double SellFirstTP  = 0;
double SellSecondTP = 0;

double SellThirdTP  = 0;
CUtilities tools;
CAccountInfo Account;
CTerminalInfo Terminal;
CExecute trade;
CValidationCheck Check;
CPosition Pos(Symbol(), MagicNumber, GROUP_POSITIONS_ALL);
CPosition SellPos(Symbol(), MagicNumber, GROUP_POSITIONS_SELLS);
CPosition BuyPos(Symbol(), MagicNumber, GROUP_POSITIONS_BUYS);
CiTime Time;
CiHigh High;
CiClose Close;
CiLow Low;
CChart Chart;
CiMA MA1;
CiMA MA2;
CiMA MA3;
CiMA MA4;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   trade.SetMagicNumber(MagicNumber);
   trade.SetSymbol(Symbol());
   Time.Create(Symbol(), PERIOD_CURRENT);
   High.Create(Symbol(), PERIOD_CURRENT);
   Close.Create(Symbol(), PERIOD_CURRENT);
   Low.Create(Symbol(), PERIOD_CURRENT);
   MA1.Create(Symbol(), PERIOD_CURRENT, MAPeriod1, 0, MAMethod1, MAPrice1);
   MA1.AddToChart(0, 0);
   MA2.Create(Symbol(), PERIOD_CURRENT, MAPeriod2, 0, MAMethod2, MAPrice2);
   MA2.AddToChart(0, 0);
   MA3.Create(Symbol(), PERIOD_CURRENT, MAPeriod3, 0, MAMethod3, MAPrice3);
   MA3.AddToChart(0, 0);
   MA4.Create(Symbol(), Timeframe, MAPeriod4, 0, MAMethod4, MAPrice4);
   MA3.AddToChart(0, 0);
   handle1 = iCustom(NULL, 0, "SQZPRO");
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
   Refresh();
   if(LastTime != Time.GetData(1))
     {
      Trend = 2;
      LastTime = Time.GetData(1);
      DoPivot();
      CheckMa4PriceRelation();
      CheckSignal(Symbol());
      //Comment("Buy first : "+BuyFirstTP+" | Buy second : "+BuySecondTP);
      GetOrder(Symbol(), LotSize1);
     }
   DoTrail();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int GetOrder(string sym, double lot)
  {
   double Ask = tools.Ask();
   double Bid = tools.Bid();
   double SL = 0;
   double TP = 0;
   int    Ticket = 0;
   int    TT = Pos.GroupTotal();
   if(Trend == 0 && (TT == 0 || Allow_Multi_Trade == true))
      if(Ask < BuySecondTP)
        {
         if(Buy_SL_Mode == BPointSL)
            if(StopLoss > 0)
               SL = Ask - StopLoss * Point();
         //...
         if(Buy_SL_Mode == SupLevel1)
            SL = SellFirstTP;
         if(Buy_SL_Mode == SupLevel2)
            SL = SellSecondTP;
         if(Buy_SL_Mode == SupLevel3)
            SL = SellThirdTP;
         //...
         if(TakeProfit > 0)
            TP = Ask + TakeProfit * Point();
         //...
         //TP = BuyFirstTP;
         double TP1 = 0;
         double TP2 = 0;
         double TP3 = 0;
         //...
         if(TakeProfitMode1 == TPMode1)
           {
            TP1 = BuyFirstTP;
           }
         if(TakeProfitMode2 == TPMode2)
            TP2 = BuySecondTP;
         if(TakeProfitMode3 == TPMode3)
            TP3 = BuyThirdTP;
         //...
         if(TakeProfitMode1 == FixTP)
            TP1 = TP;
         if(TakeProfitMode2 == FixTP)
            TP2 = TP;
         if(TakeProfitMode3 == FixTP)
            TP3 = TP;
         //...
         if(TP1 > 200000)
            TP1 = TP;
         if(TP2 > 200000)
            TP2 = TP;
         if(TP3 > 200000)
            TP3 = TP;
         //...
         if(Validity(sym, LotValidity(sym, lot), ORDER_TYPE_BUY, Ask, SL, TP) == true)
           {
            if(StrategyType == Strategy1)
              {
               if(TP1 > tools.Bid() < SL)
                 {
                  trade.Position(TYPE_POSITION_BUY, LotValidity(sym, LotSize1), SL, TP1, SLTP_PRICE, 30, "_1st");
                  SendAlert(0, SL, TP1);
                 }
              }
            if(StrategyType == Strategy2)
              {
               if(TP1 > tools.Bid() < SL && TP2 > tools.Bid())
                 {
                  trade.Position(TYPE_POSITION_BUY, LotValidity(sym, LotSize1), SL, TP1, SLTP_PRICE, 30, "_2nd");
                  SendAlert(0, SL, TP1);
                  trade.Position(TYPE_POSITION_BUY, LotValidity(sym, LotSize2), SL, TP2, SLTP_PRICE, 30, "_3th");
                  SendAlert(0, SL, TP2);
                 }
              }
            if(StrategyType == Strategy3)
              {
               if(TP1 > tools.Bid() < SL && TP2 > tools.Bid() && TP3 > tools.Bid())
                 {
                  trade.Position(TYPE_POSITION_BUY, LotValidity(sym, LotSize1), SL, TP1, SLTP_PRICE, 30, "_1st");
                  SendAlert(0, SL, TP1);
                  trade.Position(TYPE_POSITION_BUY, LotValidity(sym, LotSize1), SL, TP2, SLTP_PRICE, 30, "_2nd");
                  SendAlert(0, SL, TP2);
                  trade.Position(TYPE_POSITION_BUY, LotValidity(sym, LotSize3), SL, TP3, SLTP_PRICE, 30, "_3th");
                  SendAlert(0, SL, TP3);
                 }
              }
           }
        }
//...
   if(Trend == 1 && (TT == 0 || Allow_Multi_Trade == true))
      if(Bid > SellSecondTP)
        {
         if(Sell_SL_Mode == SPointSL)
            if(StopLoss > 0)
               SL = Bid + StopLoss * Point();
         //...
         if(Sell_SL_Mode == ResLevel1)
            SL = BuyFirstTP;
         if(Sell_SL_Mode == ResLevel2)
            SL = BuySecondTP;
         if(Sell_SL_Mode == ResLevel3)
            SL = BuyThirdTP;
         //...
         if(TakeProfit > 0)
            TP = Bid - TakeProfit * Point();
         //...
         //TP = SellFirstTP;
         double TP1 = 0;
         double TP2 = 0;
         double TP3 = 0;
         if(TakeProfitMode1 == TPMode1)
            TP1 = SellFirstTP;
         if(TakeProfitMode2 == TPMode2)
            TP2 = SellSecondTP;
         if(TakeProfitMode3 == TPMode3)
            TP3 = SellThirdTP;
         //...
         if(TakeProfitMode1 == FixTP)
            TP1 = TP;
         if(TakeProfitMode2 == FixTP)
            TP2 = TP;
         if(TakeProfitMode3 == FixTP)
            TP3 = TP;
         //...
         if(TP1 > 200000)
            TP1 = TP;
         if(TP2 > 200000)
            TP2 = TP;
         if(TP3 > 200000)
            TP3 = TP;
         //...
         if(Validity(sym, LotValidity(sym, lot), ORDER_TYPE_SELL, Bid, SL, TP) == true)
           {
            if(StrategyType == Strategy1)
               if(TP1<tools.Bid()>SL)
                 {
                  trade.Position(TYPE_POSITION_SELL, LotValidity(sym, LotSize1), SL, TP1, SLTP_PRICE, 30, "_1st");
                  SendAlert(1, SL, TP1);
                 }
            if(StrategyType == Strategy2)
              {
               if(TP1<tools.Bid()>SL && TP2 < tools.Bid())
                 {
                  trade.Position(TYPE_POSITION_SELL, LotValidity(sym, LotSize1), SL, TP1, SLTP_PRICE, 30, "_2nd");
                  SendAlert(1, SL, TP1);
                  trade.Position(TYPE_POSITION_SELL, LotValidity(sym, LotSize2), SL, TP2, SLTP_PRICE, 30, "_3th");
                  SendAlert(1, SL, TP2);
                 }
              }
            if(StrategyType == Strategy3)
              {
               if(TP1<tools.Bid()>SL && TP2 < tools.Bid() && TP3 < tools.Bid())
                 {
                  trade.Position(TYPE_POSITION_SELL, LotValidity(sym, LotSize1), SL, TP1, SLTP_PRICE, 30, "_1st");
                  SendAlert(1, SL, TP1);
                  trade.Position(TYPE_POSITION_SELL, LotValidity(sym, LotSize1), SL, TP2, SLTP_PRICE, 30, "_2nd");
                  SendAlert(1, SL, TP2);
                  trade.Position(TYPE_POSITION_SELL, LotValidity(sym, LotSize3), SL, TP3, SLTP_PRICE, 30, "_3th");
                  SendAlert(1, SL, TP3);
                 }
              }
           }
        }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(Ticket);
  }

//+------------------------------------------------------------------+
bool Validity(string sym, double lot, ENUM_ORDER_TYPE type, double entry, double sl, double tp)
  {
//---
   if(Account.FreeMarginCheck(sym, type, lot, tools.Ask()) < 0)
     {
      Print("Not Enough Free Margin!");
      return(false);
     }
//---
   if(!Check.CheckVolumeValue(sym, lot))
     {
      Print("Lot Size is not in range");
      return(false);
     }
//---
   int SLDiss = int(MathAbs((entry - sl) * MathPow(10, int(tools.Digits()))));
   int TPDiss = int(MathAbs((entry - tp) * MathPow(10, int(tools.Digits()))));
   if(SLDiss < SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL) || TPDiss < SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL))
     {
      Print("SL Or TP is closer than valid stop level");
      return(false);
     }
//---
   if(Terminal.IsConnected() == false && MQLInfoInteger(MQL_TESTER) == false)
     {
      Print("Termianl Connection Error");
      return(false);
     }
//---
   if(Terminal.IsTradeAllowed() == false && MQLInfoInteger(MQL_TESTER) == false)
     {
      Print("Automatic Trading Permission Error");
      return(false);
     }
//
//---
   return(true);
  }
//+------------------------------------------------------------------+
double LotValidity(string sym, double L)
  {
   double minVolume = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double maxVolume = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   if(L > maxVolume)
      L = maxVolume;
   if(L < minVolume)
      L = minVolume;
   return(L);
  }


//+------------------------------------------------------------------+
void DoPivot()
  {
//---
   int Count;
   double Range;
   bool check = false;
   double newsl = 0;
//i = Bars - IndicatorCounted() - 1;
   int i = iBars(Symbol(), PERIOD_CURRENT) - 10;
   ArrayResize(Res1, i + 2);
   ArrayResize(Res2, i + 2);
   ArrayResize(Res3, i + 2);
   ArrayResize(Sup1, i + 2);
   ArrayResize(Sup2, i + 2);
   ArrayResize(Sup3, i + 2);
   ArrayResize(Pivot, i + 2);
   while(i >= 0)
     {
      // If the pivot day changes...
      if(PivotDay(Time.GetData(i + 1), ShiftHrs) != PivotDay(Time.GetData(i), ShiftHrs))
        {
         // Determine High & Low for the previous Pivot Day
         Count = iBarShift(NULL, 0, PivotDayStartTime) - i;             // number of bars in the day
         PDayHigh = High.GetData(iHighest(NULL, 0, MODE_HIGH, Count, i + 1));   // Pivot Day high
         PDayLow = Low.GetData(iLowest(NULL, 0, MODE_LOW, Count, i + 1));       // Pivot Day low
         // Pivot calculations
         Pivot[i] = (PDayHigh + PDayLow + Close.GetData(i + 1)) / 3; // Pivot point
         Range = PDayHigh - PDayLow;
         Res1[i] = 2 * Pivot[i] - PDayLow;                     // R1
         Res2[i] = Pivot[i] + Range;                           // R2
         Res3[i] = Res1[i] + Range;                            // R3
         Sup1[i] = 2 * Pivot[i] - PDayHigh;                    // S1
         Sup2[i] = Pivot[i] - Range;                           // S2
         Sup3[i] = Sup1[i] - Range;                            // S3
         // Don't draw the transition between levels
         Res3[i + 1] = EMPTY_VALUE;
         Res2[i + 1] = EMPTY_VALUE;
         Res1[i + 1] = EMPTY_VALUE;
         Pivot[i + 1] = EMPTY_VALUE;
         Sup1[i + 1] = EMPTY_VALUE;
         Sup2[i + 1] = EMPTY_VALUE;
         Sup3[i + 1] = EMPTY_VALUE;
         // Remember when the Day changed over
         PivotDayStartTime = Time.GetData(i);
        }
      else     // no change to pivot levels
        {
         Res3[i] = Res3[i + 1];
         Res2[i] = Res2[i + 1];
         Res1[i] = Res1[i + 1];
         Pivot[i] = Pivot[i + 1];
         Sup1[i] = Sup1[i + 1];
         Sup2[i] = Sup2[i + 1];
         Sup3[i] = Sup3[i + 1];
        }
      // Move the labels to sensible places
      // If this is the last bar and (it's a new bar or time scale has changed)...
      if(i == 0 && (BarTime != Time.GetData(i) || VisibleBars != Chart.VisibleBars()))
        {
         DayStartBar = iBarShift(ThisSymbol, Period(), PivotDayStartTime);
         LeftMostBar = Chart.VisibleBars() - 7;
         RightMostBar = 15;
         if(DayStartBar < RightMostBar) // label too close to the right
           {
            ObjectMove(0, R3_NAME, 0, Time.GetData(RightMostBar), Res3[i]);
            ObjectMove(0, R2_NAME, 0, Time.GetData(RightMostBar), Res2[i]);
            ObjectMove(0, R1_NAME, 0, Time.GetData(RightMostBar), Res1[i]);
            ObjectMove(0, PIVOT_NAME, 0, Time.GetData(RightMostBar), Pivot[i]);
            ObjectMove(0, S1_NAME, 0, Time.GetData(RightMostBar), Sup1[i]);
            ObjectMove(0, S2_NAME, 0, Time.GetData(RightMostBar), Sup2[i]);
            ObjectMove(0, S3_NAME, 0, Time.GetData(RightMostBar), Sup3[i]);
           }
         else
            if(DayStartBar > LeftMostBar) // label too close to the left
              {
               ObjectMove(0, R3_NAME, 0, Time.GetData(LeftMostBar), Res3[i]);
               ObjectMove(0, R2_NAME, 0, Time.GetData(LeftMostBar), Res2[i]);
               ObjectMove(0, R1_NAME, 0, Time.GetData(LeftMostBar), Res1[i]);
               ObjectMove(0, PIVOT_NAME, 0, Time.GetData(LeftMostBar), Pivot[i]);
               ObjectMove(0, S1_NAME, 0, Time.GetData(LeftMostBar), Sup1[i]);
               ObjectMove(0, S2_NAME, 0, Time.GetData(LeftMostBar), Sup2[i]);
               ObjectMove(0, S3_NAME, 0, Time.GetData(LeftMostBar), Sup3[i]);
              }
            else                                      // move it with the bars
              {
               ObjectMove(0, R3_NAME, 0, PivotDayStartTime, Res3[i]);
               ObjectMove(0, R2_NAME, 0, PivotDayStartTime, Res2[i]);
               ObjectMove(0, R1_NAME, 0, PivotDayStartTime, Res1[i]);
               ObjectMove(0, PIVOT_NAME, 0, PivotDayStartTime, Pivot[i]);
               ObjectMove(0, S1_NAME, 0, PivotDayStartTime, Sup1[i]);
               ObjectMove(0, S2_NAME, 0, PivotDayStartTime, Sup2[i]);
               ObjectMove(0, S3_NAME, 0, PivotDayStartTime, Sup3[i]);
              }
        }
      VisibleBars = Chart.VisibleBars();
      BarTime = Time.GetData(i);
      i--;
     }
   if(Pos.GroupTotal() == 0)
     {
      BuyFirstTP  = Res1[1];
      SellFirstTP = Sup1[1];
      //...
      BuySecondTP  = Res2[1];
      SellSecondTP = Sup2[1];
      //...
      BuyThirdTP  = Res3[1];
      SellThirdTP = Sup3[1];
      //...
     }
   /*string text = "";
   text += "Buy TP1 :"+DoubleToString(BuyFirstTP,_Digits);
   text += "\nBuy TP2 : "+DoubleToString(BuySecondTP,_Digits);
   text += "\nBuy TP3 : "+DoubleToString(BuyThirdTP,_Digits);
   text += "\nSell TP1 : "+DoubleToString(SellFirstTP,_Digits);
   text += "\nSell TP2 : "+DoubleToString(SellSecondTP,_Digits);
   text += "\nSell TP3 : "+DoubleToString(SellThirdTP,_Digits);
   Comment(text);*/
//...
   int daycounter = 0;
   for(int d = 1; d < ArraySize(Res1) - 1; d++)
     {
      MqlDateTime str1, str2;
      TimeToStruct(Time.GetData(d), str1);
      TimeToStruct(Time.GetData(d + 1), str2);
      if(str1.day_of_year != str2.day_of_year)
        {
         daycounter++;
         datetime startt = Time.GetData(d);
         datetime stopt  = startt + (1440 * 60);
         datetime middle = datetime((startt + stopt) / 2);
         DrawTLine("Res1_" + TimeToString(Time.GetData(d)), startt, Res1[d], stopt, Res1[d], ResistanceColor);
         DrawText("Res1Text_" + TimeToString(Time.GetData(d)), middle, Res1[d], "Res1 : " + DoubleToString(Res1[d], _Digits), FontColor);
         DrawTLine("Res2_" + TimeToString(Time.GetData(d)), startt, Res2[d], stopt, Res2[d], ResistanceColor);
         DrawText("Res2Text_" + TimeToString(Time.GetData(d)), middle, Res2[d], "Res2 : " + DoubleToString(Res2[d], _Digits), FontColor);
         DrawTLine("Res3_" + TimeToString(Time.GetData(d)), startt, Res3[d], stopt, Res3[d], ResistanceColor);
         DrawText("Res3Text_" + TimeToString(Time.GetData(d)), middle, Res3[d], "Res3 : " + DoubleToString(Res3[d], _Digits), FontColor);
         DrawTLine("Pivot_" + TimeToString(Time.GetData(d)), startt, Pivot[d], stopt, Pivot[d], PivotColor);
         DrawText("PivotText_" + TimeToString(Time.GetData(d)), middle, Pivot[d], "Pivot : " + DoubleToString(Pivot[d], _Digits), FontColor);
         //...
         DrawTLine("Sup1_" + TimeToString(Time.GetData(d)), startt, Sup1[d], stopt, Sup1[d], SupportColor);
         DrawText("Sup1Text_" + TimeToString(Time.GetData(d)), middle, Sup1[d], "Sup1 : " + DoubleToString(Sup1[d], _Digits), FontColor);
         DrawTLine("Sup2_" + TimeToString(Time.GetData(d)), startt, Sup2[d], stopt, Sup2[d], SupportColor);
         DrawText("Sup2Text_" + TimeToString(Time.GetData(d)), middle, Sup2[d], "Sup2 : " + DoubleToString(Sup2[d], _Digits), FontColor);
         DrawTLine("Sup3_" + TimeToString(Time.GetData(d)), startt, Sup3[d], stopt, Sup3[d], SupportColor);
         DrawText("Sup3Text_" + TimeToString(Time.GetData(d)), middle, Sup3[d], "Sup3 : " + DoubleToString(Sup3[d], _Digits), FontColor);
         //...
        }
      if(daycounter > 10)
         break;
     }
//Comment("Res1 : "+Res1[1]+"\nRes2 : "+Res2[1]+"\nRes3 : "+Res3[1]+"\nSup1 : "+Sup1[1]+"\nSup2 : "+Sup2[1]+"\nSup3 : "+Sup3[1]);
//---
  }
//+------------------------------------------------------------------+
int PivotDay(datetime Bar_Time, datetime Shift_Hrs)
  {
   MqlDateTime str1;
   TimeToStruct(Bar_Time + Shift_Hrs * 3600, str1);
   int PDay = str1.day_of_week;
   if(PDay == 0)
      PDay = 1;      // Count Sunday as Monday
   if(PDay == 6)
      PDay = 5;      // Count Saturday as Friday
   return(PDay);
  }
//+------------------------------------------------------------------+
void DrawText(string name, datetime t1, double p1, string text, color cl)
  {
//---
   if(ShowText == false)
      return;
   ObjectDelete(ChartID(), name);
   ObjectCreate(ChartID(), name, OBJ_TEXT, 0, t1, p1);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, cl);
   ObjectSetString(ChartID(), name, OBJPROP_TEXT, text);
   ObjectSetString(ChartID(), name, OBJPROP_FONT, "Arial Black");
   ObjectSetInteger(ChartID(), name, OBJPROP_FONTSIZE, FontSize);
//---
  }
//+------------------------------------------------------------------+
void DrawTLine(string name, datetime t1, double p1, datetime t2, double p2, color cl)
  {
//---
   if(ShowLine == false)
      return;
   ObjectDelete(ChartID(), name);
   ObjectCreate(ChartID(), name, OBJ_TREND, 0, t1, p1, t2, p2);
   ObjectSetInteger(ChartID(), name, OBJPROP_COLOR, cl);
   ObjectSetInteger(ChartID(), name, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(ChartID(), name, OBJPROP_RAY, false);
//---
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckConsildation()
  {
   double buff[7] = {0, 0, 0, 0, 0, 0};
   if(CopyBuffer(handle1, 0, 0, 7, buff) != 7)
      return false;
   ArrayPrint(buff);
   int size = ArraySize(buff);
   for(int i = size ; i > 1; i--)
     {
      if(buff[i] < buff[i - 1] > buff[i - 2])
        {
         return true;
        }
      else
         if(buff[i] > buff[i - 1] < buff[i - 2])
           {
            return true;
           }
     }
   return false;
  }
//+------------------------------------------------------------------+
void CheckSignal(string sym)
  {
//---
   if(Use_50Day_MA)
     {
      if(tools.Ask() > MA3.Main(0))
        {
         if(MA1.Main(1) > MA2.Main(1) && MA1.Main(2) < MA2.Main(2) && !CheckConsildation())
           {
            Trend = 0;
           }
        }
      else
         if(tools.Bid() < MA3.Main(0))
           {
            if(MA1.Main(1) < MA2.Main(1) && MA1.Main(2) > MA2.Main(2) && !CheckConsildation())
              {
               Trend = 1;
              }
           }
     }
   else
      if(!Use_50Day_MA)
        {
         if(MA1.Main(1) > MA2.Main(1) && MA1.Main(2) < MA2.Main(2))
           {
            Trend = 0;
           }
         if(MA1.Main(1) < MA2.Main(1) && MA1.Main(2) > MA2.Main(2))
           {
            Trend = 1;
           }
        }
   if(UseBuyRetracment)
     {
      if(MA4PriceRelation == 1)
        {
         if(MA4.Main(1) > MA4.Main(0) && MA4.Main(0) == tools.Bid())
           {
            Trend = 0;
            MA4PriceRelation = 0;
           }
        }
     }
   if(UseSellRetracment)
     {
      if(MA4PriceRelation == -1)
        {
         if(MA4.Main(1) < MA4.Main(0) && MA4.Main(0) == tools.Bid())
           {
            Trend = 1;
            MA4PriceRelation = 0;
           }
        }
     }
//---
   if(Close_By_Reverse_Signal == true)
     {
      if(Trend == 0)
         SellPos.GroupCloseAll(20);
      if(Trend == 1)
         BuyPos.GroupCloseAll(20);
     }
//---
  }
//+------------------------------------------------------------------+
void DoTrail()
  {
//---
   double Bid = tools.Bid();
   bool check   = false;
   double newsl = 0;
   int  ThirdLevelDistance = 0;
   if(TrailEnable == true)
      for(int j = 0; j < OrdersTotal(); j++)
         if(Pos.SelectByIndex(j))
           {
            newsl = 0;
            ThirdLevelDistance = int(DiffPrice(BuyThirdTP, Pos[j].GetPriceOpen(), Symbol()));
            ThirdLevelDistance = int((ThirdLevelDistance * TrailPercent) / 100);
            if(Pos[j].GetType() == ORDER_TYPE_BUY)
              {
               if(Bid >= BuyFirstTP && Bid < BuySecondTP)
                  if(BuyFirstTP > Pos[j].GetPriceOpen())
                     newsl = Pos[j].GetPriceOpen();
               //...
               if(Bid >= BuySecondTP && Bid < BuyThirdTP)
                  newsl = BuyFirstTP;
               //...
               if(Bid >= Pos[j].GetPriceOpen() + ThirdLevelDistance * _Point)
                  newsl = BuySecondTP;
               //...
               if(Bid > Pos[j].GetPriceOpen() && newsl > 0)
                  if(newsl > Pos[j].GetStopLoss() || Pos[j].GetStopLoss() == 0)
                     Pos[j].Modify(newsl, Pos[j].GetTakeProfit(), SLTP_PRICE);
               //...
              }
            if(Pos[j].GetType() == ORDER_TYPE_SELL)
              {
               ThirdLevelDistance = int(DiffPrice(SellThirdTP, Pos[j].GetPriceOpen(), Symbol()));
               ThirdLevelDistance = int((ThirdLevelDistance * TrailPercent) / 100);
               if(Bid <= SellFirstTP && Bid > SellSecondTP)
                  if(SellFirstTP < Pos[j].GetPriceOpen())
                     newsl = Pos[j].GetPriceOpen();
               //...
               if(Bid <= SellSecondTP && Bid > SellThirdTP)
                  newsl = SellFirstTP;
               //...
               if(Bid <= Pos[j].GetPriceOpen() - ThirdLevelDistance * _Point)
                  newsl = SellSecondTP;
               //...
               if(Bid < Pos[j].GetPriceOpen() && newsl > 0)
                  if(newsl < Pos[j].GetStopLoss() || Pos[j].GetStopLoss() == 0)
                     Pos[j].Modify(newsl, Pos[j].GetTakeProfit(), SLTP_PRICE);
              }
           }
//---
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DiffPrice(double price1, double price2, string sym)
  {
//---
   double diff = MathAbs((price1 - price2) * MathPow(10, tools.Digits()));
//---
   return(diff);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void CheckMa4PriceRelation()
  {
   if(UseBuyRetracment)
     {
      if(MA4PriceRelation != 1)
        {
         if(tools.Bid() > MA4.Main(0))
           {
            MA4PriceRelation = 1;
           }
        }
     }
   if(MA4PriceRelation != -1)
     {
      if(UseSellRetracment)
        {
         if(tools.Bid() < MA4.Main(0))
           {
            MA4PriceRelation = -1;
           }
        }
     }
  }
//+------------------------------------------------------------------+
void Refresh()
  {
   Time.Refresh(-1);
   High.Refresh(-1);
   Low.Refresh(-1);
   Close.Refresh(-1);
   MA1.Refresh(-1);
   MA2.Refresh(-1);
   MA3.Refresh(-1);
   MA4.Refresh(-1);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendAlert(int type, double sl, double tp)
  {
   string order = type == 0 ? "Buy" : "Sell";
   if(Email)
     {
      Alert(order + " Position Enterd at Price: " + DoubleToString(tools.Ask(), 4) + " With StopLoss at: " + DoubleToString(sl, 4)  + " and takeProfit at: " + DoubleToString(tp, 4));
      SendMail(EmailSubject, order + " Position Enterd at Price: " + DoubleToString(tools.Ask(), 4) + " With StopLoss at: " + DoubleToString(sl, 4) + " and takeProfit at: " + DoubleToString(tp, 4));
     }
   if(MobileNotification)
     {
      SendNotification(order + " Position Enterd at Price: " + DoubleToString(tools.Ask(), 4) + " With StopLoss at: " + DoubleToString(sl, 4) + " and takeProfit at: " + DoubleToString(tp, 4));
     }
  }
//+------------------------------------------------------------------+
