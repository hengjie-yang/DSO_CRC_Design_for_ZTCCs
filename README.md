# DSO_CRC_Design_for_ZTCCs
This repository provides tools to design the distance-spectrum-optimal (DSO) CRC generator polynomial for a given rate-1/n zero terminated convolutional code (CC).

Design steps
  1. run "find_dominant_error_event_fast.m" to generate all error events of distance bounded by 'd_tilde'
  2. run "find_DSO_CRC_by_exclusion.m" to search for the degree-m DSO CRC generator polynomial for the given CC.
 
Notes:
  1. Please refer to the input/output specifications inside each .m file
  
