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
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Magenta
#property indicator_color5 clrLimeGreen
#property indicator_color6 clrRed
#property indicator_color7 clrAliceBlue
#property indicator_color8 clrAqua
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2
#property indicator_width7 2
#property indicator_width8 2
#property indicator_label5 "Reversal Buy"
#property indicator_label6 "Reversal Sell"
#property indicator_label7 "BreakOut Buy"
#property indicator_label8 "BreakOut Buy"
enum strategy
  {
   Breakout,
   Reversal,
   Both,
  };
extern bool RSICCI_Filter = FALSE;
extern strategy Strategy=Reversal;
extern int xpip_for_Revesal=0;
extern int Max_distance=2;
extern int xpip_for_Breakout=0;
extern double RSIPeriod = 5;
extern double RSIOverbought = 90;
extern double RSIOversold = 5;
extern double CCIPeriod = 5;
extern double CCIBuyLevel = 166;
extern double CCISellLevel = -166;
extern bool HighLow = FALSE;
extern int SignalDots = 3;
extern bool Alerts = TRUE;
extern bool AlertOnClose = False;
extern int BarCount = 500;

bool HighBreakout = TRUE;
bool HighBreakPending = TRUE;
bool LowBreakout = TRUE;
bool LowBreakPending = TRUE;
double LastResistance = 0;
double LastSupport = 0;
double AlertBar = 0;
//---- buffers
double v1[];
double v2[];
double BreakUp[];
double BreakDown[];
double RevUp[],RevDn[];
double BUp[],BDn[];
double val1;
double val2;
int counter1;
int counter2;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexArrow(0, 119);
   SetIndexArrow(1, 119);
//----
   SetIndexStyle(0, DRAW_ARROW, STYLE_DOT, 0, Red);
//SetIndexDrawBegin(0, i-1);
   SetIndexBuffer(0, v1);
   SetIndexLabel(0, "Resistance");
//----
   SetIndexStyle(1, DRAW_ARROW, STYLE_DOT, 0, Blue);
//SetIndexDrawBegin(1, i-1);
   SetIndexBuffer(1, v2);
   SetIndexLabel(1, "Support");
//----
   SetIndexStyle(2, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(2, 233);
   SetIndexBuffer(2, BreakUp);
//----
   SetIndexStyle(3, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(3, 234);
   SetIndexBuffer(3, BreakDown);
//----
   SetIndexStyle(4, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(4, 233);
   SetIndexBuffer(4, RevUp);
//----
   SetIndexStyle(5, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(5, 234);
   SetIndexBuffer(5, RevDn);
//----
   SetIndexStyle(6, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(6, 233);
   SetIndexBuffer(6, BUp);
//----
   SetIndexStyle(7, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(7, 234);
   SetIndexBuffer(7, BDn);
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
//----
   for(int i = BarCount; i >=0; i--)
     {

      val1 = iFractals(NULL, 0, MODE_UPPER, i);
      //----
      if(val1 > 0)
        {
         v1[i] = High[i];
         counter1 = 1;
        }
      else
        {
         v1[i] = v1[i+1];
         counter1++;
        }
      val2 = iFractals(NULL, 0, MODE_LOWER, i);
      //----
      if(val2 > 0)
        {
         v2[i] = Low[i];
         counter2 = 1;
        }
      else
        {
         v2[i] = v2[i+1];
         counter2++;
        }

      if(v1[i] != LastResistance)
        {
         HighBreakPending = True;
         LastResistance = v1[i];
        }
      if(v2[i] != LastSupport)
        {
         LowBreakPending = True;
         LastSupport = v2[i];
        }

      if(HighLow)
         double BPrice=High[i];
      else
         BPrice=Close[i];
      if(HighBreakPending && BPrice > v1[i] && (!RSICCI_Filter || (RSICCI_Filter && iRSI(NULL, 0, RSIPeriod, PRICE_CLOSE, i) < RSIOverbought &&
            iCCI(Symbol(), NULL, CCIPeriod, PRICE_CLOSE, i) > CCIBuyLevel)) && counter1 >= SignalDots)
         HighBreakout = TRUE;
      if(HighLow)
         BPrice=Low[i];
      else
         BPrice=Close[i];
      if(LowBreakPending && BPrice < v2[i] && (!RSICCI_Filter || (RSICCI_Filter && iRSI(NULL, 0, RSIPeriod, PRICE_CLOSE, i) > RSIOversold &&
            iCCI(Symbol(), NULL, CCIPeriod, PRICE_CLOSE, i) < CCISellLevel)) && counter2 >= SignalDots)
         LowBreakout = TRUE;

      if(AlertOnClose)
         int AlertCandle = 1;
      else
         AlertCandle = 0;

      if(HighBreakout)
        {
         if(i >= AlertCandle)
            BreakUp[i] = Low[i]-20*Point;
         if(Alerts && i == AlertCandle && Bars > AlertBar)
           {
            Alert(Symbol(), " M", Period(), ": Resistance Breakout: BUY");
            AlertBar = 60;
           }
         HighBreakout = False;
         HighBreakPending = False;
        }
      else
         if(LowBreakout)
           {
            if(i >= AlertCandle)
               BreakDown[i] = High[i]+20*Point;
            if(Alerts && i==AlertCandle && Bars>AlertBar)
              {
               Alert(Symbol(), " M", Period(), ": Support Breakout: SELL");
               AlertBar =60;
              }
            LowBreakout = False;
            LowBreakPending = False;
           }
      //Reversal Strategy
      if(Strategy==Reversal||Strategy==Both)
        {
         if(Open[i+1]>v2[i+1]&&Low[i+1]<=v2[i+1]+xpip_for_Revesal*10*Point&&Close[i+1]>v2[i+1]&&Close[i+1]<v2[i+1]+Max_distance*10*Point)
           {
            RevUp[i]=Low[i];
           }
         if(Open[i+1]<v1[i+1]&&High[i+1]>=v1[i+1]-xpip_for_Revesal*10*Point&&Close[i+1]<v1[i+1]&&Close[i+1]>v1[i+1]-Max_distance*10*Point)
           {
            RevDn[i]=High[i];
           }
        }

      //Breakout Strategy
      if(Strategy==Breakout||Strategy==Both)
        {
         if(Open[i+1]>v2[i+1]&&Low[i+1]<=v2[i+1]&&Close[i+1]<v2[i+1]-xpip_for_Breakout*10*Point)
           {
            BDn[i]=High[i];
           }
         if(Open[i+1]<v1[i+1]&&High[i+1]>=v1[i+1]&&Close[i+1]>v1[i+1]+xpip_for_Breakout*10*Point)
           {
            BUp[i]=Low[i];
           }
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
