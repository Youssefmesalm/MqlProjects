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
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
#property indicator_type1   DRAW_ARROW
#property indicator_color1  LightSeaGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_DOT
#property indicator_width2  1
#property indicator_label1  "buy"
#property indicator_label2  "Sell"
//input
input int InpPeriod=14;
datetime allowed_until = D'2022.03.11 00:00';
//variables
int ADX_Handle,ROC_Handle,ExtPeriod;
double buy[],sell[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//--- check for input parameters
   if(InpPeriod>=100 || InpPeriod<=0)
     {
      ExtPeriod=14;
      PrintFormat("Incorrect value for input variable Period=%d. Indicator will use value=%d for calculations.",InpPeriod,ExtPeriod);
     }
   else
      ExtPeriod=InpPeriod;
//--- indicator buffers
   SetIndexBuffer(0,buy,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_ARROW,233);
   SetIndexBuffer(1,sell,INDICATOR_DATA);
   PlotIndexSetInteger(1,PLOT_ARROW,234);

//--- indicator digit
   ADX_Handle=iCustom(Symbol(),PERIOD_CURRENT,"ADX",14);
   ROC_Handle=iCustom(Symbol(),PERIOD_CURRENT,"ROC_810",14);
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

   int limit;
   if(prev_calculated==0)   //--- If it is the first call go through all bars
      limit=0;
   else
      limit=rates_total-1;  //--- Else just check the most current bar that has not yet finished
   if(TimeCurrent() < allowed_until)
     {
      for(int i=limit; i<rates_total; i++)
        {
         double Adx[1],DiP[1],DiN[1],Roc[2];
         CopyBuffer(ADX_Handle,0,(rates_total-1)-i,1,Adx);
         CopyBuffer(ADX_Handle,1,(rates_total-1)-i,1,DiP);
         CopyBuffer(ADX_Handle,2,(rates_total-1)-i,1,DiN);
         CopyBuffer(ROC_Handle,0,(rates_total-1)-i,2,Roc);

         double abs=MathAbs(Roc[0]);
         double inc=abs*2.5-abs;
         if(DiP[0]>Adx[0]&&DiP[0]>DiN[0]&&Roc[0]>=Roc[1]+inc)
           {
            buy[i]=low[i];
            sell[i]=0;
            if(i==0)
               Alert("Green");

           }
         else
            if(DiN[0]>Adx[0]&&DiP[0]<DiN[0]&&Roc[0]<=Roc[1]-inc)
              {
               sell[i]=high[i];
               buy[i]=0;
               if(i==0)
                  Alert("ReD");
              }
            else
              {
               buy[i]=0;
               sell[i]=0;
               if(i==0)
                  Alert("White");
              }



        }
     }
   else
     {
      MessageBox("EA Demo Expired If you complete the job with Yousuf Use the Last version");
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
