
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <CustomFunctions01.mqh>


input double Pre = 0.1;
input double SL = 0.3;
input double TP = 0.3;
input double Risk = 0.1;
input int MaxHours = 12;
input int HourStart = 7;;
input int MinuteOpen = 1;
input int magic = 50000;
input int MaxOrders = 3;
input int NoTradyDay1 = 0;
input int NoTradyDay2 = 0;
input int candels = 24;



double Lot;
double Top;// top of the chanell
double Buttom;//buttom of the dhanell
double Distance;
double PriceAt7;
bool OpenTrade = false;
double max;
double min;
double MiniBoxTop;
double MiniBoxButtom;
int order0;
bool IsBuy;
bool IsSet = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
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
   if ((Hour()== HourStart-1)&&(Minute() >= 58)&&(!IsSet))
   {
      
     
      OpenTrade=True;
      if ((iMA(NULL,0,20,0,0,0,0) > iMA(NULL,0,100,0,0,0,0))
      &&(iMA(NULL,0,5,0,0,0,0) > iMA(NULL,0,20,0,0,0,0))) IsBuy = true;
      else  if ((iMA(NULL,0,20,0,0,0,0) < iMA(NULL,0,100,0,0,0,0))
      &&(iMA(NULL,0,5,0,0,0,0) < iMA(NULL,0,20,0,0,0,0))) IsBuy = false;
      else 
         OpenTrade = false;
         
         
      if (OpenTrade)
      {
         if ((DayOfWeek() == NoTradyDay1) || (DayOfWeek() == NoTradyDay2))
            OpenTrade = false;
         //if (DayOfWeek() != NoTradyDay1)
           // OpenTrade = false;
      }  
      
       
      if (OpenTrade)
      {
         Top =  NormalizeDouble(GetMaxHigh(264),Digits);
         Buttom = NormalizeDouble(GetMinLow(264),Digits);
         Distance = NormalizeDouble(Top-Buttom,Digits);
         PriceAt7 = Ask;
         MiniBoxTop = NormalizeDouble(PriceAt7+(Pre*Distance),Digits);
         MiniBoxButtom = NormalizeDouble(PriceAt7+-(Pre*Distance),Digits);
      }
      IsSet = true;   
   }    
   else if ((Hour() == HourStart+2)&&(OpenTrade)&&(IsSet))   
   {                  
      max = NormalizeDouble(GetMaxHigh(candels),Digits);
      min= NormalizeDouble(GetMinLow(candels),Digits);
      if ((max>MiniBoxTop)||(min<MiniBoxButtom))
      {
         OpenTrade=false;
         //Print("The graph is out of the box");
      }
      //else 
         //Print("The graph is in the box");
         
      IsSet = False; 
       
   }
     
   else if ((Hour()== HourStart+2)&&(Minute() == MinuteOpen)&&(OpenTrade)
   &&(OrderTotalMagic(magic) == 0)&&(OrdersTotal() < MaxOrders))
   {   
      if (IsBuy)
      {  
         
         Lot = MathMax(OptimalLotSize(Risk,Ask,Ask-(SL*Distance)),0.01);
         order0 = OrderSend(NULL,0,Lot,Ask,10,Ask-(SL*Distance),Ask+(TP*Distance),NULL,magic);           
         
      }
      else 
      {
        
         Lot = MathMax(OptimalLotSize(Risk,Bid,Bid+(SL*Distance)),0.01);
         order0 = OrderSend(NULL,1,Lot,Bid,10,Bid+(SL*Distance),Bid-(TP*Distance),NULL,magic);
         
      }
   
   }
    
  else if ((Minute() == 0)&&(OrderTotalMagic(magic) == 1)&&(Hour() == (HourStart + MaxHours + 3)%24))
   {
   
      for (int i = 0;i < MaxOrders;i++)
      {
         if (OrderSelect(i,SELECT_BY_POS));
         {
            if (OrderMagicNumber()== magic)
            {
               
                  if (OrderType() == OP_BUY) OrderClose(OrderTicket(),OrderLots(),
                     MarketInfo(OrderSymbol(),MODE_BID),9999,CLR_NONE);
                  if (OrderType() == OP_SELL)OrderClose(OrderTicket(),OrderLots(),
                     MarketInfo(OrderSymbol(),MODE_ASK),9999,CLR_NONE);
                
            }
         }
      }
   }
   else  if ((Hour()==HourStart+3)&&(IsSet)) 
      IsSet=false;
  
   

}
//+------------------------------------------------------------------+

