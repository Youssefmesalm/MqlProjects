//+------------------------------------------------------------------+
//|                                                                  |
//|                                                          Kalenzo |
//|                                                  simone@konto.pl |
//|                                    Modified by Newdigital        |
//|                                    Modified by Linuxser          |
//|                                    Modified by Noel CUILLANDRE   |
//+------------------------------------------------------------------+

#property copyright "Kalenzo"
#property link      "simone@konto.pl"
#property version   "1.03"

#property indicator_chart_window
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
#property indicator_width1 0
#property indicator_width2 0

enum ENUM_CROSSING_MODE {
   T3CrossingSnake,
   SnakeCrossingT3
};

input bool UseSound              = false;           // Alerts plays a sound ? 
input bool TypeChart             = false;           // Alerts displays on screen ?
input bool UseAlert              = false;           // Use alert?
input string NameFileSound       = "alert.wav";     // Sound filename
input int T3Period               = 14;               // T3 Period
input ENUM_APPLIED_PRICE T3Price = PRICE_CLOSE;     // T3 Source
input double b                   = 0.618;           // T3 b Factor
input int Snake_HalfCycle        = 5;               // Snake_HalfCycle = 4...10 or other
input ENUM_CROSSING_MODE Inverse = T3CrossingSnake; // 0=T3 crossing Snake, 1=Snake crossing T3
input int DeltaForSell           = 0;               // Delta for sell signal
input int DeltaForBuy            = 0;               // Delta for buy signal
input double ArrowOffset         = 0.5;             // Arrow vertical offset
input int    Maxbars             = 500;             // Lookback

#property indicator_buffers 10
//---- input parameters
//---- buffers
double UpBuffer[];
double DnBuffer[];
double alertBar;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- indicators

  int index = 0;
   SetIndexStyle (index,DRAW_ARROW,EMPTY);
   SetIndexBuffer(index,UpBuffer);
   SetIndexArrow (index,159); //233
   SetIndexLabel (index,"Up Signal");
   index++;
   SetIndexStyle (index,DRAW_ARROW,EMPTY);
   SetIndexBuffer(index,DnBuffer);
   SetIndexArrow (index,159); //234
   SetIndexLabel (index,"Down Signal");
   index++;

   int status = Snake.OnInit(index,Snake_HalfCycle);
   if (status != INIT_SUCCEEDED) {
      return status;
   }
   status = T3.OnInit(index,T3Period,T3Price,b);
   if (status != INIT_SUCCEEDED) {
      return status;
   }   
   IndicatorBuffers(index);
//----
   return status;
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int total = rates_total - prev_calculated;
   total = total > 0 ? total - 1 : 0;
   total = MathMin(total,Maxbars);
   int total_to = 0;

   for(int i=total;i>=total_to;i--) {
      if (i > rates_total - Snake_HalfCycle - 1) {
         continue;
      }
      double pwma5;
      double pwma50;
      double cwma5;
      double cwma50;

      Snake.Snake(i);
      T3.CalculateT3(i);    
      if ( i > rates_total - Snake_HalfCycle - 2) //--- to access i+1 below
         continue;  
      switch(Inverse) {
         default:
            break;
         case T3CrossingSnake: {
            pwma5 = Snake.Snake_Buffer[i+1];
            cwma5 = Snake.Snake_Buffer[i];
            pwma50 = T3.t3Array[i+1];
            cwma50 = T3.t3Array[i];
            break;
         }
         case SnakeCrossingT3: {
            pwma50 = Snake.Snake_Buffer[i+1];
            cwma50 = Snake.Snake_Buffer[i];
            pwma5  = T3.t3Array[i+1];
            cwma5  = T3.t3Array[i];
            break;
         }
      }
      double gap  = ArrowOffset*2.0*iATR(NULL,0,20,i)/4.0;
      
      if( (cwma5 > (cwma50 +(DeltaForBuy*Point))) && (pwma5 <= pwma50))
      {  
         UpBuffer[i] = iLow(Symbol(),0,i)-gap;
         DnBuffer[i] = 0;
         if (UseSound) PlaySound(NameFileSound);
         if (UseAlert && Bars>alertBar) {Alert(Symbol(), "Buy signal", Period());alertBar = Bars;}
         if (TypeChart) Comment ("Buy signal at Ask=",Ask,", Bid=",Bid,", Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime())," Symbol=",Symbol()," Period=",Period());
      }
      
      else if( (pwma5 >= pwma50) && (cwma5 < (cwma50 - (DeltaForSell*Point))))
      {
         UpBuffer[i] = 0;
         DnBuffer[i] = iHigh(Symbol(),0,i)+gap;
         if (UseSound) PlaySound(NameFileSound);
         if (UseAlert && Bars>alertBar) {Alert(Symbol(), "Sell signal", Period());alertBar = Bars;} 
         if (TypeChart) Comment ("Sell signal at Ask=",Ask,", Bid=",Bid,", Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime())," Symbol=",Symbol()," Period=",Period());
      }
      else
      {
        DnBuffer[i] = 0;
        UpBuffer[i] = 0;
      }  
   }
   return(rates_total);
  }

//+------------------------------------------------------------------+
//--- SNAKE
//extern int Snake_HalfCycle=5; // Snake_HalfCycle = 4...10 or other
//----
struct STRUCT_SNAKE {
   double Snake_Buffer[];
   double Snake_Sum, Snake_Weight, Snake_Sum_Minus, Snake_Sum_Plus;
   int Snake_FullCycle;
   int Snake_HalfCycle;
   //---
   STRUCT_SNAKE() { Reset(); }
   void Reset() {
      ArrayFree  (Snake_Buffer);
      ArrayResize(Snake_Buffer,0);
      Snake_Sum       = 0;
      Snake_Weight    = 0;
      Snake_Sum_Minus = 0;
      Snake_Sum_Plus  = 0;
      Snake_FullCycle = 0;
      Snake_HalfCycle = 0;
   }
   //----
   int OnInit(int &index, int half_cycle) {
      int draw_begin;
      Snake_HalfCycle = (half_cycle < 3 ? 3 : half_cycle);
      Snake_FullCycle = Snake_HalfCycle*2+1;
      draw_begin      = Snake_FullCycle+1;
      SetIndexBuffer   (index,Snake_Buffer);
      SetIndexDrawBegin(index,draw_begin);
      SetIndexStyle    (index,DRAW_LINE);
      index++;
      return INIT_SUCCEEDED;
   }
   //----
   int OnCalculate(const int rates_total,
                    const int prev_calculated,
                    const datetime& time[],
                    const double& open[],
                    const double& high[],
                    const double& low[],
                    const double& close[],
                    const long& tick_volume[],
                    const long& volume[],
                    const int& spread[]) {
      return rates_total;
   }
   //----
   void Snake(int Pos)
   {
      if(Pos<=Snake_HalfCycle+1) Pos=Snake_HalfCycle+2;
      Snake_Buffer[Pos]=SnakeFirstCalc(Pos);
      Pos--;
      while(Pos>=Snake_HalfCycle)
      {
         Snake_Buffer[Pos]=SnakeNextCalc(Pos);
         Pos--;
      }
      while(Pos>0)
      {
         Snake_Buffer[Pos]=SnakeFirstCalc(Pos);
         Pos--;
      }
      if(Pos==0) 
         Snake_Buffer[0]=iMA(NULL,0,Snake_HalfCycle,0,MODE_LWMA,PRICE_TYPICAL,0);
      return;
   }
   //----
   double SnakePrice(int shift)
   {
      return ((2*iClose(Symbol(),PERIOD_CURRENT,shift)+iHigh(Symbol(),PERIOD_CURRENT,shift)+iLow(Symbol(),PERIOD_CURRENT,shift))/4.0);
   }
   //----
   double SnakeFirstCalc(int Shift)
   {
   int i, j, w;
      Snake_Sum=0.0;
      Snake_Weight=0.0;
      if(Shift<Snake_HalfCycle)
      {
         i=0;
         w=Shift+Snake_HalfCycle;
         while(w>=Shift)
         {
            i++;
            Snake_Sum=Snake_Sum+i*SnakePrice(w);
            Snake_Weight=Snake_Weight+i;
            w--;
         }
         while(w>=0)
         {
            i--;
            Snake_Sum=Snake_Sum+i*SnakePrice(w);
            Snake_Weight=Snake_Weight+i;
            w--;
         }
      }
      else
      {
         Snake_Sum_Minus=0.0;
         Snake_Sum_Plus=0.0;
         for(j=Shift-Snake_HalfCycle,i=Shift+Snake_HalfCycle,w=1;
             w<= Snake_HalfCycle; 
             j++,i--,w++)
         {
            Snake_Sum=Snake_Sum+w*(SnakePrice(i)+SnakePrice(j));
            Snake_Weight=Snake_Weight+2*w;
            Snake_Sum_Minus=Snake_Sum_Minus+SnakePrice(i);
            Snake_Sum_Plus=Snake_Sum_Plus+SnakePrice(j);
         }
         Snake_Sum=Snake_Sum+( Snake_HalfCycle+1)*SnakePrice(Shift);
         Snake_Weight=Snake_Weight+ Snake_HalfCycle+1;
         Snake_Sum_Minus=Snake_Sum_Minus+SnakePrice(Shift);
      }
      return(Snake_Sum/ Snake_Weight);
   }
   //----
   double SnakeNextCalc(int Shift)
   {
      Snake_Sum_Plus=Snake_Sum_Plus+SnakePrice(Shift-Snake_HalfCycle);
      Snake_Sum=Snake_Sum-Snake_Sum_Minus+Snake_Sum_Plus;
      Snake_Sum_Minus=Snake_Sum_Minus-SnakePrice(Shift+Snake_HalfCycle+1)+SnakePrice(Shift);
      Snake_Sum_Plus=Snake_Sum_Plus-SnakePrice(Shift);
      return(Snake_Sum/Snake_Weight);
   }
};
STRUCT_SNAKE Snake;
//----

struct STRUCT_T3 {
   
   int                T3Period;//  = 14;
   ENUM_APPLIED_PRICE T3Price; //   = PRICE_CLOSE;
   double             b;       //         = 0.618;
   
   double t3Array[];
   double ae1[];
   double ae2[];
   double ae3[];
   double ae4[];
   double ae5[];
   double ae6[];
   
   //
   //
   //
   //
   //
   
   int    timeFrame;
   string IndicatorFileName;

   double e1,e2,e3,e4,e5,e6;
   double c1,c2,c3,c4;
   double w1,w2,b2,b3;   
   
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   STRUCT_T3() { Reset(); }
   void Reset() {
      ArrayFree(t3Array);
      ArrayFree(ae1);
      ArrayFree(ae2);
      ArrayFree(ae3);
      ArrayFree(ae4);
      ArrayFree(ae5);
      ArrayFree(ae6);
      ArrayResize(t3Array,0);
      ArrayResize(ae1,0);
      ArrayResize(ae2,0);
      ArrayResize(ae3,0);
      ArrayResize(ae4,0);
      ArrayResize(ae5,0);
      ArrayResize(ae6,0);     
      T3Period = 0;
      T3Price  = PRICE_CLOSE;
      b        = 0;                   
   }  
   int OnInit(int &index,int t3_period,ENUM_APPLIED_PRICE t3_price,double t3_b)
   {
      T3Period = t3_period;
      T3Price  = t3_price;
      b        = t3_b;
      
      SetIndexBuffer(index,t3Array);
      index++;
      SetIndexBuffer(index,ae1);
      index++;
      SetIndexBuffer(index,ae2);
      index++;
      SetIndexBuffer(index,ae3);
      index++;
      SetIndexBuffer(index,ae4);
      index++;
      SetIndexBuffer(index,ae5);
      index++;
      SetIndexBuffer(index,ae6);
      index++;
   
      //
      //
      //
      //
      //
      //

      b2 = b*b;
      b3 = b2*b;

      c1 = -b3;
      c2 = (3*(b2+b3));
      c3 = -3*(2*b2+b+b3);
      c4 = (1+3*b+b3+3*b2);

      w1 = 2 / (2 + 0.5*(MathMax(1,T3Period)-1));
      w2 = 1 - w1;      
      return INIT_SUCCEEDED;
   }
   
   
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   int OnCalculate(const int rates_total,
                   const int prev_calculated,
                   const datetime& time[],
                   const double& open[],
                   const double& high[],
                   const double& low[],
                   const double& close[],
                   const long& tick_volume[],
                   const long& volume[],
                   const int& spread[])
     {
      return(rates_total);
     }
   void CalculateT3(const int shift) {
         double price = iMA(NULL,0,1,0,MODE_SMA,T3Price,shift);
         e1 = w1*price + w2*ae1[shift+1];
         e2 = w1*e1    + w2*ae2[shift+1];
         e3 = w1*e2    + w2*ae3[shift+1];
         e4 = w1*e3    + w2*ae4[shift+1];
         e5 = w1*e4    + w2*ae5[shift+1];
         e6 = w1*e5    + w2*ae6[shift+1];
            t3Array[shift]=c1*e6 + c2*e5 + c3*e4 + c4*e3;
            ae1[shift] = e1;
            ae2[shift] = e2;
            ae3[shift] = e3;
            ae4[shift] = e4;
            ae5[shift] = e5;
            ae6[shift] = e6;     
   }
};

STRUCT_T3 T3;