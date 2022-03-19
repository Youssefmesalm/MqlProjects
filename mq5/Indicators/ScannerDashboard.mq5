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

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   3
//---- plot Zigzag
#property indicator_label1  "Zigzag"
#property indicator_type1   DRAW_SECTION
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2


//--- indicator buffers
double         ZigzagBuffer[];      // main buffer
double         HighMapBuffer[];     // highs
double         LowMapBuffer[];      // lows
CChartObjectArrowDown DN;
CChartObjectArrowUp UP;
//+------------------------------------------------------------------+
//| variables                                                        |
//+------------------------------------------------------------------+
input string set1 = "Currency Pair";
input bool CheckAllPairs = false;
input string CustomPairs = "EURUSD,USDCHF,USDCAD,USDJPY,GBPUSD";
input int TrendPeriod = 15;
input string set2 = "Alerts Settings";
input bool PushNotifications = true;
input bool AlertMessage = true;
input bool Email = true;
double Highs[][9];
double Lows[][9];
int trend[][9];
double entrybuy[][9];
double entrysell[][9];
bool first = true;
static datetime HighTime[][9], LowTime[][9], TimeeR[][9];
string Symbols[];
string TimeFrames[9];
int lastswing[][9] ;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//--- indicator buffers mapping
   SetIndexBuffer(0, ZigzagBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, HighMapBuffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(2, LowMapBuffer, INDICATOR_CALCULATIONS);

   IndicatorSetInteger(INDICATOR_DIGITS, Digits());
//--- set empty value
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0);

   
   ArraySetAsSeries(ZigzagBuffer,true);
   ArraySetAsSeries(HighMapBuffer,true);
   ArraySetAsSeries(LowMapBuffer,true);

   first = true;
   setSymbolsTimeframes();
   int sizeSym = ArraySize(Symbols);
   ArrayResize(HighTime, sizeSym);
   ArrayResize(LowTime, sizeSym);
   ArrayResize(Highs, sizeSym);
   ArrayResize(Lows, sizeSym);
   ArrayResize(trend, sizeSym);
   ArrayResize(entrybuy, sizeSym);
   ArrayResize(entrysell, sizeSym);
   ArrayResize(TimeeR, sizeSym);
   ArrayResize(lastswing, sizeSym);
   CreateDashboardTitles();
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
for(int i =ObjectsTotal(0,-1,OBJ_TREND)-1; i>=0; i--)
     {
   ObjectsDeleteAll(0);
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
//--- initializing
   if(prev_calculated == 0)
     {
      ArrayInitialize(ZigzagBuffer, 0.0);
      ArrayInitialize(HighMapBuffer, 0.0);
      ArrayInitialize(LowMapBuffer, 0.0);
     }
      if(rates_total<100) return(0);
      
   int limit = rates_total - prev_calculated;
   if(limit > 2)
     {
      limit = 100;
     }
     
   for(int bar = 100; bar >=0; bar--)
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
            double clos = iClose(symbol, getTimeFrame(j), bar);
            bool update = false;
            
            // check if ther is mew swing high or low
            if(CheckLowsHighs(i, j, bar))
              {
               // some calcultion befor signal
               if(lastswing[i][j] == 0)
                 {
                  double L = Lows[i][j];
                  datetime LT = LowTime[i][j];
                  double H = Highs[i][j];
                  double half = (H - L) / 2;
                  entrysell[i][j] = L-half;
                
                 }
               else
                  if(lastswing[i][j] == 1)
                    {
                     double H = Highs[i][j];
                     double L = Lows[i][j];
                     datetime HT = HighTime[i][j];
                     double half = (H - L) / 2;
                     entrybuy[i][j] = H + half;
                    
                    }
              }
            // check sell signal
            if(clos < entrysell[i][j])
              {
               if(trend[i][j] != 0)
                 {
                  if(TimeeR[i][j] != iTime(Symbol(), getTimeFrame(j), 0))
                    {
                     trend[i][j] = 0;
                     alerts(symbol, "Sell", TimeFrames[j]);
                     TimeeR[i][j] = iTime(Symbol(), getTimeFrame(j), 0);
                     ENUM_TIMEFRAMES TF = getTimeFrame(j);
                     string Signal_Type = "Sell" ;
                     color Color = clrRed ;
                     CreatePanel("Signals" + Symbols[i] + "_" + string(TF), OBJ_EDIT, Signal_Type, X_Shift, Y_Shift, 75, 25, Color, clrBlack, clrWhite, 9, true, false, 0, ALIGN_CENTER);
                    }
                 }
              }
            // check buy signal
            if(clos > entrybuy[i][j]&&entrybuy[i][j]>0)
              {
               if(trend[i][j] != 1)
                 {
                  if(TimeeR[i][j] != iTime(Symbol(), getTimeFrame(j), 0))
                    {
                     trend[i][j] = 1;
                     ENUM_TIMEFRAMES TF = getTimeFrame(j);
                     string Signal_Type = "Buy";
                     color Color = clrGreen;
                     CreatePanel("Signals" + Symbols[i] + "_" + string(TF), OBJ_EDIT, Signal_Type, X_Shift, Y_Shift, 75, 25, Color, clrBlack, clrWhite, 9, true, false, 0, ALIGN_CENTER);
                     alerts(symbol, "Buy", TimeFrames[j]);
                     TimeeR[i][j] = iTime(Symbol(), getTimeFrame(j), 0);
                    }
                 }
              }
            X_Shift += 73;
           }
         Y_Shift += 25;
        }
      if(HighMapBuffer[bar] > 0)
        {
         ZigzagBuffer[bar] = HighMapBuffer[bar];
         UP.Create(0,TimeToString(TimeCurrent(),TIME_DATE),0,time[bar],high[bar] );
        }
      else
         if(LowMapBuffer[bar] > 0)
           {
            ZigzagBuffer[bar] = LowMapBuffer[bar];
            DN.Create(0,TimeToString(TimeCurrent(),TIME_DATE),0,time[bar],low[bar]);
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
   if(CheckAllPairs)
      for(int i = 0; i < SymbolsTotal(true); i++)
        {
         ArrayResize(Symbols, i + 1);
         Symbols[i] = SymbolName(i, true);
        }
   else
     {
      StringSplit(CustomPairs, StringGetCharacter(",", 0), Symbols);
     }
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
      if(Type == OBJ_EDIT)
        {
         ObjectSetInteger(0, name, OBJPROP_ALIGN, Align);
         ObjectSetInteger(0, name, OBJPROP_READONLY, readonly);
        }
     }
   else
     {
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontsize);
      ObjectSetInteger(0, name, OBJPROP_COLOR, InfoColor);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, boarderColor);
      ObjectSetInteger(0, name, OBJPROP_BGCOLOR, BGColor_);
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
bool CheckLowsHighs(int symbol, int TF, int b)
  {
   double close[];
   double open[];
   datetime time[];
   CopyOpen(Symbols[symbol], getTimeFrame(TF), b, TrendPeriod + 3, open);
   CopyTime(Symbols[symbol], getTimeFrame(TF), b, TrendPeriod + 3, time);
   CopyClose(Symbols[symbol], getTimeFrame(TF), b, TrendPeriod + 3, close);
   for(int i = ArraySize(close)-1;i>3  ; i--)
     {
      //Get Low
      if(close[i] < open[i] && close[i] < close[i - 1] && close[i] < close[i - 2]
         && close[i - 1] < close[i - 2] && LowTime[symbol][TF] < time[i])
        {
         double Swing_Low = close[i];
         if(Swing_Low != Lows[symbol][TF])
           {
            Lows[symbol][TF] = Swing_Low ;
            LowTime[symbol][TF] = time[i];
            if(Symbols[symbol] == Symbol()&&getTimeFrame(TF))
              {
               LowMapBuffer[b] = Swing_Low;
              }
            lastswing[symbol][TF] = 0;
            return true;
           }
        }
      //Get High
      if(close[i] > open[i] && close[i] > close[i - 1] && close[i] > close[i - 2]
         && close[i - 1] > close[i - 2] && HighTime[symbol][TF] < time[i])
        {
         double swing_High = close[i];
         if(swing_High != Highs[symbol][TF])
           {
            Highs[symbol][TF] = swing_High;
            HighTime[symbol][TF] = time[i];
            if(Symbols[symbol] == Symbol()&&getTimeFrame(TF))
              {
               HighMapBuffer[b] = swing_High;
              }
            lastswing[symbol][TF] = 1;
            return true;
           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
