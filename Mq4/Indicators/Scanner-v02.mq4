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

// General EA inputs for user
input string              Symbols_Names          = "EURUSDm,GBPUSDm,USDCHFm,USDJPYm";
extern string             MA1_SetUP              = "------< MA1_SetUP >------";
input int                 period1                = 8;
input ENUM_MA_METHOD      MA_Method1             = MODE_EMA;
input ENUM_APPLIED_PRICE  MA_price1              = PRICE_CLOSE;
extern string             MA2_SetUP              = "------< MA2_SetUP >------";
input int                 period2                = 21;
input ENUM_MA_METHOD      MA_Method2             = MODE_EMA;
input ENUM_APPLIED_PRICE  MA_price2              = PRICE_CLOSE;
extern string             Stochastic1_SetUP      = "------< Stochastic1_SetUP >------";
input int                 K_Period1              = 33;
input int                 D_Period1              = 1;
input int                 Slowing1               = 11;
input ENUM_MA_METHOD      Stochastic_Method1     = MODE_SMA;
input ENUM_STO_PRICE      Stochastic_price1      = STO_CLOSECLOSE;
input double              STO_Up                 = 61.8;
input double              STO_Dn                 = 38.2;
input bool                Sound_alert            = true;
input bool                Mobile_alert           = true;
input bool                Email_alert            = true;
input color               Buy_color              = clrGreen;
input color               Sell_color             = clrRed;
input bool                MA_Cross_Alert         = true;
input bool                OS_condition           = true;
input bool                MA_STO_Alert           = true;

// Global variables for EA use
color Color1,Color2,Color3,Color4,Color5,Color6,Color7,Color8,Color9,Color10,Color11,Color12,Color13,Color14,Color15,Color16,Color17,Color18;
int num1, num2,num3,num4,num5,num6,num7,num8,num9,num10,num11,num12,num13,num14,num15,num16,num17,num18;
int z;
datetime time1 =0;
datetime time2 =0;
datetime time3 =0;
datetime time4 =0;
datetime time5 =0;
datetime time6 =0;
datetime time7 =0;
datetime time8 =0;
datetime time9 =0;
datetime time10 =0;
datetime time11 =0;
datetime time12 =0;
datetime time13 =0;
datetime time14 =0;
datetime time15 =0;
datetime time16 =0;
datetime time17 =0;
datetime time18 =0;
datetime time19 =0;
datetime time20 =0;
datetime time21 =0;
datetime time22 =0;
datetime time23 =0;
datetime time24 =0;
datetime time25 =0;
datetime time26 =0;
datetime time27 =0;
datetime time28 =0;
datetime time29 =0;
datetime time30 =0;
datetime time31 =0;
datetime time32 =0;
datetime time33 =0;
datetime time34 =0;
datetime time35 =0;
datetime time36 =0;
datetime time37 =0;
datetime time38 =0;
datetime time39 =0;
datetime time40 =0;
datetime time41 =0;
datetime time42 =0;
datetime time43 =0;
datetime time44 =0;
datetime time45 =0;
datetime time46 =0;
datetime time47 =0;
datetime time48 =0;
datetime time49 =0;
datetime time50 =0;
datetime time51 =0;
datetime time52 =0;
datetime time53 =0;
datetime time54 =0;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
  void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(-1);
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


//DashBoard
   string sep=",";
   ushort u_sep;
   string result[];
   u_sep=StringGetCharacter(sep,0);
   int k=StringSplit(Symbols_Names,u_sep,result);


   Button("Head11",OBJ_BUTTON,0,60,50,60,30,"",10,clrBlack,clrWhite,clrBlack);
   Button("Head12",OBJ_BUTTON,0,120,50,120,30,"M1",10,clrBlack,clrWhite,clrBlack);
   Button("Head13",OBJ_BUTTON,0,240,50,120,30,"M5",10,clrBlack,clrWhite,clrBlack);
   Button("Head14",OBJ_BUTTON,0,360,50,120,30,"M15",10,clrBlack,clrWhite,clrBlack);
   Button("Head15",OBJ_BUTTON,0,480,50,120,30,"M30",10,clrBlack,clrWhite,clrBlack);
   Button("Head16",OBJ_BUTTON,0,600,50,120,30,"H1",10,clrBlack,clrWhite,clrBlack);
   Button("Head17",OBJ_BUTTON,0,720,50,120,30,"H4",10,clrBlack,clrWhite,clrBlack);
   Button("Head18",OBJ_BUTTON,0,840,50,120,30,"D1",10,clrBlack,clrWhite,clrBlack);
   Button("Head19",OBJ_BUTTON,0,960,50,120,30,"W",10,clrBlack,clrWhite,clrBlack);
   Button("Head110",OBJ_BUTTON,0,1080,50,120,30,"MN1",10,clrBlack,clrWhite,clrBlack);

   Button("Head21",OBJ_BUTTON,0,60,80,60,30,"",8,clrBlack,clrWhite,clrBlack);
   Button("Head22",OBJ_BUTTON,0,120,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head23",OBJ_BUTTON,0,180,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head24",OBJ_BUTTON,0,240,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head25",OBJ_BUTTON,0,300,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head26",OBJ_BUTTON,0,360,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head27",OBJ_BUTTON,0,420,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head28",OBJ_BUTTON,0,480,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head29",OBJ_BUTTON,0,540,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head210",OBJ_BUTTON,0,600,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head211",OBJ_BUTTON,0,660,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head212",OBJ_BUTTON,0,720,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head213",OBJ_BUTTON,0,780,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head214",OBJ_BUTTON,0,840,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head215",OBJ_BUTTON,0,900,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head216",OBJ_BUTTON,0,960,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head217",OBJ_BUTTON,0,1020,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);
   Button("Head218",OBJ_BUTTON,0,1080,80,60,30,"MA Cross",7,clrBlack,clrWhite,clrBlack);
   Button("Head219",OBJ_BUTTON,0,1140,80,60,30,"Stoch",7,clrBlack,clrWhite,clrBlack);



   if(k>0)
     {
      for(int i=0; i<k; i++)
        {
         double MA1_M1   =iMA(result[i],PERIOD_M1,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_M1 =iMA(result[i],PERIOD_M1,period1,0,MA_Method1,MA_price1,2);
         double ma2_M1   =iMA(result[i],PERIOD_M1,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_M1 =iMA(result[i],PERIOD_M1,period2,0,MA_Method2,MA_price2,2);
         double MA1_M5   =iMA(result[i],PERIOD_M5,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_M5 =iMA(result[i],PERIOD_M5,period1,0,MA_Method1,MA_price1,2);
         double ma2_M5   =iMA(result[i],PERIOD_M5,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_M5 =iMA(result[i],PERIOD_M5,period2,0,MA_Method2,MA_price2,2);
         double MA1_M15   =iMA(result[i],PERIOD_M15,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_M15 =iMA(result[i],PERIOD_M15,period1,0,MA_Method1,MA_price1,2);
         double ma2_M15   =iMA(result[i],PERIOD_M15,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_M15 =iMA(result[i],PERIOD_M15,period2,0,MA_Method2,MA_price2,2);
         double MA1_M30   =iMA(result[i],PERIOD_M15,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_M30 =iMA(result[i],PERIOD_M15,period1,0,MA_Method1,MA_price1,2);
         double ma2_M30   =iMA(result[i],PERIOD_M15,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_M30 =iMA(result[i],PERIOD_M15,period2,0,MA_Method2,MA_price2,2);
         double MA1_H1    =iMA(result[i],PERIOD_H1,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_H1  =iMA(result[i],PERIOD_H1,period1,0,MA_Method1,MA_price1,2);
         double ma2_H1    =iMA(result[i],PERIOD_H1,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_H1  =iMA(result[i],PERIOD_H1,period2,0,MA_Method2,MA_price2,2);
         double MA1_H4    =iMA(result[i],PERIOD_H4,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_H4  =iMA(result[i],PERIOD_H4,period1,0,MA_Method1,MA_price1,2);
         double ma2_H4    =iMA(result[i],PERIOD_H4,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_H4  =iMA(result[i],PERIOD_H4,period2,0,MA_Method2,MA_price2,2);
         double MA1_D1    =iMA(result[i],PERIOD_D1,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_D1  =iMA(result[i],PERIOD_D1,period1,0,MA_Method1,MA_price1,2);
         double ma2_D1    =iMA(result[i],PERIOD_D1,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_D1  =iMA(result[i],PERIOD_D1,period2,0,MA_Method2,MA_price2,2);
         double MA1_W1    =iMA(result[i],PERIOD_W1,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_W1  =iMA(result[i],PERIOD_W1,period1,0,MA_Method1,MA_price1,2);
         double ma2_W1    =iMA(result[i],PERIOD_W1,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_W1  =iMA(result[i],PERIOD_W1,period2,0,MA_Method2,MA_price2,2);
         double MA1_MN1    =iMA(result[i],PERIOD_MN1,period1,0,MA_Method1,MA_price1,1);
         double MA1_2_MN1  =iMA(result[i],PERIOD_MN1,period1,0,MA_Method1,MA_price1,2);
         double ma2_MN1    =iMA(result[i],PERIOD_MN1,period2,0,MA_Method2,MA_price2,1);
         double ma2_2_MN1  =iMA(result[i],PERIOD_MN1,period2,0,MA_Method2,MA_price2,2);
         double sto_M15   =  iStochastic(result[i],PERIOD_M15,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_H1    =  iStochastic(result[i],PERIOD_H1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_H4    =  iStochastic(result[i],PERIOD_H4,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_D1    =  iStochastic(result[i],PERIOD_D1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_W1    =  iStochastic(result[i],PERIOD_W1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_M1    =  iStochastic(result[i],PERIOD_M1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_M5    =  iStochastic(result[i],PERIOD_M5,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_M30    =  iStochastic(result[i],PERIOD_M30,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         double sto_MN1    =  iStochastic(result[i],PERIOD_MN1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,1);
         
         double sto_M15_2   =  iStochastic(result[i],PERIOD_M15,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_H1_2    =  iStochastic(result[i],PERIOD_H1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_H4_2    =  iStochastic(result[i],PERIOD_H4,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_D1_2    =  iStochastic(result[i],PERIOD_D1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_W1_2   =  iStochastic(result[i],PERIOD_W1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_M1_2    =  iStochastic(result[i],PERIOD_M1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_M5_2    =  iStochastic(result[i],PERIOD_M5,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_M30_2    =  iStochastic(result[i],PERIOD_M30,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);
         double sto_MN1_2    =  iStochastic(result[i],PERIOD_MN1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,2);


         Button("Data1"+IntegerToString(z),OBJ_BUTTON,0,60,110+z,60,30,result[i],6,clrBlack,clrWhite,clrWhite);


         if(MA_BUY_M1(result[i])>0 && MA_BUY_M1(result[i])< MA_SELL_M1(result[i]))
           {
            Color11=Buy_color;
            num11=MA_BUY_M1(result[i]);
           }
         if(MA_SELL_M1(result[i])>0 && MA_BUY_M1(result[i])> MA_SELL_M1(result[i]))
           {
            Color11=Sell_color;
            num11=MA_SELL_M1(result[i]);
           }
         Button("Data11"+IntegerToString(z),OBJ_BUTTON,0,120,110+z,60,30,IntegerToString(num11),10,clrBlack,Color11,clrWhite);

         if(STO_BUY_M1(result[i])>0 && STO_SELL_M1(result[i])> STO_BUY_M1(result[i]))
           {
            Color12=Buy_color;
            num12=STO_BUY_M1(result[i]);
           }
         if(STO_SELL_M1(result[i])>0 && STO_SELL_M1(result[i])< STO_BUY_M1(result[i]))
           {
            Color12=Sell_color;
            num12=STO_SELL_M1(result[i]);
           }
         if(sto_M1 < STO_Up && sto_M1 > STO_Dn)
           {
            Color12=clrGray;
            num12=NULL;
           }

         Button("Data12"+IntegerToString(z),OBJ_BUTTON,0,180,110+z,60,30,IntegerToString(num12),10,clrBlack,Color12,clrWhite);


         if(MA_BUY_M5(result[i])>0 && MA_BUY_M5(result[i])< MA_SELL_M5(result[i]))
           {
            Color13=Buy_color;
            num13=MA_BUY_M5(result[i]);
           }
         if(MA_SELL_M5(result[i])>0 && MA_BUY_M5(result[i])> MA_SELL_M5(result[i]))
           {
            Color13=Sell_color;
            num13=MA_SELL_M5(result[i]);
           }
         Button("Data13"+IntegerToString(z),OBJ_BUTTON,0,240,110+z,60,30,IntegerToString(num13),10,clrBlack,Color13,clrWhite);

         if(STO_BUY_M5(result[i])>0 && STO_SELL_M5(result[i])> STO_BUY_M5(result[i]))
           {
            Color14=Buy_color;
            num14=STO_BUY_M5(result[i]);
           }
         if(STO_SELL_M5(result[i])>0 && STO_SELL_M5(result[i])< STO_BUY_M5(result[i]))
           {
            Color14=Sell_color;
            num14=STO_SELL_M5(result[i]);
           }
         if(sto_M5 < STO_Up && sto_M5 > STO_Dn)
           {
            Color14=clrGray;
            num14=NULL;
           }

         Button("Data1114"+IntegerToString(z),OBJ_BUTTON,0,300,110+z,60,30,IntegerToString(num14),10,clrBlack,Color14,clrWhite);


         if(MA_BUY_M15(result[i])>0 && MA_BUY_M15(result[i])< MA_SELL_M15(result[i]))
           {
            Color1=Buy_color;
            num1=MA_BUY_M15(result[i]);
           }
         if(MA_SELL_M15(result[i])>0 && MA_BUY_M15(result[i])> MA_SELL_M15(result[i]))
           {
            Color1=Sell_color;
            num1=MA_SELL_M15(result[i]);
           }
         Button("Data14"+IntegerToString(z),OBJ_BUTTON,0,360,110+z,60,30,IntegerToString(num1),10,clrBlack,Color1,clrWhite);

         if(STO_BUY_M15(result[i])>0 && STO_SELL_M15(result[i])> STO_BUY_M15(result[i]))
           {
            Color2=Buy_color;
            num2=STO_BUY_M15(result[i]);
           }
         if(STO_SELL_M15(result[i])>0 && STO_SELL_M15(result[i])< STO_BUY_M15(result[i]))
           {
            Color2=Sell_color;
            num2=STO_SELL_M15(result[i]);
           }
         if(sto_M15 < STO_Up && sto_M15 > STO_Dn)
           {
            Color2=clrGray;
            num2=NULL;
           }

         Button("Data16"+IntegerToString(z),OBJ_BUTTON,0,420,110+z,60,30,IntegerToString(num2),10,clrBlack,Color2,clrWhite);

         if(MA_BUY_H1(result[i])>0 && MA_BUY_H1(result[i])< MA_SELL_H1(result[i]))
           {
            Color3=Buy_color;
            num3=MA_BUY_H1(result[i]);
           }
         if(MA_SELL_H1(result[i])>0 && MA_BUY_H1(result[i])> MA_SELL_H1(result[i]))
           {
            Color3=Sell_color;
            num3=MA_SELL_H1(result[i]);
           }

         Button("Data17"+IntegerToString(z),OBJ_BUTTON,0,480,110+z,60,30,IntegerToString(num3),10,clrBlack,Color3,clrWhite);

         if(STO_BUY_H1(result[i])>0 && STO_SELL_H1(result[i])> STO_BUY_H1(result[i]))
           {
            Color4=Buy_color;
            num4=STO_BUY_H1(result[i]);
           }
         if(STO_SELL_H1(result[i])>0 && STO_SELL_H1(result[i])< STO_BUY_H1(result[i]))
           {
            Color4=Sell_color;
            num4=STO_SELL_H1(result[i]);
           }
         if(sto_H1 < STO_Up && sto_H1 > STO_Dn)
           {
            Color4=clrGray;
            num4=NULL;
           }

         Button("Data18"+IntegerToString(z),OBJ_BUTTON,0,540,110+z,60,30,IntegerToString(num4),10,clrBlack,Color4,clrWhite);


         if(MA_BUY_M30(result[i])>0 && MA_BUY_M30(result[i])< MA_SELL_M30(result[i]))
           {
            Color15=Buy_color;
            num15=MA_BUY_M30(result[i]);
           }
         if(MA_SELL_M30(result[i])>0 && MA_BUY_M30(result[i])> MA_SELL_M30(result[i]))
           {
            Color15=Sell_color;
            num15=MA_SELL_M30(result[i]);
           }
         Button("Data19"+IntegerToString(z),OBJ_BUTTON,0,600,110+z,60,30,IntegerToString(num15),10,clrBlack,Color15,clrWhite);

         if(STO_BUY_M30(result[i])>0 && STO_SELL_M30(result[i])> STO_BUY_M30(result[i]))
           {
            Color16=Buy_color;
            num16=STO_BUY_M30(result[i]);
           }
         if(STO_SELL_M30(result[i])>0 && STO_SELL_M30(result[i])< STO_BUY_M30(result[i]))
           {
            Color16=Sell_color;
            num16=STO_SELL_M30(result[i]);
           }
         if(sto_M30 < STO_Up && sto_M30 > STO_Dn)
           {
            Color16=clrGray;
            num16=NULL;
           }

         Button("Data110"+IntegerToString(z),OBJ_BUTTON,0,660,110+z,60,30,IntegerToString(num16),10,clrBlack,Color16,clrWhite);






         if(MA_BUY_H4(result[i])>0 && MA_BUY_H4(result[i])< MA_SELL_H4(result[i]))
           {
            Color5=Buy_color;
            num5=MA_BUY_H4(result[i]);
           }
         if(MA_SELL_H4(result[i])>0 && MA_BUY_H4(result[i])> MA_SELL_H4(result[i]))
           {
            Color5=Sell_color;
            num5=MA_SELL_H4(result[i]);
           }
         Button("Data111"+IntegerToString(z),OBJ_BUTTON,0,720,110+z,60,30,IntegerToString(num5),10,clrBlack,Color5,clrWhite);

         if(STO_BUY_H4(result[i])>0 && STO_SELL_H4(result[i])> STO_BUY_H4(result[i]))
           {
            Color6=Buy_color;
            num6=STO_BUY_H4(result[i]);
           }
         if(STO_SELL_H4(result[i])>0 && STO_SELL_H4(result[i])< STO_BUY_H4(result[i]))
           {
            Color6=Sell_color;
            num6=STO_SELL_H4(result[i]);
           }
         if(sto_H4 < STO_Up && sto_H4 > STO_Dn)
           {
            Color6=clrGray;
            num6=NULL;
           }

         Button("Data112"+IntegerToString(z),OBJ_BUTTON,0,780,110+z,60,30,IntegerToString(num6),10,clrBlack,Color6,clrWhite);



         if(MA_BUY_D1(result[i])>0 && MA_BUY_D1(result[i])< MA_SELL_D1(result[i]))
           {
            Color7=Buy_color;
            num7=MA_BUY_D1(result[i]);
           }
         if(MA_SELL_D1(result[i])>0 && MA_BUY_D1(result[i])> MA_SELL_D1(result[i]))
           {
            Color7=Sell_color;
            num7=MA_SELL_D1(result[i]);
           }

         Button("Data113"+IntegerToString(z),OBJ_BUTTON,0,840,110+z,60,30,IntegerToString(num7),10,clrBlack,Color7,clrWhite);

         if(STO_BUY_D1(result[i])>0 && STO_SELL_D1(result[i])> STO_BUY_D1(result[i]))
           {
            Color8=Buy_color;
            num8=STO_BUY_H4(result[i]);
           }
         if(STO_SELL_D1(result[i])>0 && STO_SELL_D1(result[i])< STO_BUY_D1(result[i]))
           {
            Color8=Sell_color;
            num8=STO_SELL_D1(result[i]);
           }
         if(sto_D1 < STO_Up && sto_D1 > STO_Dn)
           {
            Color8=clrGray;
            num8=NULL;
           }

         Button("Data114"+IntegerToString(z),OBJ_BUTTON,0,900,110+z,60,30,IntegerToString(num8),10,clrBlack,Color8,clrWhite);



         if(MA_BUY_W1(result[i])>0 && MA_BUY_W1(result[i])< MA_SELL_W1(result[i]))
           {
            Color9=Buy_color;
            num9=MA_BUY_W1(result[i]);
           }
         if(MA_SELL_W1(result[i])>0 && MA_BUY_W1(result[i])> MA_SELL_W1(result[i]))
           {
            Color9=Sell_color;
            num9=MA_SELL_W1(result[i]);
           }

         Button("Data115"+IntegerToString(z),OBJ_BUTTON,0,960,110+z,60,30,IntegerToString(num9),10,clrBlack,Color9,clrWhite);

         if(STO_BUY_W1(result[i])>0 && STO_SELL_W1(result[i])> STO_BUY_W1(result[i]))
           {
            Color10=Buy_color;
            num10=STO_BUY_W1(result[i]);
           }
         if(STO_SELL_W1(result[i])>0 && STO_SELL_W1(result[i])< STO_BUY_W1(result[i]))
           {
            Color10=Sell_color;
            num10=STO_SELL_W1(result[i]);
           }
         if(sto_W1 < STO_Up && sto_W1 > STO_Dn)
           {
            Color10=clrGray;
            num10=NULL;
           }

         Button("Data116"+IntegerToString(z),OBJ_BUTTON,0,1020,110+z,60,30,IntegerToString(num10),10,clrBlack,Color10,clrWhite);

         if(MA_BUY_MN1(result[i])>0 && MA_BUY_MN1(result[i])< MA_SELL_MN1(result[i]))
           {
            Color17=Buy_color;
            num17=MA_BUY_MN1(result[i]);
           }
         if(MA_SELL_MN1(result[i])>0 && MA_BUY_MN1(result[i])> MA_SELL_MN1(result[i]))
           {
            Color17=Sell_color;
            num17=MA_SELL_MN1(result[i]);
           }

         Button("Data117"+IntegerToString(z),OBJ_BUTTON,0,1080,110+z,60,30,IntegerToString(num17),10,clrBlack,Color17,clrWhite);

         if(STO_BUY_MN1(result[i])>0 && STO_SELL_MN1(result[i])> STO_BUY_MN1(result[i]))
           {
            Color18=Buy_color;
            num18=STO_BUY_MN1(result[i]);
           }
         if(STO_SELL_MN1(result[i])>0 && STO_SELL_MN1(result[i])< STO_BUY_MN1(result[i]))
           {
            Color18=Sell_color;
            num18=STO_SELL_MN1(result[i]);
           }
         if(sto_MN1 < STO_Up && sto_MN1 > STO_Dn)
           {
            Color18=clrGray;
            num18=NULL;
           }

         Button("Data118"+IntegerToString(z),OBJ_BUTTON,0,1140,110+z,60,30,IntegerToString(num18),10,clrBlack,Color18,clrWhite);
         //Alert MA Cross Alert
         if(MA_Cross_Alert)
           {
            if(MA1_M1>ma2_M1 && MA1_2_M1<ma2_2_M1)
              {
               if(time1!=iTime(result[i],PERIOD_M1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M1" + "Trend = "+ "UP");

                  time1 =iTime(result[i],PERIOD_M1,0);
                 }
              }
            if(MA1_M5>ma2_M5 && MA1_2_M5<ma2_2_M5)
              {
               if(time2!=iTime(result[i],PERIOD_M5,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M5" + "Trend = "+ "UP");

                  time2 =iTime(result[i],PERIOD_M5,0);
                 }
              }

            if(MA1_M15>ma2_M15 && MA1_2_M15<ma2_2_M15)
              {
               if(time3!=iTime(result[i],PERIOD_M15,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M15" + "Trend = "+ "UP");

                  time3 =iTime(result[i],PERIOD_M15,0);
                 }
              }
            if(MA1_M30>ma2_M30 && MA1_2_M30<ma2_2_M30)
              {
               if(time4!=iTime(result[i],PERIOD_M30,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M30" + "Trend = "+ "UP");

                  time4 =iTime(result[i],PERIOD_M30,0);
                 }
              }
            if(MA1_H1>ma2_H1 && MA1_2_H1<ma2_2_H1)
              {
               if(time5!=iTime(result[i],PERIOD_H1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H1" + "Trend = "+ "UP");

                  time5 =iTime(result[i],PERIOD_H1,0);
                 }
              }
            if(MA1_H4>ma2_H4 && MA1_2_H4<ma2_2_H4)
              {
               if(time6!=iTime(result[i],PERIOD_H4,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H4" + "Trend = "+ "UP");

                  time6 =iTime(result[i],PERIOD_H4,0);
                 }
              }
            if(MA1_D1>ma2_D1 && MA1_2_D1<ma2_2_D1)
              {
               if(time7!=iTime(result[i],PERIOD_D1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "D1" + "Trend = "+ "UP");

                  time7 =iTime(result[i],PERIOD_D1,0);
                 }
              }
            if(MA1_W1>ma2_W1 && MA1_2_W1<ma2_2_W1)
              {
               if(time8!=iTime(result[i],PERIOD_W1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "W1" + "Trend = "+ "UP");

                  time8 =iTime(result[i],PERIOD_W1,0);
                 }
              }
            if(MA1_MN1>ma2_MN1 && MA1_2_MN1<ma2_2_MN1)
              {
               if(time18!=iTime(result[i],PERIOD_MN1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "MN1" + "Trend = "+ "UP");

                  time18 =iTime(result[i],PERIOD_MN1,0);
                 }
              }

            if(MA1_M1<ma2_M1 && MA1_2_M1>ma2_2_M1)
              {
               if(time9!=iTime(result[i],PERIOD_M1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M1" + "Trend = "+ "Dn");

                  time9 =iTime(result[i],PERIOD_M1,0);
                 }
              }
            if(MA1_M5<ma2_M5 && MA1_2_M5>ma2_2_M5)
              {
               if(time10!=iTime(result[i],PERIOD_M5,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M5" + "Trend = "+ "Dn");

                  time10 =iTime(result[i],PERIOD_M5,0);
                 }
              }
            if(MA1_M15<ma2_M15 && MA1_2_M15>ma2_2_M15)
              {
               if(time11!=iTime(result[i],PERIOD_M15,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M15" + "Trend = "+ "Dn");

                  time11 =iTime(result[i],PERIOD_M15,0);
                 }
              }
            if(MA1_M30<ma2_M30 && MA1_2_M30>ma2_2_M30)
              {
               if(time12!=iTime(result[i],PERIOD_M30,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M30" + "Trend = "+ "Dn");

                  time12 =iTime(result[i],PERIOD_M30,0);
                 }
              }
            if(MA1_H1<ma2_H1 && MA1_2_H1>ma2_2_H1)
              {
               if(time13!=iTime(result[i],PERIOD_H1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H1" + "Trend = "+ "Dn");

                  time13 =iTime(result[i],PERIOD_H1,0);
                 }
              }
            if(MA1_H4<ma2_H4 && MA1_2_H4>ma2_2_H4)
              {
               if(time14!=iTime(result[i],PERIOD_H4,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H4" + "Trend = "+ "Dn");

                  time14 =iTime(result[i],PERIOD_H4,0);
                 }
              }
            if(MA1_D1<ma2_D1 && MA1_2_D1>ma2_2_D1)
              {
               if(time15!=iTime(result[i],PERIOD_D1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "D1" + "Trend = "+ "Dn");

                  time15 =iTime(result[i],PERIOD_D1,0);
                 }
              }
            if(MA1_W1<ma2_W1 && MA1_2_W1>ma2_2_W1)
              {
               if(time16!=iTime(result[i],PERIOD_W1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "W1" + "Trend = "+ "Dn");

                  time16 =iTime(result[i],PERIOD_W1,0);
                 }
              }
            if(MA1_MN1<ma2_MN1 && MA1_2_MN1>ma2_2_MN1)
              {
               if(time17!=iTime(result[i],PERIOD_MN1,0))
                 {
                  Alert("MA Cross Alert :" + "Symbol =" +result[i]+ "TimeFrame ="+ "MN1" + "Trend = "+ "Dn");

                  time17 =iTime(result[i],PERIOD_MN1,0);
                 }
              }
           }
         //Alert OS condition Alert
         if(OS_condition)
           {

            if(sto_M1 < STO_Dn && sto_M1_2 > STO_Dn )
              {
               if(time19!=iTime(result[i],PERIOD_M1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M1" + "Trend = "+ "Over Sold");

                  time19 =iTime(result[i],PERIOD_M1,0);
                 }
              }
            if(sto_M5 < STO_Dn && sto_M5_2 > STO_Dn )
              {
               if(time20!=iTime(result[i],PERIOD_M5,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M5" + "Trend = "+ "Over Sold");

                  time20 =iTime(result[i],PERIOD_M5,0);
                 }
              }

            if(sto_M15 < STO_Dn && sto_M15_2 > STO_Dn )
              {
               if(time21!=iTime(result[i],PERIOD_M15,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M15" + "Trend = "+ "Over Sold");

                  time21 =iTime(result[i],PERIOD_M15,0);
                 }
              }
            if(sto_M30 < STO_Dn && sto_M30_2 > STO_Dn )
              {
               if(time22!=iTime(result[i],PERIOD_M30,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M30" + "Trend = "+ "Over Sold");
                  time22 =iTime(result[i],PERIOD_M30,0);
                 }
              }
            if(sto_H1 < STO_Dn && sto_H1_2 > STO_Dn )
              {
               if(time23!=iTime(result[i],PERIOD_H1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H1" + "Trend = "+ "Over Sold");
                  time23 =iTime(result[i],PERIOD_H1,0);
                 }
              }
            if(sto_H4 < STO_Dn && sto_H4_2 > STO_Dn )
              {
               if(time24!=iTime(result[i],PERIOD_H4,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H4" + "Trend = "+ "Over Sold");

                  time24 =iTime(result[i],PERIOD_H4,0);
                 }
              }
            if(sto_D1 < STO_Dn && sto_D1_2 > STO_Dn )
              {
               if(time25!=iTime(result[i],PERIOD_D1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "D1" + "Trend = "+ "Over Sold");

                  time25 =iTime(result[i],PERIOD_D1,0);
                 }
              }
            if(sto_W1 < STO_Dn && sto_W1_2 > STO_Dn )
              {
               if(time26!=iTime(result[i],PERIOD_W1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "W1" + "Trend = "+ "Over Sold");

                  time26 =iTime(result[i],PERIOD_W1,0);
                 }
              }
            if(sto_MN1 < STO_Dn && sto_MN1_2 > STO_Dn )
              {
               if(time27!=iTime(result[i],PERIOD_MN1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "MN1" + "Trend = "+ "Over Sold");

                  time27 =iTime(result[i],PERIOD_MN1,0);
                 }
              }
            if(sto_M1 > STO_Up && sto_M1_2 < STO_Up )
              {
               if(time28!=iTime(result[i],PERIOD_M1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M1" + "Trend = "+ "overbought");

                  time28 =iTime(result[i],PERIOD_M1,0);
                 }
              }
            if(sto_M5 > STO_Up && sto_M5_2 < STO_Up)
              {
               if(time29!=iTime(result[i],PERIOD_M5,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M5" + "Trend = "+ "overbought");

                  time29 =iTime(result[i],PERIOD_M5,0);
                 }
              }
            if(sto_M15 > STO_Up && sto_M15_2 < STO_Up)
              {
               if(time30!=iTime(result[i],PERIOD_M15,0))
                 {

                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M15" + "Trend = "+ "overbought");
                  time30 =iTime(result[i],PERIOD_M15,0);
                 }
              }
            if(sto_M30 > STO_Up && sto_M30_2 < STO_Up)
              {
               if(time31!=iTime(result[i],PERIOD_M30,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "M30" + "Trend = "+ "overbought");

                  time31 =iTime(result[i],PERIOD_M30,0);
                 }
              }
            if(sto_H1 > STO_Up && sto_H1_2 < STO_Up)
              {
               if(time32!=iTime(result[i],PERIOD_H1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H1" + "Trend = "+ "overbought");

                  time32 =iTime(result[i],PERIOD_H1,0);
                 }
              }
            if(sto_H4 > STO_Up && sto_H4_2 < STO_Up)
              {
               if(time33!=iTime(result[i],PERIOD_H4,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "H4" + "Trend = "+ "overbought");

                  time33 =iTime(result[i],PERIOD_H4,0);
                 }
              }
            if(sto_D1 > STO_Up && sto_D1_2 < STO_Up)
              {
               if(time35!=iTime(result[i],PERIOD_D1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "D1" + "Trend = "+ "overbought");
                  time35 =iTime(result[i],PERIOD_D1,0);
                 }
              }
            if(sto_W1 > STO_Up && sto_W1_2 < STO_Up)
              {
               if(time36!=iTime(result[i],PERIOD_W1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "W1" + "Trend = "+ "overbought");

                  time36 =iTime(result[i],PERIOD_W1,0);
                 }
              }
            if(sto_MN1 > STO_Up && sto_MN1_2 < STO_Up)
              {
               if(time34!=iTime(result[i],PERIOD_MN1,0))
                 {
                  Alert("OS condition :" + "Symbol =" +result[i]+ "TimeFrame ="+ "MN1" + "Trend = "+ "overbought");

                  time34 =iTime(result[i],PERIOD_MN1,0);
                 }
              }

           }
         if(MA_STO_Alert)
           {
            //Trend is UP and OS condition is met
            if(sto_M1 < STO_Dn && MA1_M1>ma2_M1 && MA1_2_M1<ma2_2_M1)
              {
               if(time37!=iTime(result[i],PERIOD_M1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M1" + "Trend = "+ "is UP and OS condition is met");

                  time37 =iTime(result[i],PERIOD_M1,0);
                 }
              }
            if(sto_M5 < STO_Dn && MA1_M5>ma2_M5 && MA1_2_M5<ma2_2_M5)
              {
               if(time38!=iTime(result[i],PERIOD_M5,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M5" + "Trend = "+ "is UP and OS condition is met");

                  time38 =iTime(result[i],PERIOD_M5,0);
                 }
              }
            if(sto_M15 < STO_Dn && MA1_M15>ma2_M15 && MA1_2_M15<ma2_2_M15)
              {
               if(time39!=iTime(result[i],PERIOD_M15,0))
                 {

                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M15" + "Trend = "+ "is UP and OS condition is met");
                  time39 =iTime(result[i],PERIOD_M15,0);
                 }
              }
            if(sto_M30 < STO_Dn && MA1_M30>ma2_M30 && MA1_2_M30<ma2_2_M30)
              {
               if(time40!=iTime(result[i],PERIOD_M30,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M30" + "Trend = "+ "is UP and OS condition is met");

                  time40 =iTime(result[i],PERIOD_M30,0);
                 }
              }
            if(sto_H1 < STO_Dn && MA1_H1>ma2_H1 && MA1_2_H1<ma2_2_H1)
              {
               if(time41!=iTime(result[i],PERIOD_H1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "H1" + "Trend = "+ "is UP and OS condition is met");

                  time41 =iTime(result[i],PERIOD_H1,0);
                 }
              }
            if(sto_H4 < STO_Dn && MA1_H4>ma2_H4 && MA1_2_H4<ma2_2_H4)
              {
               if(time42!=iTime(result[i],PERIOD_H4,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "H4" + "Trend = "+ "is UP and OS condition is met");

                  time42 =iTime(result[i],PERIOD_H4,0);
                 }
              }
            if(sto_D1 < STO_Dn && MA1_D1>ma2_D1 && MA1_2_D1<ma2_2_D1)
              {
               if(time43!=iTime(result[i],PERIOD_D1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "D1" + "Trend = "+ "is UP and OS condition is met");

                  time43 =iTime(result[i],PERIOD_D1,0);
                 }
              }
            if(sto_W1 < STO_Dn && MA1_W1>ma2_W1 && MA1_2_W1<ma2_2_W1)
              {
               if(time44!=iTime(result[i],PERIOD_W1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "W1" + "Trend = "+ "is UP and OS condition is met");

                  time44 =iTime(result[i],PERIOD_W1,0);
                 }
              }
            if(sto_MN1 < STO_Dn && MA1_MN1>ma2_MN1 && MA1_2_MN1<ma2_2_MN1)
              {
               if(time45!=iTime(result[i],PERIOD_MN1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "MN1" + "Trend = "+ "is UP and OS condition is met");

                  time45 =iTime(result[i],PERIOD_MN1,0);
                 }
              }

            //Trend is Down and OS condition is met

            if(sto_M1 > STO_Up && MA1_M1<ma2_M1 && MA1_2_M1>ma2_2_M1)
              {
               if(time46!=iTime(result[i],PERIOD_M1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M1" + "Trend = "+ "is DOWN and OB condition is met");

                  time46 =iTime(result[i],PERIOD_M1,0);
                 }
              }
            if(sto_M5 > STO_Up && MA1_M5<ma2_M5 && MA1_2_M5>ma2_2_M5)
              {
               if(time47!=iTime(result[i],PERIOD_M5,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M5" + "Trend = "+ "is DOWN and OB condition is met");
                  time47 =iTime(result[i],PERIOD_M5,0);
                 }
              }
            if(sto_M15 > STO_Up && MA1_M15<ma2_M15 && MA1_2_M15>ma2_2_M15)
              {
               if(time48!=iTime(result[i],PERIOD_M15,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M15" + "Trend = "+ "is DOWN and OB condition is met");

                  time48 =iTime(result[i],PERIOD_M15,0);
                 }
              }

            if(sto_M30 > STO_Up && MA1_M30<ma2_M30 && MA1_2_M30>ma2_2_M30)
              {
               if(time49!=iTime(result[i],PERIOD_M30,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "M30" + "Trend = "+ "is DOWN and OB condition is met");
                  time49 =iTime(result[i],PERIOD_M30,0);
                 }
              }
            if(sto_H1 > STO_Up && MA1_H1<ma2_H1 && MA1_2_H1>ma2_2_H1)
              {
               if(time50!=iTime(result[i],PERIOD_H1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "H1" + "Trend = "+ "is DOWN and OB condition is met");

                  time50 =iTime(result[i],PERIOD_H1,0);
                 }
              }
            if(sto_H4 > STO_Up && MA1_H4<ma2_H4 && MA1_2_H4>ma2_2_H4)
              {
               if(time51!=iTime(result[i],PERIOD_H4,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "H4" + "Trend = "+ "is DOWN and OB condition is met");
                  time51 =iTime(result[i],PERIOD_H4,0);
                 }
              }
            if(sto_D1 > STO_Up && MA1_D1<ma2_D1 && MA1_2_D1>ma2_2_D1)
              {
               if(time52!=iTime(result[i],PERIOD_D1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "D1" + "Trend = "+ "is DOWN and OB condition is met");

                  time52 =iTime(result[i],PERIOD_D1,0);
                 }
              }
            if(sto_W1 > STO_Up && MA1_W1<ma2_W1 && MA1_2_W1>ma2_2_W1)
              {
               if(time53!=iTime(result[i],PERIOD_W1,0))
                 {

                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "W1" + "Trend = "+ "is DOWN and OB condition is met");
                  time53 =iTime(result[i],PERIOD_W1,0);
                 }
              }
            if(sto_MN1 > STO_Up && MA1_MN1<ma2_MN1 && MA1_2_MN1>ma2_2_MN1)
              {
               if(time54!=iTime(result[i],PERIOD_MN1,0))
                 {
                  Alert("Symbol =" +result[i]+ "TimeFrame ="+ "MN1" + "Trend = "+ "is DOWN and OB condition is met");

                  time54 =iTime(result[i],PERIOD_MN1,0);
                 }
              }

           }
         z+=30;
        }
      z=0;
     }











//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Dashboard function                                   |
//+------------------------------------------------------------------+
void Button(string name,ENUM_OBJECT type, int CORNER, int XDISTANCE, int YDISTANCE, int XSIZE, int YSIZE,
            string Text, int Fontsize, color FontColor, color Background, color Border)
  {
   ObjectCreate(0,name,type,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XDISTANCE);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,XSIZE);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YDISTANCE);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,YSIZE);
   ObjectSetString(0,name,OBJPROP_TEXT,Text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,Fontsize);
   ObjectSetInteger(0,name,OBJPROP_COLOR,FontColor);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,Background);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,Border);
  }
//+------------------------------------------------------------------+
//| MA_BUY_M1 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_M1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M1   =iMA(symbol,PERIOD_M1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M1 =iMA(symbol,PERIOD_M1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M1   =iMA(symbol,PERIOD_M1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M1 =iMA(symbol,PERIOD_M1,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M1>ma2_M1 && MA1_2_M1<ma2_2_M1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_Sell_M1 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_M1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M1   =iMA(symbol,PERIOD_M1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M1 =iMA(symbol,PERIOD_M1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M1   =iMA(symbol,PERIOD_M1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M1 =iMA(symbol,PERIOD_M1,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M1<ma2_M1 && MA1_2_M1>ma2_2_M1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_M1 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_M1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M1   =  iStochastic(symbol,PERIOD_M1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M1 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_M1 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_M1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M1   =  iStochastic(symbol,PERIOD_M1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M1 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_M5 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_M5(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M5   =iMA(symbol,PERIOD_M5,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M5 =iMA(symbol,PERIOD_M5,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M5   =iMA(symbol,PERIOD_M5,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M5 =iMA(symbol,PERIOD_M5,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M5>ma2_M5 && MA1_2_M5<ma2_2_M5)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_Sell_M5 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_M5(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M5   =iMA(symbol,PERIOD_M5,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M5 =iMA(symbol,PERIOD_M5,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M5   =iMA(symbol,PERIOD_M5,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M5 =iMA(symbol,PERIOD_M5,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M5<ma2_M5 && MA1_2_M5>ma2_2_M5)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_M5 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_M5(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M5   =  iStochastic(symbol,PERIOD_M5,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M5 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_M5 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_M5(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M5   =  iStochastic(symbol,PERIOD_M5,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M5 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_M15 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_M15(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M15   =iMA(symbol,PERIOD_M15,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M15 =iMA(symbol,PERIOD_M15,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M15   =iMA(symbol,PERIOD_M15,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M15 =iMA(symbol,PERIOD_M15,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M15>ma2_M15 && MA1_2_M15<ma2_2_M15)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_Sell_M15 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_M15(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M15   =iMA(symbol,PERIOD_M15,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M15 =iMA(symbol,PERIOD_M15,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M15   =iMA(symbol,PERIOD_M15,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M15 =iMA(symbol,PERIOD_M15,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M15<ma2_M15 && MA1_2_M15>ma2_2_M15)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_M15 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_M15(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M15   =  iStochastic(symbol,PERIOD_M15,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M15 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_M15 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_M15(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M15   =  iStochastic(symbol,PERIOD_M15,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M15 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_M30 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_M30(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M30   =iMA(symbol,PERIOD_M30,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M30 =iMA(symbol,PERIOD_M30,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M30   =iMA(symbol,PERIOD_M30,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M30 =iMA(symbol,PERIOD_M30,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M30>ma2_M30 && MA1_2_M30<ma2_2_M30)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_Sell_M30 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_M30(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_M30   =iMA(symbol,PERIOD_M15,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_M30 =iMA(symbol,PERIOD_M15,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_M30   =iMA(symbol,PERIOD_M15,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_M30 =iMA(symbol,PERIOD_M15,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_M30<ma2_M30 && MA1_2_M30>ma2_2_M30)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_M30 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_M30(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M30   =  iStochastic(symbol,PERIOD_M30,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M30 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_M30 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_M30(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_M30   =  iStochastic(symbol,PERIOD_M30,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);

      if(sto_M30 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_H1 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_H1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_H1    =iMA(symbol,PERIOD_H1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_H1  =iMA(symbol,PERIOD_H1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_H1    =iMA(symbol,PERIOD_H1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_H1  =iMA(symbol,PERIOD_H1,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_H1>ma2_H1 && MA1_2_H1<ma2_2_H1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_SELL_H1 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_H1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_H1    =iMA(symbol,PERIOD_H1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_H1  =iMA(symbol,PERIOD_H1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_H1    =iMA(symbol,PERIOD_H1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_H1  =iMA(symbol,PERIOD_H1,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_H1<ma2_H1 && MA1_2_H1>ma2_2_H1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_H1 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_H1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_H1    =  iStochastic(symbol,PERIOD_H1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_H1 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_H1 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_H1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_H1    =  iStochastic(symbol,PERIOD_H1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_H1 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_H4 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_H4(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_H4    =iMA(symbol,PERIOD_H4,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_H4  =iMA(symbol,PERIOD_H4,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_H4    =iMA(symbol,PERIOD_H4,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_H4  =iMA(symbol,PERIOD_H4,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_H4>ma2_H4 && MA1_2_H4<ma2_2_H4)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_SELL_H4 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_H4(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_H4    =iMA(symbol,PERIOD_H4,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_H4  =iMA(symbol,PERIOD_H4,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_H4    =iMA(symbol,PERIOD_H4,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_H4  =iMA(symbol,PERIOD_H4,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_H4<ma2_H4 && MA1_2_H4>ma2_2_H4)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_H4 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_H4(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_H4    =  iStochastic(symbol,PERIOD_H4,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_H4 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_H4 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_H4(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_H4    =  iStochastic(symbol,PERIOD_H4,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_H4 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_D1 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_D1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_D1    =iMA(symbol,PERIOD_D1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_D1  =iMA(symbol,PERIOD_D1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_D1    =iMA(symbol,PERIOD_D1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_D1  =iMA(symbol,PERIOD_D1,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_D1>ma2_D1 && MA1_2_D1<ma2_2_D1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_SELL_D1 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_D1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_D1    =iMA(symbol,PERIOD_D1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_D1  =iMA(symbol,PERIOD_D1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_D1    =iMA(symbol,PERIOD_D1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_D1  =iMA(symbol,PERIOD_D1,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_D1<ma2_D1 && MA1_2_D1>ma2_2_D1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_D1 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_D1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_D1    =  iStochastic(symbol,PERIOD_D1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_D1 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_D1 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_D1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_D1    =  iStochastic(symbol,PERIOD_D1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_D1 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_BUY_W1 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_W1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_W1    =iMA(symbol,PERIOD_W1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_W1  =iMA(symbol,PERIOD_W1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_W1    =iMA(symbol,PERIOD_W1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_W1  =iMA(symbol,PERIOD_W1,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_W1>ma2_W1 && MA1_2_W1<ma2_2_W1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_SELL_W1 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_W1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_W1    =iMA(symbol,PERIOD_W1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_W1  =iMA(symbol,PERIOD_W1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_W1    =iMA(symbol,PERIOD_W1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_W1  =iMA(symbol,PERIOD_W1,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_W1<ma2_W1 && MA1_2_W1>ma2_2_W1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_W1 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_W1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_W1    =  iStochastic(symbol,PERIOD_W1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_W1 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_W1 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_W1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_W1    =  iStochastic(symbol,PERIOD_W1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_W1 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }

//+------------------------------------------------------------------+
//| MA_BUY_MN1 function                                   |
//+------------------------------------------------------------------+
int  MA_BUY_MN1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_MN1    =iMA(symbol,PERIOD_MN1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_MN1  =iMA(symbol,PERIOD_MN1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_MN1    =iMA(symbol,PERIOD_MN1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_MN1  =iMA(symbol,PERIOD_MN1,period2,0,MA_Method2,MA_price2,i+1);
      if(MA1_MN1>ma2_MN1 && MA1_2_MN1<ma2_2_MN1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| MA_SELL_MN1 function                                   |
//+------------------------------------------------------------------+
int  MA_SELL_MN1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double MA1_MN1    =iMA(symbol,PERIOD_MN1,period1,0,MA_Method1,MA_price1,i);
      double MA1_2_MN1  =iMA(symbol,PERIOD_MN1,period1,0,MA_Method1,MA_price1,i+1);
      double ma2_MN1    =iMA(symbol,PERIOD_MN1,period2,0,MA_Method2,MA_price2,i);
      double ma2_2_MN1  =iMA(symbol,PERIOD_MN1,period2,0,MA_Method2,MA_price2,i+1);

      if(MA1_MN1<ma2_MN1 && MA1_2_MN1>ma2_2_MN1)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_BUY_MN1 function                                   |
//+------------------------------------------------------------------+
int  STO_BUY_MN1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_MN1    =  iStochastic(symbol,PERIOD_MN1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_MN1 < STO_Dn)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
//| STO_SELL_MN1 function                                   |
//+------------------------------------------------------------------+
int  STO_SELL_MN1(string symbol)
  {
   for(int i=1; i<iBars(symbol,0); i++)
     {
      double sto_MN1    =  iStochastic(symbol,PERIOD_MN1,K_Period1,D_Period1,Slowing1,Stochastic_Method1, Stochastic_price1,0,i);
      if(sto_MN1 > STO_Up)
        {
         return(i);
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+
