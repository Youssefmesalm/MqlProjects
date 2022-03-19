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
#property indicator_chart_window

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 1

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   int Mode= AccountStopoutMode();
   int Level= AccountStopoutLevel();
  
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
double equity=AccountEquity();
double margin =AccountMargin();
   Info("info1",1,25,100,"mNArgin : ",12,"",clrLime);
   Info("info11",1,25,21,DoubleToString(margin,2),12,"",clrLime);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void Info(string NAME,double CORNER,int Y,int X,string TEXT,int FONTSIZE,string FONT,color FONTCOLOR)
  {
   ObjectCreate(NAME,OBJ_LABEL,0,0,0);
   ObjectSetText(NAME,TEXT,FONT,FONTSIZE,FONTCOLOR);
   ObjectSet(NAME,OBJPROP_CORNER,CORNER);
   ObjectSet(NAME,OBJPROP_XDISTANCE,X);
   ObjectSet(NAME,OBJPROP_YDISTANCE,Y);

  }