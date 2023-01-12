
gen_dis = function(n, val, prob){
  out = rep(0, n);
  for(i in 1:n){
    u <- runif(1)
    Fx = 0;
    valX = "";
    for(j in 1:length(val))
    {
      Fx = Fx + prob[j]
      if(Fx > u){
        valX = val[j];
        break
      }
    }
    out[i] =  valX;
    
  }
  return(out);
}

hist(gen_dis(10000, c(1,2,3,4,5), c(0.6, 0.2, 0.1, 0.05, 0.05)))
