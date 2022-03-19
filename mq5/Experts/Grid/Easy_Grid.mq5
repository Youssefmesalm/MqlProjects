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
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
CPositionInfo  m_position=CPositionInfo();// trade position object
CTrade         m_trade=CTrade();          // trading object

///grid variables
input int MaxChannelSizePoints=500;//Max Of a+d
input int MinMoveToClose=100;//Mininum Move
input int GridStepPoints=20;//Grid Step In Points
input int BarsI=999;//Bars To Start Calculate
input double KClose=3.5;//Asymmetry
///

////////minimum trading implementation
input int SlippageMaxOpen=15; //Slippage For Open In Points
input double Lot=0.01;//Lot
input int MagicC=679034;//Magic
/////////

MqlTick LastTick;//last tick

//////////minimum code to simulate predefined arrays
double High[];
double Low[];
datetime Time[];

void DimensionAllMQL5Values()//////////////////////////////
   {
   ArrayResize(Time,BarsI,0);
   ArrayResize(High,BarsI,0);
   ArrayResize(Low,BarsI,0);
   }

void CalcAllMQL5Values()///////////////////////////////////
   {
   ArraySetAsSeries(High,false);                        
   ArraySetAsSeries(Low,false);                              
   ArraySetAsSeries(Time,false);                                                            
   CopyHigh(_Symbol,_Period,0,BarsI,High);
   CopyLow(_Symbol,_Period,0,BarsI,Low);
   CopyTime(_Symbol,_Period,0,BarsI,Time);
   ArraySetAsSeries(High,true);                        
   ArraySetAsSeries(Low,true);
   ArraySetAsSeries(Time,true);
   }
/////////


void ClosePosition()//close a position by a symbol
   {
   bool ord;
   ord=PositionSelect(Symbol());
   if ( ord && int(PositionGetInteger(POSITION_MAGIC)) == MagicC  )
      {
      if(m_position.SelectByIndex(0)) m_trade.PositionClose(m_position.Ticket());          
      }
   }

void CleanLimitOrders()//clear limit orders
   {
   int orders=OrdersTotal();
   for(int i=0;i<orders;i++)
      {
      ulong ticket=OrderGetTicket(i);
      if(ticket!=0)
         {
         m_trade.OrderDelete(ticket);
         }
      }
   }

bool bCanClose()//closure condition
   {
   if ( GridStartPrice == GridUpPrice && (GridStartPrice-GridDownPrice)/_Point >= MinMoveToClose ) return true;
   if ( GridStartPrice == GridDownPrice && (GridUpPrice-GridStartPrice)/_Point >= MinMoveToClose ) return true;
   
   if ( GridStartPrice != GridUpPrice && GridStartPrice != GridDownPrice 
   && (GridStartPrice-GridDownPrice)/(GridUpPrice-GridStartPrice) >= KClose 
   && (GridStartPrice-GridDownPrice)/_Point >= MinMoveToClose ) return true;
   if ( GridStartPrice != GridDownPrice && GridStartPrice != GridUpPrice 
   && (GridUpPrice-GridStartPrice)/(GridStartPrice-GridDownPrice) >= KClose
   && (GridUpPrice-GridStartPrice)/_Point >= MinMoveToClose ) return true;
   
   /*
   if ( GridUpPrice >= GridStartPrice+MaxChannelSizePoints*_Point 
   //|| GridDownPrice <= GridStartPrice-MaxChannelSizePoints*_Point ) return true;
   */
   return false;
   }

void RestoreGrid()//recover the grid if the robot is restarted
   {
   DimensionAllMQL5Values();
   CalcAllMQL5Values(); 
   bool ord=PositionSelect(Symbol());
   if ( ord && int(PositionGetInteger(POSITION_MAGIC)) == MagicC )
      {
      GridStartTime=datetime(PositionGetInteger(POSITION_TIME));
      GridStartPrice=double(PositionGetDouble(POSITION_PRICE_OPEN));
      GridUpPrice=GridStartPrice;
      GridDownPrice=GridStartPrice;      
      
      for(int i=0;i<BarsI;i++)
         {
         if ( High[i] > GridUpPrice ) GridUpPrice=High[i];
         if ( Low[i] < GridDownPrice ) GridDownPrice=Low[i];
         if ( Time[i] < GridStartTime ) break;         
         }
      bCanUpdate=true;
      bTryedAlready=false;         
      }
      
      
   }

/////working code of the grid
datetime GridStartTime;//grid construction time
double GridStartPrice;//grid starting price
double GridUpPrice;//upper price within the corridor
double GridDownPrice;//lower price within the corridor

void CreateNewGrid()//create a new grid
   {
   SymbolInfoTick(Symbol(),LastTick);  
   GridStartTime=TimeCurrent();
   GridStartPrice=LastTick.bid;
   GridUpPrice=GridStartPrice;
   GridDownPrice=GridStartPrice;
    
   double SummUp=LastTick.ask+double(GridStepPoints)*_Point;
   double SummDown=LastTick.bid-double(GridStepPoints)*_Point;
   
   while ( SummUp <= LastTick.ask+double(MaxChannelSizePoints)*_Point )
      {
      //Order(false,false,SummUp,Lot,SlippageMaxOpen,MagicC,FILLING_E);
      m_trade.BuyStop(Lot,SummUp,Symbol());
      SummUp+=double(GridStepPoints)*_Point;
      }
     
   while ( SummDown >= LastTick.bid-double(MaxChannelSizePoints)*_Point )
      {
      //Order(true,false,SummDown,Lot,SlippageMaxOpen,MagicC,FILLING_E);
      m_trade.SellStop(Lot,SummDown,Symbol());
      SummDown-=double(GridStepPoints)*_Point;
      }
   }

void UpdateGrid()//update the grid parameters
   {
   SymbolInfoTick(Symbol(),LastTick);
   if ( LastTick.bid > GridUpPrice ) GridUpPrice=LastTick.bid;
   if ( LastTick.bid < GridDownPrice ) GridDownPrice=LastTick.bid;
   }
   
/////

bool bCanUpdate;//whether it is possible to update the grid
bool bTryedAlready;//whether there was an attempt to close a position
void Trade()//the main function where all actions are performed
   {
   bool ord=PositionSelect(Symbol());
   
   if ( bCanUpdate ) UpdateGrid();
   
   if ( ord && bCanClose() )//if there is a position and the closing condition is met
       {
       ClosePosition();
       CleanLimitOrders();
       bCanUpdate=false;
       bTryedAlready=true;
       }
   if ( bTryedAlready ) ClosePosition();
          
   if ( !bCanUpdate && !ord )
       {
       CleanLimitOrders();
       CreateNewGrid();
       bCanUpdate=true;
       bTryedAlready=false;
       }
   }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  m_trade.SetExpertMagicNumber(MagicC);//set the magic number for positions
  RestoreGrid();
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
  Trade();
  }
//+------------------------------------------------------------------+
