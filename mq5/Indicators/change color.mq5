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

#property indicator_chart_window   //Indicator in chart window              
#property  version "1.0"

#property indicator_buffers 6


#property indicator_label1 "Open;High;Low;Close"

#property indicator_plots 1     //Number of graphic plots                
#property indicator_type1 DRAW_COLOR_CANDLES   //Drawing style color candles
#property indicator_width1 3       //Width of the graphic plot              
input bool showPrice=false;

input color Color_Bar_Up_1=clrPowderBlue;
input color Color_Bar_Down_1=clrBisque;
input color Color_Bar_Up_0=clrGreen;
input color Color_Bar_Down_0=clrRed;

//Declaration of buffers
double buf_open[],buf_high[],buf_low[],buf_close[];//Buffers for data
double buf_color_line[];  //Buffer for color indexes
color chartline;
color candlebull;
color candlebeer;
color barDown;
color barUp,back;
datetime allowed_until = D'2022.03.11 00:00';
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//Assign the arrays with the indicator's buffers
   SetIndexBuffer(0,buf_open,INDICATOR_DATA);
   SetIndexBuffer(1,buf_high,INDICATOR_DATA);
   SetIndexBuffer(2,buf_low,INDICATOR_DATA);
   SetIndexBuffer(3,buf_close,INDICATOR_DATA);

   SetIndexBuffer(4,buf_color_line,INDICATOR_COLOR_INDEX);
//Assign the array with color indexes with the indicator's color indexes buffer
   PlotIndexSetInteger(0,PLOT_COLOR_INDEXES,4);
//Set color for each index
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,0,Color_Bar_Up_0);  // 0th index Color_Bar_Up_0
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,1,Color_Bar_Down_0); // 1st index Color_Bar_Down_0
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,2,Color_Bar_Up_1);   // 2nd index Color_Bar_Up_1
   PlotIndexSetInteger(0,PLOT_LINE_COLOR,3,Color_Bar_Down_1); // 3th index Color_Bar_Down_1
   chartline=GetColorChartLine();
   candlebull=GetColorCandleBull();
   candlebeer=GetColorCandleBear();
   barDown= GetColorBarDown();
   barUp= GetColorBarUp();
   if(!showPrice)
      ChartSetInteger(0,CHART_SHOW_BID_LINE,false);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   back=ChartGetInteger(0,CHART_COLOR_BACKGROUND,0);
   return(0);
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

   SetColorBarDown(back);
   SetColorBarUp(back);
   SetColorCandleBear(back);
   SetColorCandleBull(back);
   SetColorChartLine(back);
   if(TimeCurrent() < allowed_until)
     {
      for(int i=0; i<=rates_total-1; i++)
        {
         //Set data for plotting
         if(i<rates_total-1)
           {
            buf_open[i]=open[i];
            buf_high[i]=high[i];
            buf_low[i]=low[i];
            buf_close[i]=close[i];




            if(open[i]>=close[i]) //if open >= close set color index 1
               buf_color_line[i]=1;//Assign the bar with color index, equal to 1
            else
               buf_color_line[i]=0;//Assign the bar with color index, equal to 0
           }
        }


     }
   else
     {
      MessageBox("EA Demo Expired If you complete the job with Yousuf Use the Last version");
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(rates_total-1);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//------------------------------------------------------------------------------  color for line chart and Doji candles
color  GetColorChartLine() { return((color)ChartGetInteger(0,CHART_COLOR_CHART_LINE)); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  SetColorChartLine(color Color_Chart_Line) { ChartSetInteger(0,CHART_COLOR_CHART_LINE,Color_Chart_Line); }
//--------------------------------------------------------------------------------------  body color of the bull candle
color  GetColorCandleBull() { return((color)ChartGetInteger(0,CHART_COLOR_CHART_UP)); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  SetColorCandleBull(color Color_Candle_Bull) { ChartSetInteger(0,CHART_COLOR_CHART_UP,Color_Candle_Bull); }
//--------------------------------------------------------------------------------------  body color of the bear candle
color  GetColorCandleBear() { return((color)ChartGetInteger(0,CHART_COLOR_CHART_DOWN)); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  SetColorCandleBear(color Color_Candle_Bear) { ChartSetInteger(0,CHART_COLOR_CHART_DOWN,Color_Candle_Bear); }
//-----------------------------------------------------------------------------------  Body color of a bull candlestick
color  GetColorBarUp() { return((color)ChartGetInteger(0,CHART_COLOR_CANDLE_BULL)); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  SetColorBarUp(color Color_Bar_Up) { ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,Color_Bar_Up); }
//-----------------------------------------------------------------------------------  Body color of a bull candlestick
color  GetColorBarDown() { return((color)ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR)); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  SetColorBarDown(color Color_Bar_Down) { ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,Color_Bar_Down); }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
