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
#include  <ChartObjects\ChartObjectsArrows.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>

CChartObjectArrowDown DN;
CChartObjectArrowUp UP;
CChartObjectTrend line;
//+------------------------------------------------------------------+
//| variables                                                        |
//+------------------------------------------------------------------+
input string CustomPairs = "EURUSD,USDCHF,USDCAD,USDJPY,GBPUSD";
input int TrendPeriod = 200;
input string set2 = "Alerts Settings";
input bool PushNotifications = true;
input bool AlertMessage = true;
input bool Email = true;
double Highs[][9];
double Lows[][9];
double swing[][9];
int trend[][9];
double entrybuy[][9];
double entrysell[][9];
bool first = true;
static datetime HighTime[][9], LowTime[][9], TimeeR[][9],Timee[][9];
string Symbols[];
string TimeFrames[9];
int lastswing[][9] ;
string lasttrend;
double swing_Low[][9];
double swing_High[][9];
datetime swing_Low_time[][9];
datetime swing_High_time[][9];
double mid[][9];
double half[][9];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {


   ObjectCreate(0,"low",OBJ_HLINE,0,0,0);
   ObjectCreate(0,"high",OBJ_HLINE,0,0,0);
   ObjectCreate(0,"buy",OBJ_HLINE,0,0,0);
   ObjectCreate(0,"sell",OBJ_HLINE,0,0,0);
   ObjectSetInteger(0,"sell",OBJPROP_STYLE,STYLE_DASH);
   ObjectSetInteger(0,"buy",OBJPROP_COLOR,clrGreen);

   first = true;
   setSymbolsTimeframes();
   int sizeSym = ArraySize(Symbols);
   ArrayResize(HighTime, sizeSym);
   ArrayResize(LowTime, sizeSym);
   ArrayResize(swing_High, sizeSym);
   ArrayResize(swing_Low, sizeSym);
   ArrayResize(swing_High_time, sizeSym);
   ArrayResize(swing_Low_time, sizeSym);
   ArrayResize(mid, sizeSym);
   ArrayResize(half, sizeSym);
   ArrayResize(trend, sizeSym);
   ArrayResize(entrybuy, sizeSym);
   ArrayResize(entrysell, sizeSym);
   ArrayResize(TimeeR, sizeSym);
   ArrayResize(Timee, sizeSym);
   ArrayResize(lastswing, sizeSym);
   ArrayInitialize(LowTime,0);
   ArrayInitialize(HighTime,0);
   ArrayInitialize(swing_High_time,0);
   ArrayInitialize(swing_Low_time,0);
   CreateDashboardTitles();
   initDashboard();
   EventSetTimer(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll(0,-1,-1);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit = rates_total - prev_calculated;
   if(limit > 2)
     {
      limit = 1000;
     }

   for(int bar = limit; bar >=0; bar--)
     {

      int X_Shift, Y_Shift;
      int sizeSym = ArraySize(Symbols);
      int sizeTF = ArraySize(TimeFrames);
      Y_Shift = 40 + Y_Move;

      // for loop on all symbols
      for(int i = 0; i < sizeSym; i++)
        {
         X_Shift = 80;
         string symbol = Symbols[i];
         // for loop on all TF for each symbol
         for(int j = 0; j < sizeTF; j++)
           {

            // check if ther is mew swing high or low
            CheckLowsHighs(i, j, bar, X_Shift, Y_Shift);

            X_Shift += 73;
           }
         Y_Shift += 25;
        }

     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|            Send Alerts                                           |
//+------------------------------------------------------------------+
void alerts(string symbol, string signal, string TF)
  {
   string text;
   text = "Scanner: " + symbol + " on TimeFrame " + TF + " Showed (" + signal + ") signal";
   if(PushNotifications)
      SendNotification(text);
   if(AlertMessage)
      Alert(text);
   if(Email)
      SendMail("Scanner Signal", text);
  }


//+------------------------------------------------------------------+
//|          set Timeframes and symbols                              |
//+------------------------------------------------------------------+
void setSymbolsTimeframes()
  {

   StringSplit(CustomPairs, StringGetCharacter(",", 0), Symbols);
   int size= ArraySize(Symbols);
   TimeFrames[0] = "M1";
   TimeFrames[1] = "M5";
   TimeFrames[2] = "M15";
   TimeFrames[3] = "M30";
   TimeFrames[4] = "H1";
   TimeFrames[5] = "H4";
   TimeFrames[6] = "D1";
   TimeFrames[7] = "W1";
   TimeFrames[8] = "MN";
  }
int Y_Move = 20;

//+------------------------------------------------------------------+
//|              create dashboard title                              |
//+------------------------------------------------------------------+
void CreateDashboardTitles()
  {
   int X_Shift, Y_Shift;
   Y_Shift = 10 + Y_Move;
   int sizeSym = ArraySize(Symbols);
   X_Shift = 10;
   Y_Shift = 40 + Y_Move;
   for(int i = 0; i < sizeSym; i++)
     {
      CreatePanel("Symbols" + Symbols[i], OBJ_EDIT, Symbols[i], X_Shift, Y_Shift, 60, 25, clrYellow, clrBlack, clrBlack, 9, true, false, 0, ALIGN_CENTER);
      Y_Shift += 25;
     }
   int sizeTF = ArraySize(TimeFrames);
   X_Shift = 80;
   Y_Shift = 10 + Y_Move;
   for(int i = 0; i < sizeTF; i++)
     {
      CreatePanel("TF" + TimeFrames[i], OBJ_EDIT, TimeFrames[i], X_Shift, Y_Shift, 75, 25,  clrYellow, clrBlack, clrBlack, 9, true, false, 0, ALIGN_CENTER);
      X_Shift += 73;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void initDashboard()
  {
   int X_Shift, Y_Shift;
   int sizeSym = ArraySize(Symbols);
   int sizeTF = ArraySize(TimeFrames);
   Y_Shift = 40 + Y_Move;

// for loop on all symbols
   for(int i = 0; i < sizeSym; i++)
     {
      X_Shift = 80;
      string symbol = Symbols[i];
      // for loop on all TF for each symbol
      for(int j = 0; j < sizeTF; j++)
        {
         ENUM_TIMEFRAMES TF = getTimeFrame(j);

         TimeeR[i][j] = iTime(Symbol(), getTimeFrame(j), 0);
         string Signal_Type = "No Signal" ;
         color Color = clrGray ;
         CreatePanel("Signals" + Symbols[i] + "_" + string(TF), OBJ_EDIT, Signal_Type, X_Shift, Y_Shift, 75, 25, Color, clrBlack, clrWhite, 9, true, false, 0, ALIGN_CENTER);
         X_Shift += 73;
        }
      Y_Shift += 25;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreatePanel(string name, ENUM_OBJECT Type, string text, int XDistance, int YDistance, int Width, int Hight,
                 color BGColor_, color InfoColor, color boarderColor, int fontsize, bool readonly = false, bool Obj_Selectable = false, int Corner = 0, ENUM_ALIGN_MODE Align = ALIGN_LEFT)
  {
   if(ObjectFind(0, name) == -1)
     {
      ObjectCreate(0, name, Type, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, XDistance);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, YDistance);
      ObjectSetInteger(0, name, OBJPROP_XSIZE, Width);
      ObjectSetInteger(0, name, OBJPROP_YSIZE, Hight);
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetString(0, name, OBJPROP_FONT, "Arial Bold");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontsize);
      ObjectSetInteger(0, name, OBJPROP_CORNER, Corner);
      ObjectSetInteger(0, name, OBJPROP_COLOR, InfoColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, boarderColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, BGColor_);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, Obj_Selectable);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      if(Type == OBJ_EDIT)
        {
         ObjectSetInteger(0, name, OBJPROP_ALIGN, Align);
         ObjectSetInteger(0, name, OBJPROP_READONLY, readonly);
         ObjectSetInteger(0,name,OBJPROP_ZORDER,100);

        }
     }
   else
     {
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontsize);
      ObjectSetInteger(0, name, OBJPROP_COLOR, InfoColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, boarderColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, BGColor_);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,100);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES getTimeFrame(int i)
  {
   switch(i)
     {
      case 0:
         return(PERIOD_M1);
      case 1:
         return(PERIOD_M5);
      case 2:
         return(PERIOD_M15);
      case 3:
         return(PERIOD_M30);
      case 4:
         return(PERIOD_H1);
      case 5:
         return(PERIOD_H4);
      case 6:
         return(PERIOD_D1);
      case 7:
         return(PERIOD_W1);
      case 8:
         return(PERIOD_MN1);
      default:
         return(PERIOD_CURRENT);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TimeFrameString(int TF)
  {
   switch(TF)
     {
      case 1:
         return("M1");
      case 5:
         return("M5");
      case 15:
         return("M15");
      case 30:
         return("M30");
      case 60:
         return("H1");
      case 240:
         return("H4");
      case 1440:
         return("D1");
      case 10080:
         return("W1");
      case 43200:
         return("MN");
     }
   return("current");
  }
//+------------------------------------------------------------------+
bool CheckLowsHighs(int symbol, int TF, int b,int X_Shift,int  Y_Shift)
  {
   double close[];
   double open[];
   datetime time[];
   double high[];
   double low[];
   CopyLow(Symbols[symbol],getTimeFrame(TF),b,TrendPeriod+3,low);
   CopyHigh(Symbols[symbol],getTimeFrame(TF),b,TrendPeriod+3,high);
   CopyOpen(Symbols[symbol], getTimeFrame(TF), b, TrendPeriod + 3, open);
   CopyTime(Symbols[symbol], getTimeFrame(TF), b, TrendPeriod + 3, time);
   CopyClose(Symbols[symbol], getTimeFrame(TF), b, TrendPeriod + 3, close);
   bool update=false;
   bool cross=false;
   int lastswingIDx=0;
//Get Low
   for(int i=1; i<ArraySize(close)-3; i++)
     {
      if(close[i] < open[i] && close[i] < close[i + 1] && close[i] < close[i + 2]
         && LowTime[symbol][TF] < time[i])
        {
         if(low[i]<swing_Low[symbol][TF]&&time[i]>swing_Low_time[symbol][TF]&&time[i]>swing_High_time[symbol][TF]&&swing_High_time[symbol][TF]<=swing_Low_time[symbol][TF]&&low[i]<swing_Low[symbol][TF])
           {
            if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period()&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0)
              {
               ObjectDelete(0,lasttrend);
              }
            cross=false;
            swing_Low[symbol][TF] = low[i];
            swing_Low_time[symbol][TF]=time[i];
            lastswingIDx=i;
            if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period()&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0)
              {
               lasttrend=DoubleToString(swing_High[symbol][TF],Digits())+TimeToString(swing_High_time[symbol][TF],TIME_DATE)+DoubleToString(swing_Low[symbol][TF],Digits())+TimeToString(swing_Low_time[symbol][TF],TIME_DATE);
               ObjectCreate(0,lasttrend,OBJ_TREND,0,swing_High_time[symbol][TF],swing_High[symbol][TF],swing_Low_time[symbol][TF],swing_Low[symbol][TF]);

              }
           }
         else
            if(low[i]<swing_High[symbol][TF]&&time[i]>swing_High_time[symbol][TF]&&time[i]>swing_Low_time[symbol][TF]&&swing_High_time[symbol][TF]>=swing_Low_time[symbol][TF])
              {
               swing_Low[symbol][TF] = low[i];
               swing_Low_time[symbol][TF]=time[i];
               lastswingIDx=i;
               cross=false;
               if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period()&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0)
                 {

                  lasttrend=DoubleToString(swing_High[symbol][TF],Digits())+TimeToString(swing_High_time[symbol][TF],TIME_DATE)+DoubleToString(swing_Low[symbol][TF],Digits())+TimeToString(swing_Low_time[symbol][TF],TIME_DATE);
                  ObjectCreate(0,lasttrend,OBJ_TREND,0,swing_High_time[symbol][TF],swing_High[symbol][TF],swing_Low_time[symbol][TF],swing_Low[symbol][TF]);

                 }
              }

         if(swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0&&time[i]>=swing_Low_time[symbol][TF]&&time[i]>=swing_High_time[symbol][TF])
           {
            half[symbol][TF]=(swing_High[symbol][TF]-swing_Low[symbol][TF])/2;
            mid[symbol][TF]= swing_Low[symbol][TF]+half[symbol][TF];
           }
        }

      if(close[i] > open[i] && close[i] > close[i+1] && close[i] > close[i + 2]
         && HighTime[symbol][TF] < time[i])
        {
         if(high[i]>swing_Low[symbol][TF]&&time[i]>swing_Low_time[symbol][TF]&&time[i]>swing_High_time[symbol][TF]&&swing_High_time[symbol][TF]>=swing_Low_time[symbol][TF]&&high[i]>swing_High[symbol][TF])
           {
            if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period()&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0)
              {
               ObjectDelete(0,lasttrend);
              }
            lastswingIDx=i;
            cross=false;
            swing_High[symbol][TF]=high[i];
            swing_High_time[symbol][TF]=time[i];
            if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period()&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0)
              {
               lasttrend=DoubleToString(swing_High[symbol][TF],Digits())+TimeToString(swing_High_time[symbol][TF],TIME_DATE)+DoubleToString(swing_Low[symbol][TF],Digits())+TimeToString(swing_Low_time[symbol][TF],TIME_DATE);
               ObjectCreate(0,lasttrend,OBJ_TREND,0,swing_Low_time[symbol][TF],swing_Low[symbol][TF],swing_High_time[symbol][TF],swing_High[symbol][TF]);
              }
           }
         else
            if(high[i]>swing_Low[symbol][TF]&&time[i]>swing_Low_time[symbol][TF]&&swing_Low_time[symbol][TF]>=swing_High_time[symbol][TF]&&time[i]>swing_High_time[symbol][TF])
              {
               lastswingIDx=i;
               cross=false;
               swing_High[symbol][TF] = high[i];
               swing_High_time[symbol][TF]=time[i];
               if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period()&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0)
                 {
                  lasttrend=DoubleToString(swing_High[symbol][TF],Digits())+TimeToString(swing_High_time[symbol][TF],TIME_DATE)+DoubleToString(swing_Low[symbol][TF],Digits())+TimeToString(swing_Low_time[symbol][TF],TIME_DATE);
                  ObjectCreate(0,lasttrend,OBJ_TREND,0,swing_Low_time[symbol][TF],swing_Low[symbol][TF],swing_High_time[symbol][TF],swing_High[symbol][TF]);
                 }
              }
         //double swing_low= low[highest];
         if(i>=lastswingIDx&&swing_Low[symbol][TF]>0&&swing_High[symbol][TF]>0&&time[i]>=swing_Low_time[symbol][TF]&&time[i]>=swing_High_time[symbol][TF])
           {
            half[symbol][TF]=(swing_High[symbol][TF]-swing_Low[symbol][TF])/2;
            mid[symbol][TF]= swing_Low[symbol][TF]+half[symbol][TF];
           }
        }
      if(i>=lastswingIDx&&close[i+2]>=mid[symbol][TF]&&close[i+3]<mid[symbol][TF]&&LowTime[symbol][TF]<swing_Low_time[symbol][TF]&&time[i]>swing_Low_time[symbol][TF]&&time[i]>swing_High_time[symbol][TF]&&!cross)
        {
         if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period())
           {

            line.Create(0,"Signals" + Symbol() + "_" + string(TF)+TimeToString(time[i+3],TIME_SECONDS)+TimeToString(time[i+3],TIME_DATE)+"mid",0,swing_Low_time[symbol][TF],mid[symbol][TF], time[i+3],mid[symbol][TF]);
            DN.Create(0,"Signals" + Symbol() + "_" + string(TF)+TimeToString(time[i+3],TIME_SECONDS)+TimeToString(time[i+3],TIME_DATE)+"Dn",0,time[i+3],high[i+3]);
           }
         cross=true;
         if(trend[symbol][TF]!=0)
           {
            trend[symbol][TF]=0;

            update= true;
           }
         LowTime[symbol][TF]=swing_Low_time[symbol][TF];
         HighTime[symbol][TF]=swing_High_time[symbol][TF];
        }
      else
         if(i>=lastswingIDx&&close[i+2]<=mid[symbol][TF]&&close[i+3]>mid[symbol][TF]&&mid[symbol][TF]!=0&&HighTime[symbol][TF]<swing_High_time[symbol][TF]&&time[i]>=swing_Low_time[symbol][TF]&&time[i]>=swing_High_time[symbol][TF]&&!cross)
           {
            if(Symbols[symbol]==Symbol()&&getTimeFrame(TF)==Period())
              {
               line.Create(0,"Signals" + Symbol() + "_" + string(TF)+TimeToString(time[i+3],TIME_SECONDS)+TimeToString(time[i+3],TIME_DATE)+"mid",0,swing_High_time[symbol][TF],mid[symbol][TF], time[i+3],mid[symbol][TF]);
               UP.Create(0,"Signals" + Symbol() + "_" + string(TF)+TimeToString(time[i+3],TIME_SECONDS)+TimeToString(time[i+3],TIME_DATE)+"up",0,time[i+3],low[i+3]);
              }
            cross=true;
            if(trend[symbol][TF]!=1)
              {

               trend[symbol][TF]=1;
               update= true;
              }
            HighTime[symbol][TF]=swing_High_time[symbol][TF];
            LowTime[symbol][TF]=swing_Low_time[symbol][TF];
           }

      if(update)
        {
         if(trend[symbol][TF] == 0)
           {

            ENUM_TIMEFRAMES TimeFrame = getTimeFrame(TF);
            if(TimeeR[symbol][TF]!= iTime(Symbol(), getTimeFrame(TF), 0))
              {
               alerts(Symbols[symbol], "Sell", TimeFrames[TF]);
               TimeeR[symbol][TF] = iTime(Symbol(), getTimeFrame(TF), 0);
              }
            string Signal_Type = "Sell" ;
            color Color = clrRed ;
            CreatePanel("Signals" + Symbols[symbol] + "_" + string(TimeFrame), OBJ_EDIT, Signal_Type, X_Shift, Y_Shift, 75, 25, Color, clrBlack, clrWhite, 9, true, false, 0, ALIGN_CENTER);
            trend[symbol][TF]=-1;
            update=false;
           }
         else
            if(trend[symbol][TF] == 1)
              {
               ENUM_TIMEFRAMES TimeFrame = getTimeFrame(TF);
               string Signal_Type = "Buy";
               color Color = clrGreen;
               CreatePanel("Signals" + Symbols[symbol] + "_" + string(TimeFrame), OBJ_EDIT, Signal_Type, X_Shift, Y_Shift, 75, 25, Color, clrBlack, clrWhite, 9, true, false, 0, ALIGN_CENTER);
               if(TimeeR[symbol][TF]!= iTime(Symbol(), getTimeFrame(TF), 0))
                 {
                  alerts(Symbols[symbol], "Buy", TimeFrames[TF]);
                  TimeeR[symbol][TF] = iTime(Symbol(), getTimeFrame(TF), 0);
                 }
               trend[symbol][TF]=-1;
               update=false;
              }
        }
      //double swing_High= high[lowest];





     }
   return false;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
