 :Current Clamp

 NEURON {
 	POINT_PROCESS dcStim
 	RANGE del, train, amp, i, conv, onoff
 	ELECTRODE_CURRENT i
 }

 UNITS { (na) = (nanoamp) }

 PARAMETER{
 	del (ms)
 	train (ms)
 	amp (na)
 	conv = 1000 (ms/s)
 	onoff (s/s)
 	}

 ASSIGNED {
 	i (na)		
 }

 INITIAL  { LOCAL j,k
 	onoff = 0
 	i = 0
 }

 BREAKPOINT { 		
	at_time(del)
	at_time(del+train)
	if(t < del + train && t >= del){
		: if we are at a time between del and del+train then we are to stimulate
		i = amp
		onoff = 1
	} else {
		i = 0
		onoff = 0
	}	 
 }