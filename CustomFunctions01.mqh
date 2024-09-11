
double GetPipValue()
{
 if(Digits>=4)
  {
  return 0.0001;
 }
 else
 {
 return 0.01;
 }
}

double GetMaxHigh(int x)
{
   double Max=0;
   for(int i=1;i<x;i++)
   {
    Max= MathMax(High[i],Max);
   } 
   return Max;
}
double GetMinLow(int x)

{
   double Min=1000.0;
   for(int i=1;i<x;i++)
    {
    Min= MathMin(Low[i],Min);
   } 
   return Min;
}


double OptimalLotSize(double maxRiskPrc, double maxLossInPips)
{

  double accEquity = AccountEquity();
  //Alert("accEquity: " , accEquity);
  
  double lotSize = 100000.0;
  //Alert("lotSize: " ,lotSize);
  
  double tickValue = MarketInfo(NULL,MODE_TICKVALUE);
  
  if(Digits <= 3)
  {
   tickValue = tickValue /100;
  }
  
  //Alert("tickValue: " ,tickValue);
  
  double maxLossDollar = accEquity * maxRiskPrc;
 // Alert("maxLossDollar: " , maxLossDollar);
  
  double maxLossInQuoteCurr = maxLossDollar / tickValue;
 // Alert("maxLossInQuoteCurr: " + maxLossInQuoteCurr);
  
  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(maxLossInPips * GetPipValue())/lotSize,2);
  
  return optimalLotSize;
 
}


double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss)
{
   double maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue();
   return OptimalLotSize(maxRiskPrc,maxLossInPips);
}

int OrderTotalMagic(int Magic)
{ 
 int count=0;
 int  orderstot=OrdersTotal();
 for (int i=0;i<orderstot;i++) 
 {
   OrderSelect(i,SELECT_BY_POS);
   if(OrderMagicNumber()==Magic) count++;
 }
 
 return count;
}
  
int OrderTotalMagicK(int Magic)
{ 
 int count=0;
 int  orderstot=OrdersTotal();
 for (int i=0;i<orderstot;i++) 
 {
   OrderSelect(i,SELECT_BY_POS);
   if(OrderMagicNumber()/1000==Magic) count++;
 }
 
 return count;
}
  
