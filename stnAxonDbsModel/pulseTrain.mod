 :Current Clamp

 NEURON {
 	POINT_PROCESS pulseTrain
 	RANGE del, PW, train, amp, freq, i, conv, pulsecount, onoff
 	ELECTRODE_CURRENT i
 }

 UNITS { (na) = (nanoamp) }

 PARAMETER{
 	del (ms)
 	PW (ms)
 	train (ms)
 	amp (na)
 	freq (1/s)
 	conv = 1000 (ms/s)
 	pulsecount (s/s)
 	onoff (s/s)
 	}

 ASSIGNED {
 	i (na)		
 }

 INITIAL  { LOCAL j,k
 	pulsecount = 0
 	onoff = 0
        k =  (train/conv)/freq
 	i = 0
 	FROM j = 0 TO k  {
 		at_time (del + (j*(conv/freq)))
		at_time (del + PW + (j*(conv/freq)))
 		}
 		at_time (del + train)
 }

 BREAKPOINT {
	 : This is the original code which gives a pulse train, but this was commented out
	 :	so that I (Joey Kilgore) could try and use kilohertz frequency balanced waves for stimulation
	if (t < del + train && t > del) {
		if (t > del + (pulsecount*(conv/freq)) && t < del + (pulsecount*(conv/freq)) + PW)  {
			i = amp
			onoff = 1
		} else {
			if (onoff == 0) {
				i = 0
			} else {
				i = 0
				pulsecount = pulsecount + 1
				onoff = 0
			}
		}
	} else {
		i = 0
		pulsecount = 0
		onoff = 0
	}
 		
:	at_time(del)
:	at_time(del+train)
:		 :ADDED BY JOEY KILGORE jxk1121@case.edu on 2/28/2020
:	if(t < del + train && t > del){
:		: if we are at a time between del and del+train then we are to stimulate
:		i = sin(2*3.1415927 * freq * (t-del) * .001) * amp
:		onoff = 1
:	} else {
:		i = 0
:		onoff = 0
:	}	 
 }