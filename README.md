# DSO_CRC_Design_for_ZTCCs
This repository provides tools to design the distance-spectrum-optimal (DSO) CRC generator polynomial for a given rate-1/n zero terminated convolutional code (CC).

Design steps
  1. run "find_dominant_error_event_fast.m" to generate all error events of distance bounded by 'd_tilde'
  2. run "find_DSO_CRC_by_exclusion.m" to search for the degree-m DSO CRC generator polynomial for the given CC.
 
Notes:
  1. Please refer to the input/output specifications inside each .m file
  2. Typically, we would choose d_tilde in between 2*d_free and 3*d_free.
  3. Current program only considers at most double undetectable error events. If the desired CRC degree is too large, one needs to consider triple or n-tuple (n>2) undetectable error events.

Reference:

  [1] C. Y. Lou, B. Daneshrad, and R. D. Wesel, “Convolutional-code-specific CRC code design,” IEEE Trans. Commun., vol. 63,  no. 10, pp. 3459– 3470, Oct. 2015.
